Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaGZXWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 19:22:21 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:35600 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaGZXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 19:22:20 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stefan Weinhuber <wein@de.ibm.com>,
        Stefan Haberland <stefan.haberland@de.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: partitions: ibm.c:  Cleaning same magic numbers
Date: Sun, 27 Jul 2014 01:23:44 +0200
Message-Id: <1406417024-9170-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced a lot of the magic number, so it are now using a define instead.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 block/partitions/ibm.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/block/partitions/ibm.c b/block/partitions/ibm.c
index 47a6147..8556ea1 100644
--- a/block/partitions/ibm.c
+++ b/block/partitions/ibm.c
@@ -16,6 +16,8 @@
 #include "check.h"
 #include "ibm.h"
 
+#define IBM_PARTITION_TYPE_SIZE 4
+#define IBM_PARTITION_NAME_SIZE 6
 
 union label_t {
 	struct vtoc_volume_label_cdl vol;
@@ -72,7 +74,7 @@ static int find_label(struct parsed_partitions *state,
 	Sector sect;
 	unsigned char *data;
 	sector_t testsect[3];
-	unsigned char temp[5];
+	unsigned char temp[IBM_PARTITION_TYPE_SIZE + 1];
 	int found = 0;
 	int i, testcount;
 
@@ -102,22 +104,26 @@ static int find_label(struct parsed_partitions *state,
 		if (data == NULL)
 			continue;
 		memcpy(label, data, sizeof(*label));
-		memcpy(temp, data, 4);
-		temp[4] = 0;
-		EBCASC(temp, 4);
+		memcpy(temp, data, IBM_PARTITION_TYPE_SIZE);
+		temp[IBM_PARTITION_TYPE_SIZE] = 0;
+		EBCASC(temp, IBM_PARTITION_TYPE_SIZE);
 		put_dev_sector(sect);
 		if (!strcmp(temp, "VOL1") ||
 		    !strcmp(temp, "LNX1") ||
 		    !strcmp(temp, "CMS1")) {
 			if (!strcmp(temp, "VOL1")) {
-				strncpy(type, label->vol.vollbl, 4);
-				strncpy(name, label->vol.volid, 6);
+				strncpy(type, label->vol.vollbl,
+						IBM_PARTITION_TYPE_SIZE);
+				strncpy(name, label->vol.volid,
+						IBM_PARTITION_NAME_SIZE);
 			} else {
-				strncpy(type, label->lnx.vollbl, 4);
-				strncpy(name, label->lnx.volid, 6);
+				strncpy(type, label->lnx.vollbl,
+						IBM_PARTITION_TYPE_SIZE);
+				strncpy(name, label->lnx.volid,
+						IBM_PARTITION_NAME_SIZE);
 			}
-			EBCASC(type, 4);
-			EBCASC(name, 6);
+			EBCASC(type, IBM_PARTITION_TYPE_SIZE);
+			EBCASC(name, IBM_PARTITION_NAME_SIZE);
 			*labelsect = testsect[i];
 			found = 1;
 			break;
@@ -282,7 +288,6 @@ static int find_cms1_partitions(struct parsed_partitions *state,
 	return 1;
 }
 
-
 /*
  * This is the main function, called by check.c
  */
@@ -293,8 +298,8 @@ int ibm_partition(struct parsed_partitions *state)
 	loff_t i_size, offset, size;
 	dasd_information2_t *info;
 	struct hd_geometry *geo;
-	char type[5] = {0,};
-	char name[7] = {0,};
+	char type[IBM_PARTITION_TYPE_SIZE + 1] = {0,};
+	char name[IBM_PARTITION_NAME_SIZE + 1] = {0,};
 	sector_t labelsect;
 	union label_t *label;
 
@@ -323,14 +328,14 @@ int ibm_partition(struct parsed_partitions *state)
 
 	if (find_label(state, info, geo, blocksize, &labelsect, name, type,
 		       label)) {
-		if (!strncmp(type, "VOL1", 4)) {
+		if (!strncmp(type, "VOL1", IBM_PARTITION_TYPE_SIZE)) {
 			res = find_vol1_partitions(state, geo, blocksize, name,
 						   label);
-		} else if (!strncmp(type, "LNX1", 4)) {
+		} else if (!strncmp(type, "LNX1", IBM_PARTITION_TYPE_SIZE)) {
 			res = find_lnx1_partitions(state, geo, blocksize, name,
 						   label, labelsect, i_size,
 						   info);
-		} else if (!strncmp(type, "CMS1", 4)) {
+		} else if (!strncmp(type, "CMS1", IBM_PARTITION_TYPE_SIZE)) {
 			res = find_cms1_partitions(state, geo, blocksize, name,
 						   label, labelsect);
 		}
-- 
1.7.10.4

