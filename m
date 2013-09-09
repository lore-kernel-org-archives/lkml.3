Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3IILIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:08:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3IILIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:08:49 -0400
Date: Mon, 9 Sep 2013 13:08:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn
Message-ID: <20130909110847.GB18056@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-09-13 22:59:16, Hugh Dickins wrote:
> Hit divide-by-0 in vmpressure_work_fn(): checking vmpr->scanned before
> taking the lock is not enough, we must check scanned afterwards too.

As vmpressure_work_fn seems the be the only place where we set scanned
to 0 (except for the rare occasion when scanned overflows which
would be really surprising) then the only possible way would be two
vmpressure_work_fn racing over the same work item. system_wq is
!WQ_NON_REENTRANT so one work item might be processed by multiple
workers on different CPUs. This means that the vmpr->scanned check in
the beginning of vmpressure_work_fn is inherently racy.

Hugh's patch fixes the issue obviously but doesn't it make more sense to
move the initial vmpr->scanned check under the lock instead?

Anton, what was the initial motivation for the out of the lock
check? Does it really optimize anything?

> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org
> ---
> 
>  mm/vmpressure.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- 3.11/mm/vmpressure.c	2013-09-02 13:46:10.000000000 -0700
> +++ linux/mm/vmpressure.c	2013-09-06 22:43:03.596003080 -0700
> @@ -187,6 +187,9 @@ static void vmpressure_work_fn(struct wo
>  	vmpr->reclaimed = 0;
>  	spin_unlock(&vmpr->sr_lock);
>  
> +	if (!scanned)
> +		return;
> +
>  	do {
>  		if (vmpressure_event(vmpr, scanned, reclaimed))
>  			break;

-- 
Michal Hocko
SUSE Labs
