Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3AaQnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:43:19 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:54010 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3AaQnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:43:17 -0500
Message-ID: <510A9F1E.2090403@mev.co.uk>
Date: Thu, 31 Jan 2013 16:43:10 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [Q]staging/comedi: Considation of *_find_boardinfo possible?
References: <201301300041.36064.PeterHuewe@gmx.de> <ADE657CA350FB648AAC2C43247A983F00207A707B3C8@AUSP01VMBX24.collaborationhost.net> <5108FE31.8020107@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F00207A707B521@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00207A707B521@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-30 17:54, H Hartley Sweeten wrote:
> On Wednesday, January 30, 2013 4:04 AM, Ian Abbott wrote:
>> Here's some code to illustrate what I'm on about in the above description:
>>
>> struct foobar_board {
>> 	const char *name;
>> 	unsigned int ai_chans;
>> 	unsigned int ai_bits;
>> };
>
> I would also like to make a common "boardinfo" struct that the comedi
> core can then use in the comedi_recognize() and comedi_report_boards()
> functions to remove the need for the pointer math. Something like:
>
> struct comedi_board {
> 	const char *name;
> 	const void *private;
> };
>
> The comedi_driver then could be changed to:
>
> +	const struct comedi_board *boards;
> -	/* number of elements in board_name and board_id arrays */
> -	unsigned int num_names;
> -	const char *const *board_name;
> -	/* offset in bytes from one board name pointer to the next */
> -	int offset;
> };

I think you'd still need the equivalent of num_names as the comedi core 
would need to know the length of the boards array.

I'm not excited about the idea of adding an extra layer of indirection 
to all the drivers for the sake of making a couple of functions in the 
core a little cleaner.  It was kind of done the way it is for the 
convenience of the driver in the first place.

> The board_ptr in comedi_device would then change to:
>
> +	const struct comedi_board *board_ptr;
> -	const void *board_ptr;
>
> The comedi_board() helper would also need changed:
>
> static inline const void *comedi_board(const struct comedi_device *dev)
> {
> +	return (dev->board_ptr) ? dev->board_ptr->private : NULL;
> -	return dev->board_ptr;
> }

...and probably renamed to avoid the confusion between comedi board and 
private board structures.

> It still returns the driver specific boardinfo as a const void *.
>
> The common comedi_board would also allow removing the board_name
> from the comedi_device. A helper function could just fetch it:
>
> static const char *comedi_board_name(struct comedi_device *dev)
> {
> 	return (dev->board_ptr) ? dev->board_ptr->name : dev->driver->driver_name;
> }
>
>> enum foobar_board_nums {
>> 	bn_foo,
>> 	bn_bar,
>> 	bn_baz
>> };
>>
>> static const struct foobar_board foobar_boards[] = {
>> 	[bn_foo] = {
>> 		.name = "foo",
>> 		.ai_chans = 4,
>> 		.ai_bits = 12,
>> 	},
>> 	[bn_bar] = {
>> 		.name = "bar",
>> 		.ai_chans = 4,
>> 		.ai_bits = 16,
>> 	},
>> 	[bn_baz] = {
>> 		.name = "baz",
>> 		.ai_chans = 8,
>> 		.ai_bits = 16,
>> 	},
>> };
>
> Using the common comedi_board would change this a bit:
>
> static const struct foobar_board[] = {
> 	[bn_foo] = {
> 		.ai_chans = 4,
> 		.ai_bits = 12,
> 	},
> 	[bn_bar] = {
> 		.ai_chans = 4,
> 		.ai_bits = 16,
> 	},
> 	[bn_baz] = {
> 		.ai_chans = 8,
> 		.ai_bits = 16,
> 	},
> };
>
> static const struct comedi_board foobar_boards[] = {
> 	[bn_foo] = {
> 		.name = "foo",
> 		.private = &foorbar_info[bn_foo],
> 	},
> 	[bn_bar] = {
> 		.name = "bar",
> 		.private = &foorbar_info[bn_bar],
> 	},
> 	[bn_baz] = {
> 		.name = "baz",
> 		.private = &foorbar_info[bn_baz],
> 	},
> };
>
> Any other "common" information that the comedi core needs to
> access could be added to comedi_board. All the driver specific
> information stays in the private struct.
>
>> static int foobar_auto_attach(struct comedi_device *dev,
>> 			      unsigned long context_bn)
>> {
>> 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
>> 	struct foobar_board *thisboard = &foobar_boards[bn_foo];
>>
>> 	dev->board_ptr = thisboard;	/* no searching! */
>
> The dev->board_ptr should just be set in the comedi core before
> calling the drivers auto_attach. Something like:
>
> 		comedi_set_hw_dev(comedi_dev, hardware_device);
> 		comedi_dev->driver = driver;
> +		if (driver->boards)
> +			comedi_dev->board_ptr = &driver->boards[context];
> 		ret = driver->auto_attach(comedi_dev, context);
>
> Actually, if we go this route, the context should not be required in the
> auto_attach since the core has already taken care of it.

The context should be under the control of the driver for its own 
nefarious purposes, not dictated by what the comedi core thinks it 
should be used for.

> Basically, once the auto_attach is called the comedi_device already has
> the following fields initialized correctly:
>
> driver		points to the comedi_driver
> hw_dev	points to the underlying device (pci/usb/pcmcia/etc.)
> board_name	no longer needed
> board_ptr	points to the correct comedi_board 'context'
>
> Other than that, the rest of your code follows what I'm thinking.
>
> Opinion?

Well I'm not keen!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
