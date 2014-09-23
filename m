Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaIWO1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:27:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40650 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751755AbaIWO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:26:58 -0400
Date: Tue, 23 Sep 2014 10:26:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Scot Doyle <lkml14@scotdoyle.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: core: downgrade log severity to info when descriptor
 missing
In-Reply-To: <alpine.DEB.2.11.1409222012230.1839@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1409231021190.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Scot Doyle wrote:

> According to commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0
>     USB: fix LANGID=0 regression
> 
> usb devices are not required to report string descriptors. Since they are
> optional, log an info message instead of an error message. In addition,
> use a higher level info message while moving the details to a debug message.
> 
> Tested with USB device 0930:021c.

This is a good description, but it's not what the patch actually does.

> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> ---
>  drivers/usb/core/message.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index 0c8a7fc..6b95de7 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -766,7 +766,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
> 
>  	/* If the string was reported but is malformed, default to english
>  	 * (0x0409) */
> -	if (err == -ENODATA || (err > 0 && err < 4)) {
> +	if (err > 0 && err < 4) {

Why treat ENODATA as a separate case?  It's just like the others -- the 
device returned some data, but the data was malformed.

If the device really does not support string descriptors at all, err
would be equal to -EPIPE.

>  		dev->string_langid = 0x0409;
>  		dev->have_langid = 1;
>  		dev_err(&dev->dev,
> @@ -776,6 +776,18 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
>  		return 0;
>  	}
> 
> +	/* If the string was unavailable, default to english (0x0409) */

-ENODATA doesn't mean the string was unavailable.  It means that the
second byte of the reply was different from USB_DT_STRING, i.e., the
reply was malformed.

> +	if (err == -ENODATA) {
> +		dev->string_langid = 0x0409;
> +		dev->have_langid = 1;
> +		dev_info(&dev->dev,
> +			"no string descriptor language, defaulting to English");
> +		dev_dbg(&dev->dev,
> +			"string descriptor 0 unavailable (err = -ENODATA), "
> +			"defaulting to 0x%04x\n", dev->string_langid);
> +		return 0;
> +	}

Therefore this section is completely unnecessary.

> +
>  	/* In case of all other errors, we assume the device is not able to
>  	 * deal with strings at all. Set string_langid to -1 in order to
>  	 * prevent any string to be retrieved from the device */

And down here is where you should call either dev_info() or dev_err(), 
depending on whether err is equal to -EPIPE or something else.

Alan Stern

