Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaI2QJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:09:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:53295 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751971AbaI2QJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:09:43 -0400
Date: Mon, 29 Sep 2014 12:09:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
Message-ID: <20140929120927.7e05f485@gandalf.local.home>
In-Reply-To: <20140929154711.GF7996@ZenIV.linux.org.uk>
References: <20140926143721.52206f95@gandalf.local.home>
	<20140929144121.GA30562@pathway.suse.cz>
	<20140929154711.GF7996@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:47:12 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> What we need is a helper along the lines of seq_already_overflown() that
> could be used by the few places that really want that hint.  As in
> 	if (seq_already_overflown(m))
> 		return 0; // we'll be called again with bigger buffer anyway

We already have that, it's called seq_overflow(), but it's a static
function in seq_file.c. We can easily move that to seq_file.h. If you
want to rename it to seq_already_overflown() that would be fine.

> 
> And let's make seq_printf and friends return void.  Any breakage we miss
> on grep will be caught by compiler.  Enough is enough.

I'm good with this.

Note, I'm trying to make a seq_buf.c file that consolidates the code in
trace_seq.c and seq_file.c. This will extend slightly the use cases of
the seq_buf functions, but I think all the seq_*() functions from
seq_file.c can be turned into functions that return void.

I'm thinking of making m->count > m->size be what returns overflow as
true, as m->count == m->size can have all the data, that is, nothing
lost.

I'll start writing up some patches.

-- Steve
