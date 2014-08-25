Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaHYM7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:59:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbaHYM7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:59:21 -0400
Message-ID: <53FB32FD.4000603@redhat.com>
Date: Mon, 25 Aug 2014 14:58:37 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Francesco Fusco <ffusco@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        William Lee Irwin III <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>
Subject: Re: [PATCH/RFC] hash: Let gcc decide how to multiply
References: <1408968804-7295-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1408968804-7295-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 02:13 PM, Rasmus Villemoes wrote:
> A 9+ years old comment in hash_64 says that gcc can't optimize
> multiplication by GOLDEN_RATIO_PRIME_64. Well, compilers get smarter
> and CPUs get faster all the time, so it is perhaps about time to
> revisit that assumption.

Seems fine by me, but Cc'ing a couple of others (as those you have Cc'ed
haven't written that code :)). You might want to let your changes go via
Andrew's tree, too, perhaps ...

> A stupid micro-benchmark [3] on my x86_64 machine shows that letting
> gcc generate the imul instruction is ~60% faster than the sequence of
> shifts and add/sub. But that is cheating, since the load of the
> constant is hoisted out of the loop. A slightly less stupid [1]
> micro-benchmark still shows ~55% improvement over the current
> version. So let the compiler do its job.
>
> Also, this should reduce the instruction cache footprint of all
> callers of the force-inlined hash_64. [2]
>
> While at it, fix the suffixes of GOLDEN_RATIO_PRIME_{32,64} so that
> their types are compatible with u32/u64 on all platforms (I'm not sure
> what the compiler does on a 32-bit platform when encountering a
> too-wide literal with an explicit UL suffix).
>
> [1] It is stupid in another way, since my inline asm skills
> suck. Still, I at least get to force the compiler to do the load on
> every loop iteration.
>
> [2] Well, it is an overall win: x86_64, defconfig, gcc 4.7.2:
> $ scripts/bloat-o-meter /tmp/vmlinux-{master,hash}
> add/remove: 0/1 grow/shrink: 17/44 up/down: 622/-2418 (-1796)
>
> [3] Please don't laugh:
> /*
>    $ gcc -Wall -O2 -o hashtest hashtest.c
>    $ ./hashtest
>    gcc_hash        2093320 12624
>    asm_hash        2093320 14264
>    kernel_hash     2093320 32076
>    $ echo $((100*12624/32076)), $((100*14264/32076))
>    39, 44
> */
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <stdint.h>
> #include <rdtsc.h>
> #include <fcntl.h>
> #include <unistd.h>
>
> #define u64 uint64_t
>
> #define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL
>
> #ifndef __always_inline
> #define __always_inline __inline __attribute__ ((__always_inline__))
> #endif
>
> static __always_inline u64 kernel_hash(u64 val, unsigned int bits)
> {
> 	u64 hash = val;
>
> 	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
> 	u64 n = hash;
> 	n <<= 18;
> 	hash -= n;
> 	n <<= 33;
> 	hash -= n;
> 	n <<= 3;
> 	hash += n;
> 	n <<= 3;
> 	hash -= n;
> 	n <<= 4;
> 	hash += n;
> 	n <<= 2;
> 	hash += n;
>
> 	/* High bits are more random, so use them. */
> 	return hash >> (64 - bits);
> }
>
> static __always_inline u64 gcc_hash(u64 val, unsigned int bits)
> {
> 	u64 hash = val * GOLDEN_RATIO_PRIME_64;
> 	return hash >> (64 - bits);
> }
>
> static __always_inline u64 asm_hash(u64 val, unsigned int bits)
> {
> 	u64 hash;
> 	__asm__("mov %1, %%rax\n\t"
> 		"movabs $0x9e37fffffffc0001,%%rdx\n\t"
> 		"imul   %%rdx,%%rax\n\t"
> 		"mov    %%rax, %0"
> 		: "=r"(hash)
> 		:"r"(val)
> 		: "%rax", "%rdx");
> 	return hash >> (64 - bits);
> }
>
> /* I have 32 KiB of L1 data cache. */
> #define N ((1<<15)/sizeof(u64))
> #define NBITS 10 /* doesn't seem to affect the outcome */
>
> int main(void)
> {
> 	unsigned long start, stop;
> 	u64 buf[N];
> 	int fd = open("/dev/urandom", O_RDONLY);
> 	u64 sum;
> 	int i;
>
> 	if (fd < 0)
> 		exit(1);
> 	if (read(fd, buf, sizeof(buf)) != sizeof(buf))
> 		exit(2);
> 	close(fd);
>
> #define TEST(f) do {						\
> 		sum = 0;					\
> 		start = rdtsc();				\
> 		for (i = 0; i < N; ++i)				\
> 			sum += f(buf[i], NBITS);		\
> 		stop = rdtsc();					\
> 		printf("%s\t%lu\t%lu\n", #f, sum, stop-start);	\
> 	} while (0)
>
> 	TEST(gcc_hash);
> 	TEST(asm_hash);
> 	TEST(kernel_hash);
>
> 	return 0;
> }
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>   include/linux/hash.h | 21 +++------------------
>   1 file changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/hash.h b/include/linux/hash.h
> index bd1754c..6a0879a 100644
> --- a/include/linux/hash.h
> +++ b/include/linux/hash.h
> @@ -19,9 +19,9 @@
>   #include <linux/compiler.h>
>
>   /* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
> -#define GOLDEN_RATIO_PRIME_32 0x9e370001UL
> +#define GOLDEN_RATIO_PRIME_32 0x9e370001U
>   /*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
> -#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL
> +#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001ULL
>
>   #if BITS_PER_LONG == 32
>   #define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_32
> @@ -35,22 +35,7 @@
>
>   static __always_inline u64 hash_64(u64 val, unsigned int bits)
>   {
> -	u64 hash = val;
> -
> -	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
> -	u64 n = hash;
> -	n <<= 18;
> -	hash -= n;
> -	n <<= 33;
> -	hash -= n;
> -	n <<= 3;
> -	hash += n;
> -	n <<= 3;
> -	hash -= n;
> -	n <<= 4;
> -	hash += n;
> -	n <<= 2;
> -	hash += n;
> +	u64 hash = val * GOLDEN_RATIO_PRIME_64;
>
>   	/* High bits are more random, so use them. */
>   	return hash >> (64 - bits);
>
