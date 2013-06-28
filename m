Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3F1CUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 22:20:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6885 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F1CU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 22:20:28 -0400
X-Spam-Score: -100.8
Message-ID: <51CCF2B6.3030707@asianux.com>
Date: Fri, 28 Jun 2013 10:19:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m32r: include: asm: add ioread*_rep() and iowrite*_rep()
References: <51CBA43F.9050000@asianux.com> <51CBC186.3080401@asianux.com> <CAMuHMdVCv=MOJ8C4U=QHntQKZ=rThoKvXorgcR6jFRCA8hLULQ@mail.gmail.com> <3279444.s8HediXDkj@wuerfel>
In-Reply-To: <3279444.s8HediXDkj@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 04:25 PM, Arnd Bergmann wrote:
> On Thursday 27 June 2013 09:07:29 Geert Uytterhoeven wrote:
>> > On Thu, Jun 27, 2013 at 6:37 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> > > --- a/arch/m32r/include/asm/io.h
>>> > > +++ b/arch/m32r/include/asm/io.h
>>> > > @@ -169,6 +169,20 @@ static inline void _writel(unsigned long l, unsigned long addr)
>>> > >  #define iowrite16 writew
>>> > >  #define iowrite32 writel
>>> > >
>>> > > +#define ioread8_rep(p, dst, count) \
>>> > > +       insb((unsigned long) (p), (dst), (count))
>> > 
>> > As ioread8() is mapped to readb() (I/O memory space), not inb() (I/O
>> > port space),
>> > ioread8_rep() should map to readsb() (which m32r doesn't have yet
>> > BTW), not insb().
>> > For m32r this does matter, as inb() and readb() use different mechanisms
>> > internally.
>> > 
>> > It seems include/asm-generic/io.h also has this wrong?
> Yes, you are right. I thought we had fixed that long ago.
> 
> Does the patch below look ok to you? Note that none of the architectures
> using asm-generic/io.h supports PIO access and it works by chance
> this way, but we should definitely fix it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 

