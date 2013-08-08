Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab3HHREO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:04:14 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53537 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3HHREK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:04:10 -0400
Subject: [PATCH 2/2] powerpc/pseries: Add backward compatibilty to read old
 kernel oops-log
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: mahesh@linux.vne.ibm.com
Date: Thu, 08 Aug 2013 22:34:00 +0530
Message-ID: <20130808170358.9914.98084.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130808170253.9914.25346.stgit@aruna-ThinkPad-T420>
References: <20130808170253.9914.25346.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080816-0260-0000-0000-00000370FED8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older kernels has just length information in their header. Handle it
while reading old kernel oops log from pstore.

Applies on top of powerpc/pseries: Fix buffer overflow when reading from pstore

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 893f360..6a5f2b1 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -720,15 +720,25 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
 		int length, unzipped_len;
+		size_t hdr_size;
 
 		oops_hdr = (struct oops_log_info *)buff;
-		length = oops_hdr->report_length;
+		if (oops_hdr->version < OOPS_HDR_VERSION) {
+			/* Old format oops header had 2-byte record size */
+			hdr_size = sizeof(u16);
+			length = oops_hdr->version;
+			time->tv_sec = 0;
+			time->tv_nsec = 0;
+		} else {
+			hdr_size = sizeof(*oops_hdr);
+			length = oops_hdr->report_length;
+			time->tv_sec = oops_hdr->timestamp;
+			time->tv_nsec = 0;
+		}
 		*buf = kmalloc(length, GFP_KERNEL);
 		if (*buf == NULL)
 			return -ENOMEM;
-		memcpy(*buf, buff + sizeof(*oops_hdr), length);
-		time->tv_sec = oops_hdr->timestamp;
-		time->tv_nsec = 0;
+		memcpy(*buf, buff + hdr_size, length);
 		kfree(buff);
 
 		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ) {

