Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3LMPsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:48:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22766 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752719Ab3LMPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:48:16 -0500
Date: Fri, 13 Dec 2013 10:48:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Howells <dhowells@redhat.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Message-ID: <20131213104806.4fb56012@gandalf.local.home>
In-Reply-To: <20131213163349.4bc686c0@endymion.delvare>
References: <20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
	<20131213163349.4bc686c0@endymion.delvare>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 16:33:49 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Hi David,
> 
> Please note that I am no longer maintaining the i2c subsystem so you
> should have sent this to Wolfram, not me.
> 
> On Fri, 13 Dec 2013 14:26:27 +0000, David Howells wrote:
> > Add tracepoints into the I2C and SMBUS message transfer functions to retrieve
> > the message sent or received.  The following config options must be turned on
> > to make use of the facility:
> > 
> > 	CONFIG_FTRACE
> > 	CONFIG_ENABLE_DEFAULT_TRACERS
> > 
> > The I2C tracepoint can be enabled thusly:
> > 
> > 	echo 1 >/sys/kernel/debug/tracing/events/i2c/i2c_transfer/enable
> > 
> > and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
> > that look like:
> > 
> >         ... i2c_transfer: i2c-5 f=00 a=44 l=6 ret=1 [021433000000]
> > 
> > formatted as:
> > 
> > 	i2c-<adapter-nr>
> > 	f=<flags>
> > 	a=<addr>
> > 	l=<datalen>
> > 	ret=<result>
> > 	[<data>]
> > 
> > (Bit 0 of the flags is set if this was a read and clear if it was a write).
> 
> Wouldn't the traces be more readable if the direction was written
> explicitly as R or W?

We can easily do that by adding in the TP_printk()

	".. (%s) ..", ..., __entry->flags & 1 ? "R" : "W", ...

> 
> > 
> > 
> > The SMBUS tracepoint can be enabled thusly:
> > 
> > 	echo 1 >/sys/kernel/debug/tracing/events/i2c/smbus_transfer/enable
> > 
> > and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
> > that look like:
> > 
> > 	... smbus_transfer: i2c-0 f=00 a=51 r=1 c=0 p=2 res=0 [80ff0100000000000000800c693d0088ffffb83aee3b0088ffff0100000000000000]
> > 
> > formatted as:
> > 
> > 	i2c-<adapter-nr>
> > 	f=<flags>
> > 	a=<addr>
> > 	r=<read_write>
> 
> Here too I would consider R and W as more readable than r=1 and r=0.

Same thing can be done here.

> 
> > 	c=<command>
> > 	p=<protocol>
> 
> Would it be possible to print this as a string rather than a number?
> The protocol numbers are completely arbitrary, so the reader would have
> to open i2c.h each time to figure out what is what.

That can be done in the TP_printk() with:

	".. %s ..", ..,
	__print_symbolic(__entry->protocol,
		{ I2C_SMBUS_QUICK	,	"QUICK"	},
		{ I2C_SMBUS_BYTE	,	"BYTE"	},
		{ I2C_SMBUS_BYTE_DATA	,	"BYTE_DATA" },
		[...]
		{ I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA"}), ...


> 
> > 	res=<result>
> > 	[<data-block>]
> > 
> > 
> > In both cases, the adapters to be traced can be selected by something like:
> > 
> > 	echo adapter_nr==1 >/sys/kernel/debug/tracing/events/i2c/{i2c,smbus}_transfer/filter
> 
> I have no objection to the feature, but it should be noted that
> i2c-core already offers something similar (albeit less flexible) for
> I2C level transfers:
> 
> #ifdef DEBUG
> 		for (ret = 0; ret < num; ret++) {
> 			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, "
> 				"len=%d%s\n", ret, (msgs[ret].flags & I2C_M_RD)
> 				? 'R' : 'W', msgs[ret].addr, msgs[ret].len,
> 				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");
> 		}
> #endif
> 
> If your code goes in, I suppose the code above should be removed to
> avoid redundancy.
> 
> One significant difference between both implementations is that the old
> one logs before the actual transfer, while yours logs afterward. While I
> understand this allows you to log the result of the transfer, this also
> means you'll miss the log if the actual transaction locks the system
> (we've seen this before.) Something to think about...
> 

Note, as this is being added to the trace system, one can use function
tracing to see if this is causing the crash. Yeah, you wont be able to
see what the transfer packet was, but you can use kprobes to help there
too.

-- Steve
