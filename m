Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaDYRRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:17:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58034 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbaDYRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:17:01 -0400
Subject: [PATCH 4/4] x86/gart: Tidy messages and add bridge device info
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Bodo Eggert <7eggert@gmx.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 25 Apr 2014 11:16:55 -0600
Message-ID: <20140425171655.312.97511.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140425171144.312.9601.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140425171144.312.9601.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the AGP bridge info the same way as the rest of the kernel, e.g.,
"0000:00:04.0" instead of "00:04:00".

Also print the AGP aperture address range the same way we print resources,
and label it explicitly as a bus address range.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/aperture_64.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 9fa8aa051f54..4dd76d3df056 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -126,10 +126,12 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 	u64 aper;
 	u32 old_order;
 
-	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d: AGP bridge\n", bus, slot,
+	       func);
 	apsizereg = read_pci_config_16(bus, slot, func, cap + 0x14);
 	if (apsizereg == 0xffffffff) {
-		printk(KERN_ERR "APSIZE in AGP bridge unreadable\n");
+		printk(KERN_ERR "pci 0000:%02x:%02x.%d: APSIZE unreadable\n",
+		       bus, slot, func);
 		return 0;
 	}
 
@@ -153,16 +155,18 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 	 * On some sick chips, APSIZE is 0. It means it wants 4G
 	 * so let double check that order, and lets trust AMD NB settings:
 	 */
-	printk(KERN_INFO "Aperture from AGP @ %Lx old size %u MB\n",
-			aper, 32 << old_order);
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d: AGP aperture [bus %Lx-%Lx] old size %u MB\n",
+	       bus, slot, func, aper, aper + (32 << old_order) - 1,
+	       32 << old_order);
 	if (aper + (32ULL<<(20 + *order)) > 0x100000000ULL) {
-		printk(KERN_INFO "Aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
-				32 << *order, apsizereg);
+		printk(KERN_INFO "pci 0000:%02x:%02x.%d: AGP aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
+		       bus, slot, func, 32 << *order, apsizereg);
 		*order = old_order;
 	}
 
-	printk(KERN_INFO "Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n",
-			aper, 32 << *order, apsizereg);
+	printk(KERN_INFO "pci 0000:%02x:%02x.%d: AGP aperture [bus %Lx-%Lx] size %u MB (APSIZE %x)\n",
+	       bus, slot, func, aper, aper + (32 << *order) - 1, 32 << *order,
+	       apsizereg);
 
 	if (!aperture_valid(aper, (32*1024*1024) << *order, 32<<20))
 		return 0;

