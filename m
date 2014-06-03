Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbaFCVn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:43:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34507 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaFCVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:43:25 -0400
Date: Tue, 3 Jun 2014 14:43:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Motohiro.Kosaki@us.fujitsu.com, david@fromorbit.com, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        hch@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever
 atshrink_inactive_list().
In-Reply-To: <201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
References: <20140520004449.GE18954@dastard> <20140519225915.3370328d.akpm@linux-foundation.org> <20140520063024.GH18954@dastard> <201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp> <6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
 <201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014, Tetsuo Handa wrote:

> In shrink_inactive_list(), we do not insert delay at
> 
>   if (!sc->hibernation_mode && !current_is_kswapd())
>     wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
> 
> if sc->hibernation_mode != 0.
> Follow the same reason, we should not insert delay at
> 
>   while (unlikely(too_many_isolated(zone, file, sc))) {
>     congestion_wait(BLK_RW_ASYNC, HZ/10);
> 
>     /* We are about to die and free our memory. Return now. */
>     if (fatal_signal_pending(current))
>       return SWAP_CLUSTER_MAX;
>   }
> 
> if sc->hibernation_mode != 0.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  mm/vmscan.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 32c661d..89c42ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1362,6 +1362,9 @@ static int too_many_isolated(struct zone *zone, int file,
>  	if (current_is_kswapd())
>  		return 0;
>  
> +	if (sc->hibernation_mode)
> +		return 0;
> +
>  	if (!global_reclaim(sc))
>  		return 0;
>  

This isn't the only too_many_isolated() functions that do a delay, how is 
the too_many_isolated() in mm/compaction.c different?
