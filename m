Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3LSOjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:39:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60385 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab3LSOjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:39:42 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1387439053-8711-4-git-send-email-jlee@suse.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387439053-8711-4-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 03/14] rtc: block registration of rtc-cmos when CMOS RTC Not Present
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 19 Dec 2013 06:38:28 -0800
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Message-ID: <6fc9a2f9-eae7-4588-a092-f338053ec96a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where did you find a platform with "no CMOS" set and a PNP RTC? I find the expect behavior in that case to be quite ambiguous and it is not at all clear to me that what you have here is the right thing.

"Lee, Chun-Yi" <joeyli.kernel@gmail.com> wrote:
>We should not acess CMOS address when CMOS RTC Not Present bit set in
>FADT. The ee5872be patch didn't avoid rtc-cmos driver loaded when
>system support
>ACPI PNP PNP0B0* devices.
>So this patch block the registion of rtc-cmos driver to avoid
>user space access RTC through CMOS interface.
>
>Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
>---
> arch/x86/kernel/rtc.c  |   20 ++++++++++++++++----
> drivers/rtc/rtc-cmos.c |    9 +++++++++
> 2 files changed, 25 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
>index ca9622a..9b6c568 100644
>--- a/arch/x86/kernel/rtc.c
>+++ b/arch/x86/kernel/rtc.c
>@@ -174,16 +174,27 @@ static __init int add_rtc_cmos(void)
> 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
> 	struct pnp_dev *dev;
> 	struct pnp_id *id;
>-	int i;
>+	int i = 0;
>+	bool found_pnp;
> 
> 	pnp_for_each_dev(dev) {
> 		for (id = dev->id; id; id = id->next) {
> 			for (i = 0; i < ARRAY_SIZE(ids); i++) {
>-				if (compare_pnp_id(id, ids[i]) != 0)
>-					return 0;
>+				if (compare_pnp_id(id, ids[i]) != 0) {
>+					found_pnp = true;
>+					goto found_pnp;
>+				}
> 			}
> 		}
> 	}
>+
>+found_pnp:
>+	if (found_pnp) {
>+		if (acpi_gbl_FADT.header.revision >= 5 &&
>+		    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
>+			pr_err(FW_BUG "Found %s device but CMOS RTC Not Present flag
>set\n", ids[i]);
>+		return 0;
>+	}
> #endif
> 	if (of_have_populated_dt())
> 		return 0;
>@@ -193,7 +204,8 @@ static __init int add_rtc_cmos(void)
> 		return -ENODEV;
> 
> #ifdef CONFIG_ACPI
>-	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
>+	if (acpi_gbl_FADT.header.revision >= 5 &&
>+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
> 		/* This warning can likely go away again in a year or two. */
> 		pr_info("ACPI: not registering RTC platform device\n");
> 		return -ENODEV;
>diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
>index f148762..3a84ca9 100644
>--- a/drivers/rtc/rtc-cmos.c
>+++ b/drivers/rtc/rtc-cmos.c
>@@ -28,6 +28,9 @@
>  * interrupts disabled, holding the global rtc_lock, to exclude those
>  * other drivers and utilities on correctly configured systems.
>  */
>+
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/init.h>
>@@ -1144,6 +1147,12 @@ static int __init cmos_init(void)
> {
> 	int retval = 0;
> 
>+	if (acpi_gbl_FADT.header.revision >= 5 &&
>+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
>+		pr_info("ACPI CMOS RTC Not Present detected - not loading\n");
>+		return 0;
>+	}
>+
> #ifdef	CONFIG_PNP
> 	retval = pnp_register_driver(&cmos_pnp_driver);
> 	if (retval == 0)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
