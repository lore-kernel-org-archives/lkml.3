Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3JPLEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:04:39 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:58835 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060Ab3JPLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 7/8] zorro/UAPI: Disintegrate include/linux/zorro*.h
Date: Wed, 16 Oct 2013 13:03:24 +0200
Message-Id: <1381921405-11206-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zorro definitions and device IDs are used by bootstraps, hence they
should be exported through UAPI.

Unfortunately zorro.h was never marked for export when headers_install
was introduced, so it was forgotten during the big UAPI disintegration.
In addition, the removal of zorro_ids.h had been sneaked into commit
7e7a43c32a8970ea2bfc3d1af353dcb1a9237769 ("PCI: don't export device IDs to
userspace") before, so it was also forgotten.

Split off and export the Zorro definitions used by bootstraps.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 Documentation/zorro.txt              |    3 +-
 include/linux/zorro.h                |  103 +------------------------------
 include/uapi/linux/Kbuild            |    2 +
 include/uapi/linux/zorro.h           |  113 ++++++++++++++++++++++++++++++++++
 include/{ => uapi}/linux/zorro_ids.h |    0
 5 files changed, 119 insertions(+), 102 deletions(-)
 create mode 100644 include/uapi/linux/zorro.h
 rename include/{ => uapi}/linux/zorro_ids.h (100%)

diff --git a/Documentation/zorro.txt b/Documentation/zorro.txt
index d17670400564..90a64d52bea2 100644
--- a/Documentation/zorro.txt
+++ b/Documentation/zorro.txt
@@ -95,8 +95,9 @@ The treatment of these regions depends on the type of Zorro space:
 -------------
 
 linux/include/linux/zorro.h
+linux/include/uapi/linux/zorro.h
+linux/include/uapi/linux/zorro_ids.h
 linux/arch/m68k/include/asm/zorro.h
-linux/include/linux/zorro_ids.h
 linux/drivers/zorro
 /proc/bus/zorro
 
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 661cbd2a86ee..63fbba0740c2 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -11,107 +11,10 @@
 #ifndef _LINUX_ZORRO_H
 #define _LINUX_ZORRO_H
 
-#include <linux/device.h>
-
-
-    /*
-     *  Each Zorro board has a 32-bit ID of the form
-     *
-     *      mmmmmmmmmmmmmmmmppppppppeeeeeeee
-     *
-     *  with
-     *
-     *      mmmmmmmmmmmmmmmm	16-bit Manufacturer ID (assigned by CBM (sigh))
-     *      pppppppp		8-bit Product ID (assigned by manufacturer)
-     *      eeeeeeee		8-bit Extended Product ID (currently only used
-     *				for some GVP boards)
-     */
-
-
-#define ZORRO_MANUF(id)		((id) >> 16)
-#define ZORRO_PROD(id)		(((id) >> 8) & 0xff)
-#define ZORRO_EPC(id)		((id) & 0xff)
-
-#define ZORRO_ID(manuf, prod, epc) \
-    ((ZORRO_MANUF_##manuf << 16) | ((prod) << 8) | (epc))
-
-typedef __u32 zorro_id;
 
+#include <uapi/linux/zorro.h>
 
-/* Include the ID list */
-#include <linux/zorro_ids.h>
-
-
-    /*
-     *  GVP identifies most of its products through the 'extended product code'
-     *  (epc). The epc has to be ANDed with the GVP_PRODMASK before the
-     *  identification.
-     */
-
-#define GVP_PRODMASK			(0xf8)
-#define GVP_SCSICLKMASK			(0x01)
-
-enum GVP_flags {
-    GVP_IO		= 0x01,
-    GVP_ACCEL		= 0x02,
-    GVP_SCSI		= 0x04,
-    GVP_24BITDMA	= 0x08,
-    GVP_25BITDMA	= 0x10,
-    GVP_NOBANK		= 0x20,
-    GVP_14MHZ		= 0x40,
-};
-
-
-struct Node {
-    struct  Node *ln_Succ;	/* Pointer to next (successor) */
-    struct  Node *ln_Pred;	/* Pointer to previous (predecessor) */
-    __u8    ln_Type;
-    __s8    ln_Pri;		/* Priority, for sorting */
-    __s8    *ln_Name;		/* ID string, null terminated */
-} __attribute__ ((packed));
-
-struct ExpansionRom {
-    /* -First 16 bytes of the expansion ROM */
-    __u8  er_Type;		/* Board type, size and flags */
-    __u8  er_Product;		/* Product number, assigned by manufacturer */
-    __u8  er_Flags;		/* Flags */
-    __u8  er_Reserved03;	/* Must be zero ($ff inverted) */
-    __u16 er_Manufacturer;	/* Unique ID, ASSIGNED BY COMMODORE-AMIGA! */
-    __u32 er_SerialNumber;	/* Available for use by manufacturer */
-    __u16 er_InitDiagVec;	/* Offset to optional "DiagArea" structure */
-    __u8  er_Reserved0c;
-    __u8  er_Reserved0d;
-    __u8  er_Reserved0e;
-    __u8  er_Reserved0f;
-} __attribute__ ((packed));
-
-/* er_Type board type bits */
-#define ERT_TYPEMASK	0xc0
-#define ERT_ZORROII	0xc0
-#define ERT_ZORROIII	0x80
-
-/* other bits defined in er_Type */
-#define ERTB_MEMLIST	5		/* Link RAM into free memory list */
-#define ERTF_MEMLIST	(1<<5)
-
-struct ConfigDev {
-    struct Node		cd_Node;
-    __u8		cd_Flags;	/* (read/write) */
-    __u8		cd_Pad;		/* reserved */
-    struct ExpansionRom cd_Rom;		/* copy of board's expansion ROM */
-    void		*cd_BoardAddr;	/* where in memory the board was placed */
-    __u32		cd_BoardSize;	/* size of board in bytes */
-    __u16		cd_SlotAddr;	/* which slot number (PRIVATE) */
-    __u16		cd_SlotSize;	/* number of slots (PRIVATE) */
-    void		*cd_Driver;	/* pointer to node of driver */
-    struct ConfigDev	*cd_NextCD;	/* linked list of drivers to config */
-    __u32		cd_Unused[4];	/* for whatever the driver wants */
-} __attribute__ ((packed));
-
-#define ZORRO_NUM_AUTO		16
-
-#ifdef __KERNEL__
-
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/mod_devicetable.h>
@@ -245,6 +148,4 @@ extern DECLARE_BITMAP(zorro_unused_z2ram, 128);
 #define Z2RAM_CHUNKSHIFT	(16)
 
 
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_ZORRO_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 115add2515aa..5b973b187eeb 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -424,3 +424,5 @@ header-y += x25.h
 header-y += xattr.h
 header-y += xfrm.h
 header-y += hw_breakpoint.h
+header-y += zorro.h
+header-y += zorro_ids.h
diff --git a/include/uapi/linux/zorro.h b/include/uapi/linux/zorro.h
new file mode 100644
index 000000000000..36a033e23d31
--- /dev/null
+++ b/include/uapi/linux/zorro.h
@@ -0,0 +1,113 @@
+/*
+ *  linux/zorro.h -- Amiga AutoConfig (Zorro) Bus Definitions
+ *
+ *  Copyright (C) 1995--2003 Geert Uytterhoeven
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of this archive
+ *  for more details.
+ */
+
+#ifndef _UAPI_LINUX_ZORRO_H
+#define _UAPI_LINUX_ZORRO_H
+
+#include <linux/types.h>
+
+
+    /*
+     *  Each Zorro board has a 32-bit ID of the form
+     *
+     *      mmmmmmmmmmmmmmmmppppppppeeeeeeee
+     *
+     *  with
+     *
+     *      mmmmmmmmmmmmmmmm	16-bit Manufacturer ID (assigned by CBM (sigh))
+     *      pppppppp		8-bit Product ID (assigned by manufacturer)
+     *      eeeeeeee		8-bit Extended Product ID (currently only used
+     *				for some GVP boards)
+     */
+
+
+#define ZORRO_MANUF(id)		((id) >> 16)
+#define ZORRO_PROD(id)		(((id) >> 8) & 0xff)
+#define ZORRO_EPC(id)		((id) & 0xff)
+
+#define ZORRO_ID(manuf, prod, epc) \
+	((ZORRO_MANUF_##manuf << 16) | ((prod) << 8) | (epc))
+
+typedef __u32 zorro_id;
+
+
+/* Include the ID list */
+#include <linux/zorro_ids.h>
+
+
+    /*
+     *  GVP identifies most of its products through the 'extended product code'
+     *  (epc). The epc has to be ANDed with the GVP_PRODMASK before the
+     *  identification.
+     */
+
+#define GVP_PRODMASK		(0xf8)
+#define GVP_SCSICLKMASK		(0x01)
+
+enum GVP_flags {
+	GVP_IO			= 0x01,
+	GVP_ACCEL		= 0x02,
+	GVP_SCSI		= 0x04,
+	GVP_24BITDMA		= 0x08,
+	GVP_25BITDMA		= 0x10,
+	GVP_NOBANK		= 0x20,
+	GVP_14MHZ		= 0x40,
+};
+
+
+struct Node {
+	struct  Node *ln_Succ;	/* Pointer to next (successor) */
+	struct  Node *ln_Pred;	/* Pointer to previous (predecessor) */
+	__u8    ln_Type;
+	__s8    ln_Pri;		/* Priority, for sorting */
+	__s8    *ln_Name;	/* ID string, null terminated */
+} __packed;
+
+struct ExpansionRom {
+	/* -First 16 bytes of the expansion ROM */
+	__u8  er_Type;		/* Board type, size and flags */
+	__u8  er_Product;	/* Product number, assigned by manufacturer */
+	__u8  er_Flags;		/* Flags */
+	__u8  er_Reserved03;	/* Must be zero ($ff inverted) */
+	__u16 er_Manufacturer;	/* Unique ID, ASSIGNED BY COMMODORE-AMIGA! */
+	__u32 er_SerialNumber;	/* Available for use by manufacturer */
+	__u16 er_InitDiagVec;	/* Offset to optional "DiagArea" structure */
+	__u8  er_Reserved0c;
+	__u8  er_Reserved0d;
+	__u8  er_Reserved0e;
+	__u8  er_Reserved0f;
+} __packed;
+
+/* er_Type board type bits */
+#define ERT_TYPEMASK	0xc0
+#define ERT_ZORROII	0xc0
+#define ERT_ZORROIII	0x80
+
+/* other bits defined in er_Type */
+#define ERTB_MEMLIST	5		/* Link RAM into free memory list */
+#define ERTF_MEMLIST	(1<<5)
+
+struct ConfigDev {
+	struct Node	cd_Node;
+	__u8		cd_Flags;	/* (read/write) */
+	__u8		cd_Pad;		/* reserved */
+	struct ExpansionRom cd_Rom;	/* copy of board's expansion ROM */
+	void		*cd_BoardAddr;	/* where in memory the board was placed */
+	__u32		cd_BoardSize;	/* size of board in bytes */
+	__u16		cd_SlotAddr;	/* which slot number (PRIVATE) */
+	__u16		cd_SlotSize;	/* number of slots (PRIVATE) */
+	void		*cd_Driver;	/* pointer to node of driver */
+	struct ConfigDev *cd_NextCD;	/* linked list of drivers to config */
+	__u32		cd_Unused[4];	/* for whatever the driver wants */
+} __packed;
+
+#define ZORRO_NUM_AUTO		16
+
+#endif /* _UAPI_LINUX_ZORRO_H */
diff --git a/include/linux/zorro_ids.h b/include/uapi/linux/zorro_ids.h
similarity index 100%
rename from include/linux/zorro_ids.h
rename to include/uapi/linux/zorro_ids.h
-- 
1.7.9.5

