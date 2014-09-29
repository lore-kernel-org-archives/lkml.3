Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaI2PZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:25:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:19611 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521AbaI2PZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:25:41 -0400
Date: Mon, 29 Sep 2014 11:25:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
Message-ID: <20140929112538.3929a9a2@gandalf.local.home>
In-Reply-To: <20140929144121.GA30562@pathway.suse.cz>
References: <20140926143721.52206f95@gandalf.local.home>
	<20140929144121.GA30562@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:41:22 +0200
Petr Mladek <pmladek@suse.cz> wrote:


> This patch moves set_putc() from b) to c) because it leaves mess in the
> last byte.

Which removes the "b" section, and makes seq_putc() and seq_puts()
function the same.

> 
> 
> The semantic looks weird in all categories:
> 
> add a) They report error even when there was not a real overflow.
>     Well, they do not know if there was overflow because
>     bitmap_scnprintf() does not report if it shrunk
>     the data or not.
> 
> add b) It does not report error even when seq_overflow() might later
>     report overflow.
> 
> add c) Any overflow invalidates the whole buffer because there might
>     be mess at the end. The overflow is not checked by read functions,
>     so they allow to read the mess.
> 
> 
> I think that reasonable semantic would be:
> 
>   + either signalize overflow another way (extra struct member and
>     leave count to point to the valid data) or always fill valid
>     data until the end of the buffer.
> 
>     The second variant might be problem if we add only half of
>     an escape sequence.
> 
> 
>   + always return error when seq_overflow() would return overflow;
>     in fact, the full buffer means that the last write operation
>     was most likely incomplete

I think this is probably the best option.

> 
>     Also we might rename it from "overflow" to "full" or "filled"
>     or "sealed" or "complete" that might describe the state more
>     precisely because there is not a real overflow in some situations

We could make overflow be m->count > m->size, which would mean that
m->count == m->size (full) isn't a problem. Although, I would have to
audit the kernel to see if anything just assumes that m->count is
always less than m->size.

This would mean overflow is the correct term, and wouldn't have to
change it.

Anyway, that should be a second patch, and we should get my current
patch (the one to make putc and puts the same) in first, as that
actually fixes the inconsistency between the two.

I'll post another patch to try to make seq_file operations a bit more
consistent. Perhaps we can have m->count be what would have been
written.

-- Steve
