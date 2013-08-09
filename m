Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031445Ab3HIXBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:01:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031414Ab3HIXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:01:52 -0400
Date: Fri, 9 Aug 2013 16:01:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130809230150.GA23418@kroah.com>
References: <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202B674.7060005@linuxtoys.org>
 <20130807213325.GB5373@kroah.com>
 <520569B2.4000704@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520569B2.4000704@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 03:14:10PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
>  (snip)
> > You are mixing protocols and bindings and system calls up it seems.> They are not the same at all.
> 
> Yes, I may be using the term binding wrong.  As I understand it
> - We should use a _syscall_ to open a unix socket on the daemon, then

If you want to use unix sockets, yes, do that.  All languages have
bindings for those syscalls.

> - define a _protocol_ to describe the data flowing over the socket,

Good protocols exist, look at protobufs from Google if you want to
define your own.  Never create your own protocol these days, it doesn't
make sense, be it a text one or something else.

> - a C _binding_ to present a C API and hide the protocol for C programmers,
> - a C++ binding and API for C++ programmers
> - a Java binding
> - a PHP binding
> - a Perl binding
> - a Python binding
> - a node.js binding
> - a Scratch binding for Raspberry Pi users
> - and some kind of shell binding for Bash programmers

All of those languages already support Linux syscalls, no need to create
anything else.

> > (snip)
> > Again, /sys and /proc is talking to the kernel, not userspace to
> > userspace, I still fail to understand how you will do that to create a
> > "userspace" driver.
> 
> From a kernel developer's point of view the term "userspace driver"
> may seem like an oxymoron.  By definition, all devices on the system
> have to be controlled by the kernel.  All else is just userspace.

Not true at all, I know all about userspace drivers, look at the UIO
code in the Linux kernel.  It was created explicitly for this exact
thing, and to prevent the myrads of broken implementations from being
created again and again and again.  Just use it if you wish to talk to
your hardware directly, lots of people do so.

> As an _opinion_ only, I think maybe userspace device drivers do exist.
> It refers to  hardware that the kernel is not, and should not, be aware
> of.  This hardware is not seen because it is at the end of some kind of
> communications channel like USB-serial or Ethernet. A developer might
> like to view that hardware as part of the overall system even if Linux
> and the CPU do not have direct access to it.  A userspace driver looks
> something like this
> 
> 	=(ProxyDevNode)====(daemon)===(CommChannel)===(hardware)
> 
> As an engineer, I can see that "userspace driver" might not make sense.
> As a marketing guy, I'm super-duper pleased to tell my customers  "Yes,
> we support Linux.  After all, we have Userspace Device Drivers!" :)

Not really, you are just using an IPC to talk to a "real" device driver.

> My (hardware) has a Xilinx FPGA with connectors that goes out to eight
> peripheral cards.  There are about thirty different peripheral cards
> available  The FPGA has to be programmed for a specific peripheral mix,
> but it is pretty easy for a customer to request a new FPGA image for a
> new mix of cards. Inside the FPGA the peripherals are controlled by
> 8-bit registers on an internal address bus.

FPGAs are interesting things, people are creating "real" drivers for
them (see the linux-kernel archives for a few examples.)  Other people
just use the UIO layer instead, which works quite well for them.  I
suggest you do the same thing.

Again, you are creating a new form of userspace/userspace IPC, without a
good reason for why one of the existing IPC implementations will not
work for you (no, being able to use "echo" is not a good reason, you can
do that with local sockets just fine).

I suggest you take a look at the book, The Linux Programming Interface,
by Michael Kerrisk, specifically chapter 43, which goes into great
detail about all of the existing IPC mechanisms that Linux already
provides.  I'm sure one of them should be able to fit your needs.

Otherwise, to accept this code, I need to see a way that normal users
can use it (i.e. no root or mknod), and that it can handle namespaces
and the security interface that the kernel has to support.  To do so
otherwise would be unfair to users who expect such a thing.

thanks,

greg k-h
