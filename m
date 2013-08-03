Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3HCWhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:37:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3HCWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:37:12 -0400
Date: Sun, 4 Aug 2013 06:38:28 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130803223828.GA14611@kroah.com>
References: <51FC5478.40500@linuxtoys.org>
 <51FC5A97.1090102@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC5A97.1090102@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 06:19:19PM -0700, Bob Smith wrote:
> This character device can give daemons an interface similar to
> the kernel's /sys and /proc interfaces.   It is a nice way to
> give user space drivers real device nodes in /dev.

Other comments about this patch:

> From 7ee4391af95b828179cf5627f8b431c3301c5057 Mon Sep 17 00:00:00 2001
> From: Bob Smith <bsmith@linuxtoys.org>
> Date: Fri, 2 Aug 2013 16:44:48 -0700
> Subject: [PATCH] PROXY, a driver that gives daemons a /sys like interface
> 

No signed-off-by:, or body of text here that explains what this is and
why it should be accepted.

> ---
>  Documentation/proxy.txt |   36 ++++
>  drivers/char/Kconfig    |    8 +
>  drivers/char/Makefile   |    2 +-
>  drivers/char/proxy.c    |  539 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 584 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/proxy.txt
>  create mode 100644 drivers/char/proxy.c
> 
> diff --git a/Documentation/proxy.txt b/Documentation/proxy.txt
> new file mode 100644
> index 0000000..6b9206a
> --- /dev/null
> +++ b/Documentation/proxy.txt
> @@ -0,0 +1,36 @@
> +Proxy Character Devices
> +
> +
> +Proxy is a small character device that connects two user space
> +processes.  It is intended to give user space daemons a /sys like
> +interface for configuration and status.
> +
> +As an example consider a daemon that controls a stepper motor. The
> +daemon would create and open one proxy device to read and write
> +configuration (/dev/stepper/config) and another proxy device to
> +accept a motor step count (/dev/stepper/count).
> +Shell commands to illustrate this example:
> +	$ stepper_daemon	# start the stepper control daemon
> +	$ # Set config to full steps, clockwise and 400 step/sec
> +	$ echo "full, cw, 400" > /dev/stepper/config
> +	$ # Now tell the motor to step 4000 steps
> +	$ echo 4000 > /dev/stepper/count
> +	$ sleep 2
> +	$ # How many steps remain?
> +	$ cat /dev/stepper/count
> +
> +
> +Proxy has some unique features that make ideal for providing a
> +/sys like interface.  It has no internal buffering.  The means
> +the daemon can not write until a client program is listening.
> +Both named pipes and pseudo-ttys have internal buffers.

So what is wrong with internal buffers?  Named pipes have been around
for a long time, they should be able to be used much like this, right?

> +Proxy will succeed on a write of zero bytes.  A zero byte write
> +gives the client an EOF.  The daemon in the example above would
> +use a zero byte write in the last command after it had written the
> +number of steps remaining.  No other IPC mechanism can close one
> +side of a device and leave the other side open.

No "direct" IPC, but you can always emulate this just fine with existing
IPC mechanisms.

> +Proxy works well with select(), an important feature for daemons.
> +In contrast, the FUSE filesystem has some issues with select() on
> +the client side.

What are those issues?  Why not just fix them?

Adding a new IPC function to the kernel should not be burried down in
drivers/char/.  We have 10+ different IPC mechanisms already, some
simple, some more complex.  Are you _sure_ none of the existing ones
will not work for you?  Maybe a simple userspace library that wraps the
existing mechanisms would be better (no kernel changes needed, portable
to any kernel release, etc.)?

thanks,

greg k-h
