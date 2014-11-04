Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaKDInh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:43:37 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41873 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaKDInb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:43:31 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 05/11] backports: use BACKPORT_DIR prefix on kconfig sources
Date: Tue,  4 Nov 2014 00:42:56 -0800
Message-Id: <1415090582-14129-6-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will allow us to do less work for built-in integration support.
This requires a bit of self evaluation of the variable within our
kconfig library, ideally we'd have support for groking all variables
defined within the Kconfig setup but that requires quite a lot more
work as it means also parsing Makefiles and inheriting these definitions
within config symbols when used. Since we only define one right now and
its used for built-in support we deal with it ourselves for now.

Please consider the complexity of adding others, it doesn't seem like
there would be much need for others though. If others wanted to use a
different BACKPORT_DIR path other than 'backports' that would require
tweaking here, but we'll start by assuming no one will want to do that.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig | 37 ++++++++++++++++++++-----------------
 lib/kconfig.py   | 53 ++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/backport/Kconfig b/backport/Kconfig
index f63f4fd..c523323 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -1,5 +1,8 @@
 mainmenu "Linux Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (with backports $BACKPORTS_VERSION)"
 
+config BACKPORT_DIR
+	string
+	option env="BACKPORT_DIR"
 config BACKPORTS_VERSION
 	string
 	option env="BACKPORTS_VERSION"
@@ -11,8 +14,8 @@ config BACKPORTED_KERNEL_NAME
 	option env="BACKPORTED_KERNEL_NAME"
 
 # these will be generated
-source Kconfig.kernel
-source Kconfig.versions
+source "$BACKPORT_DIR/Kconfig.kernel"
+source "$BACKPORT_DIR/Kconfig.versions"
 
 # some hacks for when we use backports to generate a package
 # to build modules out of tree.
@@ -27,25 +30,25 @@ config EXPERT
 	def_bool y
 
 # this has the configuration for the backport code
-source compat/Kconfig
+source "$BACKPORT_DIR/compat/Kconfig"
 
 # these are copied from the kernel
-source net/wireless/Kconfig
-source net/mac80211/Kconfig
-source net/bluetooth/Kconfig
-source drivers/net/wireless/Kconfig
-source drivers/net/ethernet/Kconfig
-source drivers/net/usb/Kconfig
+source "$BACKPORT_DIR/net/wireless/Kconfig"
+source "$BACKPORT_DIR/net/mac80211/Kconfig"
+source "$BACKPORT_DIR/net/bluetooth/Kconfig"
+source "$BACKPORT_DIR/drivers/net/wireless/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ethernet/Kconfig"
+source "$BACKPORT_DIR/drivers/net/usb/Kconfig"
 
-source drivers/ssb/Kconfig
-source drivers/bcma/Kconfig
+source "$BACKPORT_DIR/drivers/ssb/Kconfig"
+source "$BACKPORT_DIR/drivers/bcma/Kconfig"
 
-source net/nfc/Kconfig
+source "$BACKPORT_DIR/net/nfc/Kconfig"
 
-source drivers/media/Kconfig
+source "$BACKPORT_DIR/drivers/media/Kconfig"
 
-source net/ieee802154/Kconfig
-source net/mac802154/Kconfig
-source drivers/net/ieee802154/Kconfig
+source "$BACKPORT_DIR/net/ieee802154/Kconfig"
+source "$BACKPORT_DIR/net/mac802154/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ieee802154/Kconfig"
 
-source drivers/usb/class/Kconfig
+source "$BACKPORT_DIR/drivers/usb/class/Kconfig"
diff --git a/lib/kconfig.py b/lib/kconfig.py
index 1efffed..5c47161 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -5,6 +5,7 @@
 import os, re
 
 src_line = re.compile(r'^\s*source\s+"?(?P<src>[^\s"]*)"?\s*$')
+bk_src_line = re.compile(r'^\s*source\s+"?\$BACKPORT_DIR/(?P<src>[^\s"]*)"?\s*$')
 tri_line = re.compile(r'^(?P<spc>\s+)tristate')
 bool_line = re.compile(r'^(?P<spc>\s+)bool')
 cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
@@ -21,23 +22,53 @@ class ConfigTree(object):
         yield f
         for l in open(os.path.join(self.basedir, f), 'r'):
             m = src_line.match(l)
-            if m and os.path.exists(os.path.join(self.basedir, m.group('src'))):
-                for i in self._walk(m.group('src')):
-                    yield i
+            if m:
+                bm = bk_src_line.match(l)
+                if bm:
+                    if os.path.exists(os.path.join(self.basedir, bm.group('src'))):
+                        for i in self._walk(os.path.join(self.basedir, bm.group('src'))):
+                            yield i
+                    elif os.path.exists(os.path.join(self.basedir, 'backports/' + bm.group('src'))):
+                        for i in self._walk(os.path.join(self.basedir, 'backports/' + bm.group('src'))):
+                            yield i
+                else:
+                    if os.path.exists(os.path.join(self.basedir, m.group('src'))):
+                        for i in self._walk(m.group('src')):
+                            yield i
 
     def _prune_sources(self, f, ignore):
         for nf in self._walk(f):
             out = ''
             for l in open(os.path.join(self.basedir, nf), 'r'):
-                m = src_line.match(l)
-                if not m:
-                    out += l
-                    continue
-                src = m.group('src')
-                if src in ignore or os.path.exists(os.path.join(self.basedir, src)):
-                    out += l
+                bm = bk_src_line.match(l)
+                if bm:
+                    bp_src = bm.group('src')
+                    if bp_src in ignore or \
+                       os.path.exists(os.path.join(self.basedir, bp_src)) or \
+                       os.path.exists(os.path.join(self.basedir, 'backports/' + bp_src)):
+                        out += l
+                    else:
+                        out += '#' + l
                 else:
-                    out += '#' + l
+                    m = src_line.match(l)
+                    # we should consider disallowing these as it could mean
+                    # someone forgot to add the BACKPORT_DIR prefix to
+                    # the kconfig source entries which we will need to
+                    # support built-in integration.
+                    if not m:
+                        out += l
+                        continue
+                    src = m.group('src')
+                    if src in ignore or os.path.exists(os.path.join(self.basedir, src)):
+                        if 'backports' in self.basedir and 'BACKPORT_DIR' not in bp_src:
+                            out += 'source "$BACKPORT_DIR/' + src + '"\n'
+                        else:
+                            out += l
+                    else:
+                        if 'backports' in self.basedir and 'BACKPORT_DIR' not in bp_src:
+                            out += '# source "$BACKPORT_DIR/' + src + '"\n'
+                        else:
+                            out += '#' + l
             outf = open(os.path.join(self.basedir, nf), 'w')
             outf.write(out)
             outf.close()
-- 
2.1.1

