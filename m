Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaHLGNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaHLGNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:13:15 -0400
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 5/5] efi_rtc: probe function error out in case no efi runtime enabled
Date: Tue, 12 Aug 2014 14:10:22 +0800
Message-Id: <1407823822-23829-5-git-send-email-dyoung@redhat.com>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efi rtc depends on efi runtime services, so if efi runtime services are not
usable it should error out.

Without this patch rtc-efi will panic with 'noefi' boot

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/rtc/rtc-efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 8225b89..8c02ed8 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -213,6 +213,9 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
 	rtc = devm_rtc_device_register(&dev->dev, "rtc-efi", &efi_rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR(rtc))
-- 
1.8.3.1

