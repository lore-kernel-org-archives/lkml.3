Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LARIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 12:08:41 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58288 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3LARIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 12:08:37 -0500
From: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
To: <omar.ramirez@copitl.com>
Cc: gregkh@linuxfoundation.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
Date: Sun,  1 Dec 2013 19:07:40 +0200
Message-Id: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
need to be exported. It can also be made way simpler by using sscanf.

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
---
 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |   85 --------------------
 .../tidspbridge/include/dspbridge/uuidutil.h       |   18 ----
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   42 +++++++++-
 4 files changed, 39 insertions(+), 108 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 230e3e6..2e77734 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge.o
 
-libgen = gen/gh.o gen/uuidutil.o
+libgen = gen/gh.o
 libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
 		core/tiomap3430_pwr.o core/tiomap_io.o \
 		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
deleted file mode 100644
index b7d8313..0000000
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * uuidutil.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * This file contains the implementation of UUID helper functions.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-#include <linux/types.h>
-
-/*  ----------------------------------- Host OS */
-#include <dspbridge/host_os.h>
-
-/*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/dbdefs.h>
-
-/*  ----------------------------------- This */
-#include <dspbridge/uuidutil.h>
-
-static s32 uuid_hex_to_bin(char *buf, s32 len)
-{
-	s32 i;
-	s32 result = 0;
-	int value;
-
-	for (i = 0; i < len; i++) {
-		value = hex_to_bin(*buf++);
-		result *= 16;
-		if (value > 0)
-			result += value;
-	}
-
-	return result;
-}
-
-/*
- *  ======== uuid_uuid_from_string ========
- *  Purpose:
- *      Converts a string to a struct dsp_uuid.
- */
-void uuid_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
-{
-	s32 j;
-
-	uuid_obj->data1 = uuid_hex_to_bin(sz_uuid, 8);
-	sz_uuid += 8;
-
-	/* Step over underscore */
-	sz_uuid++;
-
-	uuid_obj->data2 = (u16) uuid_hex_to_bin(sz_uuid, 4);
-	sz_uuid += 4;
-
-	/* Step over underscore */
-	sz_uuid++;
-
-	uuid_obj->data3 = (u16) uuid_hex_to_bin(sz_uuid, 4);
-	sz_uuid += 4;
-
-	/* Step over underscore */
-	sz_uuid++;
-
-	uuid_obj->data4 = (u8) uuid_hex_to_bin(sz_uuid, 2);
-	sz_uuid += 2;
-
-	uuid_obj->data5 = (u8) uuid_hex_to_bin(sz_uuid, 2);
-	sz_uuid += 2;
-
-	/* Step over underscore */
-	sz_uuid++;
-
-	for (j = 0; j < 6; j++) {
-		uuid_obj->data6[j] = (u8) uuid_hex_to_bin(sz_uuid, 2);
-		sz_uuid += 2;
-	}
-}
diff --git a/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h b/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
index 414bf71..b4951a1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
@@ -21,22 +21,4 @@
 
 #define MAXUUIDLEN  37
 
-/*
- *  ======== uuid_uuid_from_string ========
- *  Purpose:
- *      Converts an ANSI string to a dsp_uuid.
- *  Parameters:
- *      sz_uuid:    Pointer to a string that represents a dsp_uuid object.
- *      uuid_obj:      Pointer to a dsp_uuid object.
- *  Returns:
- *  Requires:
- *      uuid_obj & sz_uuid are non-NULL values.
- *  Ensures:
- *  Details:
- *      We assume the string representation of a UUID has the following format:
- *      "12345678_1234_1234_1234_123456789abc".
- */
-extern void uuid_uuid_from_string(char *sz_uuid,
-				  struct dsp_uuid *uuid_obj);
-
 #endif /* UUIDUTIL_ */
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 3d2a26f..d640794 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -74,6 +74,40 @@ static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 				   enum nldr_phase phase);
 
 /*
+ *  ======== dcd_uuid_from_string ========
+ *  Purpose:
+ *      Converts an ANSI string to a dsp_uuid.
+ *  Parameters:
+ *      sz_uuid:    Pointer to a string that represents a dsp_uuid object.
+ *      uuid_obj:      Pointer to a dsp_uuid object.
+ *  Returns:
+ *  Requires:
+ *      uuid_obj & sz_uuid are non-NULL values.
+ *  Ensures:
+ *  Details:
+ *      We assume the string representation of a UUID has the following format:
+ *      "12345678_1234_1234_1234_123456789abc".
+ */
+static void dcd_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
+{
+	char c;
+	u64 t;
+
+	/*
+	 * sscanf implementation cannot deal with hh format modifier
+	 * if the converted value doesn't fit in u32. So, convert the
+	 * last six bytes to u64 and memcpy what is needed
+	 */
+	sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
+	       &uuid_obj->data1, &c, &uuid_obj->data2, &c,
+	       &uuid_obj->data3, &c, &uuid_obj->data4,
+	       &uuid_obj->data5, &c, &t);
+
+	t = cpu_to_be64(t);
+	memcpy(&uuid_obj->data6[0], ((char*)&t) + 2, 6);
+}
+
+/*
  *  ======== dcd_auto_register ========
  *  Purpose:
  *      Parses the supplied image and resigsters with DCD.
@@ -253,7 +287,7 @@ int dcd_enumerate_object(s32 index, enum dsp_dcdobjtype obj_type,
 		if (!status) {
 			/* Create UUID value using string retrieved from
 			 * registry. */
-			uuid_uuid_from_string(sz_value, &dsp_uuid_obj);
+			dcd_uuid_from_string(sz_value, &dsp_uuid_obj);
 
 			*uuid_obj = dsp_uuid_obj;
 
@@ -581,7 +615,7 @@ int dcd_get_objects(struct dcd_manager *hdcd_mgr,
 		psz_cur = psz_coff_buf;
 		while ((token = strsep(&psz_cur, seps)) && *token != '\0') {
 			/*  Retrieve UUID string. */
-			uuid_uuid_from_string(token, &dsp_uuid_obj);
+			dcd_uuid_from_string(token, &dsp_uuid_obj);
 
 			/*  Retrieve object type */
 			token = strsep(&psz_cur, seps);
@@ -1001,7 +1035,7 @@ static int get_attrs_from_buf(char *psz_buf, u32 ul_buf_size,
 		token = strsep(&psz_cur, seps);
 
 		/* dsp_uuid ui_node_id */
-		uuid_uuid_from_string(token,
+		dcd_uuid_from_string(token,
 				      &gen_obj->obj_data.node_obj.ndb_props.
 				      ui_node_id);
 		token = strsep(&psz_cur, seps);
@@ -1400,7 +1434,7 @@ static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 				break;
 			} else {
 				/* Retrieve UUID string. */
-				uuid_uuid_from_string(token,
+				dcd_uuid_from_string(token,
 						      &(dep_lib_uuids
 							[dep_libs]));
 				/* Is this library persistent? */
-- 
1.5.6.1

