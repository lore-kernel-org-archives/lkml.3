Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaBNEcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:32:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaBNEcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:32:06 -0500
Date: Thu, 13 Feb 2014 20:31:56 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-8564ed2b3888176ac323eefea1722003daeba3d3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-10-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-10-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] Kbuild, lto:
  Add a gcc-ld script to let run gcc as ld
Git-Commit-ID: 8564ed2b3888176ac323eefea1722003daeba3d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:32:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8564ed2b3888176ac323eefea1722003daeba3d3
Gitweb:     http://git.kernel.org/tip/8564ed2b3888176ac323eefea1722003daeba3d3
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:14 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:25:02 -0800

Kbuild, lto: Add a gcc-ld script to let run gcc as ld

For LTO we need to run the link step with gcc, not ld.
Since there are a lot of linker options passed to it, add a gcc-ld wrapper
that wraps them as -Wl,

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-10-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/gcc-ld | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/scripts/gcc-ld b/scripts/gcc-ld
new file mode 100644
index 0000000..cadab9a
--- /dev/null
+++ b/scripts/gcc-ld
@@ -0,0 +1,29 @@
+#!/bin/sh
+# run gcc with ld options
+# used as a wrapper to execute link time optimizations
+# yes virginia, this is not pretty
+
+ARGS="-nostdlib"
+
+while [ "$1" != "" ] ; do
+	case "$1" in
+	-save-temps|-m32|-m64) N="$1" ;;
+	-r) N="$1" ;;
+	-[Wg]*) N="$1" ;;
+	-[olv]|-[Ofd]*|-nostdlib) N="$1" ;;
+	--end-group|--start-group)
+		 N="-Wl,$1" ;;
+	-[RTFGhIezcbyYu]*|\
+--script|--defsym|-init|-Map|--oformat|-rpath|\
+-rpath-link|--sort-section|--section-start|-Tbss|-Tdata|-Ttext|\
+--version-script|--dynamic-list|--version-exports-symbol|--wrap|-m)
+		A="$1" ; shift ; N="-Wl,$A,$1" ;;
+	-[m]*) N="$1" ;;
+	-*) N="-Wl,$1" ;;
+	*)  N="$1" ;;
+	esac
+	ARGS="$ARGS $N"
+	shift
+done
+
+exec $CC $ARGS
