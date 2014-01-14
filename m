Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaANOPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:15:38 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37070 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaANOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:15:32 -0500
Date: Tue, 14 Jan 2014 14:15:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: rogerable@realtek.com, Samuel Ortiz <sameo@linux.intel.com>,
        Alex Dubov <oakad@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        Chris Ball <cjb@laptop.org>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140114141523.GC11820@lee--X1>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
 <20140114130409.GB11820@lee--X1>
 <20140114134634.GM7444@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140114134634.GM7444@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ Sorry, I am coming down with the flu today so I'm doing dorky things
>   like reviewing review comments.  I'm not sure how coherent I am.  ]

Always welcome.

NB: I did this review in double-quick time, which may account for some
of the weird thought processes (or lack there of).

> > > +static void rtsx_usb_sg_timed_out(unsigned long data)
> > > +{
> > > +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)data;
> > 
> > What's going to happen when your device runs 64bit?
> > 
> 
> I'm not sure I understand what you mean here.  On linux sizeof(long) is
> always the same as sizeof(void *).

I had an odd moment where I thought we'd need long long for 64bit.

Nevermind.

> > > +	if (cmd_len > IOBUF_SIZE)
> > > +		return -EINVAL;
> > > +
> > > +	if (cmd_len % 4)
> > > +		cmd_len += (4 - cmd_len % 4);
> > 
> > Please document in a comment.
> 
> There is a kernel macro for this:
> 
> 	cmd_len = ALIGN(cmd_len, 4);
> 
> 	if (cmd_len > IOBUF_SIZE)
> 		return -EINVAL;

I had a feeling this was the intention, hence why I was asking for a
comment. But yes, if all this is doing is alignment then the kernel
macro is preferred.

> > > +
> > > +
> > 
> > Extra '/n'
> > 
> 
> It weirds me out when you mix up '\n' and /n'.

Typos happen on occasion...

> > > +int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
> > > +		u8 mask, u8 data)
> > > +{
> > > +	u16 value = 0, index = 0;
> > > +
> > > +	value |= 0x03 << 14;
> > > +	value |= addr & 0x3FFF;
> > > +	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
> > > +	index |= (u16)mask;
> > > +	index |= (u16)data << 8;
> > 
> > Lots of random numbers here, please #define for clarity and ease of
> > reading.
> > 
> 
> The only really random number is the 0x03, but yeah, it would help if
> that we a define.

See ---^

As I say, I just glossed over the code, thus didn't spend the time to
work out the arithmetic. Now I do, most of it is pretty self
explanatory. I would also like to see the SHIFT #defined, although
this may become superfluous once the 0x03 is clarified.

> 	addr |= 0x03 << 14;
> 
> 	value = __swab16(addr);
> 	index = mask | (data << 8);

This is 100% better/clearer.

> > > +
> > > +	dev_dbg(&intf->dev,
> > > +		": Realtek USB Card Reader found at bus %03d address %03d\n",
> > > +		 usb_dev->bus->busnum, usb_dev->devnum);
> > > +
> > > +	ucr = kzalloc(sizeof(struct rtsx_ucr), GFP_KERNEL);
> > 
> > s/struct rtsx_ucr/*ucr/
> > 
> > Any reason for not using managed resources?
> > 
> Roger, he means the devm_kzalloc().

That I do.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
