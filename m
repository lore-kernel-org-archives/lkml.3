Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaKRAQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:16:22 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34837 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbaKRAQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:16:21 -0500
Date: Mon, 17 Nov 2014 16:16:04 -0800
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Junjie Mao <eternal.n08@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, kaslr: handle Gold linker for finding bss+brk
Message-ID: <20141118001604.GA25045@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with the Gold linker, the .bss and .brk areas of vmlinux
are shown as consecutive instead of having the same file offset. Allow
for either state, as long as things add up correctly.

Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Junjie Mao <eternal.n08@gmail.com>
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
1.9.1


-- 
Kees Cook
Chrome OS Security
