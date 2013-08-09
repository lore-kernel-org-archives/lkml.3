Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031327Ab3HIWOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:14:10 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:55341 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031204Ab3HIWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:14:09 -0400
Message-ID: <520569B2.4000704@linuxtoys.org>
Date: Fri, 09 Aug 2013 15:14:10 -0700
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

Greg Kroah-Hartman wrote:
  (snip)
 > You are mixing protocols and bindings and system calls up it seems.> They are not the same at all.

Yes, I may be using the term binding wrong.  As I understand it
- We should use a _syscall_ to open a unix socket on the daemon, then
- define a _protocol_ to describe the data flowing over the socket,
- a C _binding_ to present a C API and hide the protocol for C programmers,
- a C++ binding and API for C++ programmers
- a Java binding
- a PHP binding
- a Perl binding
- a Python binding
- a node.js binding
- a Scratch binding for Raspberry Pi users
- and some kind of shell binding for Bash programmers

 >
 > (snip)
 > Again, /sys and /proc is talking to the kernel, not userspace to
 > userspace, I still fail to understand how you will do that to create a
 > "userspace" driver.

 From a kernel developer's point of view the term "userspace driver"
may seem like an oxymoron.  By definition, all devices on the system
have to be controlled by the kernel.  All else is just userspace.

As an _opinion_ only, I think maybe userspace device drivers do exist.
It refers to  hardware that the kernel is not, and should not, be aware
of.  This hardware is not seen because it is at the end of some kind of
communications channel like USB-serial or Ethernet. A developer might
like to view that hardware as part of the overall system even if Linux
and the CPU do not have direct access to it.  A userspace driver looks
something like this

	=(ProxyDevNode)====(daemon)===(CommChannel)===(hardware)

As an engineer, I can see that "userspace driver" might not make sense.
As a marketing guy, I'm super-duper pleased to tell my customers  "Yes,
we support Linux.  After all, we have Userspace Device Drivers!" :)


 >
 > (snip)
 > How can you control a robot with this code?
 > What do you want to do in order to control your robot?
 > What are your needs in accessing the hardware?
 > What hardware are you wanting to control?

In my message I said I was building a robot.  While true, this gives the
erroneous impression that it is just me for just one robot.  In fact, I
build and sell FPGA based robot controllers.  It is my _customers_ who
build and program the robots.

The descriptions below may be representative of others wanting to have
userspace device drivers even though the descriptions are for my specific
case.

My (hardware) has a Xilinx FPGA with connectors that goes out to eight
peripheral cards.  There are about thirty different peripheral cards
available  The FPGA has to be programmed for a specific peripheral mix,
but it is pretty easy for a customer to request a new FPGA image for a
new mix of cards. Inside the FPGA the peripherals are controlled by
8-bit registers on an internal address bus.

My (CommChannel) is an FTDI USB-serial interface.  The protocol over the
link consists of reads and writes to the 8-bit registers in the FPGA.
Polling is not needed since the FPGA can automatically generate a read
response packet when it needs to.

My (daemon) is passed which serial port to use.  It establishes a link
to the FPGA and then asks it for a list of its peripherals.  Using this
list it loads a shared object library for each different peripheral.
The init in the library creates the device nodes needed by the driver
(userspace driver, that is).  When all the device nodes have been set
up the daemon drops root permissions.  The daemon does not need root
permissions if the device nodes are set up in advance.
     Once everything is set up the system becomes completely event
driven.  Sensor reading are passed from the FPGA through the daemon
and out to the device nodes, and configuration changes are passed
from the device node out to the FPGA.


 >
 > And why can't you just access that hardware through the normal
 > kernel apis we have today?

Because the kernel doesn't even see the hardware I'm controlling.

 >
 > greg k-h

Greg, sorry this message was so long, and thanks again for your patience.

Bob Smith


