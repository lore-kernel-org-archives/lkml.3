Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3GADOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:14:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39312 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489Ab3GADOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:34 -0400
X-Sasl-enc: kSjsGngJ0j3Prhv2nvb3oaBN70pKfmG2HCMnS6iOBpAr 1372648473
Subject: [RFC PATCH 4/7] autofs - merge auto_fs.h and auto_fs4.h
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:29 +0800
Message-ID: <20130701031428.4423.82837.stgit@perseus.fritz.box>
In-Reply-To: <20130701031335.4423.6154.stgit@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The autofs module has long since been removed so there's no need to have
two separate include files for autofs.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/autofs_i.h         |    2 -
 fs/compat_ioctl.c             |    1 
 include/uapi/linux/auto_fs.h  |  156 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/auto_fs4.h |  158 +----------------------------------------
 4 files changed, 149 insertions(+), 168 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 76b8097..1a79bc7 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -10,7 +10,7 @@
 
 /* Internal header file for autofs */
 
-#include <linux/auto_fs4.h>
+#include <linux/auto_fs.h>
 #include <linux/auto_dev-ioctl.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5d19acf..43345ce 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -38,7 +38,6 @@
 #include <linux/if_pppox.h>
 #include <linux/mtio.h>
 #include <linux/auto_fs.h>
-#include <linux/auto_fs4.h>
 #include <linux/tty.h>
 #include <linux/vt_kern.h>
 #include <linux/fb.h>
diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
index bb991df..fe7518d 100644
--- a/include/uapi/linux/auto_fs.h
+++ b/include/uapi/linux/auto_fs.h
@@ -1,8 +1,7 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *   
- * linux/include/linux/auto_fs.h
- *
- *   Copyright 1997 Transmeta Corporation - All Rights Reserved
+/*
+ * Copyright 1997 Transmeta Corporation - All Rights Reserved
+ * Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ * Copyright 2005-2006,2013 Ian Kent <raven@themaw.net>
  *
  * This file is part of the Linux kernel and is made available under
  * the terms of the GNU General Public License, version 2, or at your
@@ -10,7 +9,6 @@
  *
  * ----------------------------------------------------------------------- */
 
-
 #ifndef _UAPI_LINUX_AUTO_FS_H
 #define _UAPI_LINUX_AUTO_FS_H
 
@@ -19,13 +17,11 @@
 #include <sys/ioctl.h>
 #endif /* __KERNEL__ */
 
+#define AUTOFS_PROTO_VERSION		5
+#define AUTOFS_MIN_PROTO_VERSION	3
+#define AUTOFS_MAX_PROTO_VERSION	5
 
