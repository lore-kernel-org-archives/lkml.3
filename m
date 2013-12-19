Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3LSPUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:20:49 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:46120 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3LSPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:20:48 -0500
Date: Thu, 19 Dec 2013 10:20:44 -0500
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/38] workqueue: add missing put_device call
Message-ID: <20131219152044.GB16994@htj.dyndns.org>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
 <1387465429-3568-22-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387465429-3568-22-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:03:32PM +0100, Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.
> Remove the kfree() as that is the job of wq_device_release which will now
> be called due to the reference count actually reaching zero.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
> ---
>  kernel/workqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 987293d..f3b3398 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3361,7 +3361,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
>  
>  	ret = device_register(&wq_dev->dev);
>  	if (ret) {
> -		kfree(wq_dev);
> +		put_device(&wq_dev->dev);

Umm... this doesn't look right.  You're basically converting the code
to the following,

	x = kmalloc();
	if (register(x) < 0)
		put(x)

They're not symmetrical anymore.  register(), or any API call really,
isn't supposed to have side effects which need explicit cleanup after
a failure.  The fact that x is properly initialized even after
register(x) failed is a coincidental implementation detail which
shouldn't be depended upon.  Your patch is actively breaking the
convention for no good reason.

 Nacked-by: Tejun Heo <tj@kernel.org>

>From the patch title, I suppose you posted a bunch of patches towards
this direction.  Please consider all of them nacked if they're doing
the same thing.

Thanks.

-- 
tejun
