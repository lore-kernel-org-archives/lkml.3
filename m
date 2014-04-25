Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaDYO5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:57:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaDYO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:57:05 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [RFC] UAPI: Prevent kernel modules from using the exported headers
Date: Fri, 25 Apr 2014 16:56:48 +0200
Message-Id: <1398437808-9263-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandriva/Mageia and SUSE have been adding an #error statement to the
/usr/include/linux/version.h header and it does trigger with broken out
of tree modules occasionally. Adding it to all exported headers should
not hurt and is easier to implement.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/headers_install.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index 5de5660..1c787da 100644
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -30,16 +30,19 @@ trap 'rm -f "$OUTDIR/$FILE" "$OUTDIR/$FILE.sed"' EXIT
 for i in "$@"
 do
 	FILE="$(basename "$i")"
+	scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ "$SRCDIR/$i" \
+		> "$OUTDIR/$FILE.sed"
 	sed -r \
+		-e '1i #ifdef __KERNEL__' \
+		-e '1i #error Kernel modules must not include files from /usr/include/' \
+		-e '1i #endif' \
 		-e 's/([ \t(])(__user|__force|__iomem)[ \t]/\1/g' \
 		-e 's/__attribute_const__([ \t]|$)/\1/g' \
 		-e 's@^#include <linux/compiler.h>@@' \
 		-e 's/(^|[^a-zA-Z0-9])__packed([^a-zA-Z0-9_]|$)/\1__attribute__((packed))\2/g' \
 		-e 's/(^|[ \t(])(inline|asm|volatile)([ \t(]|$)/\1__\2__\3/g' \
 		-e 's@#(ifndef|define|endif[ \t]*/[*])[ \t]*_UAPI@#\1 @' \
-		"$SRCDIR/$i" > "$OUTDIR/$FILE.sed" || exit 1
-	scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ "$OUTDIR/$FILE.sed" \
-		> "$OUTDIR/$FILE"
+		"$OUTDIR/$FILE.sed" >"$OUTDIR/$FILE" || exit 1
 	[ $? -gt 1 ] && exit 1
 	rm -f "$OUTDIR/$FILE.sed"
 done
-- 
1.8.4.5