-/* This file describes autofs v3 */
-#define AUTOFS_PROTO_VERSION	3
-
-/* Range of protocol versions defined */
-#define AUTOFS_MAX_PROTO_VERSION	AUTOFS_PROTO_VERSION
-#define AUTOFS_MIN_PROTO_VERSION	AUTOFS_PROTO_VERSION
+#define AUTOFS_PROTO_SUBVERSION		2
 
 /*
  * The wait_queue_token (autofs_wqt_t) is part of a structure which is passed
@@ -71,4 +67,140 @@ struct autofs_packet_expire {
 #define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93,0x64,unsigned long)
 #define AUTOFS_IOC_EXPIRE     _IOR(0x93,0x65,struct autofs_packet_expire)
 
+/* autofs version 4 and later definitions */
+
+/* Mask for expire behaviour */
+#define AUTOFS_EXP_IMMEDIATE		1
+#define AUTOFS_EXP_LEAVES		2
+
+#define AUTOFS_TYPE_ANY			0U
+#define AUTOFS_TYPE_INDIRECT		1U
+#define AUTOFS_TYPE_DIRECT		2U
+#define AUTOFS_TYPE_OFFSET		4U
+
+static inline void set_autofs_type_indirect(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_INDIRECT;
+	return;
+}
+
+static inline unsigned int autofs_type_indirect(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_INDIRECT);
+}
+
+static inline void set_autofs_type_direct(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_DIRECT;
+	return;
+}
+
+static inline unsigned int autofs_type_direct(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_DIRECT);
+}
+
+static inline void set_autofs_type_offset(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_OFFSET;
+	return;
+}
+
+static inline unsigned int autofs_type_offset(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_OFFSET);
+}
+
+static inline unsigned int autofs_type_trigger(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_DIRECT || type == AUTOFS_TYPE_OFFSET);
+}
+
+/*
+ * This isn't really a type as we use it to say "no type set" to
+ * indicate we want to search for "any" mount in the
+ * autofs_dev_ioctl_ismountpoint() device ioctl function.
+ */
+static inline void set_autofs_type_any(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_ANY;
+	return;
+}
+
+static inline unsigned int autofs_type_any(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_ANY);
+}
+
+/* Daemon notification packet types */
+enum autofs_notify {
+	NFY_NONE,
+	NFY_MOUNT,
+	NFY_EXPIRE
+};
+
+/* Kernel protocol version 4 packet types */
+
+/* Expire entry (umount request) */
+#define autofs_ptype_expire_multi	2
+
+/* Kernel protocol version 5 packet types */
+
+/* Indirect mount missing and expire requests. */
+#define autofs_ptype_missing_indirect	3
+#define autofs_ptype_expire_indirect	4
+
+/* Direct mount missing and expire requests */
+#define autofs_ptype_missing_direct	5
+#define autofs_ptype_expire_direct	6
+
+/* v4 multi expire (via pipe) */
+struct autofs_packet_expire_multi {
+	struct autofs_packet_hdr hdr;
+        autofs_wqt_t wait_queue_token;
+	int len;
+	char name[NAME_MAX+1];
+};
+
+union autofs_packet_union {
+	struct autofs_packet_hdr hdr;
+	struct autofs_packet_missing missing;
+	struct autofs_packet_expire expire;
+	struct autofs_packet_expire_multi expire_multi;
+};
+
+/* autofs v5 common packet struct */
+struct autofs_v5_packet {
+	struct autofs_packet_hdr hdr;
+	autofs_wqt_t wait_queue_token;
+	__u32 dev;
+	__u64 ino;
+	__u32 uid;
+	__u32 gid;
+	__u32 pid;
+	__u32 tgid;
+	__u32 len;
+	char name[NAME_MAX+1];
+};
+
+typedef struct autofs_v5_packet autofs_packet_missing_indirect_t;
+typedef struct autofs_v5_packet autofs_packet_expire_indirect_t;
+typedef struct autofs_v5_packet autofs_packet_missing_direct_t;
+typedef struct autofs_v5_packet autofs_packet_expire_direct_t;
+
+union autofs_v5_packet_union {
+	struct autofs_packet_hdr hdr;
+	struct autofs_v5_packet v5_packet;
+	autofs_packet_missing_indirect_t missing_indirect;
+	autofs_packet_expire_indirect_t expire_indirect;
+	autofs_packet_missing_direct_t missing_direct;
+	autofs_packet_expire_direct_t expire_direct;
+};
+
+#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
+#define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
+#define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
+#define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93,0x67,int)
+#define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93,0x70,int)
+
 #endif /* _UAPI_LINUX_AUTO_FS_H */
diff --git a/include/uapi/linux/auto_fs4.h b/include/uapi/linux/auto_fs4.h
index e02982f..69205a3 100644
--- a/include/uapi/linux/auto_fs4.h
+++ b/include/uapi/linux/auto_fs4.h
@@ -1,6 +1,4 @@
-/* -*- c -*-
- * linux/include/linux/auto_fs4.h
- *
+/*
  * Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *
  * This file is part of the Linux kernel and is made available under
@@ -8,157 +6,9 @@
  * option, any later version, incorporated herein by reference.
  */
 
-#ifndef _LINUX_AUTO_FS4_H
-#define _LINUX_AUTO_FS4_H
+#ifndef _UAPI_LINUX_AUTO_FS4_H
+#define _UAPI_LINUX_AUTO_FS4_H
 
-/* Include common v3 definitions */
-#include <linux/types.h>
 #include <linux/auto_fs.h>
 
