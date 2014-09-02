Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaIBXcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:32:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41649 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbaIBXcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:32:01 -0400
From: behanw@converseincode.com
To: john.johansen@canonical.com
Cc: james.l.morris@oracle.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH v2] apparmor: LLVMLinux: Remove VLAIS
Date: Tue,  2 Sep 2014 16:31:47 -0700
Message-Id: <1409700707-12853-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54064FD1.6060900@canonical.com>
References: <54064FD1.6060900@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinícius Tinti <viniciustinti@gmail.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This is the original VLAIS struct.

struct {
	struct shash_desc shash;
	char ctx[crypto_shash_descsize(apparmor_tfm)];
} desc;

This patch instead allocates the appropriate amount of memory using an
char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that can
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/crypto.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index 532471d..62b32e7 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -32,10 +32,9 @@ unsigned int aa_hash_size(void)
 int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 			 size_t len)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(apparmor_tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(apparmor_tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 	int error = -ENOMEM;
 	u32 le32_version = cpu_to_le32(version);
 
@@ -46,19 +45,19 @@ int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 	if (!profile->hash)
 		goto fail;
 
-	desc.shash.tfm = apparmor_tfm;
-	desc.shash.flags = 0;
+	shash->tfm = apparmor_tfm;
+	shash->flags = 0;
 
-	error = crypto_shash_init(&desc.shash);
+	error = crypto_shash_init(shash);
 	if (error)
 		goto fail;
-	error = crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4);
+	error = crypto_shash_update(shash, (u8 *) &le32_version, 4);
 	if (error)
 		goto fail;
-	error = crypto_shash_update(&desc.shash, (u8 *) start, len);
+	error = crypto_shash_update(shash, (u8 *) start, len);
 	if (error)
 		goto fail;
-	error = crypto_shash_final(&desc.shash, profile->hash);
+	error = crypto_shash_final(shash, profile->hash);
 	if (error)
 		goto fail;
 
-- 
1.9.1

