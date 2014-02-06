Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaBFUvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:51:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBFUu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:50:59 -0500
Date: Thu, 6 Feb 2014 12:50:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Perches <joe@perches.com>, Kent Overstreet <kmo@daterainc.com>,
        Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different
 types
Message-Id: <20140206125058.8b5d884cca468b9850d5b538@linux-foundation.org>
In-Reply-To: <CAMuHMdVJ8N7UHWz6aMdurwpKwafb_V0AS7MyUQWftiH9C-8b5A@mail.gmail.com>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
	<CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
	<CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
	<1391677607.15777.2.camel@joe-AO722>
	<20140206123824.ab35615f4561340d91255cf2@linux-foundation.org>
	<CAMuHMdVJ8N7UHWz6aMdurwpKwafb_V0AS7MyUQWftiH9C-8b5A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014 21:45:36 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > --- a/drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix
> > +++ a/drivers/md/bcache/btree.c
> > @@ -1805,7 +1805,7 @@ static bool btree_insert_key(struct btre
> >
> >  static size_t insert_u64s_remaining(struct btree *b)
> >  {
> > -       ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
> > +       size_t ret = bch_btree_keys_u64s_remaining(&b->keys);
> >
> >         /*
> >          * Might land in the middle of an existing extent and have to split it
> > @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(stru
> >         if (b->keys.ops->is_extents)
> >                 ret -= KEY_MAX_U64S;
> 
> I think the reason is the line above: with size_t, ret may become a big
> positive number when the subtraction wraps below zero.

Well, I assumed that case would be a bug - otherwise the programmer
would have commented such a subtlety.  Wouldn't he?

> >
> > -       return max(ret, 0);
> > +       return max_t(size_t, ret, 0);
> 
> That part is OK, cfr. my v1 (which I had planned to send out as v3 again).

It needs to be ssize_t.
