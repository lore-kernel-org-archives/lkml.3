Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3DWMlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:41:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63870 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3DWMlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:41:09 -0400
X-Nat-Received: from [202.181.97.72]:56539 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366720849.16068
To: arjan@infradead.org, hpa@zytor.com, james.hogan@imgtec.com,
        rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com
Subject: [PATCH] x86_32: Fix module version table mismatch.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
	<CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
	<201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
In-Reply-To: <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
Message-Id: <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 23 Apr 2013 21:40:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 23042013 #9885973, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a4b6a77b "module: fix symbol versioning with symbol prefixes" broke
loading of net/ipv6/ipv6.ko built with CONFIG_MODVERSIONS=y for x86_32.

  # modprobe ipv6
  FATAL: Error inserting ipv6 (/lib/modules/3.9.0-rc8-next-20130422/kernel/net/ipv6/ipv6.ko): Invalid argument
  # dmesg
  ipv6: no symbol version for memcmp
  ipv6: Unknown symbol memcmp (err -22)

The reason for breakage is that check_version() in kernel/module.c tries to
find symname == "memcmp" but versions[i].name == "__builtin_memcmp".

The reason for versions[i].name == "__builtin_memcmp" is that
memcmp() for x86_32 is defined as

  #define memcmp __builtin_memcmp

in arch/x86/include/asm/string_32.h while memcmp() for x86_64 is defined as

  int memcmp(const void *cs, const void *ct, size_t count);

in arch/x86/include/asm/string_64.h.

Since __builtin_memcmp is a gcc's built-in function which might emit a call to
memcmp, __builtin_memcmp should not be used for versions[i].name field.

In order to make sure that versions[i].name == "memcmp", make the definition of
memcmp() for x86_32 identical with that of x86_64.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/string_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 3d3e835..bb85b4e 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -199,7 +199,7 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t n);
 
-#define memcmp __builtin_memcmp
+int memcmp(const void *cs, const void *ct, size_t count);
 
 #define __HAVE_ARCH_MEMCHR
 extern void *memchr(const void *cs, int c, size_t count);
-- 
1.7.1
