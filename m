Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaI2Qkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:40:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54973 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754059AbaI2Qkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:40:42 -0400
Date: Mon, 29 Sep 2014 12:40:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
Message-ID: <20140929124029.64aa1b0a@gandalf.local.home>
In-Reply-To: <20140929162334.GB30562@pathway.suse.cz>
References: <20140926143721.52206f95@gandalf.local.home>
	<20140929144121.GA30562@pathway.suse.cz>
	<20140929112538.3929a9a2@gandalf.local.home>
	<20140929162334.GB30562@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 18:23:34 +0200
Petr Mladek <pmladek@suse.cz> wrote:
 
> Do you prefer:
> 
>       + the extra struct member?

I hate the extra member.

>       + or always filling some valid data?

Not needed.

>       + or invalidating the buffer when the overflow is set?

Not needed.

> 
> > > 
> > >   + always return error when seq_overflow() would return overflow;
> > >     in fact, the full buffer means that the last write operation
> > >     was most likely incomplete
> > 
> > I think this is probably the best option.
> 
> > 
> > > 
> > >     Also we might rename it from "overflow" to "full" or "filled"
> > >     or "sealed" or "complete" that might describe the state more
> > >     precisely because there is not a real overflow in some situations
> > 
> > We could make overflow be m->count > m->size, which would mean that
> > m->count == m->size (full) isn't a problem. Although, I would have to
> > audit the kernel to see if anything just assumes that m->count is
> > always less than m->size.
> 
> I am not sure if it is a good idea. I think that having
> m->count > m->size is prone to buffer overflow errors in
> the buffer reading code. I vote for adding extra flag to
> the struct :-)

Reading the seq_file code, it is really an all or nothing approach. It
even does the saving of the m->count and on overflow, will reset it to
what it did originally.

If an overflow happens, the buffer count should either be reset to what
it was (throw away anything that was written), or discarded completely,
which it sometimes does.

I'm going to write up some patches that converts overflow to be count =
size + 1, and then updating everything to be an all or nothing approach.

I'll take Joe's patches to convert them to void as well, with the
addition of a seq_is_full() helper for those places that wont waste time
adding more if it's just going to be discarded.

But first, I'm off to my doctor's appointment followed by more PT.

-- Steve
