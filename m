Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3HVLGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:06:04 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48361 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3HVLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:05:59 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 14/18] Hibernate: applied SNAPSHOT_VERIFICATION config to switch signature check
Date: Thu, 22 Aug 2013 19:01:53 +0800
Message-Id: <1377169317-5959-15-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applied SNAPSHOT_VERIFICATION kernel config for switching
signature check of hibernate snapshot image.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/snapshot.c |   19 +++++++++++++++++++
 kernel/power/swap.c     |   30 +++++++++++++++++++-----------
 kernel/power/user.c     |    2 ++
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 9e4c94b..cf3d69c 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1052,6 +1052,8 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 {
 	struct zone *zone;
 	unsigned long pfn, dst_pfn;
+
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 	struct page *d_page;
 	void *hash_buffer = NULL;
 	struct crypto_shash *tfm;
@@ -1083,6 +1085,7 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
 		goto error_shash;
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
 
 	for_each_populated_zone(zone) {
 		unsigned long max_zone_pfn;
@@ -1102,6 +1105,7 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 		dst_pfn = memory_bm_next_pfn(copy_bm);
 		copy_data_page(dst_pfn, pfn);
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 		/* Generate digest */
 		d_page = pfn_to_page(dst_pfn);
 		if (PageHighMem(d_page)) {
@@ -1116,8 +1120,10 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 		ret = crypto_shash_update(desc, hash_buffer, PAGE_SIZE);
 		if (ret)
 			goto error_shash;
+#endif
 	}
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 	crypto_shash_final(desc, digest);
 	if (ret)
 		goto error_shash;
@@ -1147,9 +1153,11 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 	kfree(pks);
 	kfree(digest);
 	crypto_free_shash(tfm);
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
 
 	return 0;
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 error_sign:
 	destroy_sign_key(s4_sign_key);
 error_key:
@@ -1158,6 +1166,7 @@ error_shash:
 error_digest:
 	crypto_free_shash(tfm);
 	return ret;
+#endif
 }
 
 /* Total number of image pages */
@@ -2321,8 +2330,10 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca,
 	return pbe->address;
 }
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 void **h_buf;
 void *skey_snapshot_buf;
+#endif
 
 /**
  *	snapshot_write_next - used for writing the system memory snapshot.
@@ -2367,12 +2378,14 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		if (error)
 			return error;
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 		/* Allocate void * array to keep buffer point for generate hash,
 		 * h_buf will freed in snapshot_image_verify().
 		 */
 		h_buf = kmalloc(sizeof(void *) * nr_copy_pages, GFP_KERNEL);
 		if (!h_buf)
 			pr_err("Allocate hash buffer fail!");
+#endif
 
 		error = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
 		if (error)
@@ -2400,8 +2413,10 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 			if (h_buf)
 				*h_buf = handle->buffer;
+#endif
 		}
 	} else {
 		copy_last_highmem_page();
@@ -2412,11 +2427,13 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			return PTR_ERR(handle->buffer);
 		if (handle->buffer != buffer)
 			handle->sync_read = 0;
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 		if (h_buf)
 			*(h_buf + (handle->cur - nr_meta_pages - 1)) = handle->buffer;
 		/* Keep the buffer of sign key in snapshot */
 		if (pfn == skey_data_buf_pfn)
 			skey_snapshot_buf = handle->buffer;
+#endif
 	}
 	handle->cur++;
 	return PAGE_SIZE;
@@ -2449,6 +2466,7 @@ int snapshot_image_loaded(struct snapshot_handle *handle)
 			handle->cur <= nr_meta_pages + nr_copy_pages);
 }
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 int snapshot_verify_signature(u8 *digest, size_t digest_size)
 {
 	struct key *s4_wake_key;
@@ -2575,6 +2593,7 @@ void snapshot_fill_s4_skey(void)
 	erase_skey_data();
 	pr_info("PM: Fill new s4 key to snapshot");
 }
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
 
 #ifdef CONFIG_HIGHMEM
 /* Assumes that @buf is ready and points to a "safe" page */
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index f6eaf6e..b5f8ce1 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1004,13 +1004,17 @@ static int load_image(struct swap_map_handle *handle,
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
-		ret = snapshot_image_verify();
-		if (ret)
-			pr_info("PM: snapshot signature check FAIL: %d\n", ret);
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 		else {
-			pr_info("PM: snapshot signature check SUCCESS!\n");
-			snapshot_fill_s4_skey();
+			ret = snapshot_image_verify();
+			if (ret)
+				pr_info("PM: snapshot signature check FAIL: %d\n", ret);
+			else {
+				pr_info("PM: snapshot signature check SUCCESS!\n");
+				snapshot_fill_s4_skey();
+			}
 		}
+#endif
 	}
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 	return ret;
@@ -1365,13 +1369,17 @@ out_finish:
 				}
 			}
 		}
-		ret = snapshot_image_verify();
-		if (ret)
-			pr_info("PM: snapshot signature check FAIL: %d\n", ret);
-		else {
-			pr_info("PM: snapshot signature check SUCCESS!\n");
-			snapshot_fill_s4_skey();
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+		if (!ret) {
+			ret = snapshot_image_verify();
+			if (ret)
+				pr_info("PM: snapshot signature check FAIL: %d\n", ret);
+			else {
+				pr_info("PM: snapshot signature check SUCCESS!\n");
+				snapshot_fill_s4_skey();
+			}
 		}
+#endif
 	}
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 out_clean:
diff --git a/kernel/power/user.c b/kernel/power/user.c
index c092e81..27b21ee 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -254,6 +254,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
 		if (!snapshot_image_verify()) {
 			pr_info("PM: snapshot signature check SUCCESS!\n");
 			snapshot_fill_s4_skey();
@@ -262,6 +263,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+#endif
 		error = hibernation_restore(data->platform_support);
 		break;
 
-- 
1.6.4.2

