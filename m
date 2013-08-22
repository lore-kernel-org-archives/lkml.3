Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3HVLGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:06:41 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48585 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3HVLGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:06:35 -0400
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
Subject: [PATCH 17/18] Hibernate: introduced SNAPSHOT_SIG_HASH config for select hash algorithm
Date: Thu, 22 Aug 2013 19:01:56 +0800
Message-Id: <1377169317-5959-18-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduced SNAPSHOT_SIG_HASH config for user to select which
hash algorithm will be used during signature generation of snapshot.

v2:
Add define check of oCONFIG_SNAPSHOT_VERIFICATION in snapshot.c before
declare pkey_hash().

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/Kconfig    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/snapshot.c |   27 ++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index b592d88..79b34fa 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -78,6 +78,52 @@ config SNAPSHOT_VERIFICATION
 	  dependent on UEFI environment. EFI bootloader should generate the
 	  key-pair.
 
+choice
+	prompt "Which hash algorithm should snapshot be signed with?"
+        depends on SNAPSHOT_VERIFICATION
+        help
+          This determines which sort of hashing algorithm will be used during
+          signature generation of snapshot. This algorithm _must_ be built into
+	  the kernel directly so that signature verification can take place.
+	  It is not possible to load a signed snapshot containing the algorithm
+	  to check the signature on that module.
+
+config SNAPSHOT_SIG_SHA1
+        bool "Sign modules with SHA-1"
+        select CRYPTO_SHA1
+	select CRYPTO_SHA1_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA224
+        bool "Sign modules with SHA-224"
+        select CRYPTO_SHA256
+	select CRYPTO_SHA256_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA256
+        bool "Sign modules with SHA-256"
+        select CRYPTO_SHA256
+	select CRYPTO_SHA256_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA384
+        bool "Sign modules with SHA-384"
+        select CRYPTO_SHA512
+	select CRYPTO_SHA512_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA512
+        bool "Sign modules with SHA-512"
+        select CRYPTO_SHA512
+	select CRYPTO_SHA512_SSSE3 if X86_64
+
+endchoice
+
+config SNAPSHOT_SIG_HASH
+        string
+        depends on SNAPSHOT_VERIFICATION
+        default "sha1" if SNAPSHOT_SIG_SHA1
+        default "sha224" if SNAPSHOT_SIG_SHA224
+        default "sha256" if SNAPSHOT_SIG_SHA256
+        default "sha384" if SNAPSHOT_SIG_SHA384
+        default "sha512" if SNAPSHOT_SIG_SHA512
+
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on HIBERNATION
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index b9c6a8a..f02e351 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1042,12 +1042,29 @@ static inline void copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
 }
 #endif /* CONFIG_HIGHMEM */
 
-#define SNAPSHOT_HASH "sha256"
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+static const char *snapshot_hash = CONFIG_SNAPSHOT_SIG_HASH;
+
+static int pkey_hash(void)
+{
+	int i, ret;
+
+	ret = -1;
+	for (i = 0; i < PKEY_HASH__LAST; i++) {
+		if (!strcmp(pkey_hash_algo[i], snapshot_hash)) {
+			ret = i;
+			break;
+		}
+	}
+
+	return ret;
+}
 
 /*
  * Signature of snapshot for check.
  */
 static u8 signature[SIG_LENG];
+#endif
 
 static int
 copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
@@ -1068,7 +1085,7 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 
 	ret = -ENOMEM;
 	if (!capable(CAP_COMPROMISE_KERNEL)) {
-		tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
+		tfm = crypto_alloc_shash(snapshot_hash, 0, 0);
 		if (IS_ERR(tfm)) {
 			pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
 			return PTR_ERR(tfm);
@@ -1145,7 +1162,7 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 		goto error_key;
 	}
 
-	pks = generate_signature(s4_sign_key, digest, PKEY_HASH_SHA256, false);
+	pks = generate_signature(s4_sign_key, digest, pkey_hash(), false);
 	if (IS_ERR(pks)) {
 		pr_err("Generate signature fail: %lx", PTR_ERR(pks));
 		ret = PTR_ERR(pks);
@@ -2499,7 +2516,7 @@ int snapshot_verify_signature(u8 *digest, size_t digest_size)
 		pr_err("PM: Allocate public key signature fail!");
 		return -ENOMEM;
 	}
-	pks->pkey_hash_algo = PKEY_HASH_SHA256;
+	pks->pkey_hash_algo = pkey_hash();
 	pks->digest = digest;
 	pks->digest_size = digest_size;
 
@@ -2547,7 +2564,7 @@ int snapshot_image_verify(void)
 	if (!h_buf)
 		return 0;
 
-	tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
+	tfm = crypto_alloc_shash(snapshot_hash, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
 		return PTR_ERR(tfm);
-- 
1.6.4.2

