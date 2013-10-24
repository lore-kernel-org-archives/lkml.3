Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3JXWtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 18:49:41 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:49844 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3JXWtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 18:49:40 -0400
X-Greylist: delayed 810 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 18:49:40 EDT
From: James Solner <solner@alcatel-lucent.com>
To: dhowells@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Adding Documentation/module-signing.txt file
Date: Thu, 24 Oct 2013 17:35:55 -0500
Message-ID: <14578957.OSuohDRLT9@cmlinux10.ih.lucent.com>
User-Agent: KMail/4.11.2 (Linux/3.11.5-PRV01+; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Documentation/module-signing.txt file that is 
missing. There is a link to Documentation/module-signing.txt file
in init/Kconfig that references this file. 

Signed-off-by: James Solner <solner@alcatel-lucent.com>
---
 Documentation/module-signing.txt | 182 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)
 create mode 100644 Documentation/module-signing.txt

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
new file mode 100644
index 0000000..b21e1f1
--- /dev/null
+++ b/Documentation/module-signing.txt
@@ -0,0 +1,182 @@
+			==============================
+			KERNEL MODULE SIGNING FACILITY
+			==============================
+
+The module signing facility applies cryptographic signature checking to modules
+on module load, checking the signature against a ring of public keys compiled
+into the kernel.  GPG is used to do the cryptographic work and determines the
+format of the signature and key data.  The facility uses GPG&#39;s MPI library to
+handle the huge numbers involved.
+
+The signature checker in the kernel is capable of handling multiple keys of
+either DSA or RSA type, and can support any of MD5, RIPE-MD-160, SHA-1,
+SHA-224, SHA-256, SHA-384 and SHA-512 hashes - PROVIDED(!) the requisite
+algorithms are compiled into the kernel.
+
+(!) NOTE: Modules may only be verified initially with algorithms compiled into
+the kernel.  Further algorithm modules may be loaded and used - but these must
+first pass a verification step using already loaded/compiled-in algorithms.
+
+
+=====================
+SUPPLYING PUBLIC KEYS
+=====================
+
+A set of public keys must be supplied at kernel image build time.  This is done
+by taking a GPG public key file and placing it in the base of the kernel
+directory in a file called modsign.pub.
+
+For example, a throwaway key could be generated automatically by something like
+the following:
+
+	cat &gt;genkey &lt;&lt;EOF
+	%pubring modsign.pub
+	%secring modsign.sec
+	Key-Type: RSA
+	Key-Length: 4096
+	Name-Real: A. N. Other
+	Name-Comment: Kernel Module GPG key
+	%commit
+	EOF
+	gpg --homedir . --batch --gen-key genkey
+
+The above generates fresh keys using /dev/random.  If there&#39;s insufficient data
+in /dev/random, more can be provided using the rngd program if there&#39;s a
+hardware random number generator available.
+
+Note that no GPG password is used in the above scriptlet.
+
+The modsign.pub file is compiled into the kernel directly by the assembler by
+means of an &quot;.incbin&quot; directive in kernel/modsign-pubkey.c.
+
+Once the kernel is running, the keys are visible to root as kernel crypto keys
+in /proc/keys in a keyring called .module_sign:
+
+335ab517 I-----     1 perm 1f030000     0     0 keyring   .module_sign: 2/4
+38d7d169 I-----     1 perm 3f010000     0     0 crypto    modsign.0: rsa 57532ca5 []
+195fa736 I-----     1 perm 3f010000     0     0 crypto    modsign.1: dsa 5acc2142 []
+
+This keyring can be listed with the keyctl program.  See:
+
+	Documentation/security/keys-crypto.txt
+
+for more information of crypto keys.
+
+
+============================
+SELECTING THE HASH ALGORITHM
+============================
+
+The hash algorithm to be used is selected by a multiple choice configuration
+item that enables one of the following variables:
+
+	CONFIG_SIG_SHA1
+	CONFIG_SIG_SHA224
+	CONFIG_SIG_SHA256
+	CONFIG_SIG_SHA384
+	CONFIG_SIG_SHA512
+
+These cause an appropriate &quot;--digest-algo=&quot; parameter to be passed to gpg when
+signing a module and force the appropriate hash algorithm to be compiled
+directly into the kernel rather than being built as a module.
+
+
+==============
+MODULE SIGNING
+==============
+
+Modules will then be signed automatically.  The kernel make command line can
+include the following options:
+
+ (*) MODSECKEY=&lt;secret-key-ring-path&gt;
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the secret key to be used.  The default is &quot;./modsign.sec&quot;.
+
+ (*) MODPUBKEY=&lt;public-key-ring-path&gt;
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the public key to be used.  The default is &quot;./modsign.pub&quot;.
+
+ (*) MODKEYNAME=&lt;key-name&gt;
+
+     The name of the key pair to be used from the aforementioned keyrings.
+     This defaults to being unset, thus leaving the choice of default key to
+     gpg.
+
+ (*) KEYFLAGS=&quot;gpg-options&quot;
+
+     Override the complete gpg command line, including the preceding three
+     options.  The default options supplied to gpg are:
+
+	--no-default-keyring
+	--secret-keyring $(MODSECKEY)
+	--keyring $(MODPUBKEY)
+	--no-default-keyring
+	--homedir .
+	--no-options
+	--no-auto-check-trustdb
+	--no-permission-warning
+	--digest-algo=&lt;hash-algorithm&gt;
+
+      with:
+
+	--default-key $(MODKEYNAME)
+
+      being added if requested.
+
+The resulting module.ko file will be the signed module.
+
+
+============================
+SIGNED MODULES AND STRIPPING
+============================
+
+The module signature is just appended to the module binary with a magic number
+at the end of file, a couple of fixed-size lengths prior to that and the
+signature prior to that.
+
+WARNING! Signed modules are BRITTLE as the signature is outside of the defined
+ELF container.  Thus they MAY NOT be stripped once the signature is computed
+and attached, lest the signature be discarded or the payload be modified.  Note
+that the entire module is the signed payload, including all the debug
+information present at the time of signing so it must still be present when the
+signature is checked.
+
+As the module may need to be included in a ramdisk image of limited capacity,
+modules are maximally stripped prior to signing by the build process.
+
+Note that if FIPS mode is engaged, a module for which the signature does not
+match the payload will panic the box.
+
+
+======================
+LOADING SIGNED MODULES
+======================
+
+Modules are loaded with insmod, exactly as for unsigned modules.  The signature
+checker will check at the end of the file for the signature marker and apply
+signature checking if found.
+
+
+=========================================
+NON-VALID SIGNATURES AND UNSIGNED MODULES
+=========================================
+
+If CONFIG_MODULE_SIG_FORCE is enabled or &quot;enforcemodulesig=1&quot; is supplied on
+the kernel command line, the kernel will _only_ load validly signed modules
+for which it has a public key.  Otherwise, it will also load modules that are
+unsigned.  Any module for which the kernel has a key, but which proves to have
+a signature mismatch will not be permitted to load (returning EKEYREJECTED).
+
+This table indicates the behaviours of the various situations:
+
+	MODULE STATE				PERMISSIVE MODE	ENFORCING MODE
+	=======================================	===============	===============
+	Unsigned				Ok		EKEYREJECTED
+	Signed, no public key			ENOKEY		ENOKEY
+	Validly signed, public key		Ok		Ok
+	Invalidly signed, public key		EKEYREJECTED	EKEYREJECTED
+	Validly signed, expired key		EKEYEXPIRED	EKEYEXPIRED
+	Signed, hash algorithm unavailable	ENOPKG		ENOPKG
+	Corrupt signature			EBADMSG		EBADMSG
-- 
1.7.12.4
---

