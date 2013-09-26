Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3IZCLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:11:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38714 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3IZCLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:11:35 -0400
Date: Thu, 26 Sep 2013 03:11:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
Message-ID: <20130926021130.GD13318@ZenIV.linux.org.uk>
References: <20130923090100.GE6192@mwanda>
 <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com>
 <5241CB44.8080004@ahsoftware.de>
 <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com>
 <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com>
 <52420DF1.7060108@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52420DF1.7060108@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:10:57AM +0200, Alexander Holler wrote:

> Sure and I'm the last one who wants that people do have to use
> anything else than i for simple loop counters. And allowing longer
> lines doesn't mean people have to use long names, it allows them use
> them (if it makes sense). That's a big difference.
> 
> On the other side it's almost impossible to use verbose variable or
> function names where they would make sense. Not to speak about all
> the ugly splitted lines just to be below that ancient CGA limit.

Yeah, the things people will do to avoid <gasp> not nesting the living
hell out of their code...

Tell you what - pick a random place where the code is nested 8 levels
deep and I'm fairly sure that you will end up with your finger on one
hell of ugliness.  Ugliness in logical structure, not in forced line
breaks.  Let's experiment...  Aha.  In drivers/pci/hotplug/ibmphp_pci.c,
258 lines of deeply indented shite^Wcode that must be good since it compiles:

<avert your eyes if you've got a weak stomach>

