Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaLOPLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:11:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38337 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaLOO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 036/168] x86, kaslr: Handle Gold linker for finding bss/brk
Date: Mon, 15 Dec 2014 14:24:50 +0000
Message-Id: <1418653622-21105-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 70b61e362187b5fccac206506d402f3424e3e749 upstream.

When building with the Gold linker, the .bss and .brk areas of vmlinux
are shown as consecutive instead of having the same file offset. Allow
for either state, as long as things add up correctly.

Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Junjie Mao <eternal.n08@gmail.com>
Link: http://lkml.kernel.org/r/20141118001604.GA25045@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/tools/calc_run_size.pl | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
index 0b0b124d3ece..23210baade2d 100644
--- a/arch/x86/tools/calc_run_size.pl
+++ b/arch/x86/tools/calc_run_size.pl
@@ -19,7 +19,16 @@ while (<>) {
 		if ($file_offset == 0) {
 			$file_offset = $offset;
 		} elsif ($file_offset != $offset) {
-			die ".bss and .brk lack common file offset\n";
+			# BFD linker shows the same file offset in ELF.
+			# Gold linker shows them as consecutive.
+			next if ($file_offset + $mem_size == $offset + $size);
+
+			printf STDERR "file_offset: 0x%lx\n", $file_offset;
+			printf STDERR "mem_size: 0x%lx\n", $mem_size;
+			printf STDERR "offset: 0x%lx\n", $offset;
+			printf STDERR "size: 0x%lx\n", $size;
+
+			die ".bss and .brk are non-contiguous\n";
 		}
 	}
 }
-- 
2.1.3

