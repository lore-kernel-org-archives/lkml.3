Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaIAGc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:32:57 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:34665 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaIAG0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:30 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 04/27] headers_install.sh: enhance error handling
Date: Mon,  1 Sep 2014 09:25:55 +0300
Message-Id: <1409552778-2537-5-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
 <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exit with error if using undefined variables or if any sub command fails
with error return value. unidef needs special handling since but this can
be done without the trap. Enables exaniming intermediate files if some
commands failed.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 scripts/headers_install.sh | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index 5de5660..5391762 100644
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -1,4 +1,7 @@
 #!/bin/sh
+set -e
+set -u
+#set -x
 
 if [ $# -lt 1 ]
 then
@@ -26,7 +29,6 @@ shift
 # Iterate through files listed on command line
 
 FILE=
-trap 'rm -f "$OUTDIR/$FILE" "$OUTDIR/$FILE.sed"' EXIT
 for i in "$@"
 do
 	FILE="$(basename "$i")"
@@ -37,10 +39,13 @@ do
 		-e 's/(^|[^a-zA-Z0-9])__packed([^a-zA-Z0-9_]|$)/\1__attribute__((packed))\2/g' \
 		-e 's/(^|[ \t(])(inline|asm|volatile)([ \t(]|$)/\1__\2__\3/g' \
 		-e 's@#(ifndef|define|endif[ \t]*/[*])[ \t]*_UAPI@#\1 @' \
-		"$SRCDIR/$i" > "$OUTDIR/$FILE.sed" || exit 1
+		"$SRCDIR/$i" > "$OUTDIR/$FILE.sed" || \
+		( rm -f "$OUTDIR/$FILE.sed" ; exit 1 )
 	scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ "$OUTDIR/$FILE.sed" \
-		> "$OUTDIR/$FILE"
-	[ $? -gt 1 ] && exit 1
+		> "$OUTDIR/$FILE" || \
+		( if [ $? -gt 1 ]; then \
+				rm -f "$OUTDIR/$FILE" "$OUTDIR/$FILE.sed" ; \
+				exit 1 ; \
+		  fi )
 	rm -f "$OUTDIR/$FILE.sed"
 done
-trap - EXIT
-- 
2.1.0

