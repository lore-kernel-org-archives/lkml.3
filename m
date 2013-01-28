Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009Ab3A1FFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:05:49 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:48830 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3A1FFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:05:47 -0500
From: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
To: "yinghai@kernel.org" <yinghai@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
CC: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
Subject: RE: [PATCH] x86/apic: check FADT settings after enable x2apic
Thread-Topic: [PATCH] x86/apic: check FADT settings after enable x2apic
Thread-Index: AQHN8sLbtrSsPj2mD0qoH/EbzuNDVZheOwHg
Date: Mon, 28 Jan 2013 05:05:32 +0000
Message-ID: <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
In-Reply-To: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai, hpa and others,

Would you please review the patch on detecting x2apic FADT settings?

We meet a BIOS system which works on x2apic physical mode by setting the bit ACPI_FADT_APIC_PHYSICAL in FADT table.
And for those systems with all cpuid < 255, the spec requires BIOS's default mode in xapic.
The kernel detects the default mode and do some initializations and will call enable_IR_x2apic and change the mode to x2apic successfully.

So it is necessary to check ACPI_FADT_APIC_PHYSICAL bit after the kernel change the mode from xapic to x2apic.

(*drv)->acpi_madt_oem_check is called on detect default BIOS mode,
(*drv)->probe is called after enable_IR_x2apic,

The previous FADT check (commit ea0dcf90) should be applied to x2apic_phys_probe too.

Thanks,
Stoney

-----Original Message-----
From: Wang, Song-Bo (Stoney) 
Sent: Tuesday, January 15, 2013 9:51 AM
To: suresh.b.siddha@intel.com
Cc: Zhang, Lin-Bao (Linux Kernel R&D); Pearson, Greg; linux-kernel@vger.kernel.org; Wang, Song-Bo (Stoney)
Subject: [PATCH] x86/apic: check FADT settings after enable x2apic

OS will enable x2apic mode even BIOS default in xapic mode.

FADT settings check (commit ea0dcf903e7d76aa5d483d876215fedcfdfe140f)
should be applied after detect default mode and change the mode (enable_IR_x2apic called)

Signed-off-by: Stoney Wang <song-bo.wang@hp.com>
---
 arch/x86/kernel/apic/x2apic_phys.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index e03a1e1..76ea60d 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,18 +20,22 @@ static int set_x2apic_phys_mode(char *arg)  }  early_param("x2apic_phys", set_x2apic_phys_mode);
 
-static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int x2apic_fadt_phys(void)
 {
-	if (x2apic_phys)
-		return x2apic_enabled();
-	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
-		x2apic_enabled()) {
+	if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "System requires x2apic physical mode\n");
 		return 1;
 	}
-	else
-		return 0;
+	return 0;
+}
+
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id) 
+{
+	if (x2apic_enabled())
+		return x2apic_phys || x2apic_fadt_phys();
+
+	return 0;
 }
 
 static void
@@ -85,7 +89,10 @@ static int x2apic_phys_probe(void)
 	if (x2apic_mode && x2apic_phys)
 		return 1;
 
-	return apic == &apic_x2apic_phys;
+	if (apic == &apic_x2apic_phys)
+		return 1;
+
+	return x2apic_enabled() && x2apic_fadt_phys();
 }
 
 static struct apic apic_x2apic_phys = {
--
1.7.1

