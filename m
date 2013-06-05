Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3FESvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:51:37 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45192 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab3FESvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:51:35 -0400
Subject: [PATCH v4 3/8] powerpc/pseries: Introduce generic read function to
 read nvram-partitions
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Thu, 06 Jun 2013 00:21:16 +0530
Message-ID: <20130605185116.25794.36566.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
References: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060518-8256-0000-0000-000007CF347A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic read function to read nvram partitions other than rtas.
nvram_read_error_log will be retained which is used to read rtas partition
from rtasd. nvram_read_partition is the generic read function to read from
any nvram partition.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 742735a..088f023 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -293,34 +293,35 @@ int nvram_write_error_log(char * buff, int length,
 	return rc;
 }
 
-/* nvram_read_error_log
+/* nvram_read_partition
  *
- * Reads nvram for error log for at most 'length'
+ * Reads nvram partition for at most 'length'
  */
-int nvram_read_error_log(char * buff, int length,
-                         unsigned int * err_type, unsigned int * error_log_cnt)
+int nvram_read_partition(struct nvram_os_partition *part, char *buff,
+			int length, unsigned int *err_type,
+			unsigned int *error_log_cnt)
 {
 	int rc;
 	loff_t tmp_index;
 	struct err_log_info info;
 	
-	if (rtas_log_partition.index == -1)
+	if (part->index == -1)
 		return -1;
 
-	if (length > rtas_log_partition.size)
-		length = rtas_log_partition.size;
+	if (length > part->size)
+		length = part->size;
 
-	tmp_index = rtas_log_partition.index;
+	tmp_index = part->index;
 
 	rc = ppc_md.nvram_read((char *)&info, sizeof(struct err_log_info), &tmp_index);
 	if (rc <= 0) {
-		printk(KERN_ERR "nvram_read_error_log: Failed nvram_read (%d)\n", rc);
+		pr_err("%s: Failed nvram_read (%d)\n", __FUNCTION__, rc);
 		return rc;
 	}
 
 	rc = ppc_md.nvram_read(buff, length, &tmp_index);
 	if (rc <= 0) {
-		printk(KERN_ERR "nvram_read_error_log: Failed nvram_read (%d)\n", rc);
+		pr_err("%s: Failed nvram_read (%d)\n", __FUNCTION__, rc);
 		return rc;
 	}
 
@@ -330,6 +331,17 @@ int nvram_read_error_log(char * buff, int length,
 	return 0;
 }
 
+/* nvram_read_error_log
+ *
+ * Reads nvram for error log for at most 'length'
+ */
+int nvram_read_error_log(char *buff, int length,
+			unsigned int *err_type, unsigned int *error_log_cnt)
+{
+	return nvram_read_partition(&rtas_log_partition, buff, length,
+						err_type, error_log_cnt);
+}
+
 /* This doesn't actually zero anything, but it sets the event_logged
  * word to tell that this event is safely in syslog.
  */

