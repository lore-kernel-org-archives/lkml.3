Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3CPQPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:15:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53210 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850Ab3CPQPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:15:41 -0400
Message-ID: <1363450540.2023.30.camel@joe-AO722>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 09:15:40 -0700
In-Reply-To: <1363449458.25967.76.camel@gandalf.local.home>
References: <1363441844.2023.17.camel@joe-AO722>
	 <1363449458.25967.76.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 11:57 -0400, Steven Rostedt wrote:
> My macro nastiness is contagious ;-)

True.

> On Sat, 2013-03-16 at 06:50 -0700, Joe Perches wrote:

> > +int (seq_printf)(struct seq_file *m, const char *f, ...)
> 
> That's rather ugly. Why not just #undef seq_printf before defining it?

The whole thing is ugly, nasty and hackish.
I kinda like it.

But I don't like unnecessary undefs.
The preprocessor doesn't expand (funcname).

> Anyway, not making va_args a whacky name is dangerous. This is why I add
> those crazy underscores. If someone does:
> 
> 	var = 1;
> 	va_args[] = "abc";
> 	seq_printf(m, "%d %s", var, va_args);

The same could be true of fmt and it's
used in lots of macros no?

> What will be printed is:
> 
> 	1 var, va_args
> 
> That will be very confusing to people.

And so be fixed very quickly.

> > +	if (sizeof(va_args) > 1)				\
> > +		seq_printf(seq, fmt, ##__VA_ARGS__);		\
> > +	else							\
> > +		seq_puts(seq, fmt);				\
> > +} while (0)
> 
> BTW, you need to return a value.

Oh, yeah, thanks.

>  #define seq_printf(seq, fmt, ...)				\
> -do {								\
> +({								\
>  	char va_args[] = __stringify(__VA_ARGS__);		\
> +	int _____ret;						\
>  	if (sizeof(va_args) > 1)				\
> -		seq_printf(seq, fmt, ##__VA_ARGS__);		\
> +		_____ret = seq_printf(seq, fmt, ##__VA_ARGS__); \
>  	else							\
> -		seq_puts(seq, fmt);				\
> -} while (0)
> +		_____ret = seq_puts(seq, fmt);			\
> +	_____ret;						\
> +})

It's certainly better as a statement expression,
but I think the underscores are really ugly and
not necessary as ret is locally scoped.

Checkpatch doesn't generally parse strings.
checking strings for % could be done though
I suppose.

