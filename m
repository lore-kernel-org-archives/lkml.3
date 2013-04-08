Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415Ab3DHPGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:06:17 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38514 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab3DHPGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:06:13 -0400
Date: Mon, 8 Apr 2013 08:06:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [BUG] increased us/sys-load due to tty-layer in 2.6.38+ ?!
Message-ID: <20130408150611.GB13824@kroah.com>
References: <20130408092558.GD25003@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408092558.GD25003@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:25:58AM +0200, Steffen Trumtrar wrote:
> Hi!
> 
> I noticed a problem with the tty subsystem on ARM. Starting with 2.6.38+ load
> on the serial connection causes a 10-15% increase in system/userspace load.
> This doesn't change up to v3.9-rc4.
> 
> The following setup was used:
> 
>   telnet && screen microcom -p /dev/ttyUSB0
>         |                           +--------+
>         |-------------->------------|----+   |
>     +-------+<---------<------------|----+   |
>     |       |       +------+        |        |
>     |  UUT  |<-USB->| FTDI |<-UART->|        |
>     |       |       +------+        |   PC   |
>     +-------+                       +--------+
>         ^
>         |
>   telnet && top -d1
> 
> The unit under test (UUT) is connected via USB->FTDI->UART to a PC. On the PC
> a "while true; do find /; done" produces some random output.
> I connect to the UUT via telnet and then open a serial connection to the PC
> in a screen session, seeing the output produced on the PC. Then screen gets
> detached. So, basically, what I'm trying to do is producing load only on the
> USB->FTDI->UART connection and not on the UUT itself.
> Then another telnet connection is opened, to monitor the UUT with "top -d1".
> As UUT an imx27, kirkwood and an AT91 were used.
> 
> To find the "offending" code, I bisected v2.6.38..v3.0 which gave the following
> top output (non-scientifically, I know. But the switch in load distribution is
> obvious nevertheless):
> 
> 2.6.38           Cpu(s):  3.8%us,  1.9%sy,  0.0%ni, 94.3%id
> 2.6.38+          Cpu(s):  1.9%us,  3.8%sy,  0.0%ni, 94.3%id
> last good commit Cpu(s):  1.9%us,  2.8%sy,  0.0%ni, 95.3%id
> first bad commit Cpu(s):  4.8%us, 14.5%sy,  0.0%ni, 80.6%id
> 2.6.39-rc4       Cpu(s): 10.5%us,  8.9%sy,  0.0%ni, 79.8%id
> 3.0              Cpu(s): 15.9%us, 19.6%sy,  0.0%ni, 62.3%id
> 
> This resulted in
>         f23eb2b2b28547fc70df82dd5049eb39bec5ba12
>         tty: stop using "delayed_work" in the tty layer
> 
> as possible cause. Reverting this commit by hand in v3.8 showed a load distribution
> similar to 2.6.38.
> What I haven't done, is measure if the load is really increasing or if top only
> tells me so. Maybe the algorithm to calculate this somehow produces different
> results because of the switch from schedule_delayed_work to schedule_work?
> So, is this a bug, a feature, a symptom,...?

It's a "fake" load (i.e. no extra cpu is being used, just a "busy" wait
is happening.)

You should see an increased throughput with that patch applied, have you
tested a real workload?

greg k-h
