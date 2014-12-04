Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbaLDSL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:11:58 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51302 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaLDSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:11:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+LLYWJyhpe4zVQWgg1xbpg
Date: Thu, 4 Dec 2014 10:09:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] i2c: omap: fix buffer overruns during RX/TX data
 processing
Message-ID: <20141204180946.GG2817@atomide.com>
References: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
 <1417294803-14729-2-git-send-email-al.kochet@gmail.com>
 <20141201195841.GD2817@atomide.com>
 <B3F4FEFF-2333-473D-8A35-7D4EF1C44D90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B3F4FEFF-2333-473D-8A35-7D4EF1C44D90@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141202 03:19]:
> 
> 01 дек. 2014 г., в 22:58, Tony Lindgren <tony@atomide.com> написал(а):
> 
> > I think this is a different issue than what I'm seeing.
> 
> Hello, Tony!
> 
> Thank you for testing!
> 
> Could check i2c-omap.c from commit ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4.
> As all my changes comes after it[1]. So I can understand was the problem before my work.

The issue I'm seeing on 2430sdp is some earlier regression that
has started happening over the past year or so. No idea when
though as it sometimes works and sometimes does not. So it does
not have anything to do with your patches.
 
> I there was no problems, then try with my first commit:
> 27caca9d2e01c92b26d0690f065aad093fea01c7
> 
> The problems you talk about is this?
> [    9.675994] omap_i2c 48072000.i2c: controller timed out
> [   10.704010] omap_i2c 48072000.i2c: controller timed out
> [   11.734069] omap_i2c 48072000.i2c: controller timed out
> root@omap2430sdp:/# [   12.823638] omap_i2c 48072000.i2c: controller timed out

No, I'm seeing just this:

omap_i2c 48070000.i2c: bus 0 rev3.3 at 100 kHz
omap_i2c 48072000.i2c: bus 1 rev3.3 at 100 kHz
twl 1-0048: PIH (irq 216) chaining IRQs 217..225
twl 1-0048: power (irq 222) chaining IRQs 225..232

And the system just hangs. With i2c-omap debug enabled, the lines
around the twl are:

omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
twl 1-0048: PIH (irq 216) chaining IRQs 217..225
twl 1-0048: power (irq 222) chaining IRQs 225..232
omap_i2c 48072000.i2c: addr: 0x0049, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x0049, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x0049, len: 2, flags: 0x0, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x0049, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x0049, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 2, flags: 0x0, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)

And then it hangs. In the working case, the output continues with:

omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
twl 1-0048: PIH (irq 216) chaining IRQs 217..225
twl 1-0048: power (irq 222) chaining IRQs 225..232
omap_i2c 48072000.i2c: addr: 0x0049, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x0049, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x0049, len: 2, flags: 0x0, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 2, flags: 0x0, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 2, flags: 0x0, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x0, stop: 0
omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
omap_i2c 48072000.i2c: addr: 0x004b, len: 1, flags: 0x1, stop: 1
omap_i2c 48072000.i2c: IRQ (ISR = 0x0008)
omap_i2c 48072000.i2c: IRQ (ISR = 0x0004)
...


 
> And how it is possible to switch from ti,omap2430-i2c to ti,omap2420-i2c?
> They are so different IP, from the driver point of view. They have different
> data bus width.

Yes sorry, you're right. Downgrading it to  ti,omap2420-i2c just
seems to quiet down the errors as the I2C then does not work
at all :)

Of course the issue I'm seeing could be caused by hung twl4030
PMIC too.

Regards,

Tony

 
> Alexander.
> 
> [1]
> alexander@ubuntu:busses$ git log --pretty=oneline --reverse ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4^..HEAD -- i2c-omap.c 
> ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4 i2c: remove FSF address
> 27caca9d2e01c92b26d0690f065aad093fea01c7 i2c: omap: fix NACK and Arbitration Lost irq handling
> 854a59425a0b9600ee974b113aae081c873163f6 i2c: omap: cleanup register definitions
> 903c3859f77f9b0aace551da03267ef7a211dbc4 i2c: omap: implement workaround for handling invalid BB-bit values
> 80cc361f14e8fa97119afa3324c2c913915e7252 i2c: omap: don't reset controller if Arbitration Lost detected
> 39370ab406933efdedb425910f0a36c16667c45f i2c: omap: add notes related to i2c multimaster mode
> ccfc866356674cb3a61829d239c685af6e85f197 i2c: omap: fix i207 errata handling
> 7d168dc7ed384e50bb7bff4920b73550fd2e9fcb Merge branch 'i2c/for-3.19' into i2c/for-next
> 2f769d173f0e6a2e85d75fe396f18f794fc4a615 omap: i2c: don't check bus state IP rev3.3 and earlier
> 2b6f66d87b44aaf1f34f071e6f6430c3ccaa8812 i2c: omap: fix buffer overruns during RX/TX data processing
> 30c52545106785405856c7e7e40b683b79c8084a i2c: omap: show that the reason of system lockup is an unhandled ISR event
> 
> 
