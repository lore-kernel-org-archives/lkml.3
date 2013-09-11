Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3IKE5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3IKE4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:50 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=63r6cVThG84A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OS_vQPSV07gA:10 a=tHz9FfFoAAAA:8 a=yPCof4ZbAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=6O0IECtVFhoA:10 a=jeBq3FmKZ4MA:10 a=7DSvI1NPTFQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042931.514671052@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [236/251] x86/xen: do not identity map UNUSABLE regions in the machine E820
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0236-x86-xen-do-not-identity-map-UNUSABLE-regions-in-the-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 3bc38cbceb85881a8eb789ee1aa56678038b1909 ]

If there are UNUSABLE regions in the machine memory map, dom0 will
attempt to map them 1:1 which is not permitted by Xen and the kernel
will crash.

There isn't anything interesting in the UNUSABLE region that the dom0
kernel needs access to so we can avoid making the 1:1 mapping and
treat it as RAM.

We only do this for dom0, as that is where tboot case shows up.
A PV domU could have an UNUSABLE region in its pseudo-physical map
and would need to be handled in another patch.

This fixes a boot failure on hosts with tboot.

tboot marks a region in the e820 map as unusable and the dom0 kernel
would attempt to map this region and Xen does not permit unusable
regions to be mapped by guests.

  (XEN)  0000000000000000 - 0000000000060000 (usable)
  (XEN)  0000000000060000 - 0000000000068000 (reserved)
  (XEN)  0000000000068000 - 000000000009e000 (usable)
  (XEN)  0000000000100000 - 0000000000800000 (usable)
  (XEN)  0000000000800000 - 0000000000972000 (unusable)

tboot marked this region as unusable.

  (XEN)  0000000000972000 - 00000000cf200000 (usable)
  (XEN)  00000000cf200000 - 00000000cf38f000 (reserved)
  (XEN)  00000000cf38f000 - 00000000cf3ce000 (ACPI data)
  (XEN)  00000000cf3ce000 - 00000000d0000000 (reserved)
  (XEN)  00000000e0000000 - 00000000f0000000 (reserved)
  (XEN)  00000000fe000000 - 0000000100000000 (reserved)
  (XEN)  0000000100000000 - 0000000630000000 (usable)

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[v1: Altered the patch and description with domU's with UNUSABLE regions]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index e2d62d6..8cf7449 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -313,6 +313,17 @@ static void xen_align_and_add_e820_region(u64 start, u64 size, int type)
 	e820_add_region(start, end - start, type);
 }
 
+void xen_ignore_unusable(struct e820entry *list, size_t map_size)
+{
+	struct e820entry *entry;
+	unsigned int i;
+
+	for (i = 0, entry = list; i < map_size; i++, entry++) {
+		if (entry->type == E820_UNUSABLE)
+			entry->type = E820_RAM;
+	}
+}
+
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
@@ -353,6 +364,17 @@ char * __init xen_memory_setup(void)
 	}
 	BUG_ON(rc);
 
+	/*
+	 * Xen won't allow a 1:1 mapping to be created to UNUSABLE
+	 * regions, so if we're using the machine memory map leave the
+	 * region as RAM as it is in the pseudo-physical map.
+	 *
+	 * UNUSABLE regions in domUs are not handled and will need
+	 * a patch in the future.
+	 */
+	if (xen_initial_domain())
+		xen_ignore_unusable(map, memmap.nr_entries);
+
 	/* Make sure the Xen-supplied memory map is well-ordered. */
 	sanitize_e820_map(map, memmap.nr_entries, &memmap.nr_entries);
 
-- 
1.7.10.4


