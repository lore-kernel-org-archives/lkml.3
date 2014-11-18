Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaKRRlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:41:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaKRRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:41:12 -0500
Date: Tue, 18 Nov 2014 09:40:57 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-70b61e362187b5fccac206506d402f3424e3e749@git.kernel.org>
Cc: eternal.n08@gmail.com, keescook@chromium.org, markus@trippelsdorf.de,
        hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Reply-To: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, markus@trippelsdorf.de, keescook@chromium.org,
        eternal.n08@gmail.com
In-Reply-To: <20141118001604.GA25045@www.outflux.net>
References: <20141118001604.GA25045@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kaslr: Handle Gold linker for finding bss/
 brk
Git-Commit-ID: 70b61e362187b5fccac206506d402f3424e3e749
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70b61e362187b5fccac206506d402f3424e3e749
Gitweb:     http://git.kernel.org/tip/70b61e362187b5fccac206506d402f3424e3e749
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Mon, 17 Nov 2014 16:16:04 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 18:32:24 +0100

x86, kaslr: Handle Gold linker for finding bss/brk

When building with the Gold linker, the .bss and .brk areas of vmlinux
are shown as consecutive instead of having the same file offset. Allow
for either state, as long as things add up correctly.

Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Junjie Mao <eternal.n08@gmail.com>
Link: http://lkml.kernel.org/r/20141118001604.GA25045@www.outflux.net
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/tools/calc_run_size.pl | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
index 0b0b124..23210ba 100644
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
