Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab3DJHYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:24:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42037 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3DJHYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:24:16 -0400
Subject: [PATCH 7/8] Read of-config partition via pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, anton@samba.org,
        ananth@in.ibm.com
Date: Wed, 10 Apr 2013 12:54:02 +0530
Message-ID: <20130410072402.20150.11890.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041007-3864-0000-0000-000007A6C882
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exploits pstore infrastructure to read the details
from NVRAM's of-config partition.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   58 ++++++++++++++++++++++++++------
 fs/pstore/inode.c                      |    3 ++
 include/linux/pstore.h                 |    1 +
 3 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 6a3a7cd..b65a670 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -78,6 +78,14 @@ static const char *pseries_nvram_os_partitions[] = {
 	NULL
 };
 
+#ifdef CONFIG_PSTORE
+static struct nvram_os_partition of_config_partition = {
+	.name = "of-config",
+	.index = -1,
+	.os_partition = false
+};
+#endif
+
 struct oops_log_info {
 	u16 version;
 	u16 report_length;
@@ -148,6 +156,7 @@ static size_t oops_data_sz;
 static enum pstore_type_id nvram_type_ids[] = {
 	PSTORE_TYPE_DMESG,
 	PSTORE_TYPE_RTAS,
+	PSTORE_TYPE_OF,
 	-1
 };
 static int read_type;
@@ -350,11 +359,15 @@ int nvram_read_partition(struct nvram_os_partition *part, char *buff,
 
 	tmp_index = part->index;
 
-	rc = ppc_md.nvram_read((char *)&info, sizeof(struct err_log_info), &tmp_index);
-	if (rc <= 0) {
-		printk(KERN_ERR "nvram_read_partition: "
-				"Failed nvram_read (%d)\n", rc);
-		return rc;
+	if (part->os_partition) {
+		rc = ppc_md.nvram_read((char *)&info,
+					sizeof(struct err_log_info),
+					&tmp_index);
+		if (rc <= 0) {
+			printk(KERN_ERR "nvram_read_partition: "
+					"Failed nvram_read (%d)\n", rc);
+			return rc;
+		}
 	}
 
 	rc = ppc_md.nvram_read(buff, length, &tmp_index);
@@ -364,8 +377,10 @@ int nvram_read_partition(struct nvram_os_partition *part, char *buff,
 		return rc;
 	}
 
-	*error_log_cnt = info.seq_num;
-	*err_type = info.error_type;
+	if (part->os_partition) {
+		*error_log_cnt = info.seq_num;
+		*err_type = info.error_type;
+	}
 
 	return 0;
 }
@@ -755,7 +770,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
 }
 
 /*
- * Reads the oops/panic report and ibm,rtas-log partition.
+ * Reads the oops/panic report, rtas-log and of-config partition.
  * Returns the length of the data we read from each partition.
  * Returns 0 if we've been called before.
  */
@@ -764,9 +779,11 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 				struct pstore_info *psi)
 {
 	struct oops_log_info *oops_hdr;
-	unsigned int err_type, id_no;
+	unsigned int err_type, id_no, size = 0;
 	struct nvram_os_partition *part = NULL;
 	char *buff = NULL;
+	int sig = 0;
+	loff_t p;
 
 	read_type++;
 
@@ -781,10 +798,29 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 		time->tv_sec = last_rtas_event;
 		time->tv_nsec = 0;
 		break;
+	case PSTORE_TYPE_OF:
+		sig = NVRAM_SIG_OF;
+		part = &of_config_partition;
+		*type = PSTORE_TYPE_OF;
+		*id = PSTORE_TYPE_OF;
+		time->tv_sec = 0;
+		time->tv_nsec = 0;
+		break;
 	default:
 		return 0;
 	}
 
+	if (!part->os_partition) {
+		p = nvram_find_partition(part->name, sig, &size);
+		if (p <= 0) {
+			pr_err("nvram: Failed to find partition %s, "
+				"err %d\n", part->name, (int)p);
+			return 0;
+		}
+		part->index = p;
+		part->size = size;
+	}
+
 	buff = kmalloc(part->size, GFP_KERNEL);
 
 	if (!buff)
@@ -796,7 +832,9 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 	}
 
 	*count = 0;
-	*id = id_no;
+
+	if (part->os_partition)
+		*id = id_no;
 
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
 		oops_hdr = (struct oops_log_info *)buff;
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 59b1454..c3d1846 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -327,6 +327,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	case PSTORE_TYPE_RTAS:
 		sprintf(name, "rtas-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_OF:
+		sprintf(name, "of-%s-%lld", psname, id);
+		break;
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 4eb94c9..a23d7d2 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -37,6 +37,7 @@ enum pstore_type_id {
 	PSTORE_TYPE_FTRACE	= 3,
 	/* PPC64 partition types */
 	PSTORE_TYPE_RTAS	= 10,
+	PSTORE_TYPE_OF		= 11,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 

