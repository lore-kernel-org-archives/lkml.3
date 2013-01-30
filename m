Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3A3Ryp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:54:45 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:16336 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab3A3Ryn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:54:43 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1359568472!12062889!32
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Wed, 30 Jan 2013 11:54:34 -0600
Subject: RE: [Q]staging/comedi: Considation of *_find_boardinfo possible?
Thread-Topic: [Q]staging/comedi: Considation of *_find_boardinfo possible?
Thread-Index: Ac3+2ZDSvOpUQrhDSme9l7LFmurbSAANRLTA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A707B521@AUSP01VMBX24.collaborationhost.net>
References: <201301300041.36064.PeterHuewe@gmx.de>
 <ADE657CA350FB648AAC2C43247A983F00207A707B3C8@AUSP01VMBX24.collaborationhost.net>
 <5108FE31.8020107@mev.co.uk>
In-Reply-To: <5108FE31.8020107@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 30, 2013 4:04 AM, Ian Abbott wrote:
> One way is to enumerate the possible indices of the custom board array 
> as a set of enum constants, initialize the custom board array using 
> designated element initializers (indexed by the enum constants) and 
> include the same enum constant in the 'driver_data' member of the struct 
> pci_device_id elements of the module's PCI device table.  Then the 
> module's PCI driver's probe function can index directly into the custom 
> board array without searching.

Ian,

The method you describe is what I was also considering. The only
problem is it will introduce a lot of churn in the drivers.

I'm hoping to eliminate all the unnecessary boardinfo's from the
drivers before going down this path.

> The missing link in the above is passing the index from the 
> 'driver_data' through to the modules' comedi_driver's 'auto_attach' 
> function. The 'comedi_pci_auto_config()' function does not currently 
> have a parameter for passing this information, but the underlying 
> 'comedi_auto_config()' function does.  Either the existing 
> 'comedi_pci_auto_config()' function could be extended, or a separate 
> extended version of the function could be added (maybe as an inline 
> function in comedidev.h), or the modules could call 
> 'comedi_auto_config()' directly.
>
> We have posted patches to add extra context to 
> 'comedi_pci_auto_config()' before, but they weren't applied because we 
> didn't have a clear use case for them.  Now we have, but I wouldn't mind 
> leaving the existing function alone and adding a new one.

Yah, that was the intention of my patches. They just weren't clear. Also,
my patches changed the type on the 'context' which appears to not be
needed.

> The nice thing is that it's all under the control of the individual drivers.
>
> Here's some code to illustrate what I'm on about in the above description:
>
> struct foobar_board {
>	const char *name;
>	unsigned int ai_chans;
>	unsigned int ai_bits;
> };

I would also like to make a common "boardinfo" struct that the comedi
core can then use in the comedi_recognize() and comedi_report_boards()
functions to remove the need for the pointer math. Something like:

struct comedi_board {
	const char *name;
	const void *private;
};

The comedi_driver then could be changed to:

+	const struct comedi_board *boards;
-	/* number of elements in board_name and board_id arrays */
-	unsigned int num_names;
-	const char *const *board_name;
-	/* offset in bytes from one board name pointer to the next */
-	int offset;
};

The board_ptr in comedi_device would then change to:

+	const struct comedi_board *board_ptr;
-	const void *board_ptr;

The comedi_board() helper would also need changed:

static inline const void *comedi_board(const struct comedi_device *dev)
{
+	return (dev->board_ptr) ? dev->board_ptr->private : NULL;
-	return dev->board_ptr;
}

It still returns the driver specific boardinfo as a const void *.

The common comedi_board would also allow removing the board_name
from the comedi_device. A helper function could just fetch it:

static const char *comedi_board_name(struct comedi_device *dev)
{
	return (dev->board_ptr) ? dev->board_ptr->name : dev->driver->driver_name;
}

> enum foobar_board_nums {
>	bn_foo,
>	bn_bar,
>	bn_baz
> };
>
> static const struct foobar_board foobar_boards[] = {
>	[bn_foo] = {
>		.name = "foo",
>		.ai_chans = 4,
>		.ai_bits = 12,
>	},
>	[bn_bar] = {
>		.name = "bar",
>		.ai_chans = 4,
>		.ai_bits = 16,
>	},
>	[bn_baz] = {
>		.name = "baz",
>		.ai_chans = 8,
>		.ai_bits = 16,
>	},
> };

Using the common comedi_board would change this a bit:

static const struct foobar_board[] = {
	[bn_foo] = {
		.ai_chans = 4,
		.ai_bits = 12,
	},
	[bn_bar] = {
		.ai_chans = 4,
		.ai_bits = 16,
	},
	[bn_baz] = {
		.ai_chans = 8,
		.ai_bits = 16,
	},
};

static const struct comedi_board foobar_boards[] = {
	[bn_foo] = {
		.name = "foo",
		.private = &foorbar_info[bn_foo],
	},
	[bn_bar] = {
		.name = "bar",
		.private = &foorbar_info[bn_bar],
	},
	[bn_baz] = {
		.name = "baz",
		.private = &foorbar_info[bn_baz],
	},
};

Any other "common" information that the comedi core needs to
access could be added to comedi_board. All the driver specific
information stays in the private struct.

> static int foobar_auto_attach(struct comedi_device *dev,
> 			      unsigned long context_bn)
> {
>	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
>	struct foobar_board *thisboard = &foobar_boards[bn_foo];
>
>	dev->board_ptr = thisboard;	/* no searching! */

The dev->board_ptr should just be set in the comedi core before
calling the drivers auto_attach. Something like:

		comedi_set_hw_dev(comedi_dev, hardware_device);
		comedi_dev->driver = driver;
+		if (driver->boards)
+			comedi_dev->board_ptr = &driver->boards[context];
		ret = driver->auto_attach(comedi_dev, context);

Actually, if we go this route, the context should not be required in the
auto_attach since the core has already taken care of it.

Basically, once the auto_attach is called the comedi_device already has
the following fields initialized correctly:

driver		points to the comedi_driver
hw_dev	points to the underlying device (pci/usb/pcmcia/etc.)
board_name	no longer needed
board_ptr	points to the correct comedi_board 'context'

Other than that, the rest of your code follows what I'm thinking.

Opinion?

Regards,
Hartley

