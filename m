Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaIHMKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:10:32 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51627 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaIHMKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:10:30 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 8 Sep 2014 14:08:20 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140908120820.GB9560@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
 <1409930279-1382-2-git-send-email-octavian.purdila@intel.com>
 <20140908113233.GA9560@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908113233.GA9560@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:32:33PM +0200, Johan Hovold wrote:
> On Fri, Sep 05, 2014 at 06:17:57PM +0300, Octavian Purdila wrote:

> > +static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
> > +			  void *obuf, int obuf_len, void *ibuf, int *ibuf_len)
> > +{

<snip>

> > +	/* if we got here we know that the response header has been checked */
> > +	rsp = rxc->urb->transfer_buffer;
> > +	result = le16_to_cpu(rsp->result);
> 
> Yes, but you haven't verified that rsp->hdr.size > 0, so you may still
> be reading stale data.

I meant that you haven't verified that the payload size > 1 (the header
size is included in rsp->hdr.size and result is two byte wide).

> > +
> > +	if (result) {
> > +		dev_dbg(dev, "%d received response with error %d\n",
> > +			handle, result);
> > +		ret = -EREMOTEIO;
> > +		goto out_free_rx_slot;
> > +	}
> > +
> > +	if (!ibuf) {
> > +		ret = 0;
> > +		goto out_free_rx_slot;
> > +	}
> > +
> > +	if (*ibuf_len > rxc->urb->actual_length - sizeof(*rsp))
> > +		*ibuf_len = rxc->urb->actual_length - sizeof(*rsp);
> 
> And then you get an underflow here, although that doesn't seem to cause
> any troubles in this case.

Unless ibuf_len is -1... 

> But why isn't ibuf_len unsigned?
>
> > +
> > +	memcpy(ibuf, rsp + 1, *ibuf_len);
> > +
> > +out_free_rx_slot:
> > +	free_rx_slot(dln2, rxs, rx_slot);
> > +
> > +	return ret;
> > +}

Johan
