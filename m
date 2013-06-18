Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3FRJ3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:29:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab3FRJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:29:30 -0400
Date: Tue, 18 Jun 2013 10:29:26 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        Rob van der Heij <rvdheij@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-ID: <20130618092925.GI1875@suse.de>
References: <51BE1828.3060206@gmail.com>
 <20130617141357.GA6034@Krystal>
 <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 02:24:59PM -0700, Andrew Morton wrote:
> On Mon, 17 Jun 2013 10:13:57 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Hi,
> > 
> > CCing lkml on this,
> > 
> > * Yannick Brosseau (yannick.brosseau@gmail.com) wrote:
> > > Hi all,
> > > 
> > > We discovered a performance regression in recent kernels with LTTng
> > > related to the use of fadvise DONTNEED.
> > > A call to this syscall is present in the LTTng consumer.
> > > 
> > > The following kernel commit cause the call to fadvise to be sometime
> > > really slower.
> > > 
> > > Kernel commit info:
> > > mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard
> > > all pages
> > > main tree: (since 3.9-rc1)
> > > commit 67d46b296a1ba1477c0df8ff3bc5e0167a0b0732
> > > stable tree: (since 3.8.1)
> > > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit?id=bb01afe62feca1e7cdca60696f8b074416b0910d
> > > 
> > > On the workload test, we observe that the call to fadvise takes about
> > > 4-5 us before this patch is applied. After applying the patch, The
> > > syscall now takes values from 5 us up to 4 ms (4000 us) sometime. The
> > > effect on lttng is that the consumer is frozen for this long period
> > > which leads to dropped event in the trace.
> 
> That change wasn't terribly efficient - if there are any unpopulated
> pages in the range (which is quite likely), fadvise() will now always
> call invalidate_mapping_pages() a second time.
> 

I did not view the path as being performance critical and did not anticipate
a delay that severe. The original test case as well was based on
sequential IO as part of a backup so I was also generally expecting the
range to be populated. I looked at the other users of lru_add_drain_all()
but there are fairly few. compaction uses them but only when used via sysfs
or proc. ksm uses it but it's not likely to be that noticable. mlock uses
it but it's unlikely it is being called frequently so I'm not going to
worry performance of lru_add_drain_all() in general. I'll look closer at
properly detecting when it's necessarily to call in the fadvise case.

-- 
Mel Gorman
SUSE Labs
