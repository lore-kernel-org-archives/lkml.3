Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487Ab3DDS6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:58:20 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:52335 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762997Ab3DDS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:58:19 -0400
Date: Thu, 4 Apr 2013 20:58:15 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: drbd-dev@lists.linbit.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, drbd-user@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH -next] drbd: fix error return code in
 drbd_init()
Message-ID: <20130404185815.GJ22095@soda.linbit>
Mail-Followup-To: Wei Yongjun <weiyj.lk@gmail.com>,
	drbd-dev@lists.linbit.com, yongjun_wei@trendmicro.com.cn,
	linux-kernel@vger.kernel.org, drbd-user@lists.linbit.com
References: <CAPgLHd9NdpPH74owO-5=h7G2Qmhb5OJSWnuo=gPWHhnUbE6ULQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9NdpPH74owO-5=h7G2Qmhb5OJSWnuo=gPWHhnUbE6ULQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:17:09PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

We used to have an err = -ENOMEM; "just in case"...

How about this instead:

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e98da67..dfe52d6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2739,8 +2739,6 @@ int __init drbd_init(void)
 	/*
 	 * allocate all necessary structs
 	 */
-	err = -ENOMEM;
-
 	init_waitqueue_head(&drbd_pp_wait);
 
 	drbd_proc = NULL; /* play safe for drbd_cleanup */
@@ -2750,6 +2748,7 @@ int __init drbd_init(void)
 	if (err)
 		goto fail;
 
+	err = -ENOMEM;
 	drbd_proc = proc_create_data("drbd", S_IFREG | S_IRUGO , NULL, &drbd_proc_fops, NULL);
 	if (!drbd_proc)	{
 		printk(KERN_ERR "drbd: unable to register proc file\n");
@@ -2780,7 +2779,6 @@ int __init drbd_init(void)
 fail:
 	drbd_cleanup();
 	if (err == -ENOMEM)
-		/* currently always the case */
 		printk(KERN_ERR "drbd: ran out of memory\n");
 	else
 		printk(KERN_ERR "drbd: initialization failure\n");
