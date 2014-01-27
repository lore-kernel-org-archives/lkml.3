Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaA0XRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:17:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaA0XRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:17:06 -0500
Date: Mon, 27 Jan 2014 15:17:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>, Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH] vsprintf: BUG on %n
Message-Id: <20140127151704.2a5b2d05e33cfd7a8f17896d@linux-foundation.org>
In-Reply-To: <1390864354.20150.57.camel@joe-AO722>
References: <20140127230326.GA877@www.outflux.net>
	<1390864354.20150.57.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 15:12:34 -0800 Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-01-27 at 15:03 -0800, Kees Cook wrote:
> > Now that there has been a full release of the kernel, and all users
> > of %n have been dropped, switch to %n use triggering a BUG. Ignoring
> > arguments could be used to assist in information leaks if an arbitrary
> > format string was under the control of an attacker.
> []
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -1735,15 +1735,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
> >  		case FORMAT_TYPE_NRCHARS: {
> >  			/*
> >  			 * Since %n poses a greater security risk than
> > -			 * utility, ignore %n and skip its argument.
> > +			 * utility, it should not be implemented. Instead,
> > +			 * BUG when encountering %n, since there are no
> > +			 * legitimate users and skipping arguments could
> > +			 * assist information leak attacks.
> >  			 */
> > -			void *skip_arg;
> > -
> > -			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
> > -					old_fmt);
> > -
> > -			skip_arg = va_arg(args, void *);
> > -			break;
> > +			BUG();
> 
> BUGs should be avoided where possible.
> 
> I think using BUG here isn't necessary or good.
> 

Good point(s).  

In fact the patch makes the kernel less secure - it provides a way for
people to make the kernel crash if they a) are able to inject printk
control strings and b) don't know about %s ;)

