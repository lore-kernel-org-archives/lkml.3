Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaJVOTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:19:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58518 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751511AbaJVOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:19:47 -0400
Date: Wed, 22 Oct 2014 10:19:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Peter Foley <pefoley2@pefoley.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kbuild: Fix output of make kernelrelease
Message-ID: <20141022101944.70d637cc@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 7ff525712acf "kbuild: fake the "Entering directory ..." message
more simply" changed the output of "make kernelrelease" such that the
kernel release version was not the last line printed. This broke various
tools that would find the kernel release with "make kernelrelease | tail -1".
One of those tools that broke was ktest.pl which resides in the kernel.

If the target of the make is "kernelrelease" do not print the
"Leaving directory ..." message at the end as that will break tools that
expect the kernelrelease version to be the last line outputted.

Fixes: 7ff525712acf "kbuild: fake the "Entering directory ..." message more simply"
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Peter Foley <pefoley2@pefoley.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile b/Makefile
index 05d67af376c5..83fc5f0398a0 100644
--- a/Makefile
+++ b/Makefile
@@ -14,6 +14,14 @@ NAME = Shuffling Zombie Juror
 # (this increases performance and avoids hard-to-debug behaviour);
 MAKEFLAGS += -rR
 
+#
+# The target "kernelrelease" requires the last line to be the release
+# of the kernel, not a "Leaving directory ..." message.
+#   ktest.pl and other tools require this.
+ifeq ("$(MAKECMDGOALS)", "kernelrelease")
+MAKEFLAGS += --no-print-directory
+endif
+
 # Avoid funny character set dependencies
 unexport LC_ALL
 LC_COLLATE=C
-- 
2.0.1

