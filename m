Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3G3McV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:32:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38292 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3G3McR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:32:17 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-7c-51f7b250dc06
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: gregkh@linuxfoundation.org
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, b.zolnierkie@samsung.com,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] staging: zram: add per-cpu support to Crypto
Date: Tue, 30 Jul 2013 14:30:49 +0200
Message-id: <1375187449-6546-2-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jAd2ATd8DDQ4dFLTYOGM9q8WeM7/Y
	LZoXr2ezONv0ht3i8q45bBYbWmaxW6xaFOXA7nFv32EWj/1z17B7HHy3h8mjb8sqRo+dnzaz
	enzeJBfAFsVlk5Kak1mWWqRvl8CV8bUhsOCpXcXlJ9vYGxgnGXcxcnJICJhItC15xQ5hi0lc
	uLeerYuRi0NIYBGjxIkzzawQTjuTxLktD8Gq2AT0Jb5cX8MCYosIyEk8uf2HGaSIWeAoo8TU
	6+sZuxg5OIQFHCVW3CoDqWERUJX4MmcRE4jNK+Al8bb5FwtIiYSAgsScSTYgYU4Bb4ljlw+C
	jRQCKpmyZibbBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCQ+uZ9A7GVQ0WhxgF
	OBiVeHg3FHwLFGJNLCuuzD3EKMHBrCTCe37i90Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdb
	rQOFBNITS1KzU1MLUotgskwcnFINjGr3OVMOn+6O8rSru228wvLFzaMe0htto/OXL5izS/7Q
	o+cTs8un6i7XubB612eDexdnF6jaPea2LXiyPPyN89Y1+rpbI/yDnkdcEU+QtPU73GbQxXVK
	yf+05aQzN54r1J3uP5krWuMb86un3eJCBPv7nr0y/b9EdcuNPhQ/TZ/xTN2tK8ohT4mlOCPR
	UIu5qDgRAOS6DvkpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since original zram code did not implement any per-cpu operations,
my previous patch (staging: zram: add Crypto API support) did not
include them either.

This patch complements the first one with per-cpu support for Crypto,
allocating tfms buffer separately for each online processor.
Changes are based on zswap and zcache per-cpu code.

Basic tests (concurrent writing several 10-40MB chunks to zram) performed
on an ARM-based EXYNOS4412 Quad-Core showed that per-cpu code provides
noticeable time saving, ranging between 30-40% for LZO and LZ4 compressors.
Sample data (LZO): writing 160MB, 40MB per thread took 0.60s with per-cpu
code included and approximately 0.80s without per-cpu support.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/staging/zram/zram_drv.c |  146 +++++++++++++++++++++++++++++++++------
 drivers/staging/zram/zram_drv.h |    1 -
 2 files changed, 125 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d6f1f67..3dd5085 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/crypto.h>
+#include <linux/cpu.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
@@ -46,7 +47,7 @@ static unsigned int num_devices = 1;
 
 /* Cryptographic API features */
 static char *zram_compressor = ZRAM_COMPRESSOR_DEFAULT;