======================================================================
int ibmphp_configure_card (struct pci_func *func, u8 slotno)
{
	u16 vendor_id;
	u32 class;
	u8 class_code;
	u8 hdr_type, device, sec_number;
	u8 function;
	struct pci_func *newfunc;	/* for multi devices */
	struct pci_func *cur_func, *prev_func;
	int rc, i, j;
	int cleanup_count;
	u8 flag;
	u8 valid_device = 0x00; /* to see if we are able to read from card any device info at all */

	debug ("inside configure_card, func->busno = %x\n", func->busno);

	device = func->device;
	cur_func = func;

	/* We only get bus and device from IRQ routing table.  So at this point,
	 * func->busno is correct, and func->device contains only device (at the 5 
	 * highest bits)
	 */

	/* For every function on the card */
	for (function = 0x00; function < 0x08; function++) {
		unsigned int devfn = PCI_DEVFN(device, function);
		ibmphp_pci_bus->number = cur_func->busno;

		cur_func->function = function;

		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->function = %x\n",
			cur_func->busno, cur_func->device, cur_func->function);

		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_VENDOR_ID, &vendor_id);

		debug ("vendor_id is %x\n", vendor_id);
		if (vendor_id != PCI_VENDOR_ID_NOTVALID) {
			/* found correct device!!! */
			debug ("found valid device, vendor_id = %x\n", vendor_id);

			++valid_device;

			/* header: x x x x x x x x
			 *         | |___________|=> 1=PPB bridge, 0=normal device, 2=CardBus Bridge
			 *         |_=> 0 = single function device, 1 = multi-function device
			 */

			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_HEADER_TYPE, &hdr_type);
			pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);

			class_code = class >> 24;
			debug ("hrd_type = %x, class = %x, class_code %x\n", hdr_type, class, class_code);
			class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
			if (class == PCI_CLASS_NOT_DEFINED_VGA) {
				err ("The device %x is VGA compatible and as is not supported for hot plugging. "
				     "Please choose another device.\n", cur_func->device);
				return -ENODEV;
			} else if (class == PCI_CLASS_DISPLAY_VGA) {
				err ("The device %x is not supported for hot plugging. "
				     "Please choose another device.\n", cur_func->device);
				return -ENODEV;
			}
			switch (hdr_type) {
				case PCI_HEADER_TYPE_NORMAL:
					debug ("single device case.... vendor id = %x, hdr_type = %x, class = %x\n", vendor_id, hdr_type, class);
					assign_alt_irq (cur_func, class_code);
					if ((rc = configure_device (cur_func)) < 0) {
						/* We need to do this in case some other BARs were properly inserted */
						err ("was not able to configure devfunc %x on bus %x.\n",
						     cur_func->device, cur_func->busno);
						cleanup_count = 6;
						goto error;
					}	
					cur_func->next = NULL;
					function = 0x8;
					break;
				case PCI_HEADER_TYPE_MULTIDEVICE:
					assign_alt_irq (cur_func, class_code);
					if ((rc = configure_device (cur_func)) < 0) {
						/* We need to do this in case some other BARs were properly inserted */
						err ("was not able to configure devfunc %x on bus %x...bailing out\n",
						     cur_func->device, cur_func->busno);
						cleanup_count = 6;
						goto error;
					}
					newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
					if (!newfunc) {
						err ("out of system memory\n");
						return -ENOMEM;
					}
					newfunc->busno = cur_func->busno;
					newfunc->device = device;
					for (j = 0; j < 4; j++)
						newfunc->irq[j] = cur_func->irq[j];
					cur_func->next = newfunc;
					cur_func = newfunc;
					break;
				case PCI_HEADER_TYPE_MULTIBRIDGE:
					class >>= 8;
					if (class != PCI_CLASS_BRIDGE_PCI) {
						err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
						     "Please insert another card.\n", cur_func->device);
						return -ENODEV;
					}
					assign_alt_irq (cur_func, class_code);
					rc = configure_bridge (&cur_func, slotno);
					if (rc == -ENODEV) {
						err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
						err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
						return rc;
					}
					if (rc) {
						/* We need to do this in case some other BARs were properly inserted */
						err ("was not able to hot-add PPB properly.\n");
						func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
						cleanup_count = 2;
						goto error;
					}

					pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
					flag = 0;
					for (i = 0; i < 32; i++) {
						if (func->devices[i]) {
							newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
							if (!newfunc) {
								err ("out of system memory\n");
								return -ENOMEM;
							}
							newfunc->busno = sec_number;
							newfunc->device = (u8) i;
							for (j = 0; j < 4; j++)
								newfunc->irq[j] = cur_func->irq[j];

							if (flag) {
								for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
								prev_func->next = newfunc;
							} else
								cur_func->next = newfunc;

							rc = ibmphp_configure_card (newfunc, slotno);
							/* This could only happen if kmalloc failed */
							if (rc) {
								/* We need to do this in case bridge itself got configured properly, but devices behind it failed */
								func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
								cleanup_count = 2;
								goto error;
							}
							flag = 1;
						}
					}

					newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
					if (!newfunc) {
						err ("out of system memory\n");
						return -ENOMEM;
					}
					newfunc->busno = cur_func->busno;
					newfunc->device = device;
					for (j = 0; j < 4; j++)
						newfunc->irq[j] = cur_func->irq[j];
					for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
					prev_func->next = newfunc;
					cur_func = newfunc;
					break;
				case PCI_HEADER_TYPE_BRIDGE:
					class >>= 8;
					debug ("class now is %x\n", class);
					if (class != PCI_CLASS_BRIDGE_PCI) {
						err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
						     "Please insert another card.\n", cur_func->device);
						return -ENODEV;
					}

					assign_alt_irq (cur_func, class_code);

					debug ("cur_func->busno b4 configure_bridge is %x\n", cur_func->busno);
					rc = configure_bridge (&cur_func, slotno);
					if (rc == -ENODEV) {
						err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
						err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
						return rc;
					}
					if (rc) {
						/* We need to do this in case some other BARs were properly inserted */
						func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
						err ("was not able to hot-add PPB properly.\n");
						cleanup_count = 2;
						goto error;
					}
					debug ("cur_func->busno = %x, device = %x, function = %x\n",
						cur_func->busno, device, function);
					pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
					debug ("after configuring bridge..., sec_number = %x\n", sec_number);
					flag = 0;
					for (i = 0; i < 32; i++) {
						if (func->devices[i]) {
							debug ("inside for loop, device is %x\n", i);
							newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
							if (!newfunc) {
								err (" out of system memory\n");
								return -ENOMEM;
							}
							newfunc->busno = sec_number;
							newfunc->device = (u8) i;
							for (j = 0; j < 4; j++)
								newfunc->irq[j] = cur_func->irq[j];

							if (flag) {
								for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
								prev_func->next = newfunc;
							} else
								cur_func->next = newfunc;

							rc = ibmphp_configure_card (newfunc, slotno);

							/* Again, this case should not happen... For complete paranoia, will need to call remove_bus */
							if (rc) {
								/* We need to do this in case some other BARs were properly inserted */
								func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
								cleanup_count = 2;
								goto error;
							}
							flag = 1;
						}
					}

					function = 0x8;
					break;
				default:
					err ("MAJOR PROBLEM!!!!, header type not supported? %x\n", hdr_type);
					return -ENXIO;
					break;
			}	/* end of switch */
		}	/* end of valid device */
	}	/* end of for */

	if (!valid_device) {
		err ("Cannot find any valid devices on the card.  Or unable to read from card.\n");
		return -ENODEV;
	}

	return 0;

