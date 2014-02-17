Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBQVqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:46:01 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36319 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaBQVp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:45:56 -0500
Date: Mon, 17 Feb 2014 13:45:53 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
Message-ID: <20140217214553.GB11655@kmo>
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
 <530279EC.5010605@infradead.org>
 <CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:11:51PM +0100, Geert Uytterhoeven wrote:
> On Mon, Feb 17, 2014 at 10:06 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 02/17/2014 01:00 PM, Geert Uytterhoeven wrote:
> >> On Fri, Feb 14, 2014 at 8:04 PM, Linux Kernel Mailing List
> >> <linux-kernel@vger.kernel.org> wrote:
> >>>    bcache: Minor fixes from kbuild robot
> >>
> >>> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> >>> index 4f6b594..3f74b4b 100644
> >>> --- a/drivers/md/bcache/bset.c
> >>> +++ b/drivers/md/bcache/bset.c
> >>> @@ -23,7 +23,7 @@ void bch_dump_bset(struct btree_keys *b, struct bset *i, unsigned set)
> >>>         for (k = i->start; k < bset_bkey_last(i); k = next) {
> >>>                 next = bkey_next(k);
> >>>
> >>> -               printk(KERN_ERR "block %u key %zi/%u: ", set,
> >>> +               printk(KERN_ERR "block %u key %li/%u: ", set,
> >>>                        (uint64_t *) k - i->d, i->keys);
> >>>
> >>>                 if (b->ops->key_dump)
> >>
> >> On 32-bit (m68k):
> >> drivers/md/bcache/bset.c: In function ‘bch_dump_bset’:
> >> drivers/md/bcache/bset.c:27: warning: format ‘%li’ expects type ‘long
> >> int’, but argument 3 has type ‘int’
> >>
> >> What are you trying to print here? It looks a bit strange to me.
> >> Technically, the difference between two pointers is of type ptrdiff_.
> >> The kernel had
> >>
> >> typedef __kernel_ptrdiff_t      ptrdiff_t;
> >>
> >> and
> >>
> >> #if __BITS_PER_LONG != 64
> >> typedef unsigned int    __kernel_size_t;
> >> typedef int             __kernel_ssize_t;
> >> typedef int             __kernel_ptrdiff_t;
> >> #else
> >> typedef __kernel_ulong_t __kernel_size_t;
> >> typedef __kernel_long_t __kernel_ssize_t;
> >> typedef __kernel_long_t __kernel_ptrdiff_t;
> >> #endif
> >>
> >> So I'd expect "%zi" to be the right way, and a quick test compile on
> >> 32-bit (m68k)
> >> and 64-bit (amd64) comfirms that. What was wrong with it?
> >
> > The kernel supports 't' (%t) for ptrdiff_t (same as glibc),
> > so %ti should work (or %tu).
> 
> Yes, that compiles without warnings, too.
> 
> And after more decyphering, "(uint64_t *) k - i->d" seems to be positive,
> so "%tu" should be OK.

*swears* Actually, I'm just going to cast this to unsigned (that's definitely
safe here):


commit 70bc49d421c793f73a772ae1f50622a39c6136d9
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Mon Feb 17 13:44:06 2014 -0800

    bcache: Fix another compiler warning on m68k
    
    Use a bigger hammer this time
    
    Signed-off-by: Kent Overstreet <kmo@daterainc.com>

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 3f74b4b074..5454164153 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -23,8 +23,8 @@ void bch_dump_bset(struct btree_keys *b, struct bset *i, unsigned set)
 	for (k = i->start; k < bset_bkey_last(i); k = next) {
 		next = bkey_next(k);
 
-		printk(KERN_ERR "block %u key %li/%u: ", set,
-		       (uint64_t *) k - i->d, i->keys);
+		printk(KERN_ERR "block %u key %u/%u: ", set,
+		       (unsigned) ((u64 *) k - i->d), i->keys);
 
 		if (b->ops->key_dump)
 			b->ops->key_dump(b, k);

