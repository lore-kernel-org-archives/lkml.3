Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3KCTI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 14:08:29 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38080 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3KCTI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 14:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <20131102234451.GA10255@thunk.org>
References: <CAF1GSti2xbHGtBx4Qq8Br9unEM_GE8GJ99fzoRm6qKaun7MHZw@mail.gmail.com>
 <20131102234451.GA10255@thunk.org>
From: Jason Cipriani <jason.cipriani@gmail.com>
Date: Sun, 3 Nov 2013 14:07:56 -0500
Message-ID: <CAF1GStjMyDW0tTBPtXLnDSYrQtNiL8FxNCDzM3yNYrLSRX6AhQ@mail.gmail.com>
Subject: Re: Correct parameter size for BLKSSZGET ioctl.
To: "Theodore Ts'o" <tytso@mit.edu>, Jason Cipriani <jason.cipriani@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 2, 2013 at 7:44 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Fri, Nov 01, 2013 at 08:29:26PM -0400, Jason Cipriani wrote:
> > In blkdiscard in util-linux, at least since version 2.23, the
> > following code is used to retrieve a device's physical sector size:
> >
> >   uint64_t secsize;
> >   ioctl(fd, BLKSSZGET, &secsize);
> >
> > On my machine (Ubuntu 12.04 -- 3.2.0-55-generic-pae #85-Ubuntu SMP Wed
> > Oct 2 14:03:15 UTC 2013 i686 i686 i386 GNU/Linux) this yields
> > incorrect results as it seems a 32-bit int is expected, this causes
> > subsequent sector alignment calculations in blkdiscard to be
> > incorrect, which in turn causes blkdiscards trim ioctl's to fail in
> > certain situations (or even worse, to trim the wrong blocks).
>
> BLKSSZGET returns an int.  If you look at the sources of util-linux
> v2.23, you'll see it passes an int to BLKSSZGET in
>
>         sys-utils/blkdiscard.c
>         lib/blkdev.c
>
> E2fsprogs also expects BLKSSZGET to return an int, and if you look at
> the kernel sources, it very clearly returns an int.
>
> The one place it doesn't is in sys-utils/blkdiscard.c, where as you
> have noted, it is passing in a uint64 to BLKSSZGET.  This looks like
> it's a bug in sys-util/blkdiscard.c.
>
> I'll send a proposed patch in the next e-mail message.

Thank you for submitting that patch.

There was a bigger question hidden behind the context there that I'm
still wondering about: Are these ioctl interfaces specified and
documented somewhere? From what I've seen, and from your response, the
implication is that the kernel source *is* the specification, and not
document exists that the kernel is expected to comply with; is this
the case?

Secondly, would it not make sense to change all ints in all public
kernel interfaces to data types with a well-defined, machine- and
(mostly) compiler-independent size, e.g. int32_t (or whatever)? On one
hand, nothing seems particularly broken, per se, but on the other,
"int" is vaguely defined and it is arguably only by chance (albeit a
strong chance) that everything works (e.g. compilers used to build
applications agree with compilers used to build the kernel).

Please CC me on replies, I am not subscribed to this list.

Thanks again,
Jason
