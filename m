Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaJ0DJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:09:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:19064 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaJ0DJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:09:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="scan'208";a="625970928"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: =?utf-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: ACPI regression: New Acer workarounds break Samsung NP900X
Thread-Topic: ACPI regression: New Acer workarounds break Samsung NP900X
Thread-Index: AQHP8RbMquYiMoLqG0i2VzrCrPJiYpxDMJDQ
Date: Mon, 27 Oct 2014 03:08:28 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026882DB@SHSMSX101.ccr.corp.intel.com>
References: <544CE637.7000406@odi.ch>
In-Reply-To: <544CE637.7000406@odi.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9R39n6x002806

Hi,

Thanks for letting me know.

Though IMO the ACER behavior is not ACPI spec compliant, but following it still shouldn't break the others.
Because it just requires EC firmware to always flag SCI_EVT when there is an event queued up.
I couldn't see a special reason that a correct EC firmware should stop doing this.
So I didn't make it a quirk that can only apply for the ACER firmware.

I read the whole bug log, for me it looks like that the Samsung firmware need a special EC driver feature which is currently not in the Linux kernel.
According to the root cause:
Comment 100-103 at https://bugs.launchpad.net/ubuntu/+source/linux/+bug/971061/
Samsung laptops need a SCI_EVT polling mode to be implemented in the kernel.

Fortunately, I had this already implemented, you can find it here:
https://github.com/zetalog/linux/commit/0fe9406d <- it implements a polling thread in the kernel to poll SCI_EVT.
https://github.com/zetalog/linux/commit/28ef0576 <- it adds a quirk mechanism to allow Linux to always poll SCI_EVT (I need to improve it according to your report).

It just takes time to make it upstream because there is a cleanup in it to correct the storming prevention craps in the same series:
https://github.com/zetalog/linux/commit/fa4024c8
which depends on an ACPICA commit, the commit has been under discussion for more than 3 months:
https://github.com/zetalog/linux/commit/e20e0fde

Let me try to rebase the series and make the SCI_EVT polling thread independent of the storming prevention cleanups.
So that I can make it upstream first to permanently fix the Samsung laptop problems in the kernel.
I may ask you for help to test the new feature after it is ready.

Thanks and best regards
-Lv

> From: Ortwin GlÃ¼ck [mailto:odi@odi.ch]
> Sent: Sunday, October 26, 2014 8:17 PM
> 
> Lv,
> 
> These two patches introduce a regression for Samsung notebooks and they no
> longer get ACPI interrupts for plugging the power adapter or LID switches.
> 
> Multiple people have verified that reverting these patches makes the regression
> go away.
> 
> Please see new comments in:
> https://bugzilla.kernel.org/show_bug.cgi?id=44161#c184
> 
>  From 3afcf2ece453e1a8c2c6de19cdf06da3772a1b08 Mon Sep 17 00:00:00 2001
> From: Lv Zheng <lv.zheng@intel.com>
> Date: Thu, 21 Aug 2014 14:41:13 +0800
> Subject: [PATCH] ACPI / EC: Add support to disallow QR_EC to be issued when
>   SCI_EVT isn't set
> 
>  From 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4 Mon Sep 17 00:00:00 2001
> From: Lv Zheng <lv.zheng@intel.com>
> Date: Thu, 21 Aug 2014 14:41:26 +0800
> Subject: [PATCH] ACPI / EC: Add support to disallow QR_EC to be issued before
>   completing previous QR_EC
> 
> 
> Thanks,
> 
> Ortwin
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
