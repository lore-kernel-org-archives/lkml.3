Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3JUIcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:32:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40913 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3JUIcD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 21 Oct 2013 04:32:03 -0400
Message-Id: <5265029D02000078000FC4D2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 09:31:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "John Stultz" <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] x86: honor ACPI FADT flag indicating absence of a
 CMOS RTC
References: <525E969E02000078000FB710@nat28.tlf.novell.com>
 <20131018062908.GD14264@gmail.com>
 <5261015702000078000FBFA1@nat28.tlf.novell.com>
 <20131018105923.GB17696@gmail.com>
In-Reply-To: <20131018105923.GB17696@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the omission was found only during code review (originally
in the Xen hypervisor, looking through ACPI v5 flags and their meanings
and uses), we shouldn't be creating a corresponding platform device in
that case.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
v2: Emit a log message in this case, as requested by Ingo.
---
 arch/x86/kernel/rtc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- 3.12-rc6/arch/x86/kernel/rtc.c
+++ 3.12-rc6-x86-ACPI-no-RTC/arch/x86/kernel/rtc.c
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



