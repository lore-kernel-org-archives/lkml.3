Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3HHVoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:44:07 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:46208 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3HHVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:44:04 -0400
Message-ID: <52040C3A.9090708@linuxtoys.org>
Date: Thu, 08 Aug 2013 14:23:06 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com> <5202B674.7060005@linuxtoys.org> <20130807213325.GB5373@kroah.com>
In-Reply-To: <20130807213325.GB5373@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:>
 > You are mixing protocols and bindings and system calls up it seems.
 > They are not the same at all.

 > How can you control a robot with this code?
 > What do you want to do in order to control your robot?  What are your
 > needs in accessing the hardware?  What hardware are you wanting to
 > control?  And why can't you just access that hardware through the normal
 > kernel apis we have today?


Greg
     I'll reply again to this message but for now let me try
another explanation that does not mention sysfs, procfs, or
device drivers.   This is probably how I should have started.

=============================================================

proxy: a very lightweight alternative to FUSE

Proxy is a simple bidirectional character device that almost
transparently proxies opens, reads, writes, and closes from
one side of the device to the other side.

FUSE is great for giving applications a file system interface
to an application's internal variables and values.  If a FUSE
application has an internal variable called "foo" then one way
that variable could be exposed is with a (FUSE) file system
entry.  That is, reading and writing foo might appear as:
     cat < /fuse_mp/foo
     echo 5 > /fuse_mp/foo

An extraordinarily important, and often overlooked advantage
of FUSE applications is that they almost never need language
specific bindings.  This is because every single programming
language in Linux supports file IO.  You don't need a binding
to do something like this:
     open(/fuse_mp/foo)
     write(5\n)
     close

While the API offered by FUSE is nice and FUSE is really great
for file systems, it has some severe limitations that may have
prevented more widespread use.  For most daemon developers the
biggest limitation is that FUSE has its own main() routine.
This makes it difficult or impossible use use FUSE as just an
API in an application that requires select() and IO from other
parts of the system.

Proxy solves this problem.  Proxy is intended for application
developers who would like to avoid writing many language specific
binding but who, for one reason or another, can not use FUSE.

Proxy has two sides.  One side remains open to clients (like
the FUSE file system entries).  The other side is connected to
the application and can be tied into that application's select()
(or other IO multiplexer in the case of node.js, for example).
Just as with FUSE, it is entirely up to the application writer
to format, and give syntax, and meaning to the data that passes
through the proxy device.

Adding proxy to the kernel may make it easier for new types of
daemons and services to appear in Linux since it can help remove
the burden of writing language specific bindings for the daemon.


thanks
Bob Smith


