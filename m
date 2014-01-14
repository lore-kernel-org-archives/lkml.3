Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaANNrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:47:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANNrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:47:02 -0500
Date: Tue, 14 Jan 2014 16:46:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: rogerable@realtek.com, Samuel Ortiz <sameo@linux.intel.com>,
        Alex Dubov <oakad@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        Chris Ball <cjb@laptop.org>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140114134634.GM7444@mwanda>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
 <20140114130409.GB11820@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114130409.GB11820@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry, I am coming down with the flu today so I'm doing dorky things
  like reviewing review comments.  I'm not sure how coherent I am.  ]

On Tue, Jan 14, 2014 at 01:04:09PM +0000, Lee Jones wrote:
 
> > +static void rtsx_usb_sg_timed_out(unsigned long data)
> > +{
> > +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)data;
> 
> What's going to happen when your device runs 64bit?
> 

I'm not sure I understand what you mean here.  On linux sizeof(long) is
always the same as sizeof(void *).


> > +	if (cmd_len > IOBUF_SIZE)
> > +		return -EINVAL;
> > +
> > +	if (cmd_len % 4)
> > +		cmd_len += (4 - cmd_len % 4);
> 
> Please document in a comment.

There is a kernel macro for this:

	cmd_len = ALIGN(cmd_len, 4);

	if (cmd_len > IOBUF_SIZE)
		return -EINVAL;

> 
> > +
> > +
> 
> Extra '/n'
> 

It weirds me out when you mix up '\n' and /n'.

> > +int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
> > +		u8 mask, u8 data)
> > +{
> > +	u16 value = 0, index = 0;
> > +
> > +	value |= 0x03 << 14;
> > +	value |= addr & 0x3FFF;
> > +	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
> > +	index |= (u16)mask;
> > +	index |= (u16)data << 8;
> 
> Lots of random numbers here, please #define for clarity and ease of
> reading.
> 

The only really random number is the 0x03, but yeah, it would help if
that we a define.

	addr |= 0x03 << 14;

	value = __swab16(addr);
	index = mask | (data << 8);

> > +
> > +	dev_dbg(&intf->dev,
> > +		": Realtek USB Card Reader found at bus %03d address %03d\n",
> > +		 usb_dev->bus->busnum, usb_dev->devnum);
> > +
> > +	ucr = kzalloc(sizeof(struct rtsx_ucr), GFP_KERNEL);
> 
> s/struct rtsx_ucr/*ucr/
> 
> Any reason for not using managed resources?
> 

Roger, he means the devm_kzalloc().

regards,
dan carpenter
