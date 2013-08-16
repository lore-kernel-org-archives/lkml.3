Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3HPNT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:19:26 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33103 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3HPNTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:19:20 -0400
Subject: [RFC PATCH v2 11/11] pstore/ram: Read and write to the 'compressed'
 flag of pstore
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:49:07 +0530
Message-ID: <20130816131907.3338.76154.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-9264-0000-0000-0000045728BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pstore write, add character 'C'(compressed) or 'D'(decompressed)
in the header while writing to Ram persistent buffer. In pstore read,
read the header and update the 'compressed' flag accordingly.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/ram.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 2927223..4027c20 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -131,6 +131,27 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
 	return prz;
 }
 
+static void ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
+				  bool *compressed)
+{
+	char data_type;
+
+	if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu-%c\n",
+			&time->tv_sec, &time->tv_nsec, &data_type) == 3) {
+		if (data_type == 'C')
+			*compressed = true;
+		else
+			*compressed = false;
+	} else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
+			&time->tv_sec, &time->tv_nsec) == 2) {
+			*compressed = false;
+	} else {
+		time->tv_sec = 0;
+		time->tv_nsec = 0;
+		*compressed = false;
+	}
+}
+
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   int *count, struct timespec *time,
 				   char **buf, bool *compressed,
@@ -153,10 +174,6 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	if (!prz)
 		return 0;
 
-	/* TODO(kees): Bogus time for the moment. */
-	time->tv_sec = 0;
-	time->tv_nsec = 0;
-
 	size = persistent_ram_old_size(prz);
 
 	/* ECC correction notice */
@@ -167,12 +184,14 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 		return -ENOMEM;
 
 	memcpy(*buf, persistent_ram_old(prz), size);
+	ramoops_read_kmsg_hdr(*buf, time, compressed);
 	persistent_ram_ecc_string(prz, *buf + size, ecc_notice_size + 1);
 
 	return size + ecc_notice_size;
 }
 
-static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
+static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz,
+				     bool compressed)
 {
 	char *hdr;
 	struct timespec timestamp;
@@ -183,8 +202,9 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 		timestamp.tv_sec = 0;
 		timestamp.tv_nsec = 0;
 	}
-	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
-		(long)timestamp.tv_sec, (long)(timestamp.tv_nsec / 1000));
+	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu-%c\n",
+		(long)timestamp.tv_sec, (long)(timestamp.tv_nsec / 1000),
+		compressed ? 'C' : 'D');
 	WARN_ON_ONCE(!hdr);
 	len = hdr ? strlen(hdr) : 0;
 	persistent_ram_write(prz, hdr, len);
@@ -243,7 +263,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 
 	prz = cxt->przs[cxt->dump_write_cnt];
 
-	hlen = ramoops_write_kmsg_hdr(prz);
+	hlen = ramoops_write_kmsg_hdr(prz, compressed);
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
 	persistent_ram_write(prz, buf, size);

