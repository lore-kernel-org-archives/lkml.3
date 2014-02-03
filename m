Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaBCNrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:47:24 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38036 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaBCNrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:47:21 -0500
MIME-Version: 1.0
In-Reply-To: <1389783998.14001.22.camel@joe-AO722>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
Date: Mon, 3 Feb 2014 14:47:20 +0100
X-Google-Sender-Auth: ng9lyCMOy_qiYTV2j_kv-ubfuRw
Message-ID: <CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
>> drivers/md/bcache/btree.c: In function ‘insert_u64s_remaining’:
>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast
> []
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> []
>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
>>       if (b->keys.ops->is_extents)
>>               ret -= KEY_MAX_U64S;
>>
>> -     return max(ret, 0L);
>> +     return max_t(ssize_t, ret, 0L);
>
> why not
>         return max(ret, 0);

Indeed, that also works, on both 32-bit and 64-bit.
Will resend, now all the issues moved from -next to Linus' tree.

> I think it odd that:
>
> drivers/md/bcache/bset.h:static inline size_t bch_btree_keys_u64s_remaining(struct btree_keys *b)
>
> and:
>
> static size_t insert_u64s_remaining(struct btree *b)
> {
>         ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
>
>         /*
>          * Might land in the middle of an existing extent and have to split it
>          */
>         if (b->keys.ops->is_extents)
>                 ret -= KEY_MAX_U64S;
>
>         return max(ret, 0L);
> }
>
> so the only use of that size_t inline is cast to ssize_t

If the value returned by bch_btree_keys_u64s_remaining() is smaller
than KEY_MAX_U64S, it must stay negative after the subtraction,
instead of wrapping around to a big positive number. That's why ret is
ssize_t and not size_t.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
