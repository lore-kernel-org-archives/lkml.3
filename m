Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3IKFhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:37:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40949 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab3IKFhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:37:35 -0400
Date: Tue, 10 Sep 2013 22:32:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn
Message-ID: <20130911053248.GA9064@lizard>
References: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:59:16PM -0700, Hugh Dickins wrote:
> Hit divide-by-0 in vmpressure_work_fn(): checking vmpr->scanned before
> taking the lock is not enough, we must check scanned afterwards too.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org

Hm... Just trying to understand this one. I don't see how this can happen,
considering that only one instance of vmpressure_work_fn() supposed to be
running (unlike vmpressure()), and the only place where we zero
vmpr->scanned is vmpressure_work_fn() itself?

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
