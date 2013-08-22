Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3HVLFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:05:43 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38084 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3HVLFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:05:35 -0400
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
Subject: [PATCH 12/18] Hibernate: generate and verify signature of snapshot
Date: Thu, 22 Aug 2013 19:01:51 +0800
Message-Id: <1377169317-5959-13-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the code for generate/verify signature of snapshot, it
put the signature to snapshot header. This approach can support both
on userspace hibernate and in-kernel hibernate.

v2:
- Due to loaded S4 sign key before ExitBootServices, we need forward key from
  boot kernel to resume target kernel. So this patch add a empty page in
  snapshot image, then we keep the pfn of this empty page in snapshot header.
  When system resume from hibernate, we fill new sign key to this empty page
  space after snapshot image checked pass. This mechanism let boot kernel can
  forward new sign key to resume target kernel but don't need write new private
  key to any other storage, e.g. swap.

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/power.h    |    6 +
 kernel/power/snapshot.c |  280 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/power/swap.c     |   14 +++
 kernel/power/user.c     |    9 ++
 4 files changed, 302 insertions(+), 7 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 69a81d8..84e0b06 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -3,6 +3,9 @@
 #include <linux/utsname.h>
 #include <linux/freezer.h>
 
+/* The maximum length of snapshot signature */
+#define SIG_LENG 512
+
 struct swsusp_info {
 	struct new_utsname	uts;
 	u32			version_code;
@@ -11,6 +14,8 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
+	unsigned long           skey_data_buf_pfn;
+	u8			signature[SIG_LENG];
 } __attribute__((aligned(PAGE_SIZE)));
 
 #ifdef CONFIG_HIBERNATION
@@ -134,6 +139,7 @@ extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
+extern int snapshot_image_verify(void);
 
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 349587b..72e2911 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -27,6 +27,9 @@
 #include <linux/highmem.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <crypto/hash.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1031,11 +1034,49 @@ static inline void copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
 }
 #endif /* CONFIG_HIGHMEM */
 
-static void
+#define SNAPSHOT_HASH "sha256"
+
+/*
+ * Signature of snapshot for check.
+ */
+static u8 signature[SIG_LENG];
+
+static int
 copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 {
 	struct zone *zone;
-	unsigned long pfn;
+	unsigned long pfn, dst_pfn;
+	struct page *d_page;
+	void *hash_buffer = NULL;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	u8 *digest;
+	size_t digest_size, desc_size;
+	struct key *s4_sign_key;
+	struct public_key_signature *pks;
+	int ret;
+
+	ret = -ENOMEM;
+	tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest) {
+		pr_err("digest allocate fail");
+		ret = -ENOMEM;
+		goto error_digest;
+	}
+	desc = (void *) digest + digest_size;
+	desc->tfm = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_shash;
 
 	for_each_populated_zone(zone) {
 		unsigned long max_zone_pfn;
@@ -1052,8 +1093,65 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 		pfn = memory_bm_next_pfn(orig_bm);
 		if (unlikely(pfn == BM_END_OF_MAP))
 			break;
-		copy_data_page(memory_bm_next_pfn(copy_bm), pfn);
+		dst_pfn = memory_bm_next_pfn(copy_bm);
+		copy_data_page(dst_pfn, pfn);
+
+		/* Generate digest */
+		d_page = pfn_to_page(dst_pfn);
+		if (PageHighMem(d_page)) {
+			void *kaddr;
+			kaddr = kmap_atomic(d_page);
+			copy_page(buffer, kaddr);
+			kunmap_atomic(kaddr);
+			hash_buffer = buffer;
+		} else {
+			hash_buffer = page_address(d_page);
+		}
+		ret = crypto_shash_update(desc, hash_buffer, PAGE_SIZE);
+		if (ret)
+			goto error_shash;
+	}
+
+	crypto_shash_final(desc, digest);
+	if (ret)
+		goto error_shash;
+
+	/* Generate signature by private key */
+	s4_sign_key = get_sign_key();
+	if (!s4_sign_key || IS_ERR(s4_sign_key)) {
+		pr_err("Get S4 sign key fail: %ld\n", PTR_ERR(s4_sign_key));
+		ret = PTR_ERR(s4_sign_key);
+		goto error_key;
 	}
+
+	pks = generate_signature(s4_sign_key, digest, PKEY_HASH_SHA256, false);
+	if (IS_ERR(pks)) {
+		pr_err("Generate signature fail: %lx", PTR_ERR(pks));
+		ret = PTR_ERR(pks);
+		goto error_sign;
+	} else
+		memcpy(signature, pks->S, pks->k);
+
+	destroy_sign_key(s4_sign_key);
+
+	if (pks && pks->digest)
+		kfree(pks->digest);
+	if (pks && pks->rsa.s)
+		mpi_free(pks->rsa.s);
+	kfree(pks);
+	kfree(digest);
+	crypto_free_shash(tfm);
+
+	return 0;
+
+error_sign:
+	destroy_sign_key(s4_sign_key);
+error_key:
+error_shash:
+	kfree(digest);
+error_digest:
+	crypto_free_shash(tfm);
+	return ret;
 }
 
 /* Total number of image pages */
