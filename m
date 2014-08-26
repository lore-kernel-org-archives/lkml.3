Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbaHZMdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:33:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:31451 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbaHZMdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:33:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,404,1406617200"; 
   d="scan'208";a="472731777"
Date: Tue, 26 Aug 2014 08:32:42 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Keith Busch <keith.busch@intel.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH] block: Fix dev_t liftime allocations
Message-ID: <20140826123242.GC3285@linux.intel.com>
References: <1408999975-9976-1-git-send-email-keith.busch@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408999975-9976-1-git-send-email-keith.busch@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 02:52:55PM -0600, Keith Busch wrote:
> Since the partition's release may be invoked from call_rcu's soft-irq
> context, the ext_dev_idr's mutex had to be replaced with a spinlock so
> as not so sleep.

> @@ -420,9 +420,9 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
>  	}
>  
>  	/* allocate ext devt */
> -	mutex_lock(&ext_devt_mutex);
> +	spin_lock(&ext_devt_lock);
>  	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_KERNEL);
> -	mutex_unlock(&ext_devt_mutex);
> +	spin_unlock(&ext_devt_lock);

Can't use GFP_KERNEL if we're protected with a spinlock.  See the comment
in lib/idr.c about idr_preload:

+	idr_preload(GFP_KERNEL);
-	mutex_lock(&ext_devt_mutex);
+	spin_lock(&ext_devt_lock);
-	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_KERNEL);
+	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_NOWAIT);
-	mutex_unlock(&ext_devt_mutex);
+	spin_unlock(&ext_devt_lock);

