Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaBXKWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:22:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaBXKWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:22:49 -0500
Message-ID: <530B1D60.8010602@redhat.com>
Date: Mon, 24 Feb 2014 11:22:24 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, ffusco@redhat.com,
        tgraf@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com> <5308938A.8070506@redhat.com> <530B0AF2020000780011E97B@nat28.tlf.novell.com>
In-Reply-To: <530B0AF2020000780011E97B@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:03 AM, Jan Beulich wrote:
>>>> On 22.02.14 at 13:09, Daniel Borkmann <dborkman@redhat.com> wrote:
>> On 02/21/2014 11:33 AM, Jan Beulich wrote:
>>> ... to match its two callers (i.e. the alternative would have been to
>>> swap the arguments at the call sites).
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>> Cc: Francesco Fusco <ffusco@redhat.com>
>>> Cc: Daniel Borkmann <dborkman@redhat.com>
>>> Cc: Thomas Graf <tgraf@redhat.com>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> ---
>>>    arch/x86/lib/hash.c |    2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
>>> +++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
>>> @@ -37,7 +37,7 @@
>>>    #include <asm/cpufeature.h>
>>>    #include <asm/hash.h>
>>>
>>> -static inline u32 crc32_u32(u32 crc, u32 val)
>>> +static inline u32 crc32_u32(u32 val, u32 crc)
>>>    {
>>>    #ifdef CONFIG_AS_CRC32
>>>    	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
>>
>> Can you elaborate?
>>
>> Sorry, I need to ask here (even if it's a stupid question ;)) if this
>> change is safe to do; are referring to a cleanup or fixing a concrete
>> bug? The code is a modified version of the DPDK hash which you can find
>> in [1]. Arguments of the caller are in the correct order, afaik.
>>
>>     [1] http://dpdk.org/browse/dpdk/tree/lib/librte_hash/rte_hash_crc.h
>
> Yes, that file appears to be correct:
>
> rte_hash_crc_4byte(uint32_t data, uint32_t init_val)
>
> as opposed to
>
> static inline u32 crc32_u32(u32 crc, u32 val)
>
> (quite obviously data <-> val and crc <-> init_val, supported
> by the second argument in each caller being named "seed").

If you want a more descriptive name, feel free to rename these vars,
but check it yourself, it's not a bug as you claim; results are the
same:

/* gcc -march=corei7 -Wall -O2 intel_crc.c -lgsl
  * ./a.out
  * Result: good:10000 bad:0
  */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <nmmintrin.h>
#include <gsl/gsl_rng.h>

/* Kernel code */
static inline uint32_t crc32_u32(uint32_t crc, uint32_t val)
{
	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
	return crc;
}

static uint32_t intel_crc4_2_hash(const void *data, uint32_t len, uint32_t seed)
{
	const uint32_t *p32 = (const uint32_t *) data;
	uint32_t i;

	for (i = 0; i < len / 4; i++)
		seed = crc32_u32(*p32++, seed);

	return seed;
}

/* DPDK code */
static inline uint32_t rte_hash_crc_4byte(uint32_t data, uint32_t init_val)
{
	return _mm_crc32_u32(data, init_val);
}

static inline uint32_t rte_hash_crc(const void *data, uint32_t data_len,
				    uint32_t init_val)
{
	const uint32_t *p32 = (const uint32_t *) data;
	unsigned i;

	for (i = 0; i < data_len / 4; i++)
		init_val = rte_hash_crc_4byte(*p32++, init_val);

	return init_val;
}

/* Test case */
static void fill_foo(gsl_rng *rng, void *foo, size_t len)
{
	uint32_t *foo_32 = foo;
	int i;

	for (i = 0; i < len; i += sizeof(uint32_t))
		foo_32[i] = gsl_rng_get(rng);
}

int main(void)
{
	int i, good = 0, bad = 0;
	gsl_rng *rng;

	srand(time(NULL));
	gsl_rng_default_seed = rand();
	rng = gsl_rng_alloc(gsl_rng_taus113);
	if (rng == NULL)
		return -1;

	for (i = 0; i < 10000; i++) {
		char foo[sizeof(uint32_t) * 128];
		uint32_t val1, val2, seed = gsl_rng_get(rng);

		fill_foo(rng, foo, sizeof(foo));

		val1 = rte_hash_crc(foo, sizeof(foo), seed);
		val2 = intel_crc4_2_hash(foo, sizeof(foo), seed);

		if (val1 != val2)
			bad++;
		else
			good++;
	}

	gsl_rng_free(rng);
	printf("Result: good:%d bad:%d\n", good, bad);

	return 0;
}
