Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3FYTKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:10:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3FYSdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 26/95] parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50 (part 2)
Date: Tue, 25 Jun 2013 11:32:13 -0700
Message-Id: <20130625182156.603815155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 91ea8207168793b365322be3c90a4ee9e8b03ed4 upstream.

Make sure that we really return -1 (instead of 0x00ff) as node id for
page frame numbers which are not physically available.

This finally fixes the kernel panic when running
cat /proc/kpageflags /proc/kpagecount.

Theoretically this patch now limits the number of physical memory ranges
to 127 instead of 254, but currently we have MAX_PHYSMEM_RANGES
hardcoded to 8 which is sufficient for all existing parisc machines.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/mmzone.h |    4 ++--
 arch/parisc/mm/init.c            |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/mmzone.h
+++ b/arch/parisc/include/asm/mmzone.h
@@ -27,7 +27,7 @@ extern struct node_map_data node_data[];
 
 #define PFNNID_SHIFT (30 - PAGE_SHIFT)
 #define PFNNID_MAP_MAX  512     /* support 512GB */
-extern unsigned char pfnnid_map[PFNNID_MAP_MAX];
+extern signed char pfnnid_map[PFNNID_MAP_MAX];
 
 #ifndef CONFIG_64BIT
 #define pfn_is_io(pfn) ((pfn & (0xf0000000UL >> PAGE_SHIFT)) == (0xf0000000UL >> PAGE_SHIFT))
@@ -46,7 +46,7 @@ static inline int pfn_to_nid(unsigned lo
 	i = pfn >> PFNNID_SHIFT;
 	BUG_ON(i >= ARRAY_SIZE(pfnnid_map));
 
-	return (int)pfnnid_map[i];
+	return pfnnid_map[i];
 }
 
 static inline int pfn_valid(int pfn)
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -47,7 +47,7 @@ pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __a
 
 #ifdef CONFIG_DISCONTIGMEM
 struct node_map_data node_data[MAX_NUMNODES] __read_mostly;
-unsigned char pfnnid_map[PFNNID_MAP_MAX] __read_mostly;
+signed char pfnnid_map[PFNNID_MAP_MAX] __read_mostly;
 #endif
 
 static struct resource data_resource = {


