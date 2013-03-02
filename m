Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3CBVgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:36:53 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33575 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3CBVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:36:52 -0500
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 2/4] Coccinelle: Cleanup the setting of the FLAGS and OPTIONS variables
Date: Sat,  2 Mar 2013 22:36:26 +0100
Message-Id: <1362260188-14138-2-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
References: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FLAGS variable is factorized independently of the ONLINE mode.
The OPTIONS variable is now based on LINUXINCLUDE and explicit
includes are thus removed.

The format of the -I option differs between gcc and spatch.
The COCCIINCLUDE is used to adapt the format. This rewritting
needs bash.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 scripts/coccicheck |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 7f0d6a6..cdde8e0 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 SPATCH="`which ${SPATCH:=spatch}`"
 
@@ -11,24 +11,25 @@ else
 	VERBOSE=0
 fi
 
+FLAGS="-very_quiet"
+
+# spatch only allows include directories with the syntax "-I include"
+# while gcc also allows "-Iinclude" and "-include include"
+COCCIINCLUDE=${LINUXINCLUDE//-I/-I }
+COCCIINCLUDE=${COCCIINCLUDE//-include/-I}
+
 if [ "$C" = "1" -o "$C" = "2" ]; then
     ONLINE=1
 
-# This requires Coccinelle >= 0.2.3
-#    FLAGS="-ignore_unknown_options -very_quiet"
-#    OPTIONS=$*
-
-# Workaround for Coccinelle < 0.2.3
-	FLAGS="-I $srctree/include -very_quiet"
-	shift $(( $# - 1 ))
-	OPTIONS=$1
+    # Take only the last argument, which is the C file to test
+    shift $(( $# - 1 ))
+    OPTIONS="$COCCIINCLUDE $1"
 else
     ONLINE=0
-    FLAGS="-very_quiet"
     if [ "$KBUILD_EXTMOD" = "" ] ; then
-        OPTIONS="-dir $srctree"
+        OPTIONS="-dir $srctree $COCCIINCLUDE"
     else
-        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include"
+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree $COCCIINCLUDE"
     fi
 fi
 
-- 
1.7.10.4

