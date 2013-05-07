Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab3EGQqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:46:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46963 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3EGQqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:46:51 -0400
Message-ID: <51892FF5.9020607@gmail.com>
Date: Wed, 08 May 2013 00:46:45 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: eunb.song@samsung.com
CC: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jogo@openwrt.org" <jogo@openwrt.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>
Subject: Re: MIPS : die at free_initmem() function 3.9+
References: <21534601.395241367793582818.JavaMail.weblogic@epv6ml08>
In-Reply-To: <21534601.395241367793582818.JavaMail.weblogic@epv6ml08>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eunsong,
	Thanks for your help. I have done some code inspection and have 
found a possible reason for this issue. It seems that virt_to_page()
can't be used to handle address in compatible segments due to following
definitions.

#define virt_to_page(kaddr)     pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
static inline unsigned long virt_to_phys(volatile const void *address)
{
        return (unsigned long)address - PAGE_OFFSET + PHYS_OFFSET;
}
#define __va(x)         ((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))
#define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
#define __pa(x)                                                         \
({                                                                      \
    unsigned long __x = (unsigned long)(x);                             \
    __x < CKSEG0 ? XPHYSADDR(__x) : CPHYSADDR(__x);                     \
})

#define CPHYSADDR(a)            ((_ACAST32_(a)) & 0x1fffffff)
#define XPHYSADDR(a)            ((_ACAST64_(a)) &                       \
                                 _CONST64_(0x000000ffffffffff))

#define XKUSEG                  _CONST64_(0x0000000000000000)
#define XKSSEG                  _CONST64_(0x4000000000000000)
#define XKPHYS                  _CONST64_(0x8000000000000000)
#define XKSEG                   _CONST64_(0xc000000000000000)
#define CKSEG0                  _CONST64_(0xffffffff80000000)
#define CKSEG1                  _CONST64_(0xffffffffa0000000)
#define CKSSEG                  _CONST64_(0xffffffffc0000000)
#define CKSEG3                  _CONST64_(0xffffffffe0000000)

So could you please help to prepare a formal patch for this bug and send
it to Andrew Morton for v3.10-rc1? Otherwise I could help to it too.

Regards!
Gerry


=On 05/06/2013 06:39 AM, EUNBONG SONG wrote:
> 
>> So on 64bits MIPS platforms, __va(__pa(x)) may not equal to x, that may cause
>> trouble to free_initmem_default(). Could you please help to do another test
>> by changing
>> free_initmem_default(POISON_FREE_INITMEM);
>> to
>> free_initmem_default(0);
> 
>> This test could help to identify whether this panic is caused by
>> memset((void *)pos, poison, PAGE_SIZE);
>> in function free_reserved_area().
> 
> Hello, as you said i changed  "free_initmem_default(POISON_FREE_INITMEM);" to
> "free_initmem_default(0);". Panic still occurred. 
> Actually, i put the some debug messages. and i confirmed panic occurs in __free_reserved_page() function.
> Thanks!
> 
> N떑꿩�r툤y鉉싕b쾊Ф푤v�^�)頻{.n�+돴쪐{콗喩zX㎍썳變}찠꼿쟺�&j:+v돣�쳭喩zZ+�+zf＂톒쉱�~넮녬i�鎬z�췿ⅱ�?솳鈺�&�)刪f뷌^j푹y쬶끷@A첺뛴��0띠h��i�
> 

