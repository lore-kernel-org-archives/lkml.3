Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3IKPlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:41:04 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60213 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3IKPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:41:01 -0400
Date: Wed, 11 Sep 2013 08:40:57 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn
Message-ID: <20130911154057.GA16765@teo>
References: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
 <20130909110847.GB18056@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130909110847.GB18056@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:08:47PM +0200, Michal Hocko wrote:
> On Fri 06-09-13 22:59:16, Hugh Dickins wrote:
> > Hit divide-by-0 in vmpressure_work_fn(): checking vmpr->scanned before
> > taking the lock is not enough, we must check scanned afterwards too.
> 
> As vmpressure_work_fn seems the be the only place where we set scanned
> to 0 (except for the rare occasion when scanned overflows which
> would be really surprising) then the only possible way would be two
> vmpressure_work_fn racing over the same work item. system_wq is
> !WQ_NON_REENTRANT so one work item might be processed by multiple
> workers on different CPUs. This means that the vmpr->scanned check in
> the beginning of vmpressure_work_fn is inherently racy.
> 
> Hugh's patch fixes the issue obviously but doesn't it make more sense to
> move the initial vmpr->scanned check under the lock instead?
> 
> Anton, what was the initial motivation for the out of the lock
> check? Does it really optimize anything?

Thanks a lot for the explanation.

Answering your question: the idea was to minimize the lock section, but the
section is quite small anyway so I doubt that it makes any difference (during
development I could not measure any effect of vmpressure() calls in my system,
though the system itself was quite small).

I am happy with moving the check under the lock or moving the work into
its own WQ_NON_REENTRANT queue.

Anton
