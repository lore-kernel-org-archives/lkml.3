Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3DAD3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:29:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45432 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3DAD3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:29:49 -0400
Date: Sun, 31 Mar 2013 20:25:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/3] pstore/ram: Restore ecc information block
Message-ID: <20130401032548.GC17424@lizard>
References: <20130401032256.GA13801@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130401032256.GA13801@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

This was lost when proc/last_kmsg moved to pstore/console-ramoops.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
---
 fs/pstore/ram.c      | 12 ++++++++++--
 fs/pstore/ram_core.c |  3 +++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index a5ee252..32cbd7c 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -136,6 +136,7 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   char **buf, struct pstore_info *psi)
 {
 	ssize_t size;
+	ssize_t ecc_notice_size;
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
 
@@ -156,11 +157,18 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	time->tv_nsec = 0;
 
 	size = persistent_ram_old_size(prz);
-	*buf = kmemdup(persistent_ram_old(prz), size, GFP_KERNEL);
+
+	/* ECC correction notice */
+	ecc_notice_size = persistent_ram_ecc_string(prz, NULL, 0);
+
+	*buf = kmalloc(size + ecc_notice_size + 1, GFP_KERNEL);
 	if (*buf == NULL)
 		return -ENOMEM;
 
-	return size;
+	memcpy(*buf, persistent_ram_old(prz), size);
+	persistent_ram_ecc_string(prz, *buf + size, ecc_notice_size + 1);
+
+	return size + ecc_notice_size;
 }
 
 static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index c6f641c..5933732 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -235,6 +235,9 @@ ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 {
 	ssize_t ret;
 
+	if (!prz->ecc_info.ecc_size)
+		return 0;
+
 	if (prz->corrected_bytes || prz->bad_blocks)
 		ret = snprintf(str, len, ""
 			"\n%d Corrected bytes, %d unrecoverable blocks\n",
-- 
1.8.1.4
