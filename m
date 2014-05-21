Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaEUNd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:33:29 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:9246 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaEUNd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:33:28 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Joonsoo Kim <js1304@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Ian Campbell <ijc@hellion.org.uk>, Jiri Slaby <jirislaby@gmail.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Hans-Bernhard=20Br=C3=B6ker?= 
	<broeker@users.sourceforge.net>,
        Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>,
        Neil Horman <nhorman@users.sourceforge.net>,
        Neil Horman <nhorman@tuxdriver.com>, Gerhard Sittig <gsi@denx.de>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] scripts/tags.sh: ignore symlink'ed source files
Date: Wed, 21 May 2014 15:32:17 +0200
Message-Id: <1400679137-28122-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.0
References: <1396530975.4361.28.camel@localhost.localdomain> <20140407104216.GB5287@hmsreliant.think-freely.org> <20140407124259.GZ11339@book.gsilab.sittig.org> <20140407153647.GA17258@hmsreliant.think-freely.org> <534312F8.5090609@t-online.de> <20140408075610.GJ11339@book.gsilab.sittig.org> <20140408104959.GA26003@hmsreliant.think-freely.org> <1398993559.23822.1.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 22d651dcef536c75f75537290bf3da5038e68b6b ('selftests/powerpc:
Import Anton's memcpy / copy_tofrom_user tests'), some source files in the
tree appear as symlink.
Until commit 8c38a5328af8080bc69a25b3e4e144b03eeea95e ('scripts/tags.sh:
ignore code of user space tools'), those symlinks made cscope report some
warnings:

    $ make ALLSOURCE_ARCHS=all O=./obj-cscope/ cscope
      GEN     cscope
    cscope: cannot find
file .../tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
    cscope: cannot find
file .../tools/testing/selftests/powerpc/copyloops/memcpy_64.S
    cscope: cannot find
file .../tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
    cscope: cannot find
file .../tools/testing/selftests/powerpc/copyloops/copyuser_64.S

In order to prevent the same kind of warnings to be triggered by future
addition of symlinks, the best option is to ignore all symlinks when
building the file list to be processed by cscope (and other tools
supported by scripts/tags.sh).

Ignoring symlinks won't hide source files from cscope (and others) as the
target of these symlinks already appear somewhere else in the tree, and,
as such, should be processed by cscope (or others).

Note that, cscope, when used with -R option to make it find the files to
process by itself, already skip symlinks: it's not expected that cscope
access source files through symlink.

On top of commit 8c38a5328af8080bc69a25b3e4e144b03eeea95e ('scripts/tags.sh:
ignore code of user space tools'), scripts/tags.sh output from
"make cscope tags TAGS" is the same with and without this patch: it doesn't
seems to introduce any regression (on Fedora 20).

Link: http://lkml.kernel.org/r/1396530975.4361.28.camel@localhost.localdomain
Link: http://mid.gmane.org/534312F8.5090609@t-online.de
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hans-Bernhard Bröker <broeker@users.sourceforge.net>,
Cc: Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>,
Cc: Neil Horman <nhorman@users.sourceforge.net>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Gerhard Sittig <gsi@denx.de>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

---
 scripts/tags.sh | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 1c50de820289..4c425d25173c 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -50,7 +50,8 @@ find_arch_sources()
 	for i in $archincludedir; do
 		prune="$prune -wholename $i -prune -o"
 	done
-	find ${tree}arch/$1 $ignore $subarchprune $prune -name "$2" -print;
+	find ${tree}arch/$1 $ignore $subarchprune $prune -name "$2" \
+		-not -type l -print;
 }
 
 # find sources in arch/$1/include
@@ -60,14 +61,15 @@ find_arch_include_sources()
 					-name include -type d -print);
 	if [ -n "$include" ]; then
 		archincludedir="$archincludedir $include"
-		find $include $ignore -name "$2" -print;
+		find $include $ignore -name "$2" -not -type l -print;
 	fi
 }
 
 # find sources in include/
 find_include_sources()
 {
-	find ${tree}include $ignore -name config -prune -o -name "$1" -print;
+	find ${tree}include $ignore -name config -prune -o -name "$1" \
+		-not -type l -print;
 }
 
 # find sources in rest of tree
@@ -76,7 +78,7 @@ find_other_sources()
 {
 	find ${tree}* $ignore \
 	     \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
-	       -name "$1" -print;
+	       -name "$1" -not -type l -print;
 }
 
 find_sources()
-- 
1.9.0

