Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaBUULB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:11:01 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40376 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbaBUULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:11:00 -0500
Date: Fri, 21 Feb 2014 12:10:31 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ming Lei <tom.leiming@gmail.com>, Andy Honig <ahonig@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org
Subject: [PATCH] kallsyms: fix absolute addresses for kASLR
Message-ID: <20140221201031.GA8089@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

Currently symbols that are absolute addresses are incorrectly
displayed in /proc/kallsyms if the kernel is loaded with kASLR.

The problem was that the scripts/kallsyms.c file which generates
the array of symbol names and addresses uses an relocatable value
for all symbols, even absolute symbols.  This patch fixes that.

Several kallsyms output in different boot states for comparison:

$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.nokaslr
0000000000000000 D __per_cpu_start
0000000000014280 D __per_cpu_end
ffffffff810001c8 T _stext
$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr1
000000001f200000 D __per_cpu_start
000000001f214280 D __per_cpu_end
ffffffffa02001c8 T _stext
$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr2
000000000d400000 D __per_cpu_start
000000000d414280 D __per_cpu_end
ffffffff8e4001c8 T _stext
$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr-fixed
0000000000000000 D __per_cpu_start
0000000000014280 D __per_cpu_end
ffffffffadc001c8 T _stext

Signed-off-by: Andy Honig <ahonig@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/kallsyms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 10085de886fe..276e84b8a8e5 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -330,8 +330,7 @@ static void write_src(void)
 				printf("\tPTR\t_text + %#llx\n",
 					table[i].addr - _text);
 			else
-				printf("\tPTR\t_text - %#llx\n",
-					_text - table[i].addr);
+				printf("\tPTR\t%#llx\n", table[i].addr);
 		} else {
 			printf("\tPTR\t%#llx\n", table[i].addr);
 		}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
