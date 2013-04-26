Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3DZUYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:24:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3DZUYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:24:40 -0400
Date: Fri, 26 Apr 2013 13:24:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, James.Bottomley@hansenpartnership.com,
        snitzer@redhat.com
Subject: Re: Bcache v. whatever
Message-Id: <20130426132438.4e48e0688fc3c3c298e71d7e@linux-foundation.org>
In-Reply-To: <20130426194642.GC9931@google.com>
References: <20130114223202.GV26407@google.com>
	<20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
	<20130426194642.GC9931@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 12:46:42 -0700 Kent Overstreet <koverstreet@google.com> wrote:

> On Thu, Apr 25, 2013 at 04:17:04PM -0700, Andrew Morton wrote:
> > On Mon, 14 Jan 2013 14:32:02 -0800 Kent Overstreet <koverstreet@google.com> wrote:
> > 
> ...
> > drivers/md/bcache/btree.c: In function `bch_btree_refill_keybuf':
> > drivers/md/bcache/btree.c:2330: error: invalid operands to binary +
> > 
> > due to
> > 
> > #define pbtree(b)       (&bch_pbtree(b).s[0])
> > 
> > I don't know why this is happening (presumably a gcc glitch), but
> > returning an 80-byte struct by value from bch_pkey() and bch_pbtree()
> > is just gruesome.  The compiler has to allocate the space on the caller
> > stack, pass a hidden pointer into the callee and the callee copies its
> > return value into that caller stack slot.  It's slow and consumes stack.
> > 
> > Something different, please.
> 
> Well, it is kind of... perverse but really the compiler's doing exactly
> what I would've had to do otherwise - stick a char buf[80] on the
> caller's stack and pass it to bch_pbtree(). With the caveat that I
> haven't looked at the generated code.

That's the more idiomatic way of doing things and yes, the code
generation will be similarly awful.

> As far as I can tell the only real improvement would be to add a %p
> format string to vsnprintf, but adding a global extension would obviously be
> inappropriate for this. It'd be really nice to have a mechanism for
> adding file/module private format strings to vsnprintf, but I haven't
> cared enough yet to implement it myself.
> 
> Of course if you know a better solution I'm all ears.
> 
> Uhm, as for the actual bug - that is a fairly ancient gcc, I wasn't
> aware we were supporting compilers that old but I'm sure you wouldn't be
> bugging me about it if we weren't...

Documentation/Changes is the official status.  It says gcc-3.2+.  We're
very slow in updating those version numbers because it's hard. 
gcc-3.4.5 for mips fails in the same way.

Why are those things macros anyway?  urgh, it's because we want to jam
a string into the caller's stack frame without declaring any of it.


Really I do think it would be better to do away with the C party tricks
and have callers do

	char btree_buf[BTREE_BUF_SIZE];

	btree_to_text(btree_buf, b);
	pr_debug("%s\n", btree_buf);

Nice, simple, explicit, direct and stupid.  It might generate
unused-var warnings if DEBUG is undefined but from my reading of
pr_debug() things will be OK.

Then we can poke around at btree_to_text() until gcc-3.4.5 is happy
with it.