error:
	for (i = 0; i < cleanup_count; i++) {
		if (cur_func->io[i]) {
			ibmphp_remove_resource (cur_func->io[i]);
			cur_func->io[i] = NULL;
		} else if (cur_func->pfmem[i]) {
			ibmphp_remove_resource (cur_func->pfmem[i]);
			cur_func->pfmem[i] = NULL;
		} else if (cur_func->mem[i]) {
			ibmphp_remove_resource (cur_func->mem[i]);
			cur_func->mem[i] = NULL;
		}
	}
	return rc;
}
======================================================================

Note the lovely comments /* end of for */ et.al. - nice to see that somebody
understood that keeping track of that nesting might be not quite trivial.

Let's start with the obvious - we have a loop, with the end of the body
consisting of
		if (vendor_id != PCI_VENDOR_ID_NOTVALID)
			<197 lines of over-indented code>
And those lines are about 80% of the function.  What could we use here?
'Sright, "continue".  While we are at it, we have a couple of loops of
form
					for (i = 0; i < 32; i++) {
						if (func->devices[i]) {
							<deeply nested shite>
						}
					}
The same cure, of course...  Oh, and switch with long cases definitely
should not be indented that way.  With all that dealt with, we get
still overindented and hard to read
======================================================================
int ibmphp_configure_card (struct pci_func *func, u8 slotno)
{
	u16 vendor_id;
	u32 class;
	u8 class_code;
	u8 hdr_type, device, sec_number;
	u8 function;
	struct pci_func *newfunc;	/* for multi devices */
	struct pci_func *cur_func, *prev_func;
	int rc, i, j;
	int cleanup_count;
	u8 flag;
	u8 valid_device = 0x00; /* to see if we are able to read from card any device info at all */

	debug ("inside configure_card, func->busno = %x\n", func->busno);

	device = func->device;
	cur_func = func;

	/* We only get bus and device from IRQ routing table.  So at this point,
	 * func->busno is correct, and func->device contains only device (at the 5 
	 * highest bits)
	 */

	/* For every function on the card */
	for (function = 0x00; function < 0x08; function++) {
		unsigned int devfn = PCI_DEVFN(device, function);
		ibmphp_pci_bus->number = cur_func->busno;

		cur_func->function = function;

		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->function = %x\n",
			cur_func->busno, cur_func->device, cur_func->function);

		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_VENDOR_ID, &vendor_id);

		debug ("vendor_id is %x\n", vendor_id);
		if (vendor_id == PCI_VENDOR_ID_NOTVALID)
			continue;

		/* found correct device!!! */
		debug ("found valid device, vendor_id = %x\n", vendor_id);

		++valid_device;

		/* header: x x x x x x x x
		 *         | |___________|=> 1=PPB bridge, 0=normal device, 2=CardBus Bridge
		 *         |_=> 0 = single function device, 1 = multi-function device
		 */

		pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_HEADER_TYPE, &hdr_type);
		pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);

		class_code = class >> 24;
		debug ("hrd_type = %x, class = %x, class_code %x\n", hdr_type, class, class_code);
		class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
		if (class == PCI_CLASS_NOT_DEFINED_VGA) {
			err ("The device %x is VGA compatible and as is not supported for hot plugging. "
			     "Please choose another device.\n", cur_func->device);
			return -ENODEV;
		} else if (class == PCI_CLASS_DISPLAY_VGA) {
			err ("The device %x is not supported for hot plugging. "
			     "Please choose another device.\n", cur_func->device);
			return -ENODEV;
		}
		switch (hdr_type) {
		case PCI_HEADER_TYPE_NORMAL:
			debug ("single device case.... vendor id = %x, hdr_type = %x, class = %x\n", vendor_id, hdr_type, class);
			assign_alt_irq (cur_func, class_code);
			if ((rc = configure_device (cur_func)) < 0) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to configure devfunc %x on bus %x.\n",
				     cur_func->device, cur_func->busno);
				cleanup_count = 6;
				goto error;
			}	
			cur_func->next = NULL;
			function = 0x8;
			break;
		case PCI_HEADER_TYPE_MULTIDEVICE:
			assign_alt_irq (cur_func, class_code);
			if ((rc = configure_device (cur_func)) < 0) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to configure devfunc %x on bus %x...bailing out\n",
				     cur_func->device, cur_func->busno);
				cleanup_count = 6;
				goto error;
			}
			newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
			if (!newfunc) {
				err ("out of system memory\n");
				return -ENOMEM;
			}
			newfunc->busno = cur_func->busno;
			newfunc->device = device;
			cur_func->next = newfunc;
			cur_func = newfunc;
			for (j = 0; j < 4; j++)
				newfunc->irq[j] = cur_func->irq[j];
			break;
		case PCI_HEADER_TYPE_MULTIBRIDGE:
			class >>= 8;
			if (class != PCI_CLASS_BRIDGE_PCI) {
				err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
				     "Please insert another card.\n", cur_func->device);
				return -ENODEV;
			}
			assign_alt_irq (cur_func, class_code);
			rc = configure_bridge (&cur_func, slotno);
			if (rc == -ENODEV) {
				err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
				err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
				return rc;
			}
			if (rc) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to hot-add PPB properly.\n");
				func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
				cleanup_count = 2;
				goto error;
			}

			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
			flag = 0;
			for (i = 0; i < 32; i++) {
				if (!func->devices[i])
					continue;
				newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
				if (!newfunc) {
					err ("out of system memory\n");
					return -ENOMEM;
				}
				newfunc->busno = sec_number;
				newfunc->device = (u8) i;
				for (j = 0; j < 4; j++)
					newfunc->irq[j] = cur_func->irq[j];

				if (flag) {
					for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
					prev_func->next = newfunc;
				} else
					cur_func->next = newfunc;

				rc = ibmphp_configure_card (newfunc, slotno);
				/* This could only happen if kmalloc failed */
				if (rc) {
					/* We need to do this in case bridge itself got configured properly, but devices behind it failed */
					func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
					cleanup_count = 2;
					goto error;
				}
				flag = 1;
			}

			newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
			if (!newfunc) {
				err ("out of system memory\n");
				return -ENOMEM;
			}
			newfunc->busno = cur_func->busno;
			newfunc->device = device;
			for (j = 0; j < 4; j++)
				newfunc->irq[j] = cur_func->irq[j];
			for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
			prev_func->next = newfunc;
			cur_func = newfunc;
			break;
		case PCI_HEADER_TYPE_BRIDGE:
			class >>= 8;
			debug ("class now is %x\n", class);
			if (class != PCI_CLASS_BRIDGE_PCI) {
				err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
				     "Please insert another card.\n", cur_func->device);
				return -ENODEV;
			}

			assign_alt_irq (cur_func, class_code);

			debug ("cur_func->busno b4 configure_bridge is %x\n", cur_func->busno);
			rc = configure_bridge (&cur_func, slotno);
			if (rc == -ENODEV) {
				err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
				err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
				return rc;
			}
			if (rc) {
				/* We need to do this in case some other BARs were properly inserted */
				func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
				err ("was not able to hot-add PPB properly.\n");
				cleanup_count = 2;
				goto error;
			}
			debug ("cur_func->busno = %x, device = %x, function = %x\n",
				cur_func->busno, device, function);
			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
			debug ("after configuring bridge..., sec_number = %x\n", sec_number);
			flag = 0;
			for (i = 0; i < 32; i++) {
				if (!func->devices[i])
					continue;
				debug ("inside for loop, device is %x\n", i);
				newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
				if (!newfunc) {
					err (" out of system memory\n");
					return -ENOMEM;
				}
				newfunc->busno = sec_number;
				newfunc->device = (u8) i;
				for (j = 0; j < 4; j++)
					newfunc->irq[j] = cur_func->irq[j];

				if (flag) {
					for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
					prev_func->next = newfunc;
				} else
					cur_func->next = newfunc;

				rc = ibmphp_configure_card (newfunc, slotno);

				/* Again, this case should not happen... For complete paranoia, will need to call remove_bus */
				if (rc) {
					/* We need to do this in case some other BARs were properly inserted */
					func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
					cleanup_count = 2;
					goto error;
				}
				flag = 1;
			}

			function = 0x8;
			break;
		default:
			err ("MAJOR PROBLEM!!!!, header type not supported? %x\n", hdr_type);
			return -ENXIO;
			break;
		}	/* end of switch */
	}	/* end of for */

	if (!valid_device) {
		err ("Cannot find any valid devices on the card.  Or unable to read from card.\n");
		return -ENODEV;
	}

	return 0;

