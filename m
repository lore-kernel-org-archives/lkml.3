Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3GOQ4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:56:51 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46181 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GOQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:56:49 -0400
Subject: [PATCH 08/11] powerpc/pseries: Read and write to the 'compressed'
 flag of pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:26:37 +0530
Message-ID: <20130715165637.1520.4138.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-8256-0000-0000-00000859739B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If data returned from pstore is compressed, nvram's write callback
will add a flag ERR_TYPE_KERNEL_PANIC_GZ indicating the data is compressed
while writing to nvram. If the data read from nvram is compressed, nvram's
read callback will set the flag 'compressed'. The patch adds backward
compatibilty with old format oops header when reading from pstore.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   34 +++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 78c6f45..6f383eb 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -581,6 +581,9 @@ static int nvram_pstore_write(enum pstore_type_id type,
 	oops_hdr->report_length = (u16) size;
 	oops_hdr->timestamp = get_seconds();
 
+	if (compressed)
+		err_type = ERR_TYPE_KERNEL_PANIC_GZ;
+
 	rc = nvram_write_os_partition(&oops_log_partition, oops_buf,
 		(int) (sizeof(*oops_hdr) + oops_hdr->report_length), err_type,
 		count);
@@ -604,11 +607,10 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct oops_log_info *oops_hdr;
 	unsigned int err_type, id_no, size = 0;
 	struct nvram_os_partition *part = NULL;
-	char *buff = NULL, *big_buff = NULL;
-	int rc, sig = 0;
+	char *buff = NULL;
+	int  sig = 0;
 	loff_t p;
 
-read_partition:
 	read_type++;
 
 	switch (nvram_type_ids[read_type]) {
@@ -669,14 +671,32 @@ read_partition:
 		*id = id_no;
 
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
+		u16 length;
 		oops_hdr = (struct oops_log_info *)buff;
-		*buf = buff + sizeof(*oops_hdr);
-		time->tv_sec = oops_hdr->timestamp;
-		time->tv_nsec = 0;
-		return oops_hdr->report_length;
+
+		/* Provide backward compatibility with old format headers */
+		if (oops_hdr->version < OOPS_HDR_VERSION) {
+			*buf = buff + sizeof(u16);
+			length = oops_hdr->version;
+			time->tv_sec = 0;
+			time->tv_nsec = 0;
+		} else {
+			*buf = buff + sizeof(*oops_hdr);
+			length = oops_hdr->report_length;
+			time->tv_sec = oops_hdr->timestamp;
+			time->tv_nsec = 0;
+		}
+
+		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ)
+			*compressed = true;
+		else
+			*compressed = false;
+
+		return length;
 	}
 
 	*buf = buff;
+	*compressed = false;
 	return part->size;
 }
 

