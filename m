Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3AVMrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:47:23 -0500
Received: from multi.imgtec.com ([194.200.65.239]:9590 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3AVMrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:47:20 -0500
Message-ID: <50FE8A55.2000703@imgtec.com>
Date: Tue, 22 Jan 2013 12:47:17 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC] making HAVE_SYSCALL_WRAPPERS universal (Re: Issues with
 "x86, um: switch to generic fork/vfork/clone" commit)
References: <50F3D2F2.3080200@6wind.com> <20130119063808.GN4939@ZenIV.linux.org.uk> <20130120031253.GO4939@ZenIV.linux.org.uk> <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com> <20130121012217.GQ4939@ZenIV.linux.org.uk> <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com> <20130121023010.GR4939@ZenIV.linux.org.uk> <20130121225517.GV4939@ZenIV.linux.org.uk>
In-Reply-To: <20130121225517.GV4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_22_12_47_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/13 22:55, Al Viro wrote:
> I've tried to sanitize cond_syscall/SYSCALL_ALIAS situation; the tree is in
> git.kernel.org/pub/scm/linux/kernel/git/viro/signal experimental-syscalls
> NOTE: this is absolutely untested and might very well blow up
> on any number of architectures.
> 
> Review and comments would be very welcome.

Looking at "consolidate cond_syscall and SYSCALL_ALIAS declarations",
is it worth having the default __SYMBOL_NAME declaration in
include/linux/linkage.h make use of CONFIG_SYMBOL_PREFIX?

E.g. in the metag patchset we currently have the patch below.

Admittedly CONFIG_SYMBOL_PREFIX is a string which would make it's use in
SYMBOL_NAME a bit awkward.

Cheers
James


Subject: [PATCH v3 02/44] asm-generic/unistd.h: handle symbol prefixes in
 cond_syscall

Some architectures have symbol prefixes and set CONFIG_SYMBOL_PREFIX,
but this wasn't taken into account by the generic cond_syscall. It's
easy enough to fix in a generic fashion, so add the symbol prefix to
symbol names in cond_syscall when CONFIG_SYMBOL_PREFIX is set.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/unistd.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 257c55e..4077b5d 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -17,5 +17,12 @@
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#ifdef CONFIG_SYMBOL_PREFIX
+#define __SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define __SYMBOL_PREFIX
+#endif
+#define cond_syscall(x) asm(".weak\t" __SYMBOL_PREFIX #x "\n\t" \
+			    ".set\t" __SYMBOL_PREFIX #x "," \
+			    __SYMBOL_PREFIX "sys_ni_syscall")
 #endif
-- 
1.7.7.6

