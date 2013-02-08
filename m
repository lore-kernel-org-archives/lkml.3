Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267Ab3BHSvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:51:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:52294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab3BHSvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:51:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,630,1355126400"; 
   d="s'?c'?scan'208";a="284665828"
Date: Fri, 8 Feb 2013 20:50:57 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kbuild test robot <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer from
 integer of different size
Message-ID: <20130208185057.GK9135@intel.com>
References: <51143ca4.bNX7TobZ2rDrz0zj%fengguang.wu@intel.com>
 <511460B7.4030007@linux.intel.com>
 <20130208152858.GU17833@n2100.arm.linux.org.uk>
 <511530AC.1070203@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <511530AC.1070203@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Feb 08, 2013 at 09:06:52AM -0800, H. Peter Anvin wrote:
> On 02/08/2013 07:28 AM, Russell King - ARM Linux wrote:
> > 
> > Whether that's safe for x86 or not, I don't know, but my suspicions are
> > that it's unsafe on x86 as it's possible to refer to the various bytes/
> > half-words of eax separately.
> > 
> > So, I came to the conclusion that if x86 remains a problem, there's
> > little point supporting it on ARM.
> > 
> 
> It is possible to access bytes separately, but gcc generally doesn't.
> However, whether or not that can be relied upon safely is a tricky question.
> 
> It *is* also worth nothing that the x86 ABI does allow two words to be
> returned in registers from a normal C function, simply by returning a
> structure.  That doesn't solve the problem at hand, though, which is how
> to make a type-neutral macro which can handle doublewords...

I just tried to compare a couple of options:

1)
	unsigned long __val_gu;
	unsigned long long __val_gu8;

2)
	register typeof(x) __val_gu asm("eax");

	I was still using a test app based on my orignal patch which
	used eax and edx for the value.

3)
	typeof(x) __val_gu;

While options 2 and 3 get rid of the warnings, they unfortunately
produce different results as well.

I've attached my test app in case you want to see it.

One other note is that if I include the memtest() call in the test,
option 1 and 2 produce the same results, but w/o the memtest() the
results differ. I didn't look into it any further.

-- 
Ville Syrjälä
Intel OTC

--zbGR4y+acU1DwHSi
Content-Type: text/x-asm; charset=us-ascii
Content-Disposition: attachment; filename="get_user.S"

#ifdef AMD64
#define _ASM_AX rax
#define _ASM_CX rcx
#define _ASM_DX rdx
#else
#define _ASM_AX eax
#define _ASM_CX ecx
#define _ASM_DX edx
#endif

.text
.globl __get_user_1
.globl __get_user_2
.globl __get_user_4
#ifdef AMD64
.globl __get_user_8
#else
.globl __get_user_8_32
#endif

__get_user_1:
	movzb (%_ASM_CX),%eax
	xor %ecx,%ecx
	ret

__get_user_2:
	add $1,%_ASM_CX
	movzwl -1(%_ASM_CX),%eax
	xor %ecx,%ecx
	ret

__get_user_4:
	add $3,%_ASM_CX
	mov -3(%_ASM_CX),%eax
	xor %ecx,%ecx
	ret

#ifdef AMD64
__get_user_8:
	add $7,%_ASM_CX
	movq -7(%_ASM_CX),%_ASM_AX
	xor %ecx,%ecx
	ret
#else
__get_user_8_32:
	add $7,%_ASM_CX
	movl -7(%_ASM_CX),%eax
	movl -3(%_ASM_CX),%edx
	xor %ecx,%ecx
	ret
#endif

--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Makefile

CFLAGS:=-std=gnu99 -O2

CPPFLAGS:=-DAMD64
#CFLAGS+=-m32
#ASFLAGS+=-m32

CPPFLAGS+=-Wint-to-pointer-cast

.PHONY: all clean

all: test

test: uaccess.o get_user.o
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm *.o

--zbGR4y+acU1DwHSi
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="uaccess.c"

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

