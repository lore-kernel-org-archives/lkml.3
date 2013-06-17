Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3FQV5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:57:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3FQV5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:57:16 -0400
Date: Mon, 17 Jun 2013 14:57:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>,
        Mel Gorman <mgorman@suse.de>, Rob van der Heij <rvdheij@gmail.com>
Subject: Re: [lttng-dev] [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-Id: <20130617145714.8032ba33fd3e4e6887755209@linux-foundation.org>
In-Reply-To: <CAE_Gge34HCroSgNgiXL1j7Le3CNKRXR=7TZQhJSmY+wfWniKug@mail.gmail.com>
References: <51BE1828.3060206@gmail.com>
	<20130617141357.GA6034@Krystal>
	<20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
	<CAE_Gge34HCroSgNgiXL1j7Le3CNKRXR=7TZQhJSmY+wfWniKug@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 17:39:36 -0400 Rapha__l Beamonte <raphael.beamonte@gmail.com> wrote:

> 2013/6/17 Andrew Morton <akpm@linux-foundation.org>
> 
> > That change wasn't terribly efficient - if there are any unpopulated
> > pages in the range (which is quite likely), fadvise() will now always
> > call invalidate_mapping_pages() a second time.
> >
> > Perhaps this is fixable.  Say, make lru_add_drain_all() return a
> > success code, or even teach lru_add_drain_all() to return a code
> > indicating that one of the spilled pages was (or might have been) on a
> > particular mapping.
> >
> 
> Following our tests results, that was the call to lru_add_drain_all() that
> causes the problem. The second call to invalidate_mapping_pages() isn't
> really important. We tried to compile a kernel with the commit introducing
> this change but with the "lru_add_drain_all()" line removed, and the
> problem disappeared, even if we called two times invalidate_mapping_pages()
> (as the rest of the commit was still here).

Ah, OK, schedule_on_each_cpu() could certainly do that - it has to wait
for every CPU to context switch and schedule the worker function.

There's a lot we could do here.  Such as not doing the schedule_work()
at all for a cpu which has an empty lru_add_pvec.  Or even pass down
the address_space and only schedule the work for CPUs which have a page
from *this mapping* in their lru_add_pvec.  That will all be highly
racy, but as long as the failure mode is "flushed unnecessarily" then
that's OK.

