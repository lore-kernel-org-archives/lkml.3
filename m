Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaADLX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 06:23:27 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:39109 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaADLXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 06:23:24 -0500
Date: Sat, 4 Jan 2014 12:23:41 +0100
From: Johan Hovold <jhovold@gmail.com>
To: kbuild test robot <fengguang.wu@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [usb:usb-next 50/92] drivers/usb/serial/pl2303.c:149
 pl2303_vendor_read() error: doing dma on the stack (buf)
Message-ID: <20140104112341.GA10004@localhost>
References: <52c72b83.q16oondgjy37AZvd%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52c72b83.q16oondgjy37AZvd%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 05:28:35AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-next
> head:   bd6383c81d5f33e01688a87c50a8d3a878aa43d5
> commit: 362eb02603be7bb835c47f2cf585954a5080449d [50/92] USB: pl2303: add error handling to vendor read and write functions
> 
> New smatch warnings:
> drivers/usb/serial/pl2303.c:149 pl2303_vendor_read() error: doing dma on the stack (buf)
>
> Old smatch warnings:
> drivers/usb/serial/pl2303.c:673 pl2303_ioctl() warn: check that 'ser' doesn't leak information (struct has a hole after 'iomem_reg_shift')
> 
> vim +149 drivers/usb/serial/pl2303.c
> 
> 8bf769eb Johan Hovold   2012-10-15  133  };
> 8bf769eb Johan Hovold   2012-10-15  134  
> ^1da177e Linus Torvalds 2005-04-16  135  struct pl2303_private {
> ^1da177e Linus Torvalds 2005-04-16  136  	spinlock_t lock;
> ^1da177e Linus Torvalds 2005-04-16  137  	u8 line_control;
> ^1da177e Linus Torvalds 2005-04-16  138  	u8 line_status;
> 623c8263 Johan Hovold   2013-12-29  139  
> 623c8263 Johan Hovold   2013-12-29  140  	u8 line_settings[7];
> ^1da177e Linus Torvalds 2005-04-16  141  };
> ^1da177e Linus Torvalds 2005-04-16  142  
> 362eb026 Johan Hovold   2013-12-29  143  static int pl2303_vendor_read(struct usb_serial *serial, u16 value,
> 362eb026 Johan Hovold   2013-12-29  144  							unsigned char buf[1])

This is a false positive. A pointer passed as an array is still just a
pointer (and in this case the buffer it points to is not on the stack).

Looks like smatch needs to be updated.

Thanks,
Johan

> eb44da0b Sarah Sharp    2007-12-14  145  {
> 362eb026 Johan Hovold   2013-12-29  146  	struct device *dev = &serial->interface->dev;
> ccfe8188 Johan Hovold   2013-12-29  147  	int res;
> ccfe8188 Johan Hovold   2013-12-29  148  
> ccfe8188 Johan Hovold   2013-12-29 @149  	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
> eb44da0b Sarah Sharp    2007-12-14  150  			VENDOR_READ_REQUEST, VENDOR_READ_REQUEST_TYPE,
> 362eb026 Johan Hovold   2013-12-29  151  			value, 0, buf, 1, 100);
> 362eb026 Johan Hovold   2013-12-29  152  	if (res != 1) {
> 362eb026 Johan Hovold   2013-12-29  153  		dev_err(dev, "%s - failed to read [%04x]: %d\n", __func__,
> 362eb026 Johan Hovold   2013-12-29  154  								value, res);
> 362eb026 Johan Hovold   2013-12-29  155  		if (res >= 0)
> 362eb026 Johan Hovold   2013-12-29  156  			res = -EIO;
> 362eb026 Johan Hovold   2013-12-29  157  
> 
> :::::: The code at line 149 was first introduced by commit
> :::::: ccfe8188a321f4039a7e52c8336bb4ff3ca35139 USB: pl2303: clean up driver somewhat
> 
> :::::: TO: Johan Hovold <jhovold@gmail.com>
> :::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
