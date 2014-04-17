Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaDQQV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:21:58 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:40309 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbaDQQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:21:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0UAMT+T1Nbsma4/2dsb2JhbABZgwarGJlWAgKBJBd0glMTHCMYgQIkE4gAAcs3jmKEPwEDjmiKBQGSTYMzOw
Date: Thu, 17 Apr 2014 18:18:13 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joe Perches <joe@perches.com>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 1/1] FS/PSTORE: Logging clean-up
Message-Id: <20140417181813.7f411f230329274db2551652@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Define pr_fmt in plateform.c and ram_core.c for global prefix.
-Coalesce format fragments.
-Separate format/arguments on lines > 80 characters.

Note: Some pr_foo() were initially declared without prefix and
therefore this could break existing log analyzer.

Cc: Joe Perches <joe@perches.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/pstore/platform.c | 16 ++++++++--------
 fs/pstore/ram_core.c | 36 +++++++++++++++++-------------------
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 46d269e..ed72f96 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -18,6 +18,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "pstore: " fmt
+
 #include <linux/atomic.h>
 #include <linux/types.h>
 #include <linux/errno.h>
@@ -224,14 +226,12 @@ static void allocate_buf_for_compression(void)
 			zlib_inflate_workspacesize());
 		stream.workspace = kmalloc(size, GFP_KERNEL);
 		if (!stream.workspace) {
-			pr_err("pstore: No memory for compression workspace; "
-				"skipping compression\n");
+			pr_err("No memory for compression workspace; skipping compression\n");
 			kfree(big_oops_buf);
 			big_oops_buf = NULL;
 		}
 	} else {
-		pr_err("No memory for uncompressed data; "
-			"skipping compression\n");
+		pr_err("No memory for uncompressed data; skipping compression\n");
 		stream.workspace = NULL;
 	}
 
@@ -502,8 +502,8 @@ void pstore_get_records(int quiet)
 				size = unzipped_len;
 				compressed = false;
 			} else {
-				pr_err("pstore: decompression failed;"
-					"returned %d\n", unzipped_len);
+				pr_err("pstore: decompression failed;returned %d\n",
+				       unzipped_len);
 				compressed = true;
 			}
 		}
@@ -524,8 +524,8 @@ out:
 	mutex_unlock(&psi->read_mutex);
 
 	if (failed)
-		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
-		       failed, psi->name);
+		pr_warn("failed to load %d record(s) from '%s'\n",
+			failed, psi->name);
 }
 
 static void pstore_dowork(struct work_struct *work)
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index ff7e3d4..34a1e5a 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) "persistent_ram: " fmt
+
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -205,12 +207,10 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 			size = buffer->data + prz->buffer_size - block;
 		numerr = persistent_ram_decode_rs8(prz, block, size, par);
 		if (numerr > 0) {
-			pr_devel("persistent_ram: error in block %p, %d\n",
-			       block, numerr);
+			pr_devel("error in block %p, %d\n", block, numerr);
 			prz->corrected_bytes += numerr;
 		} else if (numerr < 0) {
-			pr_devel("persistent_ram: uncorrectable error in block %p\n",
-				block);
+			pr_devel("uncorrectable error in block %p\n", block);
 			prz->bad_blocks++;
 		}
 		block += prz->ecc_info.block_size;
@@ -257,7 +257,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 	prz->rs_decoder = init_rs(prz->ecc_info.symsize, prz->ecc_info.poly,
 				  0, 1, prz->ecc_info.ecc_size);
 	if (prz->rs_decoder == NULL) {
-		pr_info("persistent_ram: init_rs failed\n");
+		pr_info("init_rs failed\n");
 		return -EINVAL;
 	}
 
@@ -267,10 +267,10 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 	numerr = persistent_ram_decode_rs8(prz, buffer, sizeof(*buffer),
 					   prz->par_header);
 	if (numerr > 0) {
-		pr_info("persistent_ram: error in header, %d\n", numerr);
+		pr_info("error in header, %d\n", numerr);
 		prz->corrected_bytes += numerr;
 	} else if (numerr < 0) {
-		pr_info("persistent_ram: uncorrectable error in header\n");
+		pr_info("uncorrectable error in header\n");
 		prz->bad_blocks++;
 	}
 
@@ -317,7 +317,7 @@ void persistent_ram_save_old(struct persistent_ram_zone *prz)
 		prz->old_log = kmalloc(size, GFP_KERNEL);
 	}
 	if (!prz->old_log) {
-		pr_err("persistent_ram: failed to allocate buffer\n");
+		pr_err("failed to allocate buffer\n");
 		return;
 	}
 
@@ -396,8 +396,8 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 
 	pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
 	if (!pages) {
-		pr_err("%s: Failed to allocate array for %u pages\n", __func__,
-			page_count);
+		pr_err("%s: Failed to allocate array for %u pages\n",
+		       __func__, page_count);
 		return NULL;
 	}
 
@@ -462,19 +462,17 @@ static int persistent_ram_post_init(struct persistent_ram_zone *prz, u32 sig,
 	if (prz->buffer->sig == sig) {
 		if (buffer_size(prz) > prz->buffer_size ||
 		    buffer_start(prz) > buffer_size(prz))
-			pr_info("persistent_ram: found existing invalid buffer,"
-				" size %zu, start %zu\n",
-			       buffer_size(prz), buffer_start(prz));
+			pr_info("found existing invalid buffer, size %zu, start %zu\n",
+				buffer_size(prz), buffer_start(prz));
 		else {
-			pr_debug("persistent_ram: found existing buffer,"
-				" size %zu, start %zu\n",
-			       buffer_size(prz), buffer_start(prz));
+			pr_debug("found existing buffer, size %zu, start %zu\n",
+				 buffer_size(prz), buffer_start(prz));
 			persistent_ram_save_old(prz);
 			return 0;
 		}
 	} else {
-		pr_debug("persistent_ram: no valid data in buffer"
-			" (sig = 0x%08x)\n", prz->buffer->sig);
+		pr_debug("no valid data in buffer (sig = 0x%08x)\n",
+			 prz->buffer->sig);
 	}
 
 	prz->buffer->sig = sig;
@@ -509,7 +507,7 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 
 	prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
 	if (!prz) {
-		pr_err("persistent_ram: failed to allocate persistent ram zone\n");
+		pr_err("failed to allocate persistent ram zone\n");
 		goto err;
 	}
 
-- 
1.8.4.5

