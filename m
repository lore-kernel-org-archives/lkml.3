Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3ANUg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:36:29 -0500
Received: from csamuel.org ([74.50.50.137]:41357 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab3ANUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:36:28 -0500
Message-ID: <50F46C36.3060403@csamuel.org>
Date: Tue, 15 Jan 2013 07:36:06 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>, dhowells@redhat.com,
        Michal Marek <mmarek@suse.cz>
Subject: [RFC] [PATCH] Disable INSTALL_MOD_STRIP when CONFIG_MODULE_SIG set
Content-Type: multipart/mixed;
 boundary="------------080202010405050200080402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080202010405050200080402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

/* Please CC as I am not on LKML */

Allowing the build system to strip modules when CONFIG_MODULE_SIG is
set makes no sense as the modules will fail signature checks and at
best taint the kernel (and appear as if force loaded), and at worst
cause a kernel panic if fips_enabled is set.

So we set mod_strip_cmd to be true to prevent it stripping kernel
modules, just as happens if INSTALL_MOD_STRIP is not passed.

---
  Documentation/kbuild/kbuild.txt    |    3 +++
  Documentation/kbuild/makefiles.txt |    5 +++++
  Makefile                           |    3 +++
  init/Kconfig                       |    2 ++
  4 files changed, 13 insertions(+)

diff --git a/Documentation/kbuild/kbuild.txt 
b/Documentation/kbuild/kbuild.txt
index 6466704..8f2fa5c 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -152,6 +152,9 @@ stripped after they are installed.  If 
INSTALL_MOD_STRIP is '1', then
  the default option --strip-debug will be used.  Otherwise,
  INSTALL_MOD_STRIP value will be used as the options to the strip command.
  +A kernel configured with cryptographically signed modules 
(CONFIG_MODULE_SIG)
+will disable this to try and prevent the loss of the appended signatures.
+
  INSTALL_FW_PATH
  --------------------------------------------------
  INSTALL_FW_PATH specifies where to install the firmware blobs.
diff --git a/Documentation/kbuild/makefiles.txt 
b/Documentation/kbuild/makefiles.txt
index 14c3f4f..5b6dad8 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1396,6 +1396,11 @@ The top Makefile exports the following variables:
  	INSTALL_MOD_STRIP value will be used as the option(s) to the strip
  	command.
  +        A kernel configured with cryptographically signed modules
+	(CONFIG_MODULE_SIG) will disable this to try and prevent the loss
+	of the appended signatures.
+
+
   === 9 Makefile language
  diff --git a/Makefile b/Makefile
index a1667c4..b59a39e 100644
--- a/Makefile
+++ b/Makefile
@@ -724,6 +724,9 @@ MODSECKEY = ./signing_key.priv
  MODPUBKEY = ./signing_key.x509
  export MODPUBKEY
  mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
+# Don't strip modules as it removes the signatures we will add.
+mod_strip_cmd = true
+export mod_strip_cmd
  else
  mod_sign_cmd = true
  endif
diff --git a/init/Kconfig b/init/Kconfig
index 7d30240..1048f93 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1658,6 +1658,8 @@ config MODULE_SIG
  	  debuginfo strip done by some packagers (such as rpmbuild) and
  	  inclusion into an initramfs that wants the module size reduced.
  +	  This option disables the INSTALL_MOD_STRIP option for make.
+
  config MODULE_SIG_FORCE
  	bool "Require modules to be validly signed"
  	depends on MODULE_SIG
-- 
1.7.10.4


--------------080202010405050200080402
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------080202010405050200080402--
