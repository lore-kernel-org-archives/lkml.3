Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3CCDJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 22:09:10 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47291 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3CCDJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 22:09:08 -0500
Message-ID: <1362280145.15793.70.camel@edumazet-glaptop>
Subject: Re: sendfile and EAGAIN
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 02 Mar 2013 19:09:05 -0800
In-Reply-To: <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
	 <1361820175.6781.13.camel@edumazet-glaptop>
	 <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 20:41 -0500, Ulrich Drepper wrote:
> On Mon, Feb 25, 2013 at 2:22 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > I don't understand the issue.
> >
> > sendfile() returns -EAGAIN only if no bytes were copied to the socket.
> 
> There is something wrong/unexpected/...
> 
> I have a program which can use either sendfile or send.  When using
> sendfile to transmit a large block (I've seen it with 900k) the
> sendfile call does not transmit everything.  There receiver gets only
> about 600k.  This is the situation when I think I've seen EAGAIN
> errors from sendmail but I cannot just now reproduce it.  This is with
> sockets of AF_UNIX type.

There is no real sendfile() support for AF_UNIX.

It does a copy.

( sock_no_sendpage() fallback )

> 
> Are there any limits to take into account?


This is totally expected that sendfile() doesn't queue the whole file,
if the transport is slower than the producer.

You cant ask for non blocking operation and expect sendfile() storing
Gigabytes of data in the kernel, even if its only meta data.

Using non blocking IO means the sender (and the receiver) must be able
to perform several operations, as long as the whole transfert is not
finished.