-/* autofs v4 definitions */
-#undef AUTOFS_PROTO_VERSION
-#undef AUTOFS_MIN_PROTO_VERSION
-#undef AUTOFS_MAX_PROTO_VERSION
-
-#define AUTOFS_PROTO_VERSION		5
-#define AUTOFS_MIN_PROTO_VERSION	3
-#define AUTOFS_MAX_PROTO_VERSION	5
-
-#define AUTOFS_PROTO_SUBVERSION		2
-
-/* Mask for expire behaviour */
-#define AUTOFS_EXP_IMMEDIATE		1
-#define AUTOFS_EXP_LEAVES		2
-
-#define AUTOFS_TYPE_ANY			0U
-#define AUTOFS_TYPE_INDIRECT		1U
-#define AUTOFS_TYPE_DIRECT		2U
-#define AUTOFS_TYPE_OFFSET		4U
-
-static inline void set_autofs_type_indirect(unsigned int *type)
-{
-	*type = AUTOFS_TYPE_INDIRECT;
-	return;
-}
-
-static inline unsigned int autofs_type_indirect(unsigned int type)
-{
-	return (type == AUTOFS_TYPE_INDIRECT);
-}
-
-static inline void set_autofs_type_direct(unsigned int *type)
-{
-	*type = AUTOFS_TYPE_DIRECT;
-	return;
-}
-
-static inline unsigned int autofs_type_direct(unsigned int type)
-{
-	return (type == AUTOFS_TYPE_DIRECT);
-}
-
-static inline void set_autofs_type_offset(unsigned int *type)
-{
-	*type = AUTOFS_TYPE_OFFSET;
-	return;
-}
-
-static inline unsigned int autofs_type_offset(unsigned int type)
-{
-	return (type == AUTOFS_TYPE_OFFSET);
-}
-
-static inline unsigned int autofs_type_trigger(unsigned int type)
-{
-	return (type == AUTOFS_TYPE_DIRECT || type == AUTOFS_TYPE_OFFSET);
-}
-
-/*
- * This isn't really a type as we use it to say "no type set" to
- * indicate we want to search for "any" mount in the
- * autofs_dev_ioctl_ismountpoint() device ioctl function.
- */
-static inline void set_autofs_type_any(unsigned int *type)
-{
-	*type = AUTOFS_TYPE_ANY;
-	return;
-}
-
-static inline unsigned int autofs_type_any(unsigned int type)
-{
-	return (type == AUTOFS_TYPE_ANY);
-}
-
-/* Daemon notification packet types */
-enum autofs_notify {
-	NFY_NONE,
-	NFY_MOUNT,
-	NFY_EXPIRE
-};
-
-/* Kernel protocol version 4 packet types */
-
-/* Expire entry (umount request) */
-#define autofs_ptype_expire_multi	2
-
-/* Kernel protocol version 5 packet types */
-
-/* Indirect mount missing and expire requests. */
-#define autofs_ptype_missing_indirect	3
-#define autofs_ptype_expire_indirect	4
-
-/* Direct mount missing and expire requests */
-#define autofs_ptype_missing_direct	5
-#define autofs_ptype_expire_direct	6
-
-/* v4 multi expire (via pipe) */
-struct autofs_packet_expire_multi {
-	struct autofs_packet_hdr hdr;
-        autofs_wqt_t wait_queue_token;
-	int len;
-	char name[NAME_MAX+1];
-};
-
-union autofs_packet_union {
-	struct autofs_packet_hdr hdr;
-	struct autofs_packet_missing missing;
-	struct autofs_packet_expire expire;
-	struct autofs_packet_expire_multi expire_multi;
-};
-
-/* autofs v5 common packet struct */
-struct autofs_v5_packet {
-	struct autofs_packet_hdr hdr;
-	autofs_wqt_t wait_queue_token;
-	__u32 dev;
-	__u64 ino;
-	__u32 uid;
-	__u32 gid;
-	__u32 pid;
-	__u32 tgid;
-	__u32 len;
-	char name[NAME_MAX+1];
-};
-
-typedef struct autofs_v5_packet autofs_packet_missing_indirect_t;
-typedef struct autofs_v5_packet autofs_packet_expire_indirect_t;
-typedef struct autofs_v5_packet autofs_packet_missing_direct_t;
-typedef struct autofs_v5_packet autofs_packet_expire_direct_t;
-
-union autofs_v5_packet_union {
-	struct autofs_packet_hdr hdr;
-	struct autofs_v5_packet v5_packet;
-	autofs_packet_missing_indirect_t missing_indirect;
-	autofs_packet_expire_indirect_t expire_indirect;
-	autofs_packet_missing_direct_t missing_direct;
-	autofs_packet_expire_direct_t expire_direct;
-};
-
-#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
-#define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93,0x67,int)
-#define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93,0x70,int)
-
-
-#endif /* _LINUX_AUTO_FS4_H */
+#endif /* _UAPI_LINUX_AUTO_FS4_H */

