Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3IWE5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:57:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54543 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IWE5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:57:53 -0400
Message-ID: <523FCA4C.2010905@canonical.com>
Date: Sun, 22 Sep 2013 21:57:48 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linus GIT - kernel BUG at include/linux/scatterlist.h:115! CPU:
 1 PID: 1203 Comm: apparmor_parser Not tainted 3.12.0-rc1+
References: <CAHFgRy86OnOTorc8FPza4Vk4bnQL-J4JZho-GL2HZV=nCfYDRw@mail.gmail.com>
In-Reply-To: <CAHFgRy86OnOTorc8FPza4Vk4bnQL-J4JZho-GL2HZV=nCfYDRw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 07:30 PM, Miles Lane wrote:

yep, thanks for the report. I have a patch for this one, attached
below but is also being sent up to the security tree.

---

apparmor: Use shash crypto API interface for profile hashes

Use the shash interface, rather than the hash interface, when hashing
AppArmor profiles. The shash interface does not use scatterlists and it
is a better fit for what AppArmor needs.

This fixes a kernel paging BUG when aa_calc_profile_hash() is passed a
buffer from vmalloc(). The hash interface requires callers to handle
vmalloc() buffers differently than what AppArmor was doing. Due to
vmalloc() memory not being physically contiguous, each individual page
behind the buffer must be assigned to a scatterlist with sg_set_page()
and then the scatterlist passed to crypto_hash_update().

The shash interface does not have that limitation and allows vmalloc()
and kmalloc() buffers to be handled in the same manner.

https://launchpad.net/bugs/1216294/

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Acked-by: John Johansen <john.johansen@canonical.com>
---

I've tested this patch by comparing aafs/policy/profiles/*/sha1 between a
patched i386 VM (i386 is where the BUG is easily reproduced) and an unpatched
amd64 VM. Then I did `service apparmor restart` to trigger a profile
replacement and compared the sha1 files in aafs again. I put all of that into a
loop and let it run for a while.

Tyler

 security/apparmor/crypto.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index d6222ba..532471d 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -15,14 +15,14 @@
  * it should be.
  */
 
-#include <linux/crypto.h>
+#include <crypto/hash.h>
 
 #include "include/apparmor.h"
 #include "include/crypto.h"
 
 static unsigned int apparmor_hash_size;
 
-static struct crypto_hash *apparmor_tfm;
+static struct crypto_shash *apparmor_tfm;
 
 unsigned int aa_hash_size(void)
 {
@@ -32,35 +32,33 @@ unsigned int aa_hash_size(void)
 int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 			 size_t len)
 {
-	struct scatterlist sg[2];
-	struct hash_desc desc = {
-		.tfm = apparmor_tfm,
-		.flags = 0
-	};
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(apparmor_tfm)];
+	} desc;
 	int error = -ENOMEM;
 	u32 le32_version = cpu_to_le32(version);
 
 	if (!apparmor_tfm)
 		return 0;
 
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], &le32_version, 4);
-	sg_set_buf(&sg[1], (u8 *) start, len);
-
 	profile->hash = kzalloc(apparmor_hash_size, GFP_KERNEL);
 	if (!profile->hash)
 		goto fail;
 
-	error = crypto_hash_init(&desc);
+	desc.shash.tfm = apparmor_tfm;
+	desc.shash.flags = 0;
+
+	error = crypto_shash_init(&desc.shash);
 	if (error)
 		goto fail;
-	error = crypto_hash_update(&desc, &sg[0], 4);
+	error = crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4);
 	if (error)
 		goto fail;
-	error = crypto_hash_update(&desc, &sg[1], len);
+	error = crypto_shash_update(&desc.shash, (u8 *) start, len);
 	if (error)
 		goto fail;
-	error = crypto_hash_final(&desc, profile->hash);
+	error = crypto_shash_final(&desc.shash, profile->hash);
 	if (error)
 		goto fail;
 
@@ -75,19 +73,19 @@ fail:
 
 static int __init init_profile_hash(void)
 {
-	struct crypto_hash *tfm;
+	struct crypto_shash *tfm;
 
 	if (!apparmor_initialized)
 		return 0;
 
-	tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_shash("sha1", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		int error = PTR_ERR(tfm);
 		AA_ERROR("failed to setup profile sha1 hashing: %d\n", error);
 		return error;
 	}
 	apparmor_tfm = tfm;
-	apparmor_hash_size = crypto_hash_digestsize(apparmor_tfm);
+	apparmor_hash_size = crypto_shash_digestsize(apparmor_tfm);
 
 	aa_info_message("AppArmor sha1 policy hashing enabled");
 
-- 
1.8.3.2


