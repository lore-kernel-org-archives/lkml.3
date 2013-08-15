Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3HOVSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:18:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40275 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3HOVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:17:42 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Clement Chauplannaz <chauplac@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/4] scripts/config: use sed's POSIX interface
Date: Thu, 15 Aug 2013 23:17:31 +0200
Message-Id: <83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce.1376600922.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clement Chauplannaz <chauplac@gmail.com>

Script `config' relies on extensions of `GNU sed', and is thus not
working on all Unixes:
  - in-place edition of files (-i), which can be replaced with
    a temporary file;
  - extended-regexps (-r), which can be split into basic regexps;
  - single-line calls to `a' command, while some implementations
    require a leading newline before the parameter.

Rewrite calls to `sed' to comply with POSIX interface, and move them
to helper functions.

Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/config | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/scripts/config b/scripts/config
index 567120a..2283be2 100755
--- a/scripts/config
+++ b/scripts/config
@@ -62,15 +62,52 @@ checkarg() {
 	fi
 }
 
+txt_append() {
+	local anchor="$1"
+	local insert="$2"
+	local infile="$3"
+	local tmpfile="$infile.swp"
+
+	# sed append cmd: 'a\' + newline + text + newline
+	cmd="$(printf "a\\%b$insert" "\n")"
+
+	sed -e "/$anchor/$cmd" "$infile" >"$tmpfile"
+	# replace original file with the edited one
+	mv "$tmpfile" "$infile"
+}
+
+txt_subst() {
+	local before="$1"
+	local after="$2"
+	local infile="$3"
+	local tmpfile="$infile.swp"
+
+	sed -e "s/$before/$after/" "$infile" >"$tmpfile"
+	# replace original file with the edited one
+	mv "$tmpfile" "$infile"
+}
+
+txt_delete() {
+	local text="$1"
+	local infile="$2"
+	local tmpfile="$infile.swp"
+
+	sed -e "/$text/d" "$infile" >"$tmpfile"
+	# replace original file with the edited one
+	mv "$tmpfile" "$infile"
+}
+
 set_var() {
 	local name=$1 new=$2 before=$3
 
 	name_re="^($name=|# $name is not set)"
 	before_re="^($before=|# $before is not set)"
 	if test -n "$before" && grep -Eq "$before_re" "$FN"; then
-		sed -ri "/$before_re/a $new" "$FN"
+		txt_append "^$before=" "$new" "$FN"
+		txt_append "^# $before is not set" "$new" "$FN"
 	elif grep -Eq "$name_re" "$FN"; then
-		sed -ri "s:$name_re.*:$new:" "$FN"
+		txt_subst "^$name=.*" "$new" "$FN"
+		txt_subst "^# $name is not set" "$new" "$FN"
 	else
 		echo "$new" >>"$FN"
 	fi
@@ -79,7 +116,8 @@ set_var() {
 undef_var() {
 	local name=$1
 
-	sed -ri "/^($name=|# $name is not set)/d" "$FN"
+	txt_delete "^$name=" "$FN"
+	txt_delete "^# $name is not set" "$FN"
 }
 
 if [ "$1" = "--file" ]; then
-- 
1.8.1.2