Is it better to let the code block (from "#ifndef CONFIG_GENERIC_IOMAP
to #endif) in an individual file (e.g. iomap_inline.h)?

So that many architectures (m32r, tile, ...) can include the individual
file to get these necessary code, and not need consider the confilict
about the other code in generic io.h ?

Thanks.

> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index d5afe96..8af7a64 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -161,108 +161,108 @@ static inline void outl(u32 b, unsigned long addr)
>  #define outw_p(x, addr)	outw((x), (addr))
>  #define outl_p(x, addr)	outl((x), (addr))
>  
> -#ifndef insb
> -static inline void insb(unsigned long addr, void *buffer, int count)
> +#ifndef CONFIG_GENERIC_IOMAP
> +#define ioread8(addr)		readb(addr)
> +#define ioread16(addr)		readw(addr)
> +#define ioread16be(addr)	__be16_to_cpu(__raw_readw(addr))
> +#define ioread32(addr)		readl(addr)
> +#define ioread32be(addr)	__be32_to_cpu(__raw_readl(addr))
> +
> +#define iowrite8(v, addr)	writeb((v), (addr))
> +#define iowrite16(v, addr)	writew((v), (addr))
> +#define iowrite16be(v, addr)	__raw_writew(__cpu_to_be16(v), addr)
> +#define iowrite32(v, addr)	writel((v), (addr))
> +#define iowrite32be(v, addr)	__raw_writel(__cpu_to_be32(v), addr)
> +
> +static inline void ioread8_rep(void __iomem *addr, void *buffer, int count)
>  {
>  	if (count) {
>  		u8 *buf = buffer;
>  		do {
> -			u8 x = __raw_readb(addr + PCI_IOBASE);
> +			u8 x = __raw_readb(addr);
>  			*buf++ = x;
>  		} while (--count);
>  	}
>  }
> -#endif
>  
> -#ifndef insw
> -static inline void insw(unsigned long addr, void *buffer, int count)
> +static inline void ioread16_rep(void __iomem *addr, void *buffer, int count)
>  {
>  	if (count) {
>  		u16 *buf = buffer;
>  		do {
> -			u16 x = __raw_readw(addr + PCI_IOBASE);
> +			u16 x = __raw_readw(addr);
>  			*buf++ = x;
>  		} while (--count);
>  	}
>  }
> -#endif
>  
> -#ifndef insl
> -static inline void insl(unsigned long addr, void *buffer, int count)
> +static inline void ioread32_rep(void __iomem *addr, void *buffer, int count)
>  {
>  	if (count) {
>  		u32 *buf = buffer;
>  		do {
> -			u32 x = __raw_readl(addr + PCI_IOBASE);
> +			u32 x = __raw_readl(addr);
>  			*buf++ = x;
>  		} while (--count);
>  	}
>  }
> -#endif
>  
> -#ifndef outsb
> -static inline void outsb(unsigned long addr, const void *buffer, int count)
> +static inline void iowrite8_rep(void __iomem *addr, const void *buffer, int count)
>  {
>  	if (count) {
>  		const u8 *buf = buffer;
>  		do {
> -			__raw_writeb(*buf++, addr + PCI_IOBASE);
> +			__raw_writeb(*buf++, addr);
>  		} while (--count);
>  	}
>  }
> -#endif
>  
> -#ifndef outsw
> -static inline void outsw(unsigned long addr, const void *buffer, int count)
> +static inline void iowrite16_rep(void __iomem *addr, const void *buffer, int count)
>  {
>  	if (count) {
>  		const u16 *buf = buffer;
>  		do {
> -			__raw_writew(*buf++, addr + PCI_IOBASE);
> +			__raw_writew(*buf++, addr);
>  		} while (--count);
>  	}
>  }
> -#endif
>  
> -#ifndef outsl
> -static inline void outsl(unsigned long addr, const void *buffer, int count)
> +static inline void iowrite32_rep(void __iomem *addr, const void *buffer, int count)
>  {
>  	if (count) {
>  		const u32 *buf = buffer;
>  		do {
> -			__raw_writel(*buf++, addr + PCI_IOBASE);
> +			__raw_writel(*buf++, addr);
>  		} while (--count);
>  	}
>  }
> -#endif
> -
> -#ifndef CONFIG_GENERIC_IOMAP
> -#define ioread8(addr)		readb(addr)
> -#define ioread16(addr)		readw(addr)
> -#define ioread16be(addr)	__be16_to_cpu(__raw_readw(addr))
> -#define ioread32(addr)		readl(addr)
> -#define ioread32be(addr)	__be32_to_cpu(__raw_readl(addr))
> +#endif /* CONFIG_GENERIC_IOMAP */
>  
> -#define iowrite8(v, addr)	writeb((v), (addr))
> -#define iowrite16(v, addr)	writew((v), (addr))
> -#define iowrite16be(v, addr)	__raw_writew(__cpu_to_be16(v), addr)
> -#define iowrite32(v, addr)	writel((v), (addr))
> -#define iowrite32be(v, addr)	__raw_writel(__cpu_to_be32(v), addr)
> +#ifndef insb
> +#define insb(a, dst, count) \
> +	ioread8_rep((a) + PCI_IOBASE, (dst), (count))
> +#endif
> +#ifndef insw
> +#define insw(a, dst, count) \
> +	ioread16_rep((a) + PCI_IOBASE, (dst), (count))
> +#endif
> +#ifndef insl
> +#define insl(a, dst, count) \
> +	ioread32_rep((a) + PCI_IOBASE, (dst), (count))
> +#endif
>  
> -#define ioread8_rep(p, dst, count) \
> -	insb((unsigned long) (p), (dst), (count))
> -#define ioread16_rep(p, dst, count) \
> -	insw((unsigned long) (p), (dst), (count))
> -#define ioread32_rep(p, dst, count) \
> -	insl((unsigned long) (p), (dst), (count))
> -
> -#define iowrite8_rep(p, src, count) \
> -	outsb((unsigned long) (p), (src), (count))
> -#define iowrite16_rep(p, src, count) \
> -	outsw((unsigned long) (p), (src), (count))
> -#define iowrite32_rep(p, src, count) \
> -	outsl((unsigned long) (p), (src), (count))
> -#endif /* CONFIG_GENERIC_IOMAP */
> +#ifndef outsb
> +#define outsb(a, src, count) \
> +	iowrite8_rep((a) + PCI_IOBASE, (src), (count))
> +#endif
> +#ifndef outsw
> +#define outsw(a, src, count) \
> +	iowrite16_rep((a) + PCI_IOBASE, (src), (count))
> +#endif
> +#ifndef outsl
> +#define outsl(a, src, count) \
> +	iowrite32_rep((a) + PCI_IOBASE, (src), (count))
> +#endif
>  
>  #ifndef IO_SPACE_LIMIT
>  #define IO_SPACE_LIMIT 0xffff


-- 
Chen Gang
