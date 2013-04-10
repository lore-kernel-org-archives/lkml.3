Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab3DJHY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:24:28 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50417 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3DJHY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:24:26 -0400
Subject: [PATCH 8/8] Read common partition via pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, anton@samba.org,
        ananth@in.ibm.com
Date: Wed, 10 Apr 2013 12:54:12 +0530
Message-ID: <20130410072412.20150.13002.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041007-9574-0000-0000-00000767624C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exploits pstore infrastructure to read the details
from NVRAM's common partition.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   17 ++++++++++++++++-
 fs/pstore/inode.c                      |    3 +++
 include/linux/pstore.h                 |    1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index b65a670..542dc7e 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -84,6 +84,12 @@ static struct nvram_os_partition of_config_partition = {
 	.index = -1,
 	.os_partition = false
 };
+
+static struct nvram_os_partition common_partition = {
+	.name = "common",
+	.index = -1,
+	.os_partition = false
+};
 #endif
 
 struct oops_log_info {
@@ -157,6 +163,7 @@ static enum pstore_type_id nvram_type_ids[] = {
 	PSTORE_TYPE_DMESG,
 	PSTORE_TYPE_RTAS,
 	PSTORE_TYPE_OF,
+	PSTORE_TYPE_COMMON,
 	-1
 };
 static int read_type;
@@ -770,7 +777,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
 }
 
 /*
- * Reads the oops/panic report, rtas-log and of-config partition.
+ * Reads the oops/panic report, rtas-log, of-config and common partition.
  * Returns the length of the data we read from each partition.
  * Returns 0 if we've been called before.
  */
@@ -806,6 +813,14 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 		time->tv_sec = 0;
 		time->tv_nsec = 0;
 		break;
+	case PSTORE_TYPE_COMMON:
+		sig = NVRAM_SIG_SYS;
+		part = &common_partition;
+		*type = PSTORE_TYPE_COMMON;
+		*id = PSTORE_TYPE_COMMON;
+		time->tv_sec = 0;
+		time->tv_nsec = 0;
+		break;
 	default:
 		return 0;
 	}
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index c3d1846..11cae64 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -330,6 +330,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	case PSTORE_TYPE_OF:
 		sprintf(name, "of-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_COMMON:
+		sprintf(name, "common-%s-%lld", psname, id);
+		break;
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index a23d7d2..08224c2 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -38,6 +38,7 @@ enum pstore_type_id {
 	/* PPC64 partition types */
 	PSTORE_TYPE_RTAS	= 10,
 	PSTORE_TYPE_OF		= 11,
+	PSTORE_TYPE_COMMON	= 12,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 

