Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3JZNwC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:52:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3JZNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:58 -0400
Date: Sat, 26 Oct 2013 06:51:44 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-ee5872befc9324fa4c2583c24d7ee7120314a2b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <5265029D02000078000FC4D2@nat28.tlf.novell.com>
References: <5265029D02000078000FC4D2@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86/time:
  Honor ACPI FADT flag indicating absence of a CMOS RTC
Git-Commit-ID: ee5872befc9324fa4c2583c24d7ee7120314a2b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:51:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee5872befc9324fa4c2583c24d7ee7120314a2b7
Gitweb:     http://git.kernel.org/tip/ee5872befc9324fa4c2583c24d7ee7120314a2b7
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 21 Oct 2013 09:31:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 13:36:00 +0200

x86/time: Honor ACPI FADT flag indicating absence of a CMOS RTC

Even though the omission was found only during code review
(originally in the Xen hypervisor, looking through ACPI v5 flags
and their meanings and uses), we shouldn't be creating a
corresponding platform device in that case.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/5265029D02000078000FC4D2@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/rtc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 0aa2939..5b9dd44 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -192,6 +192,14 @@ static __init int add_rtc_cmos(void)
 	if (mrst_identify_cpu())
 		return -ENODEV;
 
+#ifdef CONFIG_ACPI
+	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
+		/* This warning can likely go away again in a year or two. */
+		pr_info("ACPI: not registering RTC platform device\n");
+		return -ENODEV;
+	}
+#endif
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
