Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab3GRV37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:29:59 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41907 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369Ab3GRV35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130718211806.GB2394@swordfish>
References: <20130712092400.GA2565@swordfish>
	<CADv+DGka4s1xc2UYqu+-EqHW8jA56JrtEE_sMsMOpc6NDmc6Zw@mail.gmail.com>
	<20130712094830.GA2257@swordfish.minsk.epam.com>
	<20130718211806.GB2394@swordfish>
Date: Thu, 18 Jul 2013 23:29:57 +0200
X-Google-Sender-Auth: quOuec8HETyCAOXOl5c6GeAko0k
Message-ID: <CAMuHMdXCsRKpFQRwMTteQpBCbtuJVqmb9UvszHi3ffTS=RxJmw@mail.gmail.com>
Subject: Re: [PATCH] LZ4: compression/decompression signedness mismatch
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>,
        Yann Collet <yann.collet.73@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:18 PM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> On (07/12/13 12:48), Sergey Senozhatsky wrote:
>> On (07/12/13 11:28), Yann Collet wrote:
>> >    The reference implementation, hosted at :�
>> >    [1]https://code.google.com/p/lz4/
>> >    only proposes char* (signed) types as part of the interface contract.
>> >    I would recommend to keep it that way, to remain consistent.
>> >    Regards
>>
>> Crypto lz4 accepts u8 * for both compression and decompression:
>>
>>  lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
>>                             unsigned int slen, u8 *dst, unsigned int *dlen)
>>
>>  lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
>>                        unsigned int slen, u8 *dst, unsigned int *dlen)
>>
>>
>> Internally LZ4 may cast unsigned char* to signed char*, the same way you
>> already do with compression:
>>
>>       int lz4_compress(const unsigned char *src, size_t src_len,
>>                       unsigned char *dst, size_t *dst_len, void *wrkmem)
>>
>>               calls:
>>                       lz4_compressctx(void *ctx,
>>                               const char *source, char *dest,
>>                               int isize, int maxoutputsize)
>>
>
>
> + lib/decompress_unlz4.c
>  STATIC int INIT decompress(unsigned char *buf, int in_len,
>                                 int(*fill)(void*, unsigned int),
>                                 int(*flush)(void*, unsigned int),
>                                 unsigned char *output,
>                                 int *posp,
>                                 void(*error)(char *x)
>
>>
>> At the moment API is a bit misaligned: unsiged char* for compression and signed char* for
>> decompression.
>>
>>
>> My 'real word' use case is, suppose:
>>
>>       struct foo {
>>       [..]
>>               int (*compress)(const unsigned char *src, size_t src_len,
>>                               unsigned char *dst, size_t *dst_len, void *wrkmem);
>>               int (*decompress)(const unsigned char *src, size_t src_len,
>>                               unsigned char *dst, size_t *dst_len);
>>       };
>>
>>
>> and (for example) module also provides sysfs attribute, so user can switch select
>> LZO or LZ4 compressions depending of his needs:
>>
>>       ->compress = lzo1x_1_compress;
>>       ->decompress = lzo1x_decompress_safe;
>>
>> to
>>       ->compress = lz4_compress;
>>       ->decompress = lz4_decompress_unknownoutputsize;
>>
>>
>> the last one produces unneccessary compilation warning.
>>
>
> did you guys have a chance to review the patch? it does not change
> implementation/internals, just decompression exported symbols.

IMHO, all these memory buffers should be of type "(const) void *", cfr.
e.g. read(2) and memcpy(3).

This avoids casts in the callers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
