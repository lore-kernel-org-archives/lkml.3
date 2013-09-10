Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3IJN3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:29:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44179 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3IJN3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:29:34 -0400
From: Javi Merino <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Javi Merino <javi.merino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] smp: harmonize prototypes of smp functions
Date: Tue, 10 Sep 2013 14:29:12 +0100
Message-Id: <1378819752-11175-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 10 Sep 2013 13:29:28.0995 (UTC) FILETIME=[C6A57F30:01CEAE29]
X-MC-Unique: 113091014293210301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r8ADTfCY028122

Avoid unnecessary casts from int to bool in smp functions.  Some
functions in kernel/smp.c have a wait parameter that can be set to one
if you want to wait for the command to complete.  It's defined as bool
in a few of them and int in the rest.  If a function with wait
declared as int calls a function whose prototype has wait defined as
bool, the compiler needs to test if the int is != 0 and change it to 1
if so.  This useless check can be avoided if we are consistent and
make all the functions use the same type for this parameter.

For example in arm, before this patch:

800464e4 <smp_call_function>:
800464e4:       b538            push    {r3, r4, r5, lr}
800464e6:       460d            mov     r5, r1
800464e8:       4613            mov     r3, r2       ; move wait to r3
800464ea:       f64f 448c       movw    r4, #64652
800464ee:       3300            adds    r3, #0       ; test if wait is 0
800464f0:       f2c8 0425       movt    r4, #32805
800464f4:       4601            mov     r1, r0
800464f6:       bf18            it      ne
800464f8:       2301            movne   r3, #1       ; if it is not, wait = 1
800464fa:       462a            mov     r2, r5
800464fc:       6820            ldr     r0, [r4, #0]
800464fe:       f7ff fea9       bl      80046254 <smp_call_function_many>
80046502:       2000            movs    r0, #0
80046504:       bd38            pop     {r3, r4, r5, pc}
80046506:       bf00            nop

After the patch:

800464e4 <smp_call_function>:
800464e4:	b538      	push	{r3, r4, r5, lr}
800464e6:	460d      	mov	r5, r1
800464e8:	4613      	mov	r3, r2      ; just move it to r3
800464ea:	f64f 448c 	movw	r4, #64652
800464ee:	4601      	mov	r1, r0
800464f0:	f2c8 0425 	movt	r4, #32805
800464f4:	462a      	mov	r2, r5
800464f6:	6820      	ldr	r0, [r4, #0]
800464f8:	f7ff feac 	bl	80046254 <smp_call_function_many>
800464fc:	2000      	movs	r0, #0
800464fe:	bd38      	pop	{r3, r4, r5, pc}

Same for x86.  Before:

ffffffff8109bf10 <smp_call_function>:
ffffffff8109bf10:       55                      push   %rbp
ffffffff8109bf11:       48 89 e5                mov    %rsp,%rbp
ffffffff8109bf14:       31 c9                   xor    %ecx,%ecx  ; ecx = 0
ffffffff8109bf16:       85 d2                   test   %edx,%edx  ; test if wait is 0
ffffffff8109bf18:       48 89 f2                mov    %rsi,%rdx
ffffffff8109bf1b:       48 89 fe                mov    %rdi,%rsi
ffffffff8109bf1e:       48 8b 3d 4b d3 76 00    mov    0x76d34b(%rip),%rdi        # ffffffff81809270 <cpu_online_mask>
ffffffff8109bf25:       0f 95 c1                setne  %cl        ; if it is not, ecx = 1
ffffffff8109bf28:       e8 43 fc ff ff          callq  ffffffff8109bb70 <smp_call_function_many>
ffffffff8109bf2d:       31 c0                   xor    %eax,%eax
ffffffff8109bf2f:       5d                      pop    %rbp
ffffffff8109bf30:       c3                      retq

After:

ffffffff8109bf20 <smp_call_function>:
ffffffff8109bf20:       55                      push   %rbp
ffffffff8109bf21:       48 89 e5                mov    %rsp,%rbp
ffffffff8109bf24:       89 d1                   mov    %edx,%ecx  ; just move wait to ecx
ffffffff8109bf26:       48 89 f2                mov    %rsi,%rdx
ffffffff8109bf29:       48 89 fe                mov    %rdi,%rsi
ffffffff8109bf2c:       48 8b 3d 3d d3 76 00    mov    0x76d33d(%rip),%rdi        # ffffffff81809270 <cpu_online_mask>
ffffffff8109bf33:       e8 48 fc ff ff          callq  ffffffff8109bb80 <smp_call_function_many>
ffffffff8109bf38:       31 c0                   xor    %eax,%eax
ffffffff8109bf3a:       5d                      pop    %rbp
ffffffff8109bf3b:       c3                      retq
ffffffff8109bf3c:       0f 1f 40 00             nopl   0x0(%rax)

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 include/linux/smp.h |    6 +++---
 kernel/smp.c        |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index c181399..a894405 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -72,7 +72,7 @@ extern void smp_cpus_done(unsigned int max_cpus);
  */
 int smp_call_function(smp_call_func_t func, void *info, int wait);
 void smp_call_function_many(const struct cpumask *mask,
-			    smp_call_func_t func, void *info, bool wait);
+			    smp_call_func_t func, void *info, int wait);
 
 void __smp_call_function_single(int cpuid, struct call_single_data *data,
 				int wait);
@@ -104,7 +104,7 @@ int on_each_cpu(smp_call_func_t func, void *info, int wait);
  * the local one.
  */
 void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
-		void *info, bool wait);
+		void *info, int wait);
 
 /*
  * Call a function on each processor for which the supplied function
@@ -112,7 +112,7 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
  * processor.
  */
 void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
-		smp_call_func_t func, void *info, bool wait,
+		smp_call_func_t func, void *info, int wait,
 		gfp_t gfp_flags);
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index 449b707..898fd8a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -353,7 +353,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
  * must be disabled when calling this function.
  */
 void smp_call_function_many(const struct cpumask *mask,
-			    smp_call_func_t func, void *info, bool wait)
+			    smp_call_func_t func, void *info, int wait)
 {
 	struct call_function_data *cfd;
 	int cpu, next_cpu, this_cpu = smp_processor_id();
@@ -576,7 +576,7 @@ EXPORT_SYMBOL(on_each_cpu);
  * from a hardware interrupt handler or from a bottom half handler.
  */
 void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
-			void *info, bool wait)
+			void *info, int wait)
 {
 	int cpu = get_cpu();
 
@@ -618,7 +618,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * from a hardware interrupt handler or from a bottom half handler.
  */
 void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
-			smp_call_func_t func, void *info, bool wait,
+			smp_call_func_t func, void *info, int wait,
 			gfp_t gfp_flags)
 {
 	cpumask_var_t cpus;
-- 
1.7.9.5