@@ -1080,6 +1178,14 @@ static struct memory_bitmap orig_bm;
  */
 static struct memory_bitmap copy_bm;
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+/*
+ * Keep the pfn of S4 sign key buffer from resume target. We write the next time
+ * sign key to this page in snapshot image before restore.
+ */
+unsigned long skey_data_buf_pfn;
+#endif
+
 /**
  *	swsusp_free - free pages allocated for the suspend.
  *
@@ -1580,6 +1686,7 @@ swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
+	int ret;
 
 	printk(KERN_INFO "PM: Creating hibernation image:\n");
 
@@ -1602,7 +1709,9 @@ asmlinkage int swsusp_save(void)
 	 * Kill them.
 	 */
 	drain_local_pages(NULL);
-	copy_data_pages(&copy_bm, &orig_bm);
+	ret = copy_data_pages(&copy_bm, &orig_bm);
+	if (ret)
+		return ret;
 
 	/*
 	 * End of critical section. From now on, we can write to memory,
@@ -1657,6 +1766,10 @@ static int init_header(struct swsusp_info *info)
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+	info->skey_data_buf_pfn = get_skey_data_buf_pfn();
+	memcpy(info->signature, signature, SIG_LENG);
+#endif
 	return init_header_complete(info);
 }
 
@@ -1819,6 +1932,10 @@ load_header(struct swsusp_info *info)
 	if (!error) {
 		nr_copy_pages = info->image_pages;
 		nr_meta_pages = info->pages - info->image_pages - 1;
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+		skey_data_buf_pfn = info->skey_data_buf_pfn;
+		memcpy(signature, info->signature, SIG_LENG);
+#endif
 	}
 	return error;
 }
@@ -2159,7 +2276,8 @@ prepare_image(struct memory_bitmap *new_bm, struct memory_bitmap *bm)
  *	set for its caller to write to.
  */
 
-static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
+static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca,
+		unsigned long *_pfn)
 {
 	struct pbe *pbe;
 	struct page *page;
@@ -2168,6 +2286,9 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 	if (pfn == BM_END_OF_MAP)
 		return ERR_PTR(-EFAULT);
 
+	if (_pfn)
+		*_pfn = pfn;
+
 	page = pfn_to_page(pfn);
 	if (PageHighMem(page))
 		return get_highmem_page_buffer(page, ca);
@@ -2194,6 +2315,9 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 	return pbe->address;
 }
 
+void **h_buf;
+void *skey_snapshot_buf;
+
 /**
  *	snapshot_write_next - used for writing the system memory snapshot.
  *
@@ -2214,6 +2338,7 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 int snapshot_write_next(struct snapshot_handle *handle)
 {
 	static struct chain_allocator ca;
+	unsigned long pfn;
 	int error = 0;
 
 	/* Check if we have already loaded the entire image */
@@ -2236,6 +2361,13 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		if (error)
 			return error;
 
+		/* Allocate void * array to keep buffer point for generate hash,
+		 * h_buf will freed in snapshot_image_verify().
+		 */
+		h_buf = kmalloc(sizeof(void *) * nr_copy_pages, GFP_KERNEL);
+		if (!h_buf)
+			pr_err("Allocate hash buffer fail!");
+
 		error = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
 		if (error)
 			return error;
@@ -2258,20 +2390,27 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			chain_init(&ca, GFP_ATOMIC, PG_SAFE);
 			memory_bm_position_reset(&orig_bm);
 			restore_pblist = NULL;
-			handle->buffer = get_buffer(&orig_bm, &ca);
+			handle->buffer = get_buffer(&orig_bm, &ca, &pfn);
 			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
+			if (h_buf)
+				*h_buf = handle->buffer;
 		}
 	} else {
 		copy_last_highmem_page();
 		/* Restore page key for data page (s390 only). */
 		page_key_write(handle->buffer);
-		handle->buffer = get_buffer(&orig_bm, &ca);
+		handle->buffer = get_buffer(&orig_bm, &ca, &pfn);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
 		if (handle->buffer != buffer)
 			handle->sync_read = 0;
+		if (h_buf)
+			*(h_buf + (handle->cur - nr_meta_pages - 1)) = handle->buffer;
+		/* Keep the buffer of sign key in snapshot */
+		if (pfn == skey_data_buf_pfn)
+			skey_snapshot_buf = handle->buffer;
 	}
 	handle->cur++;
 	return PAGE_SIZE;
@@ -2304,6 +2443,133 @@ int snapshot_image_loaded(struct snapshot_handle *handle)
 			handle->cur <= nr_meta_pages + nr_copy_pages);
 }
 
