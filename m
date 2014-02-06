Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaBFUpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:45:38 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49677 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBFUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140206123824.ab35615f4561340d91255cf2@linux-foundation.org>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
	<CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
	<CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
	<1391677607.15777.2.camel@joe-AO722>
	<20140206123824.ab35615f4561340d91255cf2@linux-foundation.org>
Date: Thu, 6 Feb 2014 21:45:36 +0100
X-Google-Sender-Auth: 1EKmb2Gx60cuw45aXC5vDxtO5rY
Message-ID: <CAMuHMdVJ8N7UHWz6aMdurwpKwafb_V0AS7MyUQWftiH9C-8b5A@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Kent Overstreet <kmo@daterainc.com>,
        Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 9:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 2014-02-06 at 10:00 +0100, Geert Uytterhoeven wrote:
>> > On Mon, Feb 3, 2014 at 2:47 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > > On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote:
>> > >> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
>> > >>> drivers/md/bcache/btree.c: In function ___insert_u64s_remaining___:
>> > >>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast
>> > >> []
>> > >>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> > >> []
>> > >>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
>> > >>>       if (b->keys.ops->is_extents)
>> > >>>               ret -= KEY_MAX_U64S;
>> > >>>
>> > >>> -     return max(ret, 0L);
>> > >>> +     return max_t(ssize_t, ret, 0L);
>> > >>
>> > >> why not
>> > >>         return max(ret, 0);
>> > >
>> > > Indeed, that also works, on both 32-bit and 64-bit.
>> > > Will resend, now all the issues moved from -next to Linus' tree.
>> >
>> > However, sparse doesn't like it, so we'll have to go for v1?
>>
>> Seems so.
>
> Kent, was there any secret reason why insert_u64s_remaining():ret has
> type ssize_t?  The function returns size_t and
> bch_btree_keys_u64s_remaining() returns size_t so I think I'll do the
> obvious:
>
>
> --- a/drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix
> +++ a/drivers/md/bcache/btree.c
> @@ -1805,7 +1805,7 @@ static bool btree_insert_key(struct btre
>
>  static size_t insert_u64s_remaining(struct btree *b)
>  {
> -       ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
> +       size_t ret = bch_btree_keys_u64s_remaining(&b->keys);
>
>         /*
>          * Might land in the middle of an existing extent and have to split it
> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(stru
>         if (b->keys.ops->is_extents)
>                 ret -= KEY_MAX_U64S;

I think the reason is the line above: with size_t, ret may become a big
positive number when the subtraction wraps below zero.

>
> -       return max(ret, 0);
> +       return max_t(size_t, ret, 0);

That part is OK, cfr. my v1 (which I had planned to send out as v3 again).

>  }
>
>  static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
