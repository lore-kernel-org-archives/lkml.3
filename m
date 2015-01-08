Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbbAHNtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:49:00 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbbAHNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:48:58 -0500
Date: Thu, 8 Jan 2015 13:48:49 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Siddhartha De <siddhartha.de87@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about kernel interfaces
Message-ID: <20150108134849.671ee761@lxorguk.ukuu.org.uk>
In-Reply-To: <CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
	<CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is sysfs 'supposed' to be a read only where various kernel parameters
> are exposed to be read ? Or are they 'supposed' to be writable too ?

You can create either

> Are all drivers in future required to expose interfaces in sysfs ?

Only if they need one (some will appear automatically as you enable power
management and the like).
 
> If the answer to the above is true , then would we be really requiring
> IOCTL calls at all anymore ... because all that we would need to do to
> make a driver do something is to change values in some of the files in
> sysfs ... for eg to call a ioctl called DO_SOMETHING on driver D1 we
> would be doing :
> 
> echo 1> /sysfs/D1/IOCTLS/DO_SOMETHING  ( or something like that ... :) )

Try implementing a few this way and you'll discover you can't. ioctls
happen on file handles which are tied to instances of an object not to
the driver. ioctl also allows read/write pairs so can be serializing and
sequenced in a way sysfs can't.

> Are there any plans of exposing the kernel api ( that is syscalls and
> libc ) as sysfs files ... for eg
> 
> echo 1> /sysfs/libc/get_system_time
> cat /sysfs/libc/results/system_time

Time is an example where you could implement it via sysfs. It's an
unusual case in that its global and stateless.

> Would it be a good idea to do this ?

No, probably not.
 
> How about exposing core system calls , libc and any new libraries over
> http/over the network  ? This would make calling ioctls and really low
> level stuff from high level languages like Java a trivial process .
> For eg right now if I wanted to call some function say foo () in
> library my_library.so in Java I would have to take the JNI/JNA route
> ... doable but not exactly 'easy' ( same for other high level
> languages ) ... whereas in the new way all I would have to do is send
> a request to say :-
>   http://localhost:7000/my_library/foo?arg1=something,arg2=something
> ( Just wanted a frank discussion on this idea .... )

Except that you've also got to transfer the data and the authentication
back and forth. You need much more than sysfs for this, you need some way
to pass messages securely, and to do work on a remote node on your
behalf. You need some way to locate a resource.

It's not entirely impossible to make syscalls remotable. It's been done to
some extent at least two ways. Read up on plan 9 (which did try and take
Unix much more networked and within the classic tradition of Unix as a
small clean OS), and perhaps also on MOSIX, which took a very different
approach to running on a cluster of boxes as one instance. Another odd
example to look at is Minix. Minix treats all syscalls internally as
messages between user processes and services like the file system. Minix
never really made use of it, but it does mean its much easier to do
remote syscall models in Minix than Linux. (in part I suspect this comes
from Tanenbaum's Amoeba and similar work).

I'm not sure I'd pick Java for this either - Java is very weak in this
area as it tends to expose notions of locality and what is and isn't
remote when doing method invocations. Languages like smalltalk on the
other hand got this right many years before.

Alan
 
