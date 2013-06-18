Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3FRVOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:14:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47711 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3FRVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:14:53 -0400
Date: Tue, 18 Jun 2013 14:14:28 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Rob Landley <rob@landley.net>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, linux-doc@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: [PATCH v2] coccicheck: span checks across CPUs
Message-ID: <20130618211428.GA14558@www.outflux.net>
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
v2:
 - added job control to clean up on interrupt, suggested by Nicolas Palix.
---
 Documentation/coccinelle.txt |    5 +++++
 scripts/coccicheck           |   31 ++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

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
index 06fcb33..7a8b722 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -2,15 +2,24 @@
 
 SPATCH="`which ${SPATCH:=spatch}`"
 
+trap kill_running SIGTERM SIGINT
+declare -s SPATCH_PID
+
 # The verbosity may be set by the environmental parameter V=
 # as for example with 'make V=1 coccicheck'
 
 if [ -n "$V" -a "$V" != "0" ]; then
-	VERBOSE=1
+	VERBOSE="$V"
 else
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
@@ -61,12 +70,28 @@ if [ "$ONLINE" = "0" ] ; then
 fi
 
 run_cmd() {
+	local i
 	if [ $VERBOSE -ne 0 ] ; then
-		echo "Running: $@"
+		echo "Running ($NPROC in parallel): $@"
 	fi
-	eval $@
+	for i in $(seq 0 $(( NPROC - 1)) ); do
+		eval "$@ -max $NPROC -index $i &"
+		SPATCH_PID[$i]=$!
+		if [ $VERBOSE -eq 2 ] ; then
+			echo "${SPATCH_PID[$i]} running"
+		fi
+	done
+	wait
 }
 
+kill_running() {
+	for i in $(seq $(( NPROC - 1 )) ); do
+		if [ $VERBOSE -eq 2 ] ; then
+			echo "Killing ${SPATCH_PID[$i]}"
+		fi
+		kill ${SPATCH_PID[$i]} 2>/dev/null
+	done
+}
 
 coccinelle () {
     COCCI="$1"
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
