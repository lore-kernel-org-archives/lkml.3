Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3IKMHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:07:15 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58967 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3IKMHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:07:13 -0400
Subject: [PATCH 1/3] pstore: Adjust buffer size for compression for smaller
 registered buffers
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, seiji.aguchi@hds.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, ananth@in.ibm.com, ccross@android.com
Date: Wed, 11 Sep 2013 17:37:00 +0530
Message-ID: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091112-8256-0000-0000-0000092D308B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When backends (ex: efivars) have smaller registered buffers, the big_oops_buf
is quite too big for them as number of repeated occurences in the text captured
will be less. Patch takes care of adjusting the buffer size based on the
registered buffer size. cmpr values has been arrived after doing experiments with
plain text for buffers of size 1k - 4k (Smaller the buffer size repeated occurence
will be less) and with sample crash log for buffers ranging from 4k - 10k.

Reported-by: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/platform.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 4ffb7ab..4efaa75 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -195,8 +195,29 @@ error:
 static void allocate_buf_for_compression(void)
 {
 	size_t size;
+	size_t cmpr;
+
+	switch (psinfo->bufsize) {
+	/* buffer range for efivars */
+	case 1000 ... 2000:
+		cmpr = 56;
+		break;
+	case 2001 ... 3000:
+		cmpr = 54;
+		break;
+	case 3001 ... 3999:
+		cmpr = 52;
+		break;
+	/* buffer range for nvram, erst */
+	case 4000 ... 10000:
+		cmpr = 48;
+		break;
+	default:
+		cmpr = 60;
+		break;
+	}
 
-	big_oops_buf_sz = (psinfo->bufsize * 100) / 45;
+	big_oops_buf_sz = (psinfo->bufsize * 100) / cmpr;
 	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 	if (big_oops_buf) {
 		size = max(zlib_deflate_workspacesize(WINDOW_BITS, MEM_LEVEL),

