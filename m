Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3AXPQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:16:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3AXPQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:16:16 -0500
Date: Thu, 24 Jan 2013 16:16:03 +0100
From: Jan Kara <jack@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: paul.szabo@sydney.edu.au, linux-mm@kvack.org, 695182@bugs.debian.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Negative (setpoint-dirty) in bdi_position_ratio()
Message-ID: <20130124151603.GD21818@quack.suse.cz>
References: <201301200002.r0K02Atl031280@como.maths.usyd.edu.au>
 <20130124145707.GB12745@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124145707.GB12745@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-01-13 22:57:07, Wu Fengguang wrote:
> Hi Paul,
> 
> > (This patch does not solve the PAE OOM issue.)
> 
> You may try the below debug patch. The only way the writeback patches
> should trigger OOM, I think, is for the number of dirty/writeback
> pages going out of control.
> 
> Or more simple, you may show us the OOM dmesg which will contain the
> number of dirty pages. Or run this in a continuous loop during your
> tests, and see how the dirty numbers change before OOM:
  I think he found the culprit of the problem being min_free_kbytes was not
properly reflected in the dirty throttling. But the patch has been already
picked up by Andrew so I didn't forward it to you. Paul please correct me
if I'm wrong.

								Honza

> 
> while :
> do
>         grep -E '(Dirty|Writeback)' /proc/meminfo
>         sleep 1
> done
> 
> Thanks,
> Fengguang
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 50f0824..cf1165a 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1147,6 +1147,16 @@ pause:
>  		if (task_ratelimit)
>  			break;
>  
> +		if (nr_dirty > dirty_thresh + dirty_thresh / 2) {
> +			if (printk_ratelimit())
> +				printk(KERN_WARNING "nr_dirty=%lu dirty_thresh=%lu task_ratelimit=%lu dirty_ratelimit=%lu pos_ratio=%lu\n",
> +				       nr_dirty,
> +				       dirty_thresh,
> +				       task_ratelimit,
> +				       dirty_ratelimit,
> +				       pos_ratio);
> +		}
> +
>  		/*
>  		 * In the case of an unresponding NFS server and the NFS dirty
>  		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
