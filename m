Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbbA0Mwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:52:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbbA0MQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 006/126] x86, vdso: Use asm volatile in __getcpu
Date: Tue, 27 Jan 2015 12:15:11 +0000
Message-Id: <1422361031-19364-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

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
[ luis: backported to 3.16: used Andy's backport for stable kernels ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