+int snapshot_verify_signature(u8 *digest, size_t digest_size)
+{
+	struct key *s4_wake_key;
+	struct public_key_signature *pks;
+	int ret;
+	MPI mpi;
+
+	/* load public key */
+	s4_wake_key = get_wake_key();
+	if (!s4_wake_key || IS_ERR(s4_wake_key)) {
+		pr_err("PM: Get S4 wake key fail: %ld\n", PTR_ERR(s4_wake_key));
+		return PTR_ERR(s4_wake_key);
+	}
+
+	pks = kzalloc(digest_size + sizeof(*pks), GFP_KERNEL);
+	if (!pks) {
+		pr_err("PM: Allocate public key signature fail!");
+		return -ENOMEM;
+	}
+	pks->pkey_hash_algo = PKEY_HASH_SHA256;
+	pks->digest = digest;
+	pks->digest_size = digest_size;
+
+	mpi = mpi_read_raw_data(signature, get_key_length(s4_wake_key));
+	if (!mpi) {
+		pr_err("PM: mpi_read_raw_data fail!\n");
+		ret = -ENOMEM;
+		goto error_mpi;
+	}
+	pks->mpi[0] = mpi;
+	pks->nr_mpi = 1;
+
+	/* RSA signature check */
+	ret = verify_signature(s4_wake_key, pks);
+	if (ret) {
+		pr_err("snapshot S4 signature verification fail: %d\n", ret);
+		goto error_verify;
+	} else
+		pr_info("snapshot S4 signature verification pass!\n");
+
+	if (pks->rsa.s)
+		mpi_free(pks->rsa.s);
+	kfree(pks);
+
+	return 0;
+
+error_verify:
+	if (pks->rsa.s)
+		mpi_free(pks->rsa.s);
+error_mpi:
+	kfree(pks);
+	return ret;
+}
+
+int snapshot_image_verify(void)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	u8 *digest;
+	size_t digest_size, desc_size;
+	int ret, i;
+
+	if (!h_buf)
+		return 0;
+
+	tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest) {
+		pr_err("digest allocate fail");
+		ret = -ENOMEM;
+		goto error_digest;
+	}
+	desc = (void *) digest + digest_size;
+	desc->tfm = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_shash;
+
+	for (i = 0; i < nr_copy_pages; i++) {
+		ret = crypto_shash_update(desc, *(h_buf + i), PAGE_SIZE);
+		if (ret)
+			goto error_shash;
+	}
+
+	ret = crypto_shash_final(desc, digest);
+	if (ret)
+		goto error_shash;
+
+	ret = snapshot_verify_signature(digest, digest_size);
+	if (ret)
+		goto error_verify;
+
+	kfree(h_buf);
+	kfree(digest);
+	crypto_free_shash(tfm);
+	return 0;
+
+error_verify:
+error_shash:
+	kfree(h_buf);
+	kfree(digest);
+error_digest:
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+void snapshot_fill_s4_skey(void)
+{
+	if (!skey_snapshot_buf)
+		return;
+
+	/* Fill new s4 sign key to snapshot in memory */
+	clone_skey_data(skey_snapshot_buf);
+	/* clean skey page data */
+	erase_skey_data();
+	pr_info("PM: Fill new s4 key to snapshot");
+}
+
 #ifdef CONFIG_HIGHMEM
 /* Assumes that @buf is ready and points to a "safe" page */
 static inline void
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7c33ed2..f6eaf6e 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1004,6 +1004,13 @@ static int load_image(struct swap_map_handle *handle,
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
+		ret = snapshot_image_verify();
+		if (ret)
+			pr_info("PM: snapshot signature check FAIL: %d\n", ret);
+		else {
+			pr_info("PM: snapshot signature check SUCCESS!\n");
+			snapshot_fill_s4_skey();
+		}
 	}
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 	return ret;
@@ -1358,6 +1365,13 @@ out_finish:
 				}
 			}
 		}
+		ret = snapshot_image_verify();
+		if (ret)
+			pr_info("PM: snapshot signature check FAIL: %d\n", ret);
+		else {
+			pr_info("PM: snapshot signature check SUCCESS!\n");
+			snapshot_fill_s4_skey();
+		}
 	}
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 out_clean:
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4ed81e7..c092e81 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -228,6 +228,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		if (!data->frozen || data->ready)
 			break;
 		pm_restore_gfp_mask();
+		restore_sign_key_data();
 		thaw_processes();
 		data->frozen = 0;
 		break;
@@ -253,6 +254,14 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		if (!snapshot_image_verify()) {
+			pr_info("PM: snapshot signature check SUCCESS!\n");
+			snapshot_fill_s4_skey();
+		} else {
+			pr_info("PM: snapshot signature check FAIL!\n");
+			error = -EPERM;
+			break;
+		}
 		error = hibernation_restore(data->platform_support);
 		break;
 
-- 
1.6.4.2

