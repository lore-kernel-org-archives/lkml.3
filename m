Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaI2PrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:47:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52709 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaI2PrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:47:15 -0400
Date: Mon, 29 Sep 2014 16:47:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with seq_puts()
Message-ID: <20140929154711.GF7996@ZenIV.linux.org.uk>
References: <20140926143721.52206f95@gandalf.local.home>
 <20140929144121.GA30562@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929144121.GA30562@pathway.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 04:41:22PM +0200, Petr Mladek wrote:

> Hmm, this inconsistency seems to be in more functions. I would divide
> it into three categories:
> 
> a) Functions that writes valid data until the end of the buffer
>    and returns -1 when the operation makes it full (m->count ==
>    m->size) or when they are not able to write at all:
> 
> 	seq_bitmap()
> 	seq_bitmap_list()

> b) Functions that writes the full buffer but they report -1 only
>    when they cannot write at all:
> 
> 	set_putc()

> c) Functions that leave mess at the end of the buffer when they could
>    not write all data; they mark it as full and return -1 when this happens:
> 
> 	set_puts()
> 	seq_put_decimal_ull()
> 	seq_put_decimal_ll()
> 	seq_write()

... and they really should not return *anything*.

>   + always return error when seq_overflow() would return overflow;
>     in fact, the full buffer means that the last write operation
>     was most likely incomplete

No.  _Any_ caller that decides to report that error to its caller is fucking
broken.  We had some cases like that.

<greps>

Oh, lovely - notify_fdinfo() is broken.  Exactly that way - "we get an error,
better report it to caller".  Bad idea - overflow is *NOT* something ->show()
must report to seq_read().  In that case you just return 0.  Returning -1
means something very different - "have read(2) fail with EPERM".

fanotify_fdinfo(): ditto.

seq_puts() ones: drivers/parisc/ccio-dma.c:ccio_proc_bitmap_info() - bogus,
but harmless (it assumes for some reason that seq_puts() returns the number
of characters written; return values are added up and ignored).

drivers/regulator/dbx500-prcmu.c:
        err = seq_puts(s, "ux500-regulator status:\n");
        if (err < 0)
                dev_err(dev, "seq_puts overflow\n");
No, you don't - it's not an error.

drivers/watchdog/bcm_kona_wdt.c: EPERM-from-read() bug.

fs/dlm/debug_fs.c: ditto.

drivers/usb/gadget/udc/goku_udc.c: unique case of seq_puts() return value
used correctly.  I.e. "if it's already overflown, don't bother with
producing the rest of output, you'll be called again on bigger buffer
anyway; just return 0 and be done with it" hint.  And yes, it is the
only place in the tree that looks at return value of seq_puts() and uses
it correctly.

<greps for seq_printf>

arch/arm/plat-pxa/dma.c:59:     pos += seq_printf(s, "DMA channel %d requesters list :\n", chan);
Bogus.  seq_printf() returns 0 or -1, again with the same kind of semantics
("don't bother with more output, you've already overflown" hint).

arch/microblaze/kernel/cpu/mb.c: same bogosity, but there it at least
ignores the sum and just returns 0 in the end.  Why the hell add them
up is a mystery...

drivers/base/power/wakeup.c: called in a helper, returned to caller, which
promptly ignores it.

drivers/mtd/devices/docg3.c: bogus, overflow leads to read(2) returning
more or less random error.

drivers/parisc/ccio-dma.c: added up and ignored.
drivers/parisc/sba_iommu.c: added up and ignored.

conntrack ct_seq_show() and friends: used properly.

net/netfilter/nf_log.c: bogus, EPERM-from-read() kind.

OK, I'm convinced - we do need to make those suckers return nothing at all,
preventing the well-intentioned bugs of that sort.  There had been a discussion
of that a while ago, but it hadn't gone anywhere.  Time to end that
depravity, let's bury the body...

What we need is a helper along the lines of seq_already_overflown() that
could be used by the few places that really want that hint.  As in
	if (seq_already_overflown(m))
		return 0; // we'll be called again with bigger buffer anyway

And let's make seq_printf and friends return void.  Any breakage we miss
on grep will be caught by compiler.  Enough is enough.
