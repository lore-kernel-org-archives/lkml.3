Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3HDVyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 17:54:32 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:38563 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3HDVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 17:54:31 -0400
Message-ID: <51FECDA6.5070001@linuxtoys.org>
Date: Sun, 04 Aug 2013 14:54:46 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com>
In-Reply-To: <20130803223828.GA14611@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg
    I've added some white space and snipped some text to make
the questions more visible.


Greg Kroah-Hartman wrote:
> No signed-off-by:, or body of text here that explains what this is and
> why it should be accepted.
D'oh!  I'll fix this and add Joe's changes before resubmitting
the patch.

BTW: Several people have said they don't understand how to use
this device, so I'll give  Documentation/proxy.txt a simple
example program that illustrates the two most common uses cases.



>> +Proxy has some unique features that make ideal for providing a
>> +/sys like interface.  It has no internal buffering.  The means
>> +the daemon can not write until a client program is listening.
>> +Both named pipes and pseudo-ttys have internal buffers.
>
> So what is wrong with internal buffers?  Named pipes have been around
> for a long time, they should be able to be used much like this, right?
Buffers are great for streaming data but are unneeded for
configuration and status information.  Neither sysfs or procfs
have internal buffers because they are not needed.
   In a way the problem is not the buffer itself but that a write
into a named pipe, for example, will succeed even if there is no
one at the other end to receive the data.  I think you'd want an
open and write on a device driver to fail if the driver is not
there and ready for the request.



>> +Proxy will succeed on a write of zero bytes.  A zero byte write
>> +gives the client an EOF.  (snip)
 >> No other IPC mechanism can close one
>> +side of a device and leave the other side open.
> No "direct" IPC, but you can always emulate this just fine with existing
> IPC mechanisms.
OK.


>> +Proxy works well with select(), an important feature for daemons.
>> +In contrast, the FUSE filesystem has some issues with select() on
>> +the client side.
> What are those issues?  Why not just fix them?
When I resubmit this patch, I'll remove all references to FUSE.
There is nothing wrong with FUSE.  It is just not the right tool
for the this job.  I shouldn't have build and load a full file
system when all I want is a handful of device nodes.



> Adding a new IPC function to the kernel should not be burried down in
> drivers/char/.  We have 10+ different IPC mechanisms already, some
> simple, some more complex.  Are you _sure_ none of the existing ones
> will not work for you?
I'm convinced this has the fewest lines of new code and the
smallest impact on the rest of the system, but I could be wrong.
The minimum feature set I want is to emulate for my user-space
device driver what the kernel has for procfs and sysfs, That is,
	echo 1 > /proc/sys/net/ipv4/ip_forward  # procfs
	echo 75 > /dev/motors/left/speed        # proxy dev



 > Maybe a simple userspace library that wraps the
> existing mechanisms would be better (no kernel changes needed, portable
> to any kernel release, etc.)?
Yes, this is the traditional model for approaching problems like
the one I have.  It would involve opening a unix socket, defining
a protocol for that socket, and then writing several bindings for
that protocol for different languages.  Wow, that is a LOT of work.

   Luckily for us the procfs and sysfs authors have given us a much
better model to use: ASCII characters terminated by a newline.  My
Raspberry Pi customers expect to control an LED with a command like
this:	echo 1 > /sys/class/gpio/gpio25

So it is entirely reasonable on their part to want to control a
stepper motor with a command like this:
	echo 300 > /dev/robot/stepper0/count



Again, I hope you don't mind the text snip and extra white space.

thanks
Bob Smith

