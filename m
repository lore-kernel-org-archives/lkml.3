Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaBFUi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:38:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaBFUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:38:27 -0500
Date: Thu, 6 Feb 2014 12:38:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different
 types
Message-Id: <20140206123824.ab35615f4561340d91255cf2@linux-foundation.org>
In-Reply-To: <1391677607.15777.2.camel@joe-AO722>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
	<CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
	<CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
	<1391677607.15777.2.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014 01:06:47 -0800 Joe Perches <joe@perches.com> wrote:

> On Thu, 2014-02-06 at 10:00 +0100, Geert Uytterhoeven wrote:
> > On Mon, Feb 3, 2014 at 2:47 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote:
> > >> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
> > >>> drivers/md/bcache/btree.c: In function ___insert_u64s_remaining___:
> > >>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast
> > >> []
> > >>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > >> []
> > >>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
> > >>>       if (b->keys.ops->is_extents)
> > >>>               ret -= KEY_MAX_U64S;
> > >>>
> > >>> -     return max(ret, 0L);
> > >>> +     return max_t(ssize_t, ret, 0L);
> > >>
> > >> why not
> > >>         return max(ret, 0);
> > >
> > > Indeed, that also works, on both 32-bit and 64-bit.
> > > Will resend, now all the issues moved from -next to Linus' tree.
> > 
> > However, sparse doesn't like it, so we'll have to go for v1?
> 
> Seems so.

Kent, was there any secret reason why insert_u64s_remaining():ret has
type ssize_t?  The function returns size_t and
bch_btree_keys_u64s_remaining() returns size_t so I think I'll do the
obvious:


--- a/drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix
+++ a/drivers/md/bcache/btree.c
@@ -1805,7 +1805,7 @@ static bool btree_insert_key(struct btre
 
 static size_t insert_u64s_remaining(struct btree *b)
 {
-	ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
+	size_t ret = bch_btree_keys_u64s_remaining(&b->keys);
 
 	/*
 	 * Might land in the middle of an existing extent and have to split it
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(stru
 	if (b->keys.ops->is_extents)
 		ret -= KEY_MAX_U64S;
 
-	return max(ret, 0);
+	return max_t(size_t, ret, 0);
 }
 
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,
_

