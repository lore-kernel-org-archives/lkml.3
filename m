Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3IMVu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:50:28 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64601 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3IMVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:50:26 -0400
From: Afzal Mohammed <afzal.mohd.ma@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Afzal Mohammed <afzal.mohd.ma@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH RFC] kbuild: prevent git private tag altering kernelrelease
Date: Sat, 14 Sep 2013 03:19:58 +0530
Message-Id: <1379109004-2411-1-git-send-email-afzal.mohd.ma@gmail.com>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a private tag is created after the most recent kernelversion tag, a
commit after this private tag would feed kernelrelease with commits
after private tag and kernelversion tag. This may confuse user relying
on kernelrelease (mostly a developer while debugging), mainly if HEAD
has a private tag and otherwise w.r.t git distance from kernelversion
tag.

Suppose the Kernel is 18 commits after v3.11-rc1, kernelrelease would be
something like '3.11.0-rc1-00018-gdeadbeef'.

And if an annotated(or signed) tag is created at HEAD, kernelrelease
would become 3.11.0-rc1, which makes one feel that source corresponds to
v3.11-rc1 tag.

Instead if such a tag is created at say HEAD~, kernelrelease would be
v3.11.0-rc1-00001-gdeadbeef, misleading the observer w.r.t git distance
from nearest kernelversion tag.

Here an attempt is made to prevent private tag from altering
kernelrelease.

Signed-off-by: Afzal Mohammed <afzal.mohd.ma@gmail.com>
---

Hi,

This seems to work on different scenarios that could be readily thought
of. I am shaky about this change, but acheives the purpose.

Regards
Afzal

 Makefile                |  4 ++--
 scripts/setlocalversion | 12 ++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index e73f758..923e492 100644
--- a/Makefile
+++ b/Makefile
@@ -795,7 +795,7 @@ $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
 define filechk_kernel.release
-	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
+	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree) $(KERNELVERSION))" > $@
 endef
 
 # Store (new) KERNELRELEASE string in include/config/kernel.release
@@ -1330,7 +1330,7 @@ checkstack:
 	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
 
 kernelrelease:
-	@echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
+	@echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree) $(KERNELVERSION))"
 
 kernelversion:
 	@echo $(KERNELVERSION)
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index d105a44..2c4552c 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -10,7 +10,7 @@
 #
 
 usage() {
-	echo "Usage: $0 [--save-scmversion] [srctree]" >&2
+	echo "Usage: $0 [--save-scmversion] [srctree] [kernelversion]" >&2
 	exit 1
 }
 
@@ -24,7 +24,11 @@ if test $# -gt 0; then
 	srctree=$1
 	shift
 fi
-if test $# -gt 0 -o ! -d "$srctree"; then
+if test $# -gt 0; then
+	kernelversion=`echo $1 | sed -e 's/[.]0//' -e 's/^/v/'`
+	shift
+fi
+if test $# -gt 0 -o ! -d "$srctree" -o -z "$kernelversion"; then
 	usage
 fi
 
@@ -47,7 +51,7 @@ scm_version()
 
 		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
 		# it, because this version is defined in the top level Makefile.
-		if [ -z "`git describe --exact-match 2>/dev/null`" ]; then
+		if [ -z "`git describe --exact-match --match $kernelversion 2>/dev/null`" ]; then
 
 			# If only the short version is requested, don't bother
 			# running further git commands
@@ -57,7 +61,7 @@ scm_version()
 			fi
 			# If we are past a tagged commit (like
 			# "v2.6.30-rc5-302-g72357d5"), we pretty print it.
-			if atag="`git describe 2>/dev/null`"; then
+			if atag="`git describe --match $kernelversion 2>/dev/null`"; then
 				echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
 
 			# If we don't have a tag at all we print -g{commitish}.
-- 
1.8.2.135.g7b592fa

