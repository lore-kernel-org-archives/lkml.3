Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaESMhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:37:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57587 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaESMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:37:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: josh@joshtriplett.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Mon, 19 May 2014 14:36:24 +0200
Message-ID: <63645237.lSKEVJUKkQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140515215646.GA16326@cloud>
References: <20140509191914.GA7286@jtriplet-mobl1> <53729873.2030805@zytor.com> <20140515215646.GA16326@cloud>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9Q5W+UfDNW9tm0tbgpo4F5h/5VrvTrF8gY3c80/JTKw
 lnYTJgd0Xq8gg6gThIuhBw4sG9Me5dRn3jSV5Q8y3F40Df8nog
 3ViwXKIkG6+irOW2nCgVSkwzlx/f7f/bAkKSuIFOKfFx0rsSuS
 ++nBHciTSj4xRltPubzlAHQxj8HPI9ycOz+CLQxYaxVZTEool5
 cviiYpHwDJY3HPT6E7jXBm3xynxFTAgBIM06qsP7BSkt23l03i
 4VzXXvObMKy3SG/7m0k9+/DMh5piSgoil3KIvSXb2659u+oBER
 tM2fYH+VLpZM16Xr4YKGNY3Mf9YmjMnsMiwR/zQO6Za7SMBbSE
 jb00NDqGn968Xs5MQ0nw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 14:56:46 josh@joshtriplett.org wrote:
> On Tue, May 13, 2014 at 03:10:59PM -0700, H. Peter Anvin wrote:
> > On 05/09/2014 03:38 PM, Josh Triplett wrote:
> > > On Fri, May 09, 2014 at 02:20:45PM -0700, H. Peter Anvin wrote:
> > >> On 05/09/2014 02:12 PM, Arnd Bergmann wrote:
> > >>>
> > >>>> However, if we're going to have these devices I'm wondering if having
> > >>>> /dev/portw and /dev/portl (or something like that) might not make sense,
> > >>>> rather than requiring a system call per transaction.
> > >>>
> > >>> Actually the behavior of /dev/port for >1 byte writes seems questionable
> > >>> already: There are very few devices on which writing to consecutive
> > >>> port numbers makes sense. Normally you just want to write a series
> > >>> of bytes (or 16/32 bit words) into the same port number instead,
> > >>> as the outsb()/outsw()/outsl() functions do.
> > >>>
> > >>
> > >> Indeed.  I missed the detail that it increments the port index; it is
> > >> virtually guaranteed to be bogus.
> > > 
> > > Exactly.  It might make sense to have ioport8/ioport16/ioport32 devices
> > > that accept arbitrary-length reads and writes (divisible by the size)
> > > and do the equivalent of the string I/O instructions outs/ins, but for
> > > the moment I'd like to add the single device that people always seem to
> > > want and can't get from /dev/port.  If someone's doing enough writes
> > > that doing a syscall per in/out instruction seems like too much
> > > overhead, they can write a real device driver or use ioperm/iopl.
> > 
> > I really have a problem with the logic "our current interface is wrong,
> > so let's introduce another wrong interface which solves a narrow use
> > case".  In some ways it would actually be *better* to use an ioctl
> > interface on /dev/port in that case...
> 
> ioport{8,16,32} seems preferable to an ioctl on /dev/port, but in any
> case, I'd be happy to adapt this patch to whatever interface seems
> preferable.  I just don't want to let the perfect be the enemy of the
> good here; 16-bit and 32-bit port operations are currently completely
> impossible via /dev/port, and I'm primarily interested in fixing that,
> not necessarily in creating a completely generalized interface for doing
> high-performance repeated I/O operations that ought to be in the kernel
> anyway.

I'd prefer to do the absolute minimum to enable this: port I/O is not
something that people really should be doing in this decade, at least
not on non-x86.

A simple pair of ioctls would be fine in my mind, if we think there
is actually a strong use case. Josh, where did you find that testing
driver? Do you have reason to believe it's actually useful on non-x86?
If the reason for the existence of that code is just that someone
didn't find the iopl() man page, I'd rather not have it at all.

My feeling is that all devices we can think of fall into at least one
of these categories:

* legacy PC stuff that needs only byte access
* PCI devices that can be accessed through sysfs
* devices on x86 that can be accessed using iopl

	Arnd
