Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3LSHzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:55:13 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64354 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3LSHzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:55:07 -0500
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
Subject: [RFC PATCH 12/14] efi: adjust system time base on timezone from EFI time services
Date: Thu, 19 Dec 2013 15:51:53 +0800
Message-Id: <1387439515-8926-13-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI time services provide the interface to store timezone to BIOS. The
timezone value from EFI indicates the offset of RTC time in minutes from
UTC.
The formula is: Localtime = UTC - TimeZone.

This patch add a efI_warp_clock() function to initial process for adjust
system time base on timezone value from EFI time services. It will also
set persistent_clock_is_local global variable to avoid user space
adjust timezone again.

This efi warp clock mechanism will triggered on x86_64 EFI machine when
timezone value is neither 0 nor 2047(UNSPECIFIED), kernel assume the
value of RTC is local time. On the other hand, system just follow
the old logic when timezone value from EFI is 0 or 2047, kernel assume
the value of RTC is UTC time.

About the 2047(EFI_UNSPECIFIED_TIMEZONE) value, it's the default value
of UEFI BIOS if there didn't have software set it through EFI interface.
We can _NOT_ follow EFI spec to interpret the RTC time as a local time
if timezone value is EFI_UNSPECIFIED_TIMEZONE, that's because Linux stored
UTC to BIOS on shipped UEFI machines.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/platform/efi/efi.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/efi.h         |    2 ++
 init/main.c                 |    5 +++++
 kernel/time.c               |    2 +-
 4 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 42d6052..848160e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -306,6 +306,43 @@ static void efi_get_time(struct timespec *now)
 	now->tv_nsec = 0;
 }
 
+static int efi_read_timezone(s16 *timezone)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+
+	status = efi.get_time(&eft, &cap);
+
+	if (status != EFI_SUCCESS) {
+		/* should never happen */
+		pr_err("efitime: can't read timezone.\n");
+		return -EINVAL;
+	}
+
+	*timezone = (s16)le16_to_cpu(eft.timezone);
+	return 0;
+}
+
+void __init efi_warp_clock(void)
+{
+	s16 timezone;
+
+	if (!efi_read_timezone(&timezone)) {
+		/* TimeZone value, 2047 or 0 means UTC */
+		if (timezone != 0 && timezone != 2047) {
+			struct timespec adjust;
+
+			persistent_clock_is_local = 1;
+			adjust.tv_sec = timezone * 60;
+			adjust.tv_nsec = 0;
+			timekeeping_inject_offset(&adjust);
+			pr_info("RTC timezone is %d mins behind of UTC.\n", timezone);
+			pr_info("Adjusted system time to UTC.\n");
+		}
+	}
+}
+
 /*
  * Tell the kernel about the EFI memory map.  This might include
  * more than the max 128 entries that can fit in the e820 legacy
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1c78ae7..a8d4f5c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -715,10 +715,12 @@ extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #ifdef CONFIG_X86
+extern void efi_warp_clock(void);
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
 extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 #else
+static inline void efi_warp_clock(void) {}
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
 
diff --git a/init/main.c b/init/main.c
index 61164ce..9effb1c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -570,6 +570,11 @@ asmlinkage void __init start_kernel(void)
 	hrtimers_init();
 	softirq_init();
 	timekeeping_init();
+#ifdef CONFIG_X86_64
+	/* adjust system time by timezone */
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_warp_clock();
+#endif
 	time_init();
 	sched_clock_postinit();
 	perf_event_init();
diff --git a/kernel/time.c b/kernel/time.c
index 7c7964c..ce18bac 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -176,7 +176,7 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 		update_vsyscall_tz();
 		if (firsttime) {
 			firsttime = 0;
-			if (!tv)
+			if (!tv && !persistent_clock_is_local)
 				warp_clock();
 		}
 	}
-- 
1.6.4.2