-static struct crypto_comp *zram_comp_tfm;
+static struct crypto_comp * __percpu *zram_comp_pcpu_tfms;
 
 enum comp_op {
 	ZRAM_COMPOP_COMPRESS,
@@ -59,7 +60,7 @@ static int zram_comp_op(enum comp_op op, const u8 *src, unsigned int slen,
 	struct crypto_comp *tfm;
 	int ret;
 
-	tfm = zram_comp_tfm;
+	tfm = *per_cpu_ptr(zram_comp_pcpu_tfms, get_cpu());
 	switch (op) {
 	case ZRAM_COMPOP_COMPRESS:
 		ret = crypto_comp_compress(tfm, src, slen, dst, dlen);
@@ -70,6 +71,7 @@ static int zram_comp_op(enum comp_op op, const u8 *src, unsigned int slen,
 	default:
 		ret = -EINVAL;
 	}
+	put_cpu();
 
 	return ret;
 }
@@ -87,9 +89,9 @@ static int __init zram_comp_init(void)
 	}
 	pr_info("using %s compressor\n", zram_compressor);
 
-	/* alloc transform */
-	zram_comp_tfm = crypto_alloc_comp(zram_compressor, 0, 0);
-	if (!zram_comp_tfm)
+	/* alloc percpu transforms */
+	zram_comp_pcpu_tfms = alloc_percpu(struct crypto_comp *);
+	if (!zram_comp_pcpu_tfms)
 		return -ENOMEM;
 
 	return 0;
@@ -97,8 +99,110 @@ static int __init zram_comp_init(void)
 
 static inline void zram_comp_exit(void)
 {
-	if (zram_comp_tfm)
-		crypto_free_comp(zram_comp_tfm);
+	/* free percpu transforms */
+	if (zram_comp_pcpu_tfms)
+		free_percpu(zram_comp_pcpu_tfms);
+}
+
+
+/* Crypto API features: percpu code */
+#define ZRAM_DSTMEM_ORDER 1
+static DEFINE_PER_CPU(u8 *, zram_dstmem);
+
+static int zram_comp_cpu_up(int cpu)
+{
+	struct crypto_comp *tfm;
+
+	tfm = crypto_alloc_comp(zram_compressor, 0, 0);
+	if (IS_ERR(tfm))
+		return NOTIFY_BAD;
+	*per_cpu_ptr(zram_comp_pcpu_tfms, cpu) = tfm;
+	return NOTIFY_OK;
+}
+
+static void zram_comp_cpu_down(int cpu)
+{
+	struct crypto_comp *tfm;
+
+	tfm = *per_cpu_ptr(zram_comp_pcpu_tfms, cpu);
+	crypto_free_comp(tfm);
+	*per_cpu_ptr(zram_comp_pcpu_tfms, cpu) = NULL;
+}
+
+static int zram_cpu_notifier(struct notifier_block *nb,
+				unsigned long action, void *pcpu)
+{
+	int ret;
+	int cpu = (long) pcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		ret = zram_comp_cpu_up(cpu);
+		if (ret != NOTIFY_OK) {
+			pr_err("zram: can't allocate compressor xform\n");
+			return ret;
+		}
+		per_cpu(zram_dstmem, cpu) = (void *)__get_free_pages(
+			GFP_KERNEL | __GFP_REPEAT, ZRAM_DSTMEM_ORDER);
+		break;
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+		zram_comp_cpu_down(cpu);
+		free_pages((unsigned long) per_cpu(zram_dstmem, cpu),
+			    ZRAM_DSTMEM_ORDER);
+		per_cpu(zram_dstmem, cpu) = NULL;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block zram_cpu_notifier_block = {
+	.notifier_call = zram_cpu_notifier
+};
+
+/* Helper function releasing tfms from online cpus */
+static inline void zram_comp_cpus_down(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		void *pcpu = (void *)(long)cpu;
+		zram_cpu_notifier(&zram_cpu_notifier_block,
+				  CPU_UP_CANCELED, pcpu);
+	}
+	put_online_cpus();
+}
+
+static int zram_cpu_init(void)
+{
+	int ret;
+	unsigned int cpu;
+
+	ret = register_cpu_notifier(&zram_cpu_notifier_block);
+	if (ret) {
+		pr_err("zram: can't register cpu notifier\n");
+		goto out;
+	}
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		void *pcpu = (void *)(long)cpu;
+		if (zram_cpu_notifier(&zram_cpu_notifier_block,
+				      CPU_UP_PREPARE, pcpu) != NOTIFY_OK)
+			goto cleanup;
+	}
+	put_online_cpus();
+	return ret;
+
+cleanup:
+	zram_comp_cpus_down();
+
+out:
+	put_online_cpus();
+	return -ENOMEM;
 }
 /* end of Cryptographic API features */
 
@@ -250,7 +354,6 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 static void zram_meta_free(struct zram_meta *meta)
 {
 	zs_destroy_pool(meta->mem_pool);
-	free_pages((unsigned long)meta->compress_buffer, 1);
 	vfree(meta->table);
 	kfree(meta);
 }
@@ -262,18 +365,11 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 	if (!meta)
 		goto out;
 
-	meta->compress_buffer =
-		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!meta->compress_buffer) {
-		pr_err("Error allocating compressor buffer space\n");
-		goto free_meta;
-	}
-
 	num_pages = disksize >> PAGE_SHIFT;
 	meta->table = vzalloc(num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
-		goto free_buffer;
+		goto free_meta;
 	}
 
 	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
@@ -286,8 +382,6 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 
 free_table:
 	vfree(meta->table);
-free_buffer:
-	free_pages((unsigned long)meta->compress_buffer, 1);
 free_meta:
 	kfree(meta);
 	meta = NULL;
@@ -455,7 +549,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	struct zram_meta *meta = zram->meta;
 
 	page = bvec->bv_page;
-	src = meta->compress_buffer;
+	src = __get_cpu_var(zram_dstmem);
+	BUG_ON(src == NULL);
 
 	if (is_partial_io(bvec)) {
 		/*
@@ -916,18 +1011,24 @@ static int __init zram_init(void)
 		goto out;
 	}
 
+	if (zram_cpu_init()) {
+		pr_err("Per-cpu initialization failed\n");
+		ret = -ENOMEM;
+		goto free_comp;
+	}
+
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
 				num_devices);
 		ret = -EINVAL;
-		goto free_comp;
+		goto free_cpu_comp;
 	}
 
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
 		pr_warn("Unable to get major number\n");
 		ret = -EBUSY;
-		goto free_comp;
+		goto free_cpu_comp;
 	}
 
 	/* Allocate the device array and initialize each one */
@@ -953,6 +1054,8 @@ free_devices:
 	kfree(zram_devices);
 unregister:
 	unregister_blkdev(zram_major, "zram");
+free_cpu_comp:
+	zram_comp_cpus_down();
 free_comp:
 	zram_comp_exit();
 out:
@@ -976,6 +1079,7 @@ static void __exit zram_exit(void)
 	unregister_blkdev(zram_major, "zram");
 
 	kfree(zram_devices);
+	zram_comp_cpus_down();
 	zram_comp_exit();
 	pr_debug("Cleanup done!\n");
 }
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 93f4d14..474474a 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -88,7 +88,6 @@ struct zram_stats {
 };
 
 struct zram_meta {
-	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
 };
-- 
1.7.9.5

