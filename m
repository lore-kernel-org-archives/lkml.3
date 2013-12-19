Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3LSHzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:55:00 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38021 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3LSHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:54:58 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [RFC PATCH 11/14] rtc: switch to get/set rtc time to efi functions if CMOS RTC Not Present git set.
Date: Thu, 19 Dec 2013 15:51:52 +0800
Message-Id: <1387439515-8926-12-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CMOS RTC Not Present git set in FADT, system should not access CMOS
interface for time. This patch move get/set rtc time function from CMOS
to EFI runtime on x86_64 machine. And, it also set the BUG_ON check in
rtc_cmos_read/write function to avoid access it.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/kernel/rtc.c     |    8 ++++++++
 include/asm-generic/rtc.h |   22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 9b6c568..a54cd09 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -117,6 +117,10 @@ unsigned char rtc_cmos_read(unsigned char addr)
 {
 	unsigned char val;
 
+	BUG_ON(acpi_gbl_FADT.header.revision >= 5 &&
+	       acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC &&
+	       addr <= RTC_YEAR);
+
 	lock_cmos_prefix(addr);
 	outb(addr, RTC_PORT(0));
 	val = inb(RTC_PORT(1));
@@ -128,6 +132,10 @@ EXPORT_SYMBOL(rtc_cmos_read);
 
 void rtc_cmos_write(unsigned char val, unsigned char addr)
 {
+	BUG_ON(acpi_gbl_FADT.header.revision >= 5 &&
+	       acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC &&
+	       addr <= RTC_YEAR);
+
 	lock_cmos_prefix(addr);
 	outb(addr, RTC_PORT(0));
 	outb(val, RTC_PORT(1));
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index fa86f24..4ba8aa6 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -16,6 +16,8 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
+#include <linux/efi.h>
+#include <linux/acpi.h>
 
 #define RTC_PIE 0x40		/* periodic interrupt enable */
 #define RTC_AIE 0x20		/* alarm interrupt enable */
@@ -51,6 +53,16 @@ static inline unsigned int __get_rtc_time(struct rtc_time *time)
 	unsigned int real_year;
 #endif
 
+	if (acpi_gbl_FADT.header.revision >= 5 &&
+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
+#if defined(CONFIG_EFI) && defined(CONFIG_X86_64)
+		printk_once(KERN_INFO "efi: get rtc time by EFI\n");
+		return efi_read_time(time);
+#else
+		BUG();
+#endif
+	}
+
 	/*
 	 * read RTC once any update in progress is done. The update
 	 * can take just over 2ms. We wait 20ms. There is no need to
@@ -123,6 +135,16 @@ static inline int __set_rtc_time(struct rtc_time *time)
 	unsigned int real_yrs, leap_yr;
 #endif
 
+	if (acpi_gbl_FADT.header.revision >= 5 &&
+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
+#if defined(CONFIG_EFI) && defined(CONFIG_X86_64)
+		printk_once(KERN_INFO "efi: set rtc time by EFI\n");
+		return efi_set_time(time);
+#else
+		BUG();
+#endif
+	}
+
 	yrs = time->tm_year;
 	mon = time->tm_mon + 1;   /* tm_mon starts at zero */
 	day = time->tm_mday;
-- 
1.6.4.2

