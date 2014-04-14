Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaDNSLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:11:53 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56183 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaDNSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <1397498661.2962.5.camel@joe-AO722>
References: <CAJhHMCDBPPB4H3Oc1JVd_R_dMaao9cWBj8rjrweFmAp9nn97AQ@mail.gmail.com>
 <1397498661.2962.5.camel@joe-AO722>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 14 Apr 2014 14:11:20 -0400
Message-ID: <CAJhHMCCPd3+AddjK2S==4jii5G5q7ioNOjJ-0ds0u6YYVeBaoQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] prefetch result for ARM64 atomic ops
To: Joe Perches <joe@perches.com>
Cc: catalin.marinas@arm.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 2:04 PM, Joe Perches <joe@perches.com> wrote:
> Are there some benchmark comparison results
> you neglected to attach?

I was trying to get these ops to be similar to the 32 bit atomic ops which
all have prefetch. I did not see any reason why we shouldn't do the same
here. But no, no hard numbers yet. Send me a dev board please :)

>
>> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
>> +    prefetchw(&v->counter);
>
> Does this compile?
>

Argh, my mistake! I overlooked this. Please find fixed patch below:

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/arm64/include/asm/atomic.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 0237f08..82271ee 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -48,6 +48,7 @@ static inline void atomic_add(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_add\n"
 "1:    ldxr    %w0, %2\n"
 "    add    %w0, %w0, %w3\n"
@@ -62,6 +63,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_add_return\n"
 "1:    ldxr    %w0, %2\n"
 "    add    %w0, %w0, %w3\n"
@@ -80,6 +82,7 @@ static inline void atomic_sub(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_sub\n"
 "1:    ldxr    %w0, %2\n"
 "    sub    %w0, %w0, %w3\n"
@@ -94,6 +97,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_sub_return\n"
 "1:    ldxr    %w0, %2\n"
 "    sub    %w0, %w0, %w3\n"
@@ -113,6 +117,7 @@ static inline int atomic_cmpxchg(atomic_t *ptr,
int old, int new)
     int oldval;

     smp_mb();
+    prefetchw(&v->counter);

     asm volatile("// atomic_cmpxchg\n"
 "1:    ldxr    %w1, %2\n"
@@ -170,6 +175,7 @@ static inline void atomic64_add(u64 i, atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_add\n"
 "1:    ldxr    %0, %2\n"
 "    add    %0, %0, %3\n"
@@ -184,6 +190,7 @@ static inline long atomic64_add_return(long i,
atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_add_return\n"
 "1:    ldxr    %0, %2\n"
 "    add    %0, %0, %3\n"
@@ -202,6 +209,7 @@ static inline void atomic64_sub(u64 i, atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_sub\n"
 "1:    ldxr    %0, %2\n"
 "    sub    %0, %0, %3\n"
@@ -216,6 +224,7 @@ static inline long atomic64_sub_return(long i,
atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_sub_return\n"
 "1:    ldxr    %0, %2\n"
 "    sub    %0, %0, %3\n"
@@ -235,6 +244,7 @@ static inline long atomic64_cmpxchg(atomic64_t
*ptr, long old, long new)
     unsigned long res;

     smp_mb();
+    prefetchw(&v->counter);

     asm volatile("// atomic64_cmpxchg\n"
 "1:    ldxr    %1, %2\n"
@@ -258,6 +268,7 @@ static inline long atomic64_dec_if_positive(atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_dec_if_positive\n"
 "1:    ldxr    %0, %2\n"
 "    subs    %0, %0, #1\n"
-- 
1.9.1


-- 
Pranith
