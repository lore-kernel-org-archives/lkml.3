Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3CPRCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:02:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3CPRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:02:08 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2s8qfAZQTSAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rUnzm6ZD3sEA:10 a=T4B5grLNUFVfDLvWdv0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363453326.25967.105.camel@gandalf.local.home>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 13:02:06 -0400
In-Reply-To: <1363450540.2023.30.camel@joe-AO722>
References: <1363441844.2023.17.camel@joe-AO722>
	 <1363449458.25967.76.camel@gandalf.local.home>
	 <1363450540.2023.30.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 09:15 -0700, Joe Perches wrote:

> > > +int (seq_printf)(struct seq_file *m, const char *f, ...)
> > 
> > That's rather ugly. Why not just #undef seq_printf before defining it?
> 
> The whole thing is ugly, nasty and hackish.
> I kinda like it.
> 
> But I don't like unnecessary undefs.
> The preprocessor doesn't expand (funcname).

Either way, as long as it's commented.

> 
> > Anyway, not making va_args a whacky name is dangerous. This is why I add
> > those crazy underscores. If someone does:
> > 
> > 	var = 1;
> > 	va_args[] = "abc";
> > 	seq_printf(m, "%d %s", var, va_args);
> 
> The same could be true of fmt and it's
> used in lots of macros no?

No, not at all. Try it. The difference is that 'fmt' is the macro arg
and gets replaced by the pre-processor, where as va_args is what gets
placed into the C code by the C pre-processor. Any variables that's not
a macro argument MUST BE UNIQUE!

> 
> > What will be printed is:
> > 
> > 	1 var, va_args
> > 
> > That will be very confusing to people.
> 
> And so be fixed very quickly.

By changing the caller, it's a bug in the implementation of the macro,
not the user of the macro.

> 
> > > +	if (sizeof(va_args) > 1)				\
> > > +		seq_printf(seq, fmt, ##__VA_ARGS__);		\
> > > +	else							\
> > > +		seq_puts(seq, fmt);				\
> > > +} while (0)
> > 
> > BTW, you need to return a value.
> 
> Oh, yeah, thanks.
> 
> >  #define seq_printf(seq, fmt, ...)				\
> > -do {								\
> > +({								\
> >  	char va_args[] = __stringify(__VA_ARGS__);		\
> > +	int _____ret;						\
> >  	if (sizeof(va_args) > 1)				\
> > -		seq_printf(seq, fmt, ##__VA_ARGS__);		\
> > +		_____ret = seq_printf(seq, fmt, ##__VA_ARGS__); \
> >  	else							\
> > -		seq_puts(seq, fmt);				\
> > -} while (0)
> > +		_____ret = seq_puts(seq, fmt);			\
> > +	_____ret;						\
> > +})
> 
> It's certainly better as a statement expression,
> but I think the underscores are really ugly and
> not necessary as ret is locally scoped.

Let me show you the issue:

#define seq_printf(seq, fmt, ...)			\
({							\
	char va_args[] = __stringify(__VA_ARGS__);		\
	int ret;					\
	if (sizeof(va_args) > 1)			\
		ret = seq_printf(seq, fmt, ##__VA_ARGS__);	\
	else
		ret = seq_puts(seq, fmt);		\
	ret;						\
})

Now lets look at the usage of in the code:

	ret = 1;
	va_args = 5;
	fmt = "hello world\n";
	seq_print(m, "my fmt=%s args=%d ret=%d\n", fmt, va_args, ret);

Notice that here we have va_args as a integer.

Here's what cpp does to it (adding newlines to make it readable):

	ret = 1;
	va_args = 5;
	fmt = "hello world";
	({
		char va_args[] = "fmt, va_args, ret";
		int ret;
		if (sizeof(va_args) > 1)
			ret = seq_printf(seq, "my fmt=%s args=%d ret=%d\n", fmt, va_args, ret);
		else
			ret = seq_puts(seq, "my fmt=%s args=%d ret=%d\n");
		ret;
	})

A couple of things here. One, you'll get a gcc warning about ret being
used uninitialized. That should confuse the hell out of the developer.

Then you'll also get a warning about %d expecting a number but the
argument is a string. Another damn confusing thing for developers to
see.

Let me stress it one more time... Any variable names added by a macro,
that's not replaced by the parameters of the macro MUST BE UNIQUE!!!!
Otherwise you will get very difficult hard to debug bugs.

I'm also thinking, as macros may include macros, we may need to define a
macro variable name space policy. Something like:

	char __seq_printf__va_args[] = __stringify(__VA_ARGS__);
	int __seq_printf__ret;

It may make the macro ugly, but it helps keep conflicts in name spacing.

-- Steve