#define OPT 1

#define __get_user_x(size, ret, x, ptr)				      \
	asm volatile("call __get_user_" #size			      \
		     : "=c" (ret), "=a" (x)			      \
		     : "0" (ptr))


#ifdef AMD64
#define __get_user_8(__ret_gu, __val_gu, ptr)                           \
	__get_user_x(8, __ret_gu, __val_gu, ptr)
#else
#define __get_user_8(ret, x, ptr)					\
	asm volatile("call __get_user_8_32"				\
		     : "=c" (ret), "=A" (x)				\
		     : "0" (ptr))
#endif

#if OPT == 1
#define get_user(x, ptr)						\
({									\
	int __ret_gu;							\
	unsigned long __val_gu;						\
	unsigned long long __val_gu8;					\
	switch (sizeof(*(ptr))) {					\
	case 1:                                                         \
		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 2:								\
		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 4:								\
		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 8:								\
		__get_user_8(__ret_gu, __val_gu8, ptr);			\
		break;							\
	default:							\
		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
		break;							\
	}								\
	if (sizeof(*(ptr)) == 8)					\
		(x) = (typeof(*(ptr)))__val_gu8;			\
	else								\
		(x) = (typeof(*(ptr)))__val_gu;				\
	__ret_gu;							\
})
#endif

#if OPT == 2
#define get_user(x, ptr)						\
({									\
	int __ret_gu;							\
	register typeof(x) __val_gu asm("eax");				\
	switch (sizeof(*(ptr))) {					\
	case 1:                                                         \
		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 2:								\
		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 4:								\
		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 8:								\
		__get_user_8(__ret_gu, __val_gu, ptr);			\
		break;							\
	default:							\
		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
		break;							\
	}								\
	(x) = (typeof(*(ptr)))__val_gu;					\
	__ret_gu;							\
})
#endif

#if OPT == 3
#define get_user(x, ptr)						\
({									\
	int __ret_gu;							\
	typeof(x) __val_gu;						\
	switch (sizeof(*(ptr))) {					\
	case 1:                                                         \
		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 2:								\
		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 4:								\
		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
		break;							\
	case 8:								\
		__get_user_8(__ret_gu, __val_gu, ptr);			\
		break;							\
	default:							\
		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
		break;							\
	}								\
	(x) = (typeof(*(ptr)))__val_gu;					\
	__ret_gu;							\
})
#endif

int main(void)
{
	uint64_t foo = 0x89abcdef76543210;

	printf(" foo: %"PRIx64"\n", foo);

	struct {
		uint8_t sika1;
		uint16_t sika2;
		uint32_t sika4;
		uint64_t sika8;
	} __attribute__((__packed__)) x;

	if (get_user(x.sika8, (const uint64_t*)&foo)) return 1;
	if (get_user(x.sika4, (const uint64_t*)&foo)) return 1;
	if (get_user(x.sika2, (const uint64_t*)&foo)) return 1;
	if (get_user(x.sika1, (const uint64_t*)&foo)) return 1;
	printf("sika8: %"PRIx64"\n", x.sika8);
	printf("sika4: %x\n", x.sika4);
	printf("sika2: %x\n", x.sika2);
	printf("sika1: %x\n", x.sika1);

	//memset(&x, 0, sizeof(x));

	if (get_user(x.sika1, (const uint64_t*)&foo)) return 1;
	if (get_user(x.sika2, (const uint64_t*)&foo)) return 1;
	if (get_user(x.sika4, (const uint64_t*)&foo)) return 1;
	if (get_user(x.sika8, (const uint64_t*)&foo)) return 1;
	printf("sika8: %"PRIx64"\n", x.sika8);
	printf("sika4: %x\n", x.sika4);
	printf("sika2: %x\n", x.sika2);
	printf("sika1: %x\n", x.sika1);

	return 0;
}

--zbGR4y+acU1DwHSi--
