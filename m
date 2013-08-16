Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3HPNSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:18:52 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39684 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3HPNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:18:47 -0400
Subject: [RFC PATCH v2 08/11] powerpc/pseries: Read and write to the
 'compressed' flag of pstore
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:48:36 +0530
Message-ID: <20130816131836.3338.4640.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-5490-0000-0000-000003FF3E1E
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
 arch/powerpc/platforms/pseries/nvram.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 6c4dc52a..d276cd3 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -581,6 +581,9 @@ static int nvram_pstore_write(enum pstore_type_id type,
 	oops_hdr->report_length = (u16) size;
 	oops_hdr->timestamp = get_seconds();
 
+	if (compressed)
+		err_type = ERR_TYPE_KERNEL_PANIC_GZ;
+
 	rc = nvram_write_os_partition(&oops_log_partition, oops_buf,
 		(int) (sizeof(*oops_hdr) + size), err_type, count);
 
@@ -687,6 +690,11 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 			return -ENOMEM;
 		memcpy(*buf, buff + hdr_size, length);
 		kfree(buff);
+
+		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ)
+			*compressed = true;
+		else
+			*compressed = false;
 		return length;
 	}
 

