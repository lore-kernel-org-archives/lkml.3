Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbbA2JEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:04:14 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44811 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbbA2JEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/176] x86, vdso: Use asm volatile in __getcpu
Date: Wed, 28 Jan 2015 15:27:37 +0100
Message-Id: <779cf1d93e1194b041cd139b8e71e0baae4884a6.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1ddf0b1b11aa8a90cef6706e935fc31c75c406ba upstream.

In Linux 3.18 and below, GCC hoists the lsl instructions in the
pvclock code all the way to the beginning of __vdso_clock_gettime,
slowing the non-paravirt case significantly.  For unknown reasons,
presumably related to the removal of a branch, the performance issue
is gone as of

e76b027e6408 x86,vdso: Use LSL unconditionally for vgetcpu

but I don't trust GCC enough to expect the problem to stay fixed.

There should be no correctness issue, because the __getcpu calls in
__vdso_vlock_gettime were never necessary in the first place.

Note to stable maintainers: In 3.18 and below, depending on
configuration, gcc 4.9.2 generates code like this:

     9c3:       44 0f 03 e8             lsl    %ax,%r13d
     9c7:       45 89 eb                mov    %r13d,%r11d
     9ca:       0f 03 d8                lsl    %ax,%ebx

This patch won't apply as is to any released kernel, but I'll send a
trivial backported version if needed.

[
 Backported by Andy Lutomirski.  Should apply to all affected
 versions.  This fixes a functionality bug as well as a performance
 bug: buggy kernels can infinite loop in __vdso_clock_gettime on
 affected compilers.  See, for exammple:

 https://bugzilla.redhat.com/show_bug.cgi?id=1178975
]

Fixes: 51c19b4f5927 x86: vdso: pvclock gettime support
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/vsyscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 2a46ca720afc..2874be9aef0a 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -34,7 +34,7 @@ static inline unsigned int __getcpu(void)
 		native_read_tscp(&p);
 	} else {
 		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+		asm volatile ("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
 	}
 
 	return p;
-- 
2.2.2

