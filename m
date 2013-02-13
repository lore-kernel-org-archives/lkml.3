Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3BMHC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:02:29 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39952 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3BMHCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:02:18 -0500
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: [PATCH 4/4] gpiolib: rename local offset variables to "hwgpio"
Date: Wed, 13 Feb 2013 16:03:03 +0900
Message-Id: <1360738983-22436-6-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delivered-To: gnurou@gmail.com
Received: by 10.64.96.232 with SMTP id dv8csp15271ieb;
        Sun, 10 Feb 2013 05:48:07 -0800 (PST)
X-Received: by 10.68.0.39 with SMTP id 7mr11102539pbb.124.1360504086445;
        Sun, 10 Feb 2013 05:48:06 -0800 (PST)
Return-Path: <acourbot@nvidia.com>
Received: from hqemgate04.nvidia.com (hqemgate04.nvidia.com. [216.228.121.35])
        by mx.google.com with ESMTPS id qj7si3931281pbb.322.2013.02.10.05.48.06
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sun, 10 Feb 2013 05:48:06 -0800 (PST)
Received-SPF: pass (google.com: best guess record for domain of acourbot@nvidia.com designates 216.228.121.35 as permitted sender) client-ip=216.228.121.35;
Authentication-Results: mx.google.com;
       spf=pass (google.com: best guess record for domain of acourbot@nvidia.com designates 216.228.121.35 as permitted sender) smtp.mail=acourbot@nvidia.com
Received: from hqnvupgp05.nvidia.com (Not Verified[216.228.121.13]) by hqemgate04.nvidia.com
	id <B5117a50b0000>; Sun, 10 Feb 2013 05:47:56 -0800
Received: from hqemhub01.nvidia.com ([172.17.108.22])
  by hqnvupgp05.nvidia.com (PGP Universal service);
  Sun, 10 Feb 2013 05:48:05 -0800
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 10 Feb 2013 05:48:05 -0800
Received: from [10.18.131.155] (172.20.144.16) by hqemhub01.nvidia.com
 (172.20.150.30) with Microsoft SMTP Server id 8.3.297.1; Sun, 10 Feb 2013
 05:48:05 -0800
Message-ID: <5117A5AB.5090702@nvidia.com>
Date: Sun, 10 Feb 2013 22:50:35 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: <gnurou@gmail.com>
Subject: Re: [grant:gpio/next 10/16] gpiolib.c:undefined reference to `gpiod_unexport'
References: <51166e1c.NRfQN8VgI14zuNwf%fengguang.wu@intel.com> <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
In-Reply-To: <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
Return-Path: acourbot@nvidia.com
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2013 01:34 AM, Grant Likely wrote:
> Alex, this is broken when the sysfs interface isn't enabled. Can you
> send a fixup patch?
>
> g.
>
> On Sat, Feb 9, 2013 at 3:41 PM, kbuild test robot
> <fengguang.wu@intel.com> wrote:
>> tree:   git://git.secretlab.ca/git/linux-2.6.git gpio/next
>> head:   8a307b35962e42de0f998c6029e8851c61eadb4e
>> commit: 5bb47609e8167d733786cb781ada29536385635c [10/16] gpiolib: use descriptors internally
>> config: i386-randconfig-b040 (attached as .config)
>>
>> All error/warnings:
>>
>>     drivers/built-in.o: In function `gpiod_free':
>>>> gpiolib.c:(.text+0xda3): undefined reference to `gpiod_unexport'
>>     drivers/built-in.o: In function `gpio_request_one':
>>>> (.text+0x147f): undefined reference to `gpiod_export'

Oops, apologies. Here follows the fix. Please meld it into the culprit 
patch to fix all warnings and errors when sysfs is not compiled in.

Thanks,
Alex.

---
  drivers/gpio/gpiolib.c | 21 +++++++++++++++++++++
  1 file changed, 21 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e6e597c..b5a71c5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1085,6 +1085,27 @@ static inline void gpiochip_unexport(struct 
gpio_chip *chip)
  {
  }

+static inline int gpiod_export(struct gpio_desc *desc,
+                              bool direction_may_change)
+{
+       return -ENOSYS;
+}
+
+static inline int gpiod_export_link(struct device *dev, const char *name,
+                                   struct gpio_desc *desc)
+{
+       return -ENOSYS;
+}
+
+static inline int gpiod_sysfs_set_active_low(struct gpio_desc *desc, 
int value)
+{
+       return -ENOSYS;
+}
+
+static inline void gpiod_unexport(struct gpio_desc *desc)
+{
+}
+
  #endif /* CONFIG_GPIO_SYSFS */

  /*
-- 
1.8.1.3

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