error:
	for (i = 0; i < cleanup_count; i++) {
		if (cur_func->io[i]) {
			ibmphp_remove_resource (cur_func->io[i]);
			cur_func->io[i] = NULL;
		} else if (cur_func->pfmem[i]) {
			ibmphp_remove_resource (cur_func->pfmem[i]);
			cur_func->pfmem[i] = NULL;
		} else if (cur_func->mem[i]) {
			ibmphp_remove_resource (cur_func->mem[i]);
			cur_func->mem[i] = NULL;
		}
	}
	return rc;
}
======================================================================

What's really deeply indented here?  Right,
                                if (flag) {
                                        for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
                                        prev_func->next = newfunc;
                                } else
                                        cur_func->next = newfunc;
Just WTF is going on here?  Looks like conditional insertion into the end of
list, but what the hell is "flag"?  Further digging shows that it starts as
0 and gets set to 1 after the first pass through that...
<looks for places assigning cur_func>
Egads...
                        cur_func = newfunc;
                        for (j = 0; j < 4; j++)
                                newfunc->irq[j] = cur_func->irq[j];
OK, that's our first bug right there...

Anyway, can cur_func->next be non-NULL when flag is 0?  It can't be non-NULL
when we enter this function (both for the initial caller and for recursive
ones); func has been freshly kzalloc'ed in all those cases, with ->next
not modified in the meanwhile.  configure_device() doesn't change ->next.
That fragment reassigning cur_func has its ->next equal to NULL (again,
kzalloc()).  configure_bridge()...  WTF?  It gets &cur_func passed to it,
then it has
	func = *func_passed;
	/* a lot of code that never modifies func */
	func_passed = &func;
	debug ("func->busno b4 returning is %x\n", func->busno);
	debug ("func->busno b4 returning in the other structure is %x\n", (*func_passed)->busno);
	kfree (amount_needed);
