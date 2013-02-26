Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3BZIMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:12:42 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23416 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3BZIMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:12:41 -0500
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "trenn@suse.com" <trenn@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [stable 3.0] x86/apic: Work around boot failure on HP ProLiant
 DL980 G7 Server systems
Thread-Topic: [stable 3.0] x86/apic: Work around boot failure on HP ProLiant
 DL980 G7 Server systems
Thread-Index: Ac4T8vCLgq5E+qDuQ8+UgYL/JFNp1Q==
Date: Tue, 26 Feb 2013 08:11:41 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F9C2EC47@G2W2436.americas.hpqcorp.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.29]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch is specially for 3.0 by integrating upstream commit cb214ede7657db458fd0b2a25ea0b28dbf900ebc and ea0dcf903e7d76aa5d483d876215fedcfdfe140f
I tested it in v3.0.66. any questions, let me know. Thanks. 

----------------------

From: Zhang Lin-Bao <linbao.zhang@hp.com>
x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems

commit cb214ede7657db458fd0b2a25ea0b28dbf900ebc and ea0dcf903e7d76aa5d483d876215fedcfdfe140f upstream.

HP ProLiant DL980 G7 Server boots a regular kernel, there will be intermittent lost interrupts which could result in a hang or (in extreme cases) data loss.

The reason is that this system only supports x2apic physical mode, while the kernel boots with a logical-cluster default setting.

This bug can be worked around by specifying "x2apic_phys" or "nox2apic" boot option, but we want to handle this system without requiring manual workarounds.

BIOS set ACPI_FADT_APIC_PHYSICAL in FADT table.
As all apicids are less than 255, BIOS need to pass the control to the OS with xapic mode, according to x2apic-spec, chapter 2.9.

Current code handle x2apic when BIOS pass with xapic mode:
When user specify x2apic_phys, or FADT indicates PHYSICAL.
1. During madt oem check, apic driver is set with xapic logical or xapic phys driver at first.
2. enable_IR_x2apic() will enable x2apic_mode.
3. if user specify x2apic_phys, x2apic_phys_probe() will install right x2apic phys driver and use x2apic phys mode.
otherwise will skip and let x2apic_cluster_probe to take over to install x2apic cluster driver (wrong one) even FADT indicates PHYSICAL, because x2apic_phys_probe does not check FADT PHYSICAL.

Add checking x2apic_fadt_phys in x2apic_phys_probe() to fix the problem.

Signed-off-by: Stoney Wang <song-bo.wang@hp.com> 
[ updated the changelog and simplified the code ]
Signed-off-by: Yinghai Lu <yinghai@kernel.org> 
Link: http://lkml.kernel.org/r/1360263182-16226-1-git-send-email-yinghai@kernel.org
Signed-off-by: Lin-Bao Zhang <Linbao.zhang@hp.com>
[ make this patch specially for 3.0 ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>

---
arch/x86/kernel/apic/x2apic_phys.c |   17 ++++++++++++-----
1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f5373df..0f8cb3a 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,12 +20,19 @@ static int set_x2apic_phys_mode(char *arg)  }  early_param("x2apic_phys", set_x2apic_phys_mode);

+static bool x2apic_fadt_phys(void)
+{
+       if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+               (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
+               printk(KERN_DEBUG "System requires x2apic physical mode\n");
+               return true;
+       }
+       return false;
+}
+
static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)  {
-       if (x2apic_phys)
-               return x2apic_enabled();
-       else
-               return 0;
+       return x2apic_enabled() && (x2apic_phys || x2apic_fadt_phys());
}

static void
@@ -108,7 +115,7 @@ static void init_x2apic_ldr(void)

static int x2apic_phys_probe(void)
{
-       if (x2apic_mode && x2apic_phys)
+       if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
                return 1;

        return apic == &apic_x2apic_phys;
--
1.7.9


-- Bob(LinBao Zhang)
HP linux kernel enginner

