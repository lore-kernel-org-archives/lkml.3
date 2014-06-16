Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaFPVHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:07:31 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51799 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaFPVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:07:29 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using min and max
Date: Mon, 16 Jun 2014 23:07:22 +0200
Message-Id: <1402952842-12886-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that gcc is better at optimising a double call to min
and max rather than open coded min3 and max3.  This can be observed
here:

    $ cat min-max.c
    #define min(x, y) ({				\
    	typeof(x) _min1 = (x);			\
    	typeof(y) _min2 = (y);			\
    	(void) (&_min1 == &_min2);		\
    	_min1 < _min2 ? _min1 : _min2; })
    #define min3(x, y, z) ({			\
    	typeof(x) _min1 = (x);			\
    	typeof(y) _min2 = (y);			\
    	typeof(z) _min3 = (z);			\
    	(void) (&_min1 == &_min2);		\
    	(void) (&_min1 == &_min3);		\
    	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
    		(_min2 < _min3 ? _min2 : _min3); })

    int fmin3(int x, int y, int z) { return min3(x, y, z); }
    int fmin2(int x, int y, int z) { return min(min(x, y), z); }

    $ gcc -O2 -o min-max.s -S min-max.c; cat min-max.s
    	.file	"min-max.c"
    	.text
    	.p2align 4,,15
    	.globl	fmin3
    	.type	fmin3, @function
    fmin3:
    .LFB0:
    	.cfi_startproc
    	cmpl	%esi, %edi
    	jl	.L5
    	cmpl	%esi, %edx
    	movl	%esi, %eax
    	cmovle	%edx, %eax
    	ret
    	.p2align 4,,10
    	.p2align 3
    .L5:
    	cmpl	%edi, %edx
    	movl	%edi, %eax
    	cmovle	%edx, %eax
    	ret
    	.cfi_endproc
    .LFE0:
    	.size	fmin3, .-fmin3
    	.p2align 4,,15
    	.globl	fmin2
    	.type	fmin2, @function
    fmin2:
    .LFB1:
    	.cfi_startproc
    	cmpl	%edi, %esi
    	movl	%edx, %eax
    	cmovle	%esi, %edi
    	cmpl	%edx, %edi
    	cmovle	%edi, %eax
    	ret
    	.cfi_endproc
    .LFE1:
    	.size	fmin2, .-fmin2
    	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
    	.section	.note.GNU-stack,"",@progbits

fmin3 function, which uses open-coded min3 macro, is compiled into
total of ten instructions including a conditional branch, whereas fmin2
function, which uses two calls to min2 macro, is compiled into six
instructions with no branches.

Similarly, open-coded clamp produces the same code as clamp using min
and max macros, but the latter is much shorter:

    $ cat clamp.c
    #define clamp(val, min, max) ({			\
    	typeof(val) __val = (val);		\
    	typeof(min) __min = (min);		\
    	typeof(max) __max = (max);		\
    	(void) (&__val == &__min);		\
    	(void) (&__val == &__max);		\
    	__val = __val < __min ? __min: __val;	\
    	__val > __max ? __max: __val; })
    #define min(x, y) ({				\
    	typeof(x) _min1 = (x);			\
    	typeof(y) _min2 = (y);			\
    	(void) (&_min1 == &_min2);		\
    	_min1 < _min2 ? _min1 : _min2; })
    #define max(x, y) ({				\
    	typeof(x) _max1 = (x);			\
    	typeof(y) _max2 = (y);			\
    	(void) (&_max1 == &_max2);		\
    	_max1 > _max2 ? _max1 : _max2; })

    int fclamp(int v, int min, int max) { return clamp(v, min, max); }
    int fclampmm(int v, int min, int max) { return min(max(v, min), max); }

    $ gcc -O2 -o clamp.s -S clamp.c; cat clamp.s
    	.file	"clamp.c"
    	.text
    	.p2align 4,,15
    	.globl	fclamp
    	.type	fclamp, @function
    fclamp:
    .LFB0:
    	.cfi_startproc
    	cmpl	%edi, %esi
    	movl	%edx, %eax
    	cmovge	%esi, %edi
    	cmpl	%edx, %edi
    	cmovle	%edi, %eax
    	ret
    	.cfi_endproc
    .LFE0:
    	.size	fclamp, .-fclamp
    	.p2align 4,,15
    	.globl	fclampmm
    	.type	fclampmm, @function
    fclampmm:
    .LFB1:
    	.cfi_startproc
    	cmpl	%edi, %esi
    	cmovge	%esi, %edi
    	cmpl	%edi, %edx
    	movl	%edi, %eax
    	cmovle	%edx, %eax
    	ret
    	.cfi_endproc
    .LFE1:
    	.size	fclampmm, .-fclampmm
    	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
    	.section	.note.GNU-stack,"",@progbits

Furthermore, after “make allmodconfig && make bzImage modules” this is the
comparison of image and modules sizes:

    # Without this patch applied
    $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
    350715800

    # With this patch applied
    $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
    349856528

The above builds were done on:

    $ uname -a; gcc --version
    Linux mpn-glaptop 3.13.0-29-generic #53~precise1-Ubuntu SMP Wed Jun 4 22:06:25 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
    Copyright (C) 2011 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/kernel.h | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

 Interestingly commit [f27c85c56b: “add {min,max}3 macros”] claims
 thatthe open-coded min3/max3 “will save some cycles as well as some
 bytes on the stack”, but as far as I can see that statement is false.
 But maybe there's something Hagen knows that I missed?

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907..44649e0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -719,23 +719,8 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
-#define min3(x, y, z) ({			\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	typeof(z) _min3 = (z);			\
-	(void) (&_min1 == &_min2);		\
-	(void) (&_min1 == &_min3);		\
-	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
-		(_min2 < _min3 ? _min2 : _min3); })
-
-#define max3(x, y, z) ({			\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	typeof(z) _max3 = (z);			\
-	(void) (&_max1 == &_max2);		\
-	(void) (&_max1 == &_max3);		\
-	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
-		(_max2 > _max3 ? _max2 : _max3); })
+#define min3(x, y, z) min(min(x, y), z)
+#define max3(x, y, z) max(max(x, y), z)
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
@@ -750,20 +735,13 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
+ * @lo: lowest allowable value
+ * @hi: highest allowable value
  *
  * This macro does strict typechecking of min/max to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, min, max) ({			\
-	typeof(val) __val = (val);		\
-	typeof(min) __min = (min);		\
-	typeof(max) __max = (max);		\
-	(void) (&__val == &__min);		\
-	(void) (&__val == &__max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+#define clamp(val, lo, hi) min(max(val, lo), hi)
 
 /*
  * ..and if you can't take the strict
-- 
2.0.0.526.g5318336

