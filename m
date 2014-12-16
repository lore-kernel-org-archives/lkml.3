Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929AbaLPGyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:54:50 -0500
Received: from tundra.namei.org ([65.99.196.166]:51598 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaLPGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:54:48 -0500
Date: Tue, 16 Dec 2014 17:54:42 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Security subsystem fixes for 3.19
Message-ID: <alpine.LRH.2.11.1412161753250.14583@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for the security subsystem.

The following changes since commit 988adfdffdd43cfd841df734664727993076d7cb:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2014-12-15 15:52:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dan Carpenter (1):
      KEYS: remove a bogus NULL check

James Morris (1):
      Merge branch 'next' of git://git.kernel.org/.../zohar/linux-integrity into for-linus

Michael Ellerman (1):
      ima: Fix build failure on powerpc when TCG_IBMVTPM dependencies are not met

Takashi Iwai (1):
      KEYS: Fix stale key registration at error path

 security/integrity/ima/Kconfig           |    2 +-
 security/keys/encrypted-keys/encrypted.c |    5 ++++-
 security/keys/key.c                      |   10 ++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

---

commit 5057975ae38452679b964f1382c5efcb9faee74e
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu Dec 11 19:59:38 2014 +0000

    KEYS: remove a bogus NULL check
    
    We already checked if "desc" was NULL at the beginning of the function
    and we've dereferenced it so this causes a static checker warning.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/keys/key.c b/security/keys/key.c
index e17ba6a..aee2ec5 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -276,12 +276,10 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	if (!key)
 		goto no_memory_2;
 
-	if (desc) {
-		key->index_key.desc_len = desclen;
-		key->index_key.description = kmemdup(desc, desclen + 1, GFP_KERNEL);
-		if (!key->description)
-			goto no_memory_3;
-	}
+	key->index_key.desc_len = desclen;
+	key->index_key.description = kmemdup(desc, desclen + 1, GFP_KERNEL);
+	if (!key->description)
+		goto no_memory_3;
 
 	atomic_set(&key->usage, 1);
 	init_rwsem(&key->sem);

commit d0bffab0439fb7edaee09677b636eef5991e8b80
Merge: 988adfd 63a0eb7
Author: James Morris <james.l.morris@oracle.com>
Date:   Tue Dec 16 12:49:10 2014 +1100

    Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into for-linus

commit 63a0eb7891bdf3ef32ecb6b01eb09106df646c10
Author: Michael Ellerman <mpe@ellerman.id.au>
Date:   Wed Dec 3 17:04:50 2014 +1100

    ima: Fix build failure on powerpc when TCG_IBMVTPM dependencies are not met
    
    On powerpc we can end up with IMA=y and PPC_PSERIES=n which leads to:
    
     warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES)
      tpm_ibmvtpm.c:(.text+0x14f3e8): undefined reference to `.plpar_hcall_norets'
    
    I'm not sure why IMA needs to select those user-visible symbols, but if
    it must then the simplest fix is to just express the proper dependencies
    on the select.
    
    Tested-by: Hon Ching (Vicky) Lo <lo1@us.ibm.com>
    Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b80a93e..57515bc 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -10,7 +10,7 @@ config IMA
 	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML
 	select TCG_TIS if TCG_TPM && X86
-	select TCG_IBMVTPM if TCG_TPM && PPC64
+	select TCG_IBMVTPM if TCG_TPM && PPC_PSERIES
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash

commit b26bdde5bb27f3f900e25a95e33a0c476c8c2c48
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Dec 4 18:25:19 2014 +0100

    KEYS: Fix stale key registration at error path
    
    When loading encrypted-keys module, if the last check of
    aes_get_sizes() in init_encrypted() fails, the driver just returns an
    error without unregistering its key type.  This results in the stale
    entry in the list.  In addition to memory leaks, this leads to a kernel
    crash when registering a new key type later.
    
    This patch fixes the problem by swapping the calls of aes_get_sizes()
    and register_key_type(), and releasing resources properly at the error
    paths.
    
    Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=908163
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index db9675d..7bed4ad 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -1017,10 +1017,13 @@ static int __init init_encrypted(void)
 	ret = encrypted_shash_alloc();
 	if (ret < 0)
 		return ret;
+	ret = aes_get_sizes();
+	if (ret < 0)
+		goto out;
 	ret = register_key_type(&key_type_encrypted);
 	if (ret < 0)
 		goto out;
-	return aes_get_sizes();
+	return 0;
 out:
 	encrypted_shash_release();
 	return ret;
