Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284Ab3CZNdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:33:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:9930 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934130Ab3CZNdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="276119448"
Date: Tue, 26 Mar 2013 14:33:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V4] mei: bus: Initial MEI Client bus type
 implementation
Message-ID: <20130326133326.GA19511@zurbaran>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
 <1363819469-696-2-git-send-email-tomas.winkler@intel.com>
 <20130325202855.GA21494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130325202855.GA21494@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Mar 25, 2013 at 01:28:55PM -0700, Greg KH wrote:
> On Thu, Mar 21, 2013 at 12:44:19AM +0200, Tomas Winkler wrote:
> >  create mode 100644 Documentation/misc-devices/mei/mei-client-bus.txt
> 
> Shouldn't you also create Documentation/ABI/ entries as well?
You mean for the bus specific stuff or for the /dev/mei entry ?
For the bus parts, we're not adding any MEI specific sysfs entries. What
should we document ?

 
> > +#define NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, 0x94, \
> > +			       0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
> > +
> > +static struct mei_cl_id contact_mei_cl_tbl[] = {
> > +	{ CONTACT_DRIVER_NAME, NFC_UUID },
> > +
> > +	/* required last entry */
> > +	{ }
> > +};
> 
> What about MODULE_DEVICE() functionality for this structure?  Don't you
> need/want that as well?
I was planning to do that as a separate mod_devicetable.h patch once this
code gets merged, but I guess it makes sense to include it with this patchset.
It reminds me that I should remove the uuid_le field from the mei_cl_id
structure, it's useless.


> > +/**
> > + * struct mei_cl_device - MEI device handle
> > + * An mei_cl_device pointer is returned from mei_add_device()
> > + * and links MEI bus clients to their actual ME host client pointer.
> > + * Drivers for MEI devices will get an mei_cl_device pointer
> > + * when being probed and shall use it for doing ME bus I/O.
> > + *
> > + * @dev: linux driver model device pointer
> > + * @uuid: me client uuid
> > + * @cl: mei client
> > + * @priv_data: client private data
> > + */
> > +struct mei_cl_device {
> > +	struct device dev;
> > +
> > +	uuid_le uuid;
> > +	struct mei_cl *cl;
> > +
> > +	void *priv_data;
> > +};
> 
> Why is priv_data needed?  What's wrong with the pointer provided to you
> in struct device?
mei_cl_device->dev->p->driver_data is used by mei drivers to carry their
private data around, we define mei_cl_get_clientdata/mei_cl_set_clientdata for
that and keep the mei_cl_device structure opaque to them.
mei_cl_device->priv_data is used internally by the drivers/misc/mei/ bus
related code to carry technology specific pointers. drivers/misc/mei/nfc.c
uses it to fetch its private data when it gets a mei_cl_device pointer.



> > + *
> > + * Contact Information:
> > + *	Intel Corporation.
> > + *	linux-mei@linux.intel.com
> > + *	http://www.intel.com
> > + *
> > + * BSD LICENSE
> 
> Wait, you are putting code that has EXPORT_SYMBOL_GPL() usage under a
> GPL/BSD license?  I need an Intel lawyer signed-off-by: on the patch
> before I can accept that.
Sorry about that. We changed our EXPORT_SYMBOL to EXPORT_SYMBOL_GPL when you
asked for it, and I missed changing this header file at the same time. I will
actually remove the licensing terms from this file.


> > +struct mei_cl_driver {
> > +	struct device_driver driver;
> > +	const char *name;
> 
> What's wrong with the driver.name field?
>From your initial comments on patchset v1:

"
	> +static struct mei_bus_driver contact_driver = {
	> +     .driver = {
	> +                .name = CONTAC_DRIVER_NAME,
	> +               },

	Can't you put a name field in your mei_bus_driver structure and then
	copy it to the version in the driver model?  That's what other bus
	drivers do and it makes more sense.
"

And you were right, that is indeed what other bus drivers do. Did I
misunderstand you here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
