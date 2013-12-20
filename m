Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3LTDzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:55:39 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:52424 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3LTDzg (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 19 Dec 2013 22:55:36 -0500
Subject: Re: [PATCH 03/14] rtc: block registration of rtc-cmos when CMOS
 RTC Not Present
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
In-Reply-To: <6fc9a2f9-eae7-4588-a092-f338053ec96a@email.android.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <1387439053-8711-4-git-send-email-jlee@suse.com>
	 <6fc9a2f9-eae7-4588-a092-f338053ec96a@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Dec 2013 11:54:10 +0800
Message-ID: <1387511650.3539.4294.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa, 

於 四，2013-12-19 於 06:38 -0800，H. Peter Anvin 提到：
> Where did you find a platform with "no CMOS" set and a PNP RTC? I find the expect behavior in that case to be quite ambiguous and it is not at all clear to me that what you have here is the right thing.

Actually there doesn't have the box both with "No CMOS" and PNP device. 
I choice to totally block rtc-cmos driver when "No CMOS RTC" because the
definition in ACPI spec:

CMOS RTC Not Present

If set, indicates that the CMOS RTC is either not implemented, or
does not exist at the legacy addresses. OSPM uses the Control
Method Time and Alarm Namespace device instead.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


It suggest us using ACPI TAD interface when this flag present. But, I
agreed your point for this is ambiguous due to ACPI spec didn't clear
define the relationship between PNP0B0x.

Maybe we can do more detail check in cmos_init when "No CMOS RTC" set:
 + check if have ACPI TAD device, then block rtc-cmos
 + check if no ACPI TAD device, but have PNP0B0x, then we use PNP0b0x.

> 
> "Lee, Chun-Yi" <joeyli.kernel@gmail.com> wrote:
> >We should not acess CMOS address when CMOS RTC Not Present bit set in
> >FADT. The ee5872be patch didn't avoid rtc-cmos driver loaded when
> >system support
> >ACPI PNP PNP0B0* devices.
> >So this patch block the registion of rtc-cmos driver to avoid
> >user space access RTC through CMOS interface.
> >
> >Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> >---
> > arch/x86/kernel/rtc.c  |   20 ++++++++++++++++----
> > drivers/rtc/rtc-cmos.c |    9 +++++++++
> > 2 files changed, 25 insertions(+), 4 deletions(-)
> >
...
> >--- a/drivers/rtc/rtc-cmos.c
> >+++ b/drivers/rtc/rtc-cmos.c
> >@@ -28,6 +28,9 @@
> >  * interrupts disabled, holding the global rtc_lock, to exclude those
> >  * other drivers and utilities on correctly configured systems.
> >  */
> >+
> >+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >+
> > #include <linux/kernel.h>
> > #include <linux/module.h>
> > #include <linux/init.h>
> >@@ -1144,6 +1147,12 @@ static int __init cmos_init(void)
> > {
> > 	int retval = 0;
> > 
> >+	if (acpi_gbl_FADT.header.revision >= 5 &&
> >+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
> >+		pr_info("ACPI CMOS RTC Not Present detected - not loading\n");
> >+		return 0;
> >+	}
> >+
> > #ifdef	CONFIG_PNP
> > 	retval = pnp_register_driver(&cmos_pnp_driver);
> > 	if (retval == 0)
> 

Thanks a lot!
Joey Lee


