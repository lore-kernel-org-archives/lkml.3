Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab3BMVkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:40:04 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:35252 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3BMVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:40:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] driver core: add wait event for deferred probe
To: Haojian Zhuang <haojian.zhuang@linaro.org>, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linus.walleij@linaro.org, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, akpm@linux-foundation.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
In-Reply-To: <1360637915-11212-1-git-send-email-haojian.zhuang@linaro.org>
References: <1360637915-11212-1-git-send-email-haojian.zhuang@linaro.org>
Date: Wed, 13 Feb 2013 21:39:59 +0000
Message-Id: <20130213213959.BE1D53E3557@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 10:58:35 +0800, Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
> do_initcalls() could call all driver initialization code in kernel_init
> thread. It means that probe() function will be also called from that
> time. After this, kernel could access console & release __init section
> in the same thread.
> 
> But if device probe fails and moves into deferred probe list, a new
> thread is created to reinvoke probe. If the device is serial console,
> kernel has to open console failure & release __init section before
> reinvoking failure. Because there's no synchronization mechanism.
> Now add wait event to synchronize after do_initcalls().
> 
> Changelog:
> v2: add comments on wait_for_device_probe().
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

As replied to on v1 of your patch, this change will cause a deadlock.
The following change would do the same without the deadlock issue:

 static int deferred_probe_initcall(void)
 {
 	deferred_wq = create_singlethread_workqueue("deferwq");
 	if (WARN_ON(!deferred_wq))
 		return -ENOMEM;

 	driver_deferred_probe_enable = true;
+	deferred_probe_work_func(NULL);
-	driver_deferred_probe_trigger();
 	return 0;
 }
 late_initcall(deferred_probe_initcall);

g.
