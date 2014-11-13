Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbaKMWY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:24:29 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55183 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:24:27 -0500
Date: Thu, 13 Nov 2014 14:24:22 -0800
From: josh@joshtriplett.org
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Pieter Smith <pieter@boesman.nl>, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/56] fs: Macros to define splice file_operations
Message-ID: <20141113222422.GA30412@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113215139.GK7996@ZenIV.linux.org.uk>
 <CAFLxGvzOoXrQZyKmX402g9eiwX_2zVVCysx+qNzZdzE=uydnAA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:49:07PM +0100, Richard Weinberger wrote:
> On Thu, Nov 13, 2014 at 10:22 PM, Pieter Smith <pieter@boesman.nl> wrote:
> > Provides a CONFIG_SYSCALL_SPLICE compatible way of defining the .splice_read
> > and .splice_write file_operations so that they can later be compiled out when
> > the kernel is configured without the splice-family syscalls
[...]
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1512,6 +1512,32 @@ struct file_operations {
> >         int (*show_fdinfo)(struct seq_file *m, struct file *f);
> >  };
> >
> > +#ifdef CONFIG_SYSCALL_SPLICE
> > +
> > +/*
> > + * Define and init the splice_read member of a file_operations struct
> > + */
> > +#define SPLICE_READ_INIT(read) .splice_read = read,
> > +
> > +/*
> > + * Define and init the splice_read member of a file_operations struct
> > + */
> > +#define SPLICE_WRITE_INIT(write) .splice_write = write,
> 
> This is ugly like hell.
> Why can't you do something like __exit_p()?

On Thu, Nov 13, 2014 at 09:51:39PM +0000, Al Viro wrote:
> This (and subsequent stuff making use of that) is bloody pointless.  You
> save 2 words per file_operations instance, at the cost of making things
> uglier and harder to grep.  NAK.

Given the large number of uses of these, I agree that it doesn't seem
worth the tradeoff, particularly since very few file_operations
structures will exist on any individual tiny configuration.  I think we
should go with a wrapper similar to __exit_p (splice_p?), which just
becomes NULL when !CONFIG_SYSCALL_SPLICE.  Removing the actual pointers
from file_operations can wait until we have compiler support for tagging
specific fields in a structure (like splice_read and splice_write) as
dead.

Similarly, you shouldn't wrap the functions that get assigned to those
pointers with #ifdef; instead, mark them as __maybe_unused, which
doesn't even add any lines of code.  The compiler will then
automatically throw them out when not used, without emiting a warning.

That should drastically reduce the number of changes, and in particular
eliminate almost all of the ifdefs.

- Josh Triplett
