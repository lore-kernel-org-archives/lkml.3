Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3GOQzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:55:35 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42026 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab3GOQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:55:33 -0400
Subject: [PATCH 01/11] powerpc/pseries: Remove (de)compression in nvram with
 pstore enabled
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:25:20 +0530
Message-ID: <20130715165520.1520.72367.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-5564-0000-0000-000008CD5090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(De)compression support is provided in pstore in subsequent patches which
needs an additional argument 'compressed' to determine if the data
is compressed or not. This patch will take care of removing (de)compression
in nvram with pstore which was making use of 'hsize' argument in pstore write
as 'hsize' will be removed in the subsequent patch.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   40 --------------------------------
 1 file changed, 40 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 9f8671a..07c3c07 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -640,27 +640,6 @@ static int nvram_pstore_write(enum pstore_type_id type,
 	oops_hdr->report_length = (u16) size;
 	oops_hdr->timestamp = get_seconds();
 
-	if (big_oops_buf) {
-		rc = zip_oops(size);
-		/*
-		 * If compression fails copy recent log messages from
-		 * big_oops_buf to oops_data.
-		 */
-		if (rc != 0) {
-			size_t diff = size - oops_data_sz + hsize;
-
-			if (size > oops_data_sz) {
-				memcpy(oops_data, big_oops_buf, hsize);
-				memcpy(oops_data + hsize, big_oops_buf + diff,
-					oops_data_sz - hsize);
-
-				oops_hdr->report_length = (u16) oops_data_sz;
-			} else
-				memcpy(oops_data, big_oops_buf, size);
-		} else
-			err_type = ERR_TYPE_KERNEL_PANIC_GZ;
-	}
-
 	rc = nvram_write_os_partition(&oops_log_partition, oops_buf,
 		(int) (sizeof(*oops_hdr) + oops_hdr->report_length), err_type,
 		count);
@@ -751,25 +730,6 @@ read_partition:
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
 		oops_hdr = (struct oops_log_info *)buff;
 		*buf = buff + sizeof(*oops_hdr);
-
-		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ) {
-			big_buff = kmalloc(big_oops_buf_sz, GFP_KERNEL);
-			if (!big_buff)
-				return -ENOMEM;
-
-			rc = unzip_oops(buff, big_buff);
-
-			if (rc != 0) {
-				kfree(buff);
-				kfree(big_buff);
-				goto read_partition;
-			}
-
-			oops_hdr = (struct oops_log_info *)big_buff;
-			*buf = big_buff + sizeof(*oops_hdr);
-			kfree(buff);
-		}
-
 		time->tv_sec = oops_hdr->timestamp;
 		time->tv_nsec = 0;
 		return oops_hdr->report_length;

