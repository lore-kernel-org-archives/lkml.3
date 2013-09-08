Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab3IHDuS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:50:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56073 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756871Ab3IHDTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Vrabel" <david.vrabel@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.202106424@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [121/121] x86/xen: do not identity map UNUSABLE regions in the
 machine E820
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 3bc38cbceb85881a8eb789ee1aa56678038b1909 upstream.

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
[v1: Altered the patch and description with domU's with UNUSABLE regions]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/setup.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -212,6 +212,17 @@ static void xen_align_and_add_e820_regio
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
@@ -250,6 +261,17 @@ char * __init xen_memory_setup(void)
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
 

