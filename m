Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3LMPeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:34:04 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46023 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab3LMPeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:34:02 -0500
Date: Fri, 13 Dec 2013 16:33:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-i2c@vger.kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Message-ID: <20131213163349.4bc686c0@endymion.delvare>
In-Reply-To: <20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
References: <20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Please note that I am no longer maintaining the i2c subsystem so you
should have sent this to Wolfram, not me.

On Fri, 13 Dec 2013 14:26:27 +0000, David Howells wrote:
> Add tracepoints into the I2C and SMBUS message transfer functions to retrieve
> the message sent or received.  The following config options must be turned on
> to make use of the facility:
> 
> 	CONFIG_FTRACE
> 	CONFIG_ENABLE_DEFAULT_TRACERS
> 
> The I2C tracepoint can be enabled thusly:
> 
> 	echo 1 >/sys/kernel/debug/tracing/events/i2c/i2c_transfer/enable
> 
> and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
> that look like:
> 
>         ... i2c_transfer: i2c-5 f=00 a=44 l=6 ret=1 [021433000000]
> 
> formatted as:
> 
> 	i2c-<adapter-nr>
> 	f=<flags>
> 	a=<addr>
> 	l=<datalen>
> 	ret=<result>
> 	[<data>]
> 
> (Bit 0 of the flags is set if this was a read and clear if it was a write).

Wouldn't the traces be more readable if the direction was written
explicitly as R or W?

> 
> 
> The SMBUS tracepoint can be enabled thusly:
> 
> 	echo 1 >/sys/kernel/debug/tracing/events/i2c/smbus_transfer/enable
> 
> and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
> that look like:
> 
> 	... smbus_transfer: i2c-0 f=00 a=51 r=1 c=0 p=2 res=0 [80ff0100000000000000800c693d0088ffffb83aee3b0088ffff0100000000000000]
> 
> formatted as:
> 
> 	i2c-<adapter-nr>
> 	f=<flags>
> 	a=<addr>
> 	r=<read_write>

Here too I would consider R and W as more readable than r=1 and r=0.

> 	c=<command>
> 	p=<protocol>

Would it be possible to print this as a string rather than a number?
The protocol numbers are completely arbitrary, so the reader would have
to open i2c.h each time to figure out what is what.

> 	res=<result>
> 	[<data-block>]
> 
> 
> In both cases, the adapters to be traced can be selected by something like:
> 
> 	echo adapter_nr==1 >/sys/kernel/debug/tracing/events/i2c/{i2c,smbus}_transfer/filter

I have no objection to the feature, but it should be noted that
i2c-core already offers something similar (albeit less flexible) for
I2C level transfers:

#ifdef DEBUG
		for (ret = 0; ret < num; ret++) {
			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, "
				"len=%d%s\n", ret, (msgs[ret].flags & I2C_M_RD)
				? 'R' : 'W', msgs[ret].addr, msgs[ret].len,
				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");
		}
#endif

If your code goes in, I suppose the code above should be removed to
avoid redundancy.

One significant difference between both implementations is that the old
one logs before the actual transfer, while yours logs afterward. While I
understand this allows you to log the result of the transfer, this also
means you'll miss the log if the actual transaction locks the system
(we've seen this before.) Something to think about...

-- 
Jean Delvare