WHAT other structure?  After that func_passed = &func we will have *func_passed
equal to func, no matter what.  How much crack had it taken to write that code,
anyway?  Oh, well...  func->next is not touched at all in there.  Another
reassignment:
                                        for (j = 0; j < 4; j++)
                                                newfunc->irq[j] = cur_func->irq[j];
                                        for (prev_func = cur_func; prev_func->next; prev_func = prev_func->next) ;
                                        prev_func->next = newfunc;
                                        cur_func = newfunc;
                                        break;
                                case PCI_HEADER_TYPE_BRIDGE:
Again, ->next is NULL here, due to kzalloc().

Grr...  OK, the right way to look at that: in the beginning of the outer
loop cur_func->next is NULL due to what callers have done; after each pass
through the loop we either bugger off (return or manually setting loop
index to upper limit) or we get cur_func->next guaranteed to be NULL again.
We never modify it in the body prior to entering switch.  Ergo, it's NULL
on the entry to each case.  We also do not modify it between case ...:
and flag = 0 inside the cases that have that shite.

In other words, all this "flag" business is pure obfuscation; what we are
doing here is appending to the end of list no matter what.  OK, let's
take that to a helper function; proper fix is probably to keep track of
the _last_ element of the list through all that.  Recursive calls will
have to report it to caller, but that's not hard to do.  Separate story,
anyway.

OK, with aforementioned bug fixed that becomes
======================================================================
static void append(struct pci_func *head, struct pci_func *new)
{
	while (head->next)
		head = head->next;
	head->next = new;
}

