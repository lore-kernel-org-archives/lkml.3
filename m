Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaIRIWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:22:42 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60161 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaIRIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:22:12 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 18 Sep 2014 10:19:59 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
Message-ID: <20140918081959.GH20727@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
 <1410290686-6680-3-git-send-email-octavian.purdila@intel.com>
 <20140917094445.GG20727@localhost>
 <CAE1zotJt+Eq7dCaWgFUV_=tXvHL=nExW-KeL3gzTUEgqu8AX9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJt+Eq7dCaWgFUV_=tXvHL=nExW-KeL3gzTUEgqu8AX9Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:07:51PM +0300, Octavian Purdila wrote:
> On Wed, Sep 17, 2014 at 12:44 PM, Johan Hovold <johan@kernel.org> wrote:
> 
> <snip>
> 
> >> +     /*
> >> +      * Buffer to hold the packet for read or write transfers. One
> >> +      * is enough since we can't have multiple transfers in
> >> +      * parallel on the i2c adapter.
> >> +      */
> >> +     union {
> >> +             struct {
> >> +                     u8 port;
> >> +                     u8 addr;
> >> +                     u8 mem_addr_len;
> >> +                     __le32 mem_addr;
> >> +                     __le16 buf_len;
> >> +                     u8 buf[DLN2_I2C_MAX_XFER_SIZE];
> >> +             } __packed tx;
> >> +             struct {
> >> +                     __le16 buf_len;
> >> +                     u8 buf[DLN2_I2C_MAX_XFER_SIZE];
> >> +             } __packed rx;
> >> +     } buf;
> >
> > While this works in this case due to the extra copy you do in
> > dln2_transfer, allocating buffers that would (generally) be used for DMA
> > transfers as part of a larger structure is a recipe for trouble.
> >
> > It's probably better to allocate separately, if only to prevent people
> > from thinking there might be a bug here.
> >
> 
> Just to make sure I understand this, what could the issues be? The
> buffers not being aligned or not allocated in continuous physical
> memory?

Yes, the buffer (and any subsequent field) would have to be cache-line
aligned to avoid corruption due to cache-line sharing on some systems.

> <snip>
> 
> >> +
> >> +     rx_buf_len = le16_to_cpu(dln2->buf.rx.buf_len);
> >> +     if (rx_len < rx_buf_len + sizeof(dln2->buf.rx.buf_len))
> >> +             return -EPROTO;
> >> +
> >> +     if (data_len > rx_buf_len)
> >> +             data_len = rx_buf_len;
> >
> > You're still not checking that the received data does not overflow the
> > supplied buffer as I already commented on v3.
> >
> >> +
> >> +     memcpy(data, dln2->buf.rx.buf, data_len);
> >> +
> >> +     return data_len;
> >> +}
> 
> Hmm, perhaps I am missing something, but we never transfer more then
> data_len, where data_len is the size of the buffer supplied by the
> user.

That is the amount of data you request from the device, but you never
check how much is actually returned.

You really should clean up the error handling of this function as it is
currently not very readable.

> <snip>
> 
> >> +
> >> +     platform_set_drvdata(pdev, dln2);
> >> +
> >> +     ret = device_create_file(dev, &dev_attr_freq);
> >> +     if (ret < 0) {
> >> +             dev_err(dev, "failed to add freq attribute\n");
> >> +             return ret;
> >> +     }
> >
> > There are a couple of problems here. First, you should not make this an
> > attribute of the platform device, which is created before any driver is
> > bound (might not ever happen).
> >
> > Instead add the attribute to the i2c adapter below. However, you need to
> > do this using device attribute groups to avoid racing with userspace (as
> > you are when using device_create_file after the device itself has been
> > created).
> >
> > You should probably also make your attribute name less generic by adding
> > a "dln2_"-prefix.
> 
> Thanks for the detailed review and explanations, as always :)

You're welcome.

Johan
