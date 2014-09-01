Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaIAHQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:16:51 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37299 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaIAHQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:16:47 -0400
Subject: [PATCH v2 2/4] scripts/config: add option for changing output for
 undefined options
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 01 Sep 2014 11:16:32 +0400
Message-ID: <20140901071632.28909.31322.stgit@zurg>
In-Reply-To: <20140901065916.28909.35097.stgit@zurg>
References: <20140901065916.28909.35097.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds command line option '--if-undef' which replaces string 'undef'
in output of next command '--state' with whatever you want.

Also it adds grep key -s to suppress error messages about nonexistent file.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 scripts/config |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/config b/scripts/config
index 026aeb4..178652c 100755
--- a/scripts/config
+++ b/scripts/config
@@ -6,6 +6,9 @@ myname=${0##*/}
 # If no prefix forced, use the default CONFIG_
 CONFIG_="${CONFIG_-CONFIG_}"
 
+# Output for undefined options
+UNDEF="undef"
+
 usage() {
 	cat >&2 <<EOL
 Manipulate options in a .config file from the command line.
@@ -34,6 +37,7 @@ commands:
 options:
 	--file config-file   .config file to change (default .config)
 	--keep-case|-k       Keep next symbols' case (dont' upper-case it)
+	--if-undef string    Print this string instead of state "undef"
 
 $myname doesn't check the validity of the .config file. This is done at next
 make time.
@@ -152,6 +156,11 @@ while [ "$1" != "" ] ; do
 		B=$ARG
 		shift 2
 		;;
+	--if-undef)
+		UNDEF=$1
+		shift
+		continue
+		;;
 	-*)
 		checkarg "$1"
 		shift
@@ -185,12 +194,12 @@ while [ "$1" != "" ] ; do
 		;;
 
 	--state|-s)
-		if grep -q "# ${CONFIG_}$ARG is not set" $FN ; then
+		if grep -sq "# ${CONFIG_}$ARG is not set" $FN ; then
 			echo n
 		else
-			V="$(grep "^${CONFIG_}$ARG=" $FN)"
+			V="$(grep -s "^${CONFIG_}$ARG=" $FN)"
 			if [ $? != 0 ] ; then
-				echo undef
+				echo "${UNDEF}"
 			else
 				V="${V/#${CONFIG_}$ARG=/}"
 				V="${V/#\"/}"

