Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaI2QXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:23:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbaI2QXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:23:36 -0400
Date: Mon, 29 Sep 2014 18:23:34 +0200
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with seq_puts()
Message-ID: <20140929162334.GB30562@pathway.suse.cz>
References: <20140926143721.52206f95@gandalf.local.home>
 <20140929144121.GA30562@pathway.suse.cz>
 <20140929112538.3929a9a2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929112538.3929a9a2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-09-29 11:25:38, Steven Rostedt wrote:
> On Mon, 29 Sep 2014 16:41:22 +0200
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> 
> > This patch moves set_putc() from b) to c) because it leaves mess in the
> > last byte.
> 
> Which removes the "b" section, and makes seq_putc() and seq_puts()
> function the same.
> 
> > 
> > 
> > The semantic looks weird in all categories:
> > 
> > add a) They report error even when there was not a real overflow.
> >     Well, they do not know if there was overflow because
> >     bitmap_scnprintf() does not report if it shrunk
> >     the data or not.
> > 
> > add b) It does not report error even when seq_overflow() might later
> >     report overflow.
> > 
> > add c) Any overflow invalidates the whole buffer because there might
> >     be mess at the end. The overflow is not checked by read functions,
> >     so they allow to read the mess.
> > 
> > 
> > I think that reasonable semantic would be:
> > 
> >   + either signalize overflow another way (extra struct member and
> >     leave count to point to the valid data) or always fill valid
> >     data until the end of the buffer.
> > 
> >     The second variant might be problem if we add only half of
> >     an escape sequence.

Do you prefer:

      + the extra struct member?
      + or always filling some valid data?
      + or invalidating the buffer when the overflow is set?

> > 
> >   + always return error when seq_overflow() would return overflow;
> >     in fact, the full buffer means that the last write operation
> >     was most likely incomplete
> 
> I think this is probably the best option.

> 
> > 
> >     Also we might rename it from "overflow" to "full" or "filled"
> >     or "sealed" or "complete" that might describe the state more
> >     precisely because there is not a real overflow in some situations
> 
> We could make overflow be m->count > m->size, which would mean that
> m->count == m->size (full) isn't a problem. Although, I would have to
> audit the kernel to see if anything just assumes that m->count is
> always less than m->size.

I am not sure if it is a good idea. I think that having
m->count > m->size is prone to buffer overflow errors in
the buffer reading code. I vote for adding extra flag to
the struct :-)

> This would mean overflow is the correct term, and wouldn't have to
> change it.
> 
> Anyway, that should be a second patch, and we should get my current
> patch (the one to make putc and puts the same) in first, as that
> actually fixes the inconsistency between the two.

Feel free to add

Acked-by: Petr Mladek <pmladek@suse.cz>

for this patch. The question is if it is really really needed in the
final patch set. It might get even partly reverted with the follow
up changes.

Best Regards,
Petr
