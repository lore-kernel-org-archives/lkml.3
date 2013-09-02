Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab3IBIzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab3IBIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 52/58] x86/xen: do not identity map UNUSABLE regions in the machine E820
Date: Mon,  2 Sep 2013 09:54:37 +0100
Message-Id: <1378112083-9475-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/xen/setup.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index c207fdb..1ba7725 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -318,6 +318,17 @@ static void xen_align_and_add_e820_region(u64 start, u64 size, int type)
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
@@ -358,6 +369,17 @@ char * __init xen_memory_setup(void)
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
1.8.3.2

