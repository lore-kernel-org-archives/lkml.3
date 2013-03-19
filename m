Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab3CSClm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:41:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34403 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753939Ab3CSCll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:41:41 -0400
Message-ID: <1363660900.1932.37.camel@joe-AO722>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 19:41:40 -0700
In-Reply-To: <20130318135949.853ef457d0334008d83ae80f@linux-foundation.org>
References: <1363441844.2023.17.camel@joe-AO722>
	 <20130316175446.GA21522@ZenIV.linux.org.uk>
	 <20130318135949.853ef457d0334008d83ae80f@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 13:59 -0700, Andrew Morton wrote:
> On Sat, 16 Mar 2013 17:54:47 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Sat, Mar 16, 2013 at 06:50:44AM -0700, Joe Perches wrote:
> > > Instead of converting the 800 or so uses of seq_printf with
> > > a constant format (without a % substitution) to seq_puts,
> > > maybe there's another way to slightly speed up these outputs.
> > > 
> > > Taking a similar approach to commit abd84d60eb
> > > ("tracing: Optimize trace_printk() with one arg to use trace_puts()")
> > > use the preprocessor to convert seq_printf(seq, "string constant")
> > > to seq_puts(seq, "string constant")
> > > 
> > > By stringifying __VA_ARGS__, we can, at compile time, determine
> > > the number of args that are being passed to seq_printf() and
> > > call seq_puts or seq_printf appropriately.
> > > 
> > > The actual function definition for seq_printf must now
> > > be enclosed in parenthesis to avoid further macro expansion.
> > 
> > Joe, would you mind showing me a single real-world case where that
> > "optimization" would really matter?
> 
> There's also a small reduction in code footprint.  We merge less
> significant things all day ;)

It's small.  ~1kb x86/32 defconfig
$ size def/vmlinux.o*
   text	   data	    bss	    dec	    hex	filename
9296433  661732 1822196 11780361 b3c109	def/vmlinux.o.new
9297361  661732 1822196 11781289 b3c4a9	def/vmlinux.o.old

> > NAKed-because: GAFL

I'm delighted to have a ViroGAFL score of 2.

> Yeah, that macro thing should be nuked from orbit.

It is kinda cute though.

Perhaps it could become something more generic like:

#define __VA_ARGS__EXIST(...)					\
({								\
	int ret;						\
	char __va_args__exist[] = __stringify(__VA_ARGS__);	\
	ret = sizeof(__va_args__exist) != 1;			\
	ret;							\
})

so the hacky ugliness is confined.

> Please let's add the
> checkpatch rule (resend when convenient with clean changelog, please)
> and if people want to send "convert seq_printk to seq_puts" patches to
> Jan and he takes them into the trivial tree then all is good.

I'll resend it.

