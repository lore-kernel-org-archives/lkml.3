Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3FESwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:52:01 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36126 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3FESv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:51:59 -0400
Subject: [PATCH v4 5/8] powerpc/pseries: Read rtas partition via pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Thu, 06 Jun 2013 00:21:44 +0530
Message-ID: <20130605185144.25794.60834.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
References: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060518-5140-0000-0000-00000352697A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set exploits the pstore subsystem to read details of rtas partition
in NVRAM to a separate file in /dev/pstore. For instance, rtas details will be
stored in a file named [rtas-nvram-4].

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   33 +++++++++++++++++++++++++-------
 fs/pstore/inode.c                      |    3 +++
 include/linux/pstore.h                 |    2 ++
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 9edec8e..78d72f0 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -131,9 +131,11 @@ static struct z_stream_s stream;
 #ifdef CONFIG_PSTORE
 static enum pstore_type_id nvram_type_ids[] = {
 	PSTORE_TYPE_DMESG,
+	PSTORE_TYPE_PPC_RTAS,
 	-1
 };
 static int read_type;
+static unsigned long last_rtas_event;
 #endif
 
 static ssize_t pSeries_nvram_read(char *buf, size_t count, loff_t *index)
@@ -297,8 +299,13 @@ int nvram_write_error_log(char * buff, int length,
 {
 	int rc = nvram_write_os_partition(&rtas_log_partition, buff, length,
 						err_type, error_log_cnt);
-	if (!rc)
+	if (!rc) {
 		last_unread_rtas_event = get_seconds();
+#ifdef CONFIG_PSTORE
+		last_rtas_event = get_seconds();
+#endif
+	}
+
 	return rc;
 }
 
@@ -506,7 +513,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
 }
 
 /*
- * Reads the oops/panic report.
+ * Reads the oops/panic report and ibm,rtas-log partition.
  * Returns the length of the data we read from each partition.
  * Returns 0 if we've been called before.
  */
@@ -526,6 +533,12 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 		part = &oops_log_partition;
 		*type = PSTORE_TYPE_DMESG;
 		break;
+	case PSTORE_TYPE_PPC_RTAS:
+		part = &rtas_log_partition;
+		*type = PSTORE_TYPE_PPC_RTAS;
+		time->tv_sec = last_rtas_event;
+		time->tv_nsec = 0;
+		break;
 	default:
 		return 0;
 	}
@@ -542,11 +555,17 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 
 	*count = 0;
 	*id = id_no;
-	oops_hdr = (struct oops_log_info *)buff;
-	*buf = buff + sizeof(*oops_hdr);
-	time->tv_sec = oops_hdr->timestamp;
-	time->tv_nsec = 0;
-	return oops_hdr->report_length;
+
+	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
+		oops_hdr = (struct oops_log_info *)buff;
+		*buf = buff + sizeof(*oops_hdr);
+		time->tv_sec = oops_hdr->timestamp;
+		time->tv_nsec = 0;
+		return oops_hdr->report_length;
+	}
+
+	*buf = buff;
+	return part->size;
 }
 
 static struct pstore_info nvram_pstore_info = {
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index e4bcb2c..ec24f9c 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -324,6 +324,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	case PSTORE_TYPE_MCE:
 		sprintf(name, "mce-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_PPC_RTAS:
+		sprintf(name, "rtas-%s-%lld", psname, id);
+		break;
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 75d0176..d7a8fe9 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -35,6 +35,8 @@ enum pstore_type_id {
 	PSTORE_TYPE_MCE		= 1,
 	PSTORE_TYPE_CONSOLE	= 2,
 	PSTORE_TYPE_FTRACE	= 3,
+	/* PPC64 partition types */
+	PSTORE_TYPE_PPC_RTAS	= 4,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 