int ibmphp_configure_card (struct pci_func *func, u8 slotno)
{
	u16 vendor_id;
	u32 class;
	u8 class_code;
	u8 hdr_type, device, sec_number;
	u8 function;
	struct pci_func *newfunc;	/* for multi devices */
	struct pci_func *cur_func;
	int rc, i, j;
	int cleanup_count;
	u8 valid_device = 0x00; /* to see if we are able to read from card any device info at all */

	debug ("inside configure_card, func->busno = %x\n", func->busno);

	device = func->device;
	cur_func = func;

	/* We only get bus and device from IRQ routing table.  So at this point,
	 * func->busno is correct, and func->device contains only device (at the 5 
	 * highest bits)
	 */

	/* For every function on the card */
	for (function = 0x00; function < 0x08; function++) {
		unsigned int devfn = PCI_DEVFN(device, function);
		ibmphp_pci_bus->number = cur_func->busno;

		cur_func->function = function;

		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->function = %x\n",
			cur_func->busno, cur_func->device, cur_func->function);

		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_VENDOR_ID, &vendor_id);

		debug ("vendor_id is %x\n", vendor_id);
		if (vendor_id == PCI_VENDOR_ID_NOTVALID)
			continue;

		/* found correct device!!! */
		debug ("found valid device, vendor_id = %x\n", vendor_id);

		++valid_device;

		/* header: x x x x x x x x
		 *         | |___________|=> 1=PPB bridge, 0=normal device, 2=CardBus Bridge
		 *         |_=> 0 = single function device, 1 = multi-function device
		 */

		pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_HEADER_TYPE, &hdr_type);
		pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);

		class_code = class >> 24;
		debug ("hrd_type = %x, class = %x, class_code %x\n", hdr_type, class, class_code);
		class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
		if (class == PCI_CLASS_NOT_DEFINED_VGA) {
			err ("The device %x is VGA compatible and as is not supported for hot plugging. "
			     "Please choose another device.\n", cur_func->device);
			return -ENODEV;
		} else if (class == PCI_CLASS_DISPLAY_VGA) {
			err ("The device %x is not supported for hot plugging. "
			     "Please choose another device.\n", cur_func->device);
			return -ENODEV;
		}
		switch (hdr_type) {
		case PCI_HEADER_TYPE_NORMAL:
			debug ("single device case.... vendor id = %x, hdr_type = %x, class = %x\n", vendor_id, hdr_type, class);
			assign_alt_irq (cur_func, class_code);
			if ((rc = configure_device (cur_func)) < 0) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to configure devfunc %x on bus %x.\n",
				     cur_func->device, cur_func->busno);
				cleanup_count = 6;
				goto error;
			}	
			cur_func->next = NULL;
			function = 0x8;
			break;
		case PCI_HEADER_TYPE_MULTIDEVICE:
			assign_alt_irq (cur_func, class_code);
			if ((rc = configure_device (cur_func)) < 0) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to configure devfunc %x on bus %x...bailing out\n",
				     cur_func->device, cur_func->busno);
				cleanup_count = 6;
				goto error;
			}
			newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
			if (!newfunc) {
				err ("out of system memory\n");
				return -ENOMEM;
			}
			newfunc->busno = cur_func->busno;
			newfunc->device = device;
			cur_func->next = newfunc;
			cur_func = newfunc;
			for (j = 0; j < 4; j++)
				newfunc->irq[j] = cur_func->irq[j];
			break;
		case PCI_HEADER_TYPE_MULTIBRIDGE:
			class >>= 8;
			if (class != PCI_CLASS_BRIDGE_PCI) {
				err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
				     "Please insert another card.\n", cur_func->device);
				return -ENODEV;
			}
			assign_alt_irq (cur_func, class_code);
			rc = configure_bridge (&cur_func, slotno);
			if (rc == -ENODEV) {
				err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
				err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
				return rc;
			}
			if (rc) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to hot-add PPB properly.\n");
				func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
				cleanup_count = 2;
				goto error;
			}

			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
			for (i = 0; i < 32; i++) {
				if (!func->devices[i])
					continue;
				newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
				if (!newfunc) {
					err ("out of system memory\n");
					return -ENOMEM;
				}
				newfunc->busno = sec_number;
				newfunc->device = (u8) i;
				for (j = 0; j < 4; j++)
					newfunc->irq[j] = cur_func->irq[j];

				append(cur_func, newfunc);

				rc = ibmphp_configure_card (newfunc, slotno);
				/* This could only happen if kmalloc failed */
				if (rc) {
					/* We need to do this in case bridge itself got configured properly, but devices behind it failed */
					func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
					cleanup_count = 2;
					goto error;
				}
			}

			newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
			if (!newfunc) {
				err ("out of system memory\n");
				return -ENOMEM;
			}
			newfunc->busno = cur_func->busno;
			newfunc->device = device;
			for (j = 0; j < 4; j++)
				newfunc->irq[j] = cur_func->irq[j];
			append(cur_func, newfunc);
			cur_func = newfunc;
			break;
		case PCI_HEADER_TYPE_BRIDGE:
			class >>= 8;
			debug ("class now is %x\n", class);
			if (class != PCI_CLASS_BRIDGE_PCI) {
				err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
				     "Please insert another card.\n", cur_func->device);
				return -ENODEV;
			}

			assign_alt_irq (cur_func, class_code);

			debug ("cur_func->busno b4 configure_bridge is %x\n", cur_func->busno);
			rc = configure_bridge (&cur_func, slotno);
			if (rc == -ENODEV) {
				err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
				err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
				return rc;
			}
			if (rc) {
				/* We need to do this in case some other BARs were properly inserted */
				func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
				err ("was not able to hot-add PPB properly.\n");
				cleanup_count = 2;
				goto error;
			}
			debug ("cur_func->busno = %x, device = %x, function = %x\n",
				cur_func->busno, device, function);
			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
			debug ("after configuring bridge..., sec_number = %x\n", sec_number);
			for (i = 0; i < 32; i++) {
				if (!func->devices[i])
					continue;
				debug ("inside for loop, device is %x\n", i);
				newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
				if (!newfunc) {
					err (" out of system memory\n");
					return -ENOMEM;
				}
				newfunc->busno = sec_number;
				newfunc->device = (u8) i;
				for (j = 0; j < 4; j++)
					newfunc->irq[j] = cur_func->irq[j];

				append(cur_func, newfunc);

				rc = ibmphp_configure_card (newfunc, slotno);

				/* Again, this case should not happen... For complete paranoia, will need to call remove_bus */
				if (rc) {
					/* We need to do this in case some other BARs were properly inserted */
					func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
					cleanup_count = 2;
					goto error;
				}
			}

			function = 0x8;
			break;
		default:
			err ("MAJOR PROBLEM!!!!, header type not supported? %x\n", hdr_type);
			return -ENXIO;
			break;
		}	/* end of switch */
	}	/* end of for */

	if (!valid_device) {
		err ("Cannot find any valid devices on the card.  Or unable to read from card.\n");
		return -ENODEV;
	}

	return 0;

