Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaHFJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:50:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38542 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754317AbaHFJu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:50:26 -0400
Date: Wed, 6 Aug 2014 10:50:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140806095012.GN30282@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int> <20140626140115.GQ32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int> <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140627112151.GF32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int> <20140627163108.GP32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 01:31:29PM +0000, Mattis Lorentzon wrote:
> We have applied your V2 patch set of 30 patches on top of v3.16-rc2 and are
> currently running some stability tests.
> 
> During our first test round we triggered a timeout which caused the fec driver
> to become unresponsive for several minutes. The attached backtrace was
> shown when the hardware was rebooted.

What is on the other end of the link?

> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 dev_watchdog+0x270/0x27c()
> NETDEV WATCHDOG: eth0 (fec): transmit queue 0 timed out
...
> fec 2188000.ethernet eth0: TX ring dump
> Nr     SC     addr       len  SKB
>   0    0x1c00 0x00000000   66   (null)
...
>  83    0x1c00 0x00000000   66   (null)
>  84  H 0x1c00 0x00000000   66   (null)
>  85    0x9c00 0x2e205000   66 9e384f00
>  86    0x1c00 0x2e204800   66 9e384d80
>  87    0x1c00 0x2e204000   66 9e384180
...
> 376    0x1c00 0x2e252800   66 81cf6180
> 377    0x1c00 0x2e253000   66 81cf6240
> 378 S  0x1c00 0x00000000   66   (null)

So, the software would insert the next packet into slot 378.  However,
the slots from 85 to 377 have not been reaped, despite those in 86 to
377 allegedly having been sent.  This is because the entry in slot 85
shows that it has yet to be sent.

I've no idea what causes this; it looks like there's something screwed
with the hardware which causes the transmitter to skip an entry in the
ring under certain circumstances.  As I've never been able to reproduce
it here, I've not been able to investigate it.

What I would like to do is to stamp each packet in some way with an
identifier marking its ring position, and then monitor the network to
find out whether the packet at slot 85 was actually transmitted - that's
made slightly harder because packets may be dropped at the receiver
when operating in promisc mode.  This would then allow us to work out
some likely causes.

Note that after the transmit watchdog, the interface should recover and
start operating normally again - and that should not take "several
minutes."

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
