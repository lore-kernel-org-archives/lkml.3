Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3DYKT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:19:27 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43033 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3DYKTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:19:24 -0400
Subject: [PATCH v3 8/8] powerpc/pseries: Read common partition via pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Thu, 25 Apr 2013 15:49:08 +0530
Message-ID: <20130425101908.21017.32553.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042510-3568-0000-0000-0000037D8383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exploits pstore subsystem to read details of common partition
in NVRAM to a separate file in /dev/pstore. For instance, common partition
details will be stored in a file named [common-nvram-6].

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   17 ++++++++++++++++-
 fs/pstore/inode.c                      |    3 +++
 include/linux/pstore.h                 |    1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index f7392f6..14cc486 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -138,10 +138,17 @@ static struct nvram_os_partition of_config_partition = {
 	.os_partition = false
 };
 
+static struct nvram_os_partition common_partition = {
+	.name = "common",
+	.index = -1,
+	.os_partition = false
+};
+
 static enum pstore_type_id nvram_type_ids[] = {
 	PSTORE_TYPE_DMESG,
 	PSTORE_TYPE_PPC_RTAS,
 	PSTORE_TYPE_PPC_OF,
+	PSTORE_TYPE_PPC_COMMON,
 	-1
 };
 static int read_type;
@@ -530,7 +537,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
 }
 
 /*
- * Reads the oops/panic report, rtas and of-config partition.
+ * Reads the oops/panic report, rtas, of-config and common partition.
  * Returns the length of the data we read from each partition.
  * Returns 0 if we've been called before.
  */
@@ -566,6 +573,14 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 		time->tv_sec = 0;
 		time->tv_nsec = 0;
 		break;
+	case PSTORE_TYPE_PPC_COMMON:
+		sig = NVRAM_SIG_SYS;
+		part = &common_partition;
+		*type = PSTORE_TYPE_PPC_COMMON;
+		*id = PSTORE_TYPE_PPC_COMMON;
+		time->tv_sec = 0;
+		time->tv_nsec = 0;
+		break;
 	default:
 		return 0;
 	}
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 8d4fb65..88cc050 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -330,6 +330,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	case PSTORE_TYPE_PPC_OF:
 		sprintf(name, "of-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_PPC_COMMON:
+		sprintf(name, "common-%s-%lld", psname, id);
+		break;
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 615dc18..656699f 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -38,6 +38,7 @@ enum pstore_type_id {
 	/* PPC64 partition types */
 	PSTORE_TYPE_PPC_RTAS	= 4,
 	PSTORE_TYPE_PPC_OF	= 5,
+	PSTORE_TYPE_PPC_COMMON	= 6,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 