error:
	for (i = 0; i < cleanup_count; i++) {
		if (cur_func->io[i]) {
			ibmphp_remove_resource (cur_func->io[i]);
			cur_func->io[i] = NULL;
		} else if (cur_func->pfmem[i]) {
			ibmphp_remove_resource (cur_func->pfmem[i]);
			cur_func->pfmem[i] = NULL;
		} else if (cur_func->mem[i]) {
			ibmphp_remove_resource (cur_func->mem[i]);
			cur_func->mem[i] = NULL;
		}
	}
	return rc;
}
======================================================================

Now, a look at the places where we are appending suggests that it might
be worth folding kzalloc + setting busno/device/irq into append(), making
it return the new pci_func or NULL in case of failure.  With that the
sucker starts looking as below and I'm quite certain that with a bit of
further massage it can be cleaned up more (I'd probably start with
moving local variables into the minimal blocks needing those and then
looked where it gets us).  I think that my point is made, though - deeply
nested code is a very good predictor of shitty code.  Not guaranteed,
of course, but as a Bayesian filter it works very well.

======================================================================
static struct pci_func *append(struct pci_func *head, u8 busno, u8 device)
{
	struct pci_func *new = kzalloc(sizeof(*new), GFP_KERNEL);
	int i;
	if (!new) {
		err ("out of system memory\n");
		return NULL;
	}
	new->busno = busno;
	new->device = device;
	for (i = 0; i < 4; i++)
		new->irq[i] = head->irq[i];
	while (head->next)
		head = head->next;
	head->next = new;
	return new;
}

