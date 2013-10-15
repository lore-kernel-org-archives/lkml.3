Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3JOHrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:47:09 -0400
Received: from odin2.bull.net ([129.184.85.11]:37878 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3JOHrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:47:08 -0400
X-Greylist: delayed 2053 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 03:47:07 EDT
Date: Tue, 15 Oct 2013 09:12:51 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Neil Horman <nhorman@tuxdriver.com>
CC: Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple
 alu's
Message-ID: <20131015091251.2345b918@b012350-ux>
In-Reply-To: <20131014202528.GG26880@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	<87siw4xy9i.fsf@tassilo.jf.intel.com>
	<20131014202528.GG26880@hmsreliant.think-freely.org>
Organization: BULL
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.192.1.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Neil, Andi,

On Mon, 14 Oct 2013 16:25:28 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Sun, Oct 13, 2013 at 09:38:33PM -0700, Andi Kleen wrote:
> > Neil Horman <nhorman@tuxdriver.com> writes:
> > 
> > > Sébastien Dugué reported to me that devices implementing ipoib (which don't have
> > > checksum offload hardware were spending a significant amount of time computing
> > 
> > Must be an odd workload, most TCP/UDP workloads do copy-checksum
> > anyways. I would rather investigate why that doesn't work.
> > 
> FWIW, the reporter was reporting this using an IP over Infiniband network.
> Neil

  indeed, our typical workload is connected mode IPoIB on mlx4 QDR hardware
where one cannot benefit from hardware offloads.

  For a bit of background on the issue:

  It all started nearly 3 years ago when trying to understand why IPoIB BW was
so low in our setups and why ksoftirqd used 100% of one CPU. A kernel profile
trace showed that the CPU spent most of it's time in checksum computation (from
the only old trace I managed to unearth):

  Function                               Hit    Time            Avg
  --------                               ---    ----            ---
  schedule                              1730    629976998 us     364148.5 us
  csum_partial                      10813465    20944414 us     1.936 us
  mwait_idle_with_hints                 1451    9858861 us     6794.529 us
  get_page_from_freelist            10110434    8120524 us     0.803 us
  alloc_pages_current               10093675    5180650 us     0.513 us
  __phys_addr                       35554783    4471387 us     0.125 us
  zone_statistics                   10110434    4360871 us     0.431 us
  ipoib_cm_alloc_rx_skb               673899    4343949 us     6.445 us

  After having recoded the checksum to use 2 ALUs, csum_partial() disappeared
from the tracer radar. IPoIB BW got from ~12Gb/s to ~ 20Gb/s and ksoftirqd load
dropped down drastically. Sorry, I could not manage to locate my old traces and
results, those seem to have been lost in the mist of time.

  I did some micro benchmark (dirty hack code below) of different solutions.
It looks like processing 128-byte blocks in 4 chains allows the best performance,
but there are plenty other possibilities.

  FWIW, this code has been running as is at our customers sites for 3 years now.

  Sébastien.

> 
> > That said the change looks reasonable, but may not fix the root cause.
> > 
> > -Andi
> > 
> > -- 
> > ak@linux.intel.com -- Speaking for myself only
> > 

8<----------------------------------------------------------------------


/*
 * gcc -Wall -O3 -o csum_test csum_test.c -lrt
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <string.h>
#include <errno.h>

#define __force
#define unlikely(x)	(x)

typedef uint32_t u32;
typedef uint16_t u16;

typedef u16 __sum16;
typedef u32 __wsum;

#define NUM_LOOPS	100000
#define BUF_LEN		65536
unsigned char buf[BUF_LEN];


/*
 * csum_fold - Fold and invert a 32bit checksum.
 * sum: 32bit unfolded sum
 *
 * Fold a 32bit running checksum to 16bit and invert it. This is usually
 * the last step before putting a checksum into a packet.
 * Make sure not to mix with 64bit checksums.
 */
static inline __sum16 csum_fold(__wsum sum)
{
	asm("  addl %1,%0\n"
	    "  adcl $0xffff,%0"
	    : "=r" (sum)
	    : "r" ((__force u32)sum << 16),
	      "0" ((__force u32)sum & 0xffff0000));
	return (__force __sum16)(~(__force u32)sum >> 16);
}

static inline unsigned short from32to16(unsigned a)
{
	unsigned short b = a >> 16;
	asm("addw %w2,%w0\n\t"
	    "adcw $0,%w0\n"
	    : "=r" (b)
	    : "0" (b), "r" (a));
	return b;
}

static inline unsigned add32_with_carry(unsigned a, unsigned b)
{
	asm("addl %2,%0\n\t"
	    "adcl $0,%0"
	    : "=r" (a)
	    : "0" (a), "r" (b));
	return a;
}

/*
 * Do a 64-bit checksum on an arbitrary memory area.
 * Returns a 32bit checksum.
 *
 * This isn't as time critical as it used to be because many NICs
 * do hardware checksumming these days.
 *
 * Things tried and found to not make it faster:
 * Manual Prefetching
 * Unrolling to an 128 bytes inner loop.
 * Using interleaving with more registers to break the carry chains.
 */
static unsigned do_csum(const unsigned char *buff, unsigned len)
{
	unsigned odd, count;
	unsigned long result = 0;

	if (unlikely(len == 0))
		return result;
	odd = 1 & (unsigned long) buff;
	if (unlikely(odd)) {
		result = *buff << 8;
		len--;
		buff++;
	}
	count = len >> 1;		/* nr of 16-bit words.. */
	if (count) {
		if (2 & (unsigned long) buff) {
			result += *(unsigned short *)buff;
			count--;
			len -= 2;
			buff += 2;
		}
		count >>= 1;		/* nr of 32-bit words.. */
		if (count) {
			unsigned long zero;
			unsigned count64;
			if (4 & (unsigned long) buff) {
				result += *(unsigned int *) buff;
				count--;
				len -= 4;
				buff += 4;
			}
			count >>= 1;	/* nr of 64-bit words.. */

			/* main loop using 64byte blocks */
			zero = 0;
			count64 = count >> 3;
			while (count64) {
				asm("addq 0*8(%[src]),%[res]\n\t"
				    "adcq 1*8(%[src]),%[res]\n\t"
				    "adcq 2*8(%[src]),%[res]\n\t"
				    "adcq 3*8(%[src]),%[res]\n\t"
				    "adcq 4*8(%[src]),%[res]\n\t"
				    "adcq 5*8(%[src]),%[res]\n\t"
				    "adcq 6*8(%[src]),%[res]\n\t"
				    "adcq 7*8(%[src]),%[res]\n\t"
				    "adcq %[zero],%[res]"
				    : [res] "=r" (result)
				    : [src] "r" (buff), [zero] "r" (zero),
				    "[res]" (result));
				buff += 64;
				count64--;
			}
			/* printf("csum %lx\n", result); */

			/* last upto 7 8byte blocks */
			count %= 8;
			while (count) {
				asm("addq %1,%0\n\t"
				    "adcq %2,%0\n"
					    : "=r" (result)
				    : "m" (*(unsigned long *)buff),
				    "r" (zero),  "0" (result));
				--count;
				buff += 8;
			}
			result = add32_with_carry(result>>32,
						  result&0xffffffff);

			if (len & 4) {
				result += *(unsigned int *) buff;
				buff += 4;
			}
		}
		if (len & 2) {
			result += *(unsigned short *) buff;
			buff += 2;
		}
	}
	if (len & 1)
		result += *buff;
	result = add32_with_carry(result>>32, result & 0xffffffff);
	if (unlikely(odd)) {
		result = from32to16(result);
		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
	}
	return result;
}

static unsigned do_csum1(const unsigned char *buff, unsigned len)
{
	unsigned odd, count;
	unsigned long result1 = 0;
	unsigned long result2 = 0;
	unsigned long result = 0;

	if (unlikely(len == 0))
		return result;
	odd = 1 & (unsigned long) buff;
	if (unlikely(odd)) {
		result = *buff << 8;
		len--;
		buff++;
	}
	count = len >> 1;		/* nr of 16-bit words.. */
	if (count) {
		if (2 & (unsigned long) buff) {
			result += *(unsigned short *)buff;
			count--;
			len -= 2;
			buff += 2;
		}
		count >>= 1;		/* nr of 32-bit words.. */
		if (count) {
			unsigned long zero;
			unsigned count64;
			if (4 & (unsigned long) buff) {
				result += *(unsigned int *) buff;
				count--;
				len -= 4;
				buff += 4;
			}
			count >>= 1;	/* nr of 64-bit words.. */

			/* main loop using 64byte blocks */
			zero = 0;
			count64 = count >> 3;
			while (count64) {
				asm("addq 0*8(%[src]),%[res1]\n\t"
				    "adcq 2*8(%[src]),%[res1]\n\t"
				    "adcq 4*8(%[src]),%[res1]\n\t"
				    "adcq 6*8(%[src]),%[res1]\n\t"
				    "adcq %[zero],%[res1]\n\t"

				    "addq 1*8(%[src]),%[res2]\n\t"
				    "adcq 3*8(%[src]),%[res2]\n\t"
				    "adcq 5*8(%[src]),%[res2]\n\t"
				    "adcq 7*8(%[src]),%[res2]\n\t"
				    "adcq %[zero],%[res2]"
				    : [res1] "=r" (result1),
				      [res2] "=r" (result2)
				    : [src] "r" (buff), [zero] "r" (zero),
				      "[res1]" (result1), "[res2]" (result2));
				buff += 64;
				count64--;
			}

			asm("addq %[res1],%[res]\n\t"
			    "adcq %[res2],%[res]\n\t"
			    "adcq %[zero],%[res]"
			    : [res] "=r" (result)
			    : [res1] "r" (result1),
			      [res2] "r" (result2),
			      [zero] "r" (zero),
			      "0" (result));

			/* last upto 7 8byte blocks */
			count %= 8;
			while (count) {
				asm("addq %1,%0\n\t"
				    "adcq %2,%0\n"
					    : "=r" (result)
				    : "m" (*(unsigned long *)buff),
				    "r" (zero),  "0" (result));
				--count;
				buff += 8;
			}
			result = add32_with_carry(result>>32,
						  result&0xffffffff);

			if (len & 4) {
				result += *(unsigned int *) buff;
				buff += 4;
			}
		}
		if (len & 2) {
			result += *(unsigned short *) buff;
			buff += 2;
		}
	}
	if (len & 1)
		result += *buff;
	result = add32_with_carry(result>>32, result & 0xffffffff);
	if (unlikely(odd)) {
		result = from32to16(result);
		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
	}
	return result;
}

static unsigned do_csum2(const unsigned char *buff, unsigned len)
{
	unsigned odd, count;
	unsigned long result1 = 0;
	unsigned long result2 = 0;
	unsigned long result3 = 0;
	unsigned long result4 = 0;
	unsigned long result = 0;

	if (unlikely(len == 0))
		return result;

	odd = 1 & (unsigned long) buff;

	if (unlikely(odd)) {
		result = *buff << 8;
		len--;
		buff++;
	}

	count = len >> 1;		/* nr of 16-bit words.. */

	if (count) {
		if (2 & (unsigned long) buff) {
			result += *(unsigned short *)buff;
			count--;
			len -= 2;
			buff += 2;
		}

		count >>= 1;		/* nr of 32-bit words.. */

		if (count) {

			if (4 & (unsigned long) buff) {
				result += *(unsigned int *) buff;
				count--;
				len -= 4;
				buff += 4;
			}

			count >>= 1;	/* nr of 64-bit words.. */

			if (count) {
				unsigned long zero = 0;
				unsigned count128;

				if (8 & (unsigned long) buff) {
					asm("addq %1,%0\n\t"
					    "adcq %2,%0\n"
					    : "=r" (result)
					    : "m" (*(unsigned long *)buff),
					      "r" (zero),  "0" (result));
					count--;
					buff += 8;
				}

				/* main loop using 128 byte blocks */
				count128 = count >> 4;

				while (count128) {
					asm("addq 0*8(%[src]),%[res1]\n\t"
					    "adcq 4*8(%[src]),%[res1]\n\t"
					    "adcq 8*8(%[src]),%[res1]\n\t"
					    "adcq 12*8(%[src]),%[res1]\n\t"
					    "adcq %[zero],%[res1]\n\t"

					    "addq 1*8(%[src]),%[res2]\n\t"
					    "adcq 5*8(%[src]),%[res2]\n\t"
					    "adcq 9*8(%[src]),%[res2]\n\t"
					    "adcq 13*8(%[src]),%[res2]\n\t"
					    "adcq %[zero],%[res2]\n\t"

					    "addq 2*8(%[src]),%[res3]\n\t"
					    "adcq 6*8(%[src]),%[res3]\n\t"
					    "adcq 10*8(%[src]),%[res3]\n\t"
					    "adcq 14*8(%[src]),%[res3]\n\t"
					    "adcq %[zero],%[res3]\n\t"

					    "addq 3*8(%[src]),%[res4]\n\t"
					    "adcq 7*8(%[src]),%[res4]\n\t"
					    "adcq 11*8(%[src]),%[res4]\n\t"
					    "adcq 15*8(%[src]),%[res4]\n\t"
					    "adcq %[zero],%[res4]"

					    : [res1] "=r" (result1),
					      [res2] "=r" (result2),
					      [res3] "=r" (result3),
					      [res4] "=r" (result4)

					    : [src] "r" (buff),
					      [zero] "r" (zero),
					      "[res1]" (result1),
					      "[res2]" (result2),
					      "[res3]" (result3),
					      "[res4]" (result4));
					buff += 128;
					count128--;
				}

				asm("addq %[res1],%[res]\n\t"
				    "adcq %[res2],%[res]\n\t"
				    "adcq %[res3],%[res]\n\t"
				    "adcq %[res4],%[res]\n\t"
				    "adcq %[zero],%[res]"
				    : [res] "=r" (result)
				    : [res1] "r" (result1),
				      [res2] "r" (result2),
				      [res3] "r" (result3),
				      [res4] "r" (result4),
				      [zero] "r" (zero),
				      "0" (result));

				/* last upto 15 8byte blocks */
				count %= 16;
				while (count) {
					asm("addq %1,%0\n\t"
					    "adcq %2,%0\n"
					    : "=r" (result)
					    : "m" (*(unsigned long *)buff),
					      "r" (zero),  "0" (result));
					--count;
					buff += 8;
				}
				result = add32_with_carry(result>>32,
							  result&0xffffffff);

				if (len & 8) {
					asm("addq %1,%0\n\t"
					    "adcq %2,%0\n"
					    : "=r" (result)
					    : "m" (*(unsigned long *)buff),
					      "r" (zero),  "0" (result));
					buff += 8;
				}
			}

			if (len & 4) {
				result += *(unsigned int *) buff;
				buff += 4;
			}
		}
		if (len & 2) {
			result += *(unsigned short *) buff;
			buff += 2;
		}
	}
	if (len & 1)
		result += *buff;
	result = add32_with_carry(result>>32, result & 0xffffffff);
	if (unlikely(odd)) {
		result = from32to16(result);
		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
	}
	return result;
}


static unsigned do_csum3(const unsigned char *buff, unsigned len)
{
	unsigned odd, count;
	unsigned long result1 = 0;
	unsigned long result2 = 0;
	unsigned long result3 = 0;
	unsigned long result4 = 0;
	unsigned long result = 0;

	if (unlikely(len == 0))
		return result;
	odd = 1 & (unsigned long) buff;
	if (unlikely(odd)) {
		result = *buff << 8;
		len--;
		buff++;
	}
	count = len >> 1;		/* nr of 16-bit words.. */
	if (count) {
		if (2 & (unsigned long) buff) {
			result += *(unsigned short *)buff;
			count--;
			len -= 2;
			buff += 2;
		}
		count >>= 1;		/* nr of 32-bit words.. */
		if (count) {
			unsigned long zero;
			unsigned count64;
			if (4 & (unsigned long) buff) {
				result += *(unsigned int *) buff;
				count--;
				len -= 4;
				buff += 4;
			}
			count >>= 1;	/* nr of 64-bit words.. */

			/* main loop using 64byte blocks */
			zero = 0;
			count64 = count >> 3;
			while (count64) {
				asm("addq 0*8(%[src]),%[res1]\n\t"
				    "adcq 4*8(%[src]),%[res1]\n\t"
				    "adcq %[zero],%[res1]\n\t"

				    "addq 1*8(%[src]),%[res2]\n\t"
				    "adcq 5*8(%[src]),%[res2]\n\t"
				    "adcq %[zero],%[res2]\n\t"

				    "addq 2*8(%[src]),%[res3]\n\t"
				    "adcq 6*8(%[src]),%[res3]\n\t"
				    "adcq %[zero],%[res3]\n\t"

				    "addq 3*8(%[src]),%[res4]\n\t"
				    "adcq 7*8(%[src]),%[res4]\n\t"
				    "adcq %[zero],%[res4]\n\t"

				    : [res1] "=r" (result1),
				      [res2] "=r" (result2),
				      [res3] "=r" (result3),
				      [res4] "=r" (result4)
				    : [src] "r" (buff),
				      [zero] "r" (zero),
				      "[res1]" (result1),
				      "[res2]" (result2),
				      "[res3]" (result3),
				      "[res4]" (result4));
				buff += 64;
				count64--;
			}

			asm("addq %[res1],%[res]\n\t"
			    "adcq %[res2],%[res]\n\t"
			    "adcq %[res3],%[res]\n\t"
			    "adcq %[res4],%[res]\n\t"
			    "adcq %[zero],%[res]"
			    : [res] "=r" (result)
			    : [res1] "r" (result1),
			      [res2] "r" (result2),
			      [res3] "r" (result3),
			      [res4] "r" (result4),
			      [zero] "r" (zero),
			      "0" (result));

			/* printf("csum1 %lx\n", result); */

			/* last upto 7 8byte blocks */
			count %= 8;
			while (count) {
				asm("addq %1,%0\n\t"
				    "adcq %2,%0\n"
					    : "=r" (result)
				    : "m" (*(unsigned long *)buff),
				    "r" (zero),  "0" (result));
				--count;
				buff += 8;
			}
			result = add32_with_carry(result>>32,
						  result&0xffffffff);

			if (len & 4) {
				result += *(unsigned int *) buff;
				buff += 4;
			}
		}
		if (len & 2) {
			result += *(unsigned short *) buff;
			buff += 2;
		}
	}
	if (len & 1)
		result += *buff;
	result = add32_with_carry(result>>32, result & 0xffffffff);
	if (unlikely(odd)) {
		result = from32to16(result);
		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
	}
	return result;
}

long long delta_ns(struct timespec *t1, struct timespec *t2)
{
	long long tt1, tt2, delta;

	tt1 = t1->tv_sec * 1000000000 + t1->tv_nsec;
	tt2 = t2->tv_sec * 1000000000 + t2->tv_nsec;
	delta = tt2 - tt1;

	return delta;
}

int main(int argc, char **argv)
{
	FILE *f;
	unsigned csum1, csum2, csum3, csum4;
	struct timespec t1;
	struct timespec t2;
	double delta;
	int i;
	unsigned int offset = 0;
	unsigned char *ptr;
	unsigned int size;

	if ((f = fopen("data.bin", "r")) == NULL) {
		printf("Failed to open input file data.bin: %s\n",
		       strerror(errno));
		return -1;
	}

	if (fread(buf, 1, BUF_LEN, f) != BUF_LEN) {
		printf("Failed to read data.bin: %s\n",
		       strerror(errno));
		fclose(f);
		return -1;
	}

	fclose(f);

	if (argc > 1)
		offset = atoi(argv[1]);

	printf("Using offset=%d\n", offset);

	ptr = &buf[offset];
	size = BUF_LEN - offset;

	clock_gettime(CLOCK_MONOTONIC, &t1);

	for (i = 0; i < NUM_LOOPS; i++)
		csum1 = do_csum((const unsigned char *)ptr, size);

	clock_gettime(CLOCK_MONOTONIC, &t2);
	delta = (double)delta_ns(&t1, &t2)/1000.0;
	printf("Original:    %.8x %f us\n",
	       csum1, (double)delta/(double)NUM_LOOPS);

	clock_gettime(CLOCK_MONOTONIC, &t1);

	for (i = 0; i < NUM_LOOPS; i++)
		csum2 = do_csum1((const unsigned char *)ptr, size);

	clock_gettime(CLOCK_MONOTONIC, &t2);
	delta = (double)delta_ns(&t1, &t2)/1000.0;
	printf("64B Split2:  %.8x %f us\n",
	       csum2, (double)delta/(double)NUM_LOOPS);


	clock_gettime(CLOCK_MONOTONIC, &t1);

	for (i = 0; i < NUM_LOOPS; i++)
		csum3 = do_csum2((const unsigned char *)ptr, size);

	clock_gettime(CLOCK_MONOTONIC, &t2);
	delta = (double)delta_ns(&t1, &t2)/1000.0;
	printf("128B Split4: %.8x %f us\n",
	       csum3, (double)delta/(double)NUM_LOOPS);

	clock_gettime(CLOCK_MONOTONIC, &t1);

	for (i = 0; i < NUM_LOOPS; i++)
		csum4 = do_csum3((const unsigned char *)ptr, size);

	clock_gettime(CLOCK_MONOTONIC, &t2);
	delta = (double)delta_ns(&t1, &t2)/1000.0;
	printf("64B Split4:  %.8x %f us\n",
	       csum4, (double)delta/(double)NUM_LOOPS);

	if ((csum1 != csum2) || (csum1 != csum3) || (csum1 != csum4))
		printf("Wrong checksum\n");

	return 0;
}


