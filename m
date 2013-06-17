Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3FQXI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:08:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45777 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3FQXIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:08:25 -0400
Date: Mon, 17 Jun 2013 16:06:55 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-doc@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: [PATCH] coccicheck: span checks across CPUs
Message-ID: <20130617230655.GA21273@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds parallelism by default to the "coccicheck" target using
spatch's "-max" and "-index" arguments.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/coccinelle.txt |    5 +++++
 scripts/coccicheck           |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index 18de785..408439d 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -91,6 +91,11 @@ To enable verbose messages set the V= variable, for example:
 
    make coccicheck MODE=report V=1
 
+By default, coccicheck tries to run as parallel as possible. To change
+the parallelism, set the J= variable. For example, to run across 4 CPUs:
+
+   make coccicheck MODE=report J=4
+
 
  Using Coccinelle with a single semantic patch
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/scripts/coccicheck b/scripts/coccicheck
index 06fcb33..077e5b2 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -11,6 +11,12 @@ else
 	VERBOSE=0
 fi
 
+if [ -z "$J" ]; then
+	NPROC=$(getconf _NPROCESSORS_ONLN)
+else
+	NPROC="$J"
+fi
+
 FLAGS="$SPFLAGS -very_quiet"
 
 # spatch only allows include directories with the syntax "-I include"
@@ -61,10 +67,14 @@ if [ "$ONLINE" = "0" ] ; then
 fi
 
 run_cmd() {
+	local i
 	if [ $VERBOSE -ne 0 ] ; then
-		echo "Running: $@"
+		echo "Running ($NPROC in parallel): $@"
 	fi
-	eval $@
+	for i in $(seq 0 $(( NPROC - 1)) ); do
+		eval $@ -max $NPROC -index $i &
+	done
+	wait
 }
 
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
