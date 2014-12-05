Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaLEXx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:53:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaLEWpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.17 017/122] x86, kaslr: Handle Gold linker for finding bss/brk
Date: Fri,  5 Dec 2014 14:43:11 -0800
Message-Id: <20141205223308.136864930@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/tools/calc_run_size.pl |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

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


