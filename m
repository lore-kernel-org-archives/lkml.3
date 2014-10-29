Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaJ2HAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:00:15 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50537 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbaJ2HAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:00:12 -0400
MIME-Version: 1.0
In-Reply-To: <3089586.phhm8NvmXk@wuerfel>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<1414139071-3818-8-git-send-email-lftan@altera.com>
	<3089586.phhm8NvmXk@wuerfel>
Date: Wed, 29 Oct 2014 15:00:09 +0800
X-Google-Sender-Auth: 6Rmqp4A0iAq4ORpPZoe-r6iY4Mo
Message-ID: <CAFiDJ586rgsSYzTvKsn4SSTQ9PJ3u3AQ-op28BgUy-D7BYbStw@mail.gmail.com>
Subject: Re: [PATCH v5 07/29] nios2: I/O Mapping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 24 October 2014 16:24:09 Ley Foon Tan wrote:
>
>> +/* PCI is not supported in nios2, set this to 0. */
>> +#define IO_SPACE_LIMIT 0
>> +
>> +extern void outsb(unsigned long addr, const void *buf, int len);
>> +extern void outsw(unsigned long addr, const void *buf, int len);
>> +extern void outsl(unsigned long addr, const void *buf, int len);
>> +extern void insb(unsigned long addr, void *buf, int len);
>> +extern void insw(unsigned long addr, void *buf, int len);
>> +extern void insl(unsigned long addr, void *buf, int len);
>> +#define outsb outsb
>> +#define outsw outsw
>> +#define outsl outsl
>> +#define insb insb
>> +#define insw insw
>> +#define insl insl
>
> You don't have inb/outb, so you shouldn't have these either.
Okay, will remove.
>
>> +/*
>> + * PCI is not enabled in nios2. Provide dummy implementation to get 'allyesconfig'
>> + * to build successfully.
>> + */
>> +#define inb(addr)    ({ 0; })
>> +#define inw(addr)    ({ 0; })
>> +#define inl(addr)    ({ 0; })
>> +#define outb(x, addr)        do { } while (0)
>> +#define outw(x, addr)        do { } while (0)
>> +#define outl(x, addr)        do { } while (0)
>
> What fails if you take these out?
Seem good, will remove this as well.
>
>> +
>> +/* Use "Duff's Device" to unroll the loops. */
>> +#define __IO_OUT_LOOP(a, b, l)                               \
>> +     do {                                            \
>> +             if (l > 0) {                            \
>> +                     int _n = (l + 7) / 8;           \
>> +                     switch (l % 8) {                \
>> +                     case 0:                         \
>> +                             do {                    \
>> +                                     *a = *b++;      \
>> +                     case 7:                         \
>> +                                     *a = *b++;      \
>> +                     case 6:                         \
>> +                                     *a = *b++;      \
>> +                     case 5:                         \
>> +                                     *a = *b++;      \
>> +                     case 4:                         \
>> +                                     *a = *b++;      \
>> +                     case 3:                         \
>> +                                     *a = *b++;      \
>> +                     case 2:                         \
>> +                                     *a = *b++;      \
>> +                     case 1:                         \
>> +                                     *a = *b++;      \
>> +                             } while (--_n > 0);     \
>> +                     }                               \
>> +             }                                       \
>> +     } while (0)
>> +
>> +#define __IO_IN_LOOP(a, b, l)                                \
>> +     do {                                            \
>> +             if (l > 0) {                            \
>> +                     int _n = (l + 7) / 8;           \
>> +                     switch (l % 8) {                \
>> +                     case 0:                         \
>> +                             do {                    \
>> +                                     *b++ = *a;      \
>> +                     case 7:                         \
>> +                                     *b++ = *a;      \
>> +                     case 6:                         \
>> +                                     *b++ = *a;      \
>> +                     case 5:                         \
>> +                                     *b++ = *a;      \
>> +                     case 4:                         \
>> +                                     *b++ = *a;      \
>> +                     case 3:                         \
>> +                                     *b++ = *a;      \
>> +                     case 2:                         \
>> +                                     *b++ = *a;      \
>> +                     case 1:                         \
>> +                                     *b++ = *a;      \
>> +                             } while (--_n > 0);     \
>> +                     }                               \
>> +             }                                       \
>> +     } while (0)
>> +
>> +#else /* __IO_USE_DUFFS */
>> +
>> +/* Use simple loops. */
>> +#define __IO_OUT_LOOP(a, b, l)                               \
>> +     do {                                            \
>> +             while (l--)                             \
>> +                     *a = *b++;                      \
>> +     } while (0)
>> +
>> +#define __IO_IN_LOOP(a, b, l)                                \
>> +     do {                                            \
>> +             while (l--)                             \
>> +                     *b++ = *a;                      \
>> +     } while (0)
>> +
>> +#endif /* __IO_USE_DUFFS */
>> +
>> +void outsb(unsigned long addr, const void *buf, int len)
>> +{
>> +     volatile unsigned char *ap = (volatile unsigned char *)addr;
>> +     unsigned char *bp = (unsigned char *)buf;
>> +     __IO_OUT_LOOP(ap, bp, len);
>> +}
>> +EXPORT_SYMBOL(outsb);
>> +
>> +void outsw(unsigned long addr, const void *buf, int len)
>> +{
>> +     volatile unsigned short *ap = (volatile unsigned short *)addr;
>> +     unsigned short *bp = (unsigned short *)buf;
>> +     __IO_OUT_LOOP(ap, bp, len);
>> +}
>> +EXPORT_SYMBOL(outsw);
>
> This implementation makes no sense, so definitely remove them.
Okay.

Thanks.

Regards
Ley Foon
