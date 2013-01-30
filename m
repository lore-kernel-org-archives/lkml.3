Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3A3LE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:04:27 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:51696 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab3A3LEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:04:24 -0500
Message-ID: <5108FE31.8020107@mev.co.uk>
Date: Wed, 30 Jan 2013 11:04:17 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [Q]staging/comedi: Considation of *_find_boardinfo possible?
References: <201301300041.36064.PeterHuewe@gmx.de> <ADE657CA350FB648AAC2C43247A983F00207A707B3C8@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00207A707B3C8@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-29 23:56, H Hartley Sweeten wrote:
> On Tuesday, January 29, 2013 4:42 PM, Peter Hüwe wrote:
>> Hi,
>>
>> while analyzing the comedi drivers, I noticed that quite a lot of them use a
>> more or less similar find_boardinfo function.
>
> <snip>
>
>> The names and the exact implementation differ slightly, but in most cases it
>> boils down to:
>> 	unsigned int i;
>>
>> 	for (i = 0; i < ARRAY_SIZE(__BOARD_ARRAY__); i++)
>> 		if (pcidev->device == __BOARD_ARRAY__[i].device_id)
>> 			return &__BOARD_ARRAY__[i];
>> 	return NULL;
>>
>> unfortunately the __BOARD_ARRAY__ is always of a different type (but all
>> contain the device_id field) and size.
>>
>>
>> ---> is there a way to consolidate these functions into one function (which
>> can operate on the different types) ?  It's almost a bit like 'templates'.
>> Maybe with some gcc extensions or kernel magic functions ?
>>
>> I already thought about passing a void pointer to the __BOARD_ARRAY__ and the
>> size of one element of the __BOARD_ARRAY__ and doing pointer calculations -
>> but I guess there must be a better way.
>>
>> Or is the only option to write a macro ?
>
> As you noticed, the problem is the driver specific definition of the struct used
> to hold the boardinfo.
>
> In drivers.c, the comedi_recognize() function actually access the boardinfo
> in order to support the COMEDI_DEVCONFIG ioctl. There is a comment above
> it giving a description of how it works.
>
> There might be a way to do this in a generic way. The problem is that the
> drivers use different names for "common" information and the data is
> packed in the structs differently so accessing it generically is a bit difficult,
> if not impossible.
>
> I have been trying to remove as much of this boardinfo stuff from the drivers
> as possible. For now I think the current implementation is fairly clean.
>
> For the PnP bus drivers that use the auto_attach mechanism I have some ideas
> to get rid of the find_boardinfo functions but I need to work out the kinks first.
>
> Please wait on "fixing" any of this until a good solution is worked out.

One way is to enumerate the possible indices of the custom board array 
as a set of enum constants, initialize the custom board array using 
designated element initializers (indexed by the enum constants) and 
include the same enum constant in the 'driver_data' member of the struct 
pci_device_id elements of the module's PCI device table.  Then the 
module's PCI driver's probe function can index directly into the custom 
board array without searching.

The missing link in the above is passing the index from the 
'driver_data' through to the modules' comedi_driver's 'auto_attach' 
function. The 'comedi_pci_auto_config()' function does not currently 
have a parameter for passing this information, but the underlying 
'comedi_auto_config()' function does.  Either the existing 
'comedi_pci_auto_config()' function could be extended, or a separate 
extended version of the function could be added (maybe as an inline 
function in comedidev.h), or the modules could call 
'comedi_auto_config()' directly.

We have posted patches to add extra context to 
'comedi_pci_auto_config()' before, but they weren't applied because we 
didn't have a clear use case for them.  Now we have, but I wouldn't mind 
leaving the existing function alone and adding a new one.

The nice thing is that it's all under the control of the individual drivers.

Here's some code to illustrate what I'm on about in the above description:

struct foobar_board {
	const char *name;
	unsigned int ai_chans;
	unsigned int ai_bits;
};

enum foobar_board_nums {
	bn_foo,
	bn_bar,
	bn_baz
};

static const struct foobar_board foobar_boards[] = {
	[bn_foo] = {
		.name = "foo",
		.ai_chans = 4,
		.ai_bits = 12,
	},
	[bn_bar] = {
		.name = "bar",
		.ai_chans = 4,
		.ai_bits = 16,
	},
	[bn_baz] = {
		.name = "baz",
		.ai_chans = 8,
		.ai_bits = 16,
	},
};

static int foobar_auto_attach(struct comedi_device *dev,
			      unsigned long context_bn)
{
	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
	struct foobar_board *thisboard = &foobar_boards[bn_foo];

	dev->board_ptr = thisboard;	/* no searching! */

	/* just return error for now */
	return -ENODEV;
}

static void foobar_detach(struct comedi_device *dev)
{
	/* nothing to do for now */
}

static struct comedi_driver foobar_comedi_driver = {
	.driver_name	= "foobar",
	.module		= THIS_MODULE,
	.auto_attach	= foobar_auto_attach,
	.detach		= foobar_detach,
};

static DEFINE_PCI_DEVICE_TABLE(foobar_pci_table) = {
	{
		PCI_DEVICE(PCI_VENDOR_ID_FOOBAR,
			   PCI_DEVICE_ID_FOOBAR_FOO),
		.driver_data = bn_foo,
	},
	{
		PCI_DEVICE(PCI_VENDOR_ID_FOOBAR,
			   PCI_DEVICE_ID_FOOBAR_BAR),
		.driver_data = bn_bar,
	},
	{
		PCI_DEVICE(PCI_VENDOR_ID_FOOBAR,
			   PCI_DEVICE_ID_FOOBAR_BAZ),
		.driver_data = bn_baz,
	},
	{ 0 }
};
MODULE_DEVICE_TABLE(pci, foobar_pci_table);

static int foobar_pci_probe(struct pci_dev *pdev,
			    const struct pci_device_id *ent)
{
	/* could use a variant of comedi_pci_auto_config() here */
	return comedi_auto_config(&pdev->dev, &foobar_comedi_driver,
				  ent->driver_data);
}

static struct pci_driver foobar_pci_driver = {
	.name		= "foobar",
	.id_table	= foobar_pci_table,
	.probe		= foobar_pci_probe,
	.remove		= comedi_pci_auto_unconfig,
};
module_comedi_pci_driver(foobar_comedi_driver, foobar_pci_driver);

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

