Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3HEXqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:46:40 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:57337 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab3HEXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:46:39 -0400
Message-ID: <52003958.7080103@linuxtoys.org>
Date: Mon, 05 Aug 2013 16:46:32 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com>
In-Reply-To: <20130804231958.GA25418@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg
Thanks for discussing the module with me.  I think I'm now
closer to distilling it down to its essence.


GOAL:
The goal of this module is to give user space programs an
interface similar to that enjoyed by the kernel using procfs
and sysfs.  All of the following should be possible
	echo 1 > /proc/sys/net/ipv4/ip_forward  # procfs
	echo 75 > /dev/motors/left/speed        # proxy
	echo 5 > /dev/wpa_supplicant/use_channel # proxy

IPC:
To accomplish the above goal a new IPC is required.  This
new IPC must have the following characteristics:
	- bidirectional
	- writer blocks until reader is present
	- a writer can cause the reader to close
	- works with 'echo' and 'cat'

No existing IPC in Linux has all of these characteristics
but proxy, the tiny self-contained module submitted, does.
(Greg, I'm kind of surprised that a shim of an IPC like this
wasn't added to Linux a long, long time ago.)

USE CASES:
Proxy should be added to the kernel because it can greatly
improve Linux in two significant ways.

USE CASE #1: User space device drivers
A viable approach to user space device drivers would make
life easier for both programmers and kernel maintainers.
The latter because now a maintainer can now reasonably say
"go use proxy and a user space driver".   Some of the SPI
and I2C drivers might have been easier to do with proxy.
   Programmers doing device drivers might have an easier time
since it will be easier to prototype and debug a system in
user space.  SPI and I2C driver writers in particular may
appreciate the ability to build a working system without
having to go through the sometimes tedious process of a
kernel submission.
   Finally, some device drivers that are not possible today
would become possible.  In my case I have a USB-serial link
to a robot controller and so need a user space daemon to
terminate the serial line.  It is only with proxy that I
can hide the details of this and give users a nice /dev
view of the robot.

USE CASE #2:  End the madness of language bindings
Over 10 years ago kernel developers had the sense to escape
(some) ioctl language bindings with the introduction of
procfs.   How is it that in all this time we haven't done
the same thing for all the daemons that populate Linux?
No, today daemon writers are still being forced to open a
socket, define and document a protocol over it, and then
write a library for that protocol for all the popular
languages.   And we're not talking about just one or two
languages.  No, now it more like C, Java, Python, PHP, and
soon node.js.  Next week some new language will wander off
the street and need a yet another binding.  Eeeech!
    Let's let daemons use the same kind of interface that the
kernel has with /sys and /proc.  With proxy, daemon coders
could define an ASCII interface in exactly the same way the
kernel has.  The inclusion of 'echo' and 'cat' above is kind
of a litmus test.  If a daemon interface works with cat and
echo, it will _NEVER_ need dedicated per-language bindings.



thanks
Bob Smith



