Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaENIWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:22:32 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55973 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaENIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:22:28 -0400
Message-ID: <5373275B.2010004@ahsoftware.de>
Date: Wed, 14 May 2014 10:20:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: dt: deps: some tips about how to debug/evaluate this feature
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

to make it a bit more easier to evaluate or debug this new feature, here 
are some tips:

- To see the initialization order you can use dtc:

	CROSS_COMPILE=arm-linux-gnu- ARCH=arm make foo.dtb
	scripts/dtc/dtc -I dtb -t arch/arm/boot/dts/foo.dtb

- To see that order in dmesg, I've left a commented function
   in patch 2/9. Just enable of_init_print_order() in
   drivers/of/of_dependencies.c

- To see which drivers do call of_platform_populate() theirself
   (which is not necessary when using this new feature) uncomment the
   WARN_ON(np->dev_created); in drivers/of/platform.c (patch 2/9).

- To see which drivers are already "well done" or not, add a small
   debug line to of_init_register_platform_driver() in
   drivers/of/of_dependencies.c:

@@ -416,39 +416,41 @@ int of_init_register_platform_driver(struct 
platform_driver *drv)
  {
         BUG_ON(!is_recording);
         order.platform_drivers[order.count_drivers++] = drv;
+       pr_info("DEPS: recording of drv %s\n", drv->driver.name);
         return 0;
  }

   Now "well done" drivers linked to the kernel will be seen in dmesg as
   beeing recorded. This also shows most drivers which are not "well
   done", they will be started before the recording of drivers (except
   late ones).

- To see when "well done" drivers will be registered (in order) add
   something like that to drivers/of/of_dependencies.c:
@@ -445,8 +445,10 @@ void __init of_init_register_drivers(void)
                         if (of_driver_match_device(dev, &drv->driver)) {
                                 if (!driver_find(drv->driver.name,
-                                   drv->driver.bus))
+                                   drv->driver.bus)) {
                                         platform_driver_register(drv);
+                                       pr_info("DEPS: driver %s 
registered\n", drv->name);
+                               }
                                 if (dev->parent)
                                         device_lock(dev->parent);
                                 rc = device_attach(dev);


Regards,

Alexander Holler
