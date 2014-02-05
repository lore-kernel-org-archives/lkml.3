Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaBEDjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 22:39:24 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:53263 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBEDjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 22:39:22 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-cf-52f1b2687faf
Message-id: <52F1B266.9080207@samsung.com>
Date: Tue, 04 Feb 2014 20:39:18 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Legacy pm ops to dev_pm_ops patches
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9hP92MTR+DDI6fN7W4vGsOm8Xn3iOM
	FmdOX2K1+PrTwYHFY+esu+weW662s3h83iQXwBzFZZOSmpNZllqkb5fAlbH9xnamgn+iFXM3
	PGJsYFwm2MXIwSEhYCIx7498FyMnkCkmceHeerYuRi4OIYFljBKfPs5hB0kICfQySUycJQ2R
	2MAoMenvQ2aQBK+AlsS6u88YQWwWAVWJK9sWs4LYbALqEp9f74BqlpNoWrIarF5UIELi1dmJ
	LBC9ghI/Jt8Ds0UEtCXm9pxiBlnALLCRUeLBg2tgCWEBHYmfk88zgdjMAtYSKydtY4Sw5SU2
	r3nLDLFAWeLP5VNMEC8oSNxYuIx1AqPQLCQ7ZiFpn4WkfQEj8ypGsdLi5ILipPTUCkO94sTc
	4tK8dL3k/NxNjJAgr9rBeOerzSFGAQ5GJR7eAxM/BgmxJpYVV+YeYpTgYFYS4U3sBgrxpiRW
	VqUW5ccXleakFh9iZOLglGpg7KjhsOvv2PlecW/7qSdy75wWnFDuebmQ/2ZA1czOF/oev2tS
	zzlN+zT1+5G3Ujs3hrzfU3s9+lPhGtlrnDbP16s+tpq3KOFQ3V3NAztmZ85/H8hRnjxfn2Xe
	veVle7bvXiM8dce/KbcOcWVEBk75bjhN98VZY98jquemZbYffuf668VmjbKrO9iUWIozEg21
	mIuKEwHvMHSDUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I checked on the status of the legacy pm ops to dev_pm_ops conversion 
patches. Several went in. I have about 13 patches I would like to send. 
These patches are similar in nature. One of the issues I am having is 
being able to test these patches. Except for drivers/pcmcia/ds.c patch, 
others I am limited to compile testing only. Would it be okay to I send 
these as RFT patches cc'ing you and linux-pm and in addition to the 
maintainers for each of these patches?

Patch details below:

5 mmc host driver patches:

drivers/mmc/host/au1xmmc.c
drivers/mmc/host/bfin_sdh.c
drivers/mmc/host/cb710-mmc.c
drivers/mmc/host/msm_sdcc.c
drivers/mmc/host/tmio_mmc.c

3 arm platform driver patches:

arch/arm/common/locomo.c
arch/arm/common/sa1111.c
arch/arm/common/scoop.c

1 macintosh driver patch:
drivers/macintosh/adb.c

3 bus drivers patches:
drivers/base/isa.c
drivers/pcmcia/ds.c
drivers/s390/crypto/ap_bus.c

The nature if changes is very similar:
1. Define dev_pm_ops as in the example below:

+static const struct dev_pm_ops pcmcia_bus_dev_pm_ops = {
+       .suspend = pcmcia_dev_suspend,
+       .resume = pcmcia_dev_resume,
+       /* Hibernate callbacks */
+       .freeze = pcmcia_dev_freeze,
+       .thaw = pcmcia_dev_resume,
+       .poweroff = pcmcia_dev_poweroff,
+       .restore = pcmcia_dev_resume,
+};

  struct bus_type pcmcia_bus_type = {
         .name = "pcmcia",
@@ -1405,8 +1432,7 @@ struct bus_type pcmcia_bus_type = {
         .dev_groups = pcmcia_dev_groups,
         .probe = pcmcia_device_probe,
         .remove = pcmcia_device_remove,
-       .suspend = pcmcia_dev_suspend,
-       .resume = pcmcia_dev_resume,
+       .pm = &pcmcia_bus_dev_pm_ops,
  };

2. Define new interfaces for poweroff, freeze which in turn call 
existing suspend interface, as in the example below. thaw, resume, and 
restore are straight forward and just point to existing resume() hook

+static int pcmcia_dev_suspend(struct device *dev)
+{
+       __pcmcia_dev_suspend(dev, PMSG_SUSPEND);
+}
+
+static int pcmcia_dev_poweroff(struct device *dev)
+{
+       __pcmcia_dev_suspend(dev, PMSG_HIBERNATE);
+}
+
+static int pcmcia_dev_freeze(struct device *dev)
+{
+       __pcmcia_dev_suspend(dev, PMSG_FREEZE);
+}
+
+static int __pcmcia_dev_suspend(struct device *dev, pm_message_t state)
  {
         struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
         struct pcmcia_driver *p_drv = NULL;
@@ -1397,6 +1415,15 @@ static struct class_interface 
pcmcia_bus_interface __refdata = {
         .remove_dev = &pcmcia_bus_remove_socket,
  };

thanks,
-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