int ibmphp_configure_card (struct pci_func *func, u8 slotno)
{
	u16 vendor_id;
	u32 class;
	u8 class_code;
	u8 hdr_type, device, sec_number;
	u8 function;
	struct pci_func *newfunc;	/* for multi devices */
	struct pci_func *cur_func;
	int rc, i, j;
	int cleanup_count;
	u8 valid_device = 0x00; /* to see if we are able to read from card any device info at all */

	debug ("inside configure_card, func->busno = %x\n", func->busno);

	device = func->device;
	cur_func = func;

	/* We only get bus and device from IRQ routing table.  So at this point,
	 * func->busno is correct, and func->device contains only device (at the 5 
	 * highest bits)
	 */

	/* For every function on the card */
	for (function = 0x00; function < 0x08; function++) {
		unsigned int devfn = PCI_DEVFN(device, function);
		ibmphp_pci_bus->number = cur_func->busno;

		cur_func->function = function;

		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->function = %x\n",
			cur_func->busno, cur_func->device, cur_func->function);

		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_VENDOR_ID, &vendor_id);

		debug ("vendor_id is %x\n", vendor_id);
		if (vendor_id == PCI_VENDOR_ID_NOTVALID)
			continue;

		/* found correct device!!! */
		debug ("found valid device, vendor_id = %x\n", vendor_id);

		++valid_device;

		/* header: x x x x x x x x
		 *         | |___________|=> 1=PPB bridge, 0=normal device, 2=CardBus Bridge
		 *         |_=> 0 = single function device, 1 = multi-function device
		 */

		pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_HEADER_TYPE, &hdr_type);
		pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);

		class_code = class >> 24;
		debug ("hrd_type = %x, class = %x, class_code %x\n", hdr_type, class, class_code);
		class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
		if (class == PCI_CLASS_NOT_DEFINED_VGA) {
			err ("The device %x is VGA compatible and as is not supported for hot plugging. "
			     "Please choose another device.\n", cur_func->device);
			return -ENODEV;
		} else if (class == PCI_CLASS_DISPLAY_VGA) {
			err ("The device %x is not supported for hot plugging. "
			     "Please choose another device.\n", cur_func->device);
			return -ENODEV;
		}
		switch (hdr_type) {
		case PCI_HEADER_TYPE_NORMAL:
			debug ("single device case.... vendor id = %x, hdr_type = %x, class = %x\n", vendor_id, hdr_type, class);
			assign_alt_irq (cur_func, class_code);
			if ((rc = configure_device (cur_func)) < 0) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to configure devfunc %x on bus %x.\n",
				     cur_func->device, cur_func->busno);
				cleanup_count = 6;
				goto error;
			}	
			cur_func->next = NULL;
			function = 0x8;
			break;
		case PCI_HEADER_TYPE_MULTIDEVICE:
			assign_alt_irq (cur_func, class_code);
			if ((rc = configure_device (cur_func)) < 0) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to configure devfunc %x on bus %x...bailing out\n",
				     cur_func->device, cur_func->busno);
				cleanup_count = 6;
				goto error;
			}
			cur_func = append(cur_func, cur_func->busno, device);
			if (!cur_func)
				return -ENOMEM;
			break;
		case PCI_HEADER_TYPE_MULTIBRIDGE:
			class >>= 8;
			if (class != PCI_CLASS_BRIDGE_PCI) {
				err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
				     "Please insert another card.\n", cur_func->device);
				return -ENODEV;
			}
			assign_alt_irq (cur_func, class_code);
			rc = configure_bridge (&cur_func, slotno);
			if (rc == -ENODEV) {
				err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
				err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
				return rc;
			}
			if (rc) {
				/* We need to do this in case some other BARs were properly inserted */
				err ("was not able to hot-add PPB properly.\n");
				func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
				cleanup_count = 2;
				goto error;
			}

			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
			for (i = 0; i < 32; i++) {
				if (!func->devices[i])
					continue;
				newfunc = append(cur_func, sec_number, i);
				if (!newfunc)
					return -ENOMEM;

				rc = ibmphp_configure_card (newfunc, slotno);
				/* This could only happen if kmalloc failed */
				if (rc) {
					/* We need to do this in case bridge itself got configured properly, but devices behind it failed */
					func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
					cleanup_count = 2;
					goto error;
				}
			}
			cur_func = append(cur_func, cur_func->busno, device);
			if (!cur_func)
				return -ENOMEM;
			break;
		case PCI_HEADER_TYPE_BRIDGE:
			class >>= 8;
			debug ("class now is %x\n", class);
			if (class != PCI_CLASS_BRIDGE_PCI) {
				err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
				     "Please insert another card.\n", cur_func->device);
				return -ENODEV;
			}

			assign_alt_irq (cur_func, class_code);

			debug ("cur_func->busno b4 configure_bridge is %x\n", cur_func->busno);
			rc = configure_bridge (&cur_func, slotno);
			if (rc == -ENODEV) {
				err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
				err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
				return rc;
			}
			if (rc) {
				/* We need to do this in case some other BARs were properly inserted */
				func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
				err ("was not able to hot-add PPB properly.\n");
				cleanup_count = 2;
				goto error;
			}
			debug ("cur_func->busno = %x, device = %x, function = %x\n",
				cur_func->busno, device, function);
			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
			debug ("after configuring bridge..., sec_number = %x\n", sec_number);
			for (i = 0; i < 32; i++) {
				if (!func->devices[i])
					continue;
				debug ("inside for loop, device is %x\n", i);
				newfunc = append(cur_func, sec_number, i);
				if (!newfunc)
					return -ENOMEM;

				rc = ibmphp_configure_card (newfunc, slotno);

				/* Again, this case should not happen... For complete paranoia, will need to call remove_bus */
				if (rc) {
					/* We need to do this in case some other BARs were properly inserted */
					func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
					cleanup_count = 2;
					goto error;
				}
			}

			function = 0x8;
			break;
		default:
			err ("MAJOR PROBLEM!!!!, header type not supported? %x\n", hdr_type);
			return -ENXIO;
			break;
		}	/* end of switch */
	}	/* end of for */

	if (!valid_device) {
		err ("Cannot find any valid devices on the card.  Or unable to read from card.\n");
		return -ENODEV;
	}

	return 0;

error:
	for (i = 0; i < cleanup_count; i++) {
		if (cur_func->io[i]) {
			ibmphp_remove_resource (cur_func->io[i]);
			cur_func->io[i] = NULL;
		} else if (cur_func->pfmem[i]) {
			ibmphp_remove_resource (cur_func->pfmem[i]);
			cur_func->pfmem[i] = NULL;
		} else if (cur_func->mem[i]) {
			ibmphp_remove_resource (cur_func->mem[i]);
			cur_func->mem[i] = NULL;
		}
	}
	return rc;
}
