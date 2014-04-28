Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaD1Xjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:39:32 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47794 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaD1Xja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:39:30 -0400
Date: Mon, 28 Apr 2014 17:39:26 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Bandan Das <bsd@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: rework new_id interface for known vendor/device
 values
Message-ID: <20140428233926.GB30008@google.com>
References: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
 <20140424224555.GK29593@google.com>
 <jpgtx9h9u15.fsf@nelium.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpgtx9h9u15.fsf@nelium.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 01:51:50PM -0400, Bandan Das wrote:
> Bjorn Helgaas <bhelgaas@google.com> writes:
> 
> > On Tue, Apr 01, 2014 at 09:32:59PM -0400, Bandan Das wrote:
> >> 
> >> While using the new_id interface, the user can unintentionally feed
> >> incorrect values if the driver static table has a matching entry.
> >> This is possible since only the device and vendor fields are
> >> mandatory and the rest are optional. As a result, store_new_id
> >> will fill in default values that are then passed on to the driver
> >> and can have unintended consequences.
> >> 
> >> As an example, consider the ixgbe driver and the 82599EB network card :
> >> echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
> >> 
> >> This will pass a driver_data value of 0 to the driver whereas
> >> the index 0 in ixgbe actually points to a different set of card
> >> operations.
> >> 
> >> This change returns an error if the user attempts to add a dynid for
> >> a vendor/device combination for which a static entry already exists.
> >> However, if the user intentionally wants a different set of values,
> >> she must provide all the 7 fields and that will be accepted.
> >> 
> >> In KVM/device assignment scenario, the user might want 
> >> to bind a device back to the host driver by writing to new_id
> >> and trip on a possible null pointer dereference.
> >
> > I don't understand this last KVM comment.  If this patch fixes a null
> > pointer dereference, it must be because we return -EEXIST instead of
> > calling the driver's probe method.
> 
> A null pointer dereference in the ixgbe driver's struct ixgbe_info
> that points to operations for a card model. In this case, when the user 
> uses the new_id interface (without specifying driver_data), it defaults
> to 0. So, ixgbe_info points to ixgbe_82598_info with mac_ops set to 
> mac_ops_82598 while the card in question is a 82599.
> 
> > Can you outline the sequence of events and the drivers involved?  Did we
> 
> Something like this is enough to trigger this -
> echo "b:f:d" > /sys/bus/.../driver/unbind
> echo "b:f:d" > /sys/bus/pci/drives/ixgbe/new_id
> echo 16 > /sys/bus/pci/devices/b:f:d/sriov_numvfs
> 
> > start with a device that was claimed by vfio, and now we're trying to get
> > ixgbe to claim it by writing to /sys/bus/pci/drivers/ixgbe/new_id?  If so,
> > does that mean the user has to know what driver_data value to supply?
> 
> Yes, but isn't it better than defaulting to 0 ?
> 
> > I know you didn't add the new_id mechanism, and this patch makes it safer
> > than it was before, but I'm uneasy about it in general.  Most drivers do
> > not validate the driver_data value.  They assume it came out of the
> > id_table supplied by the driver and is therefore trustworthy.  But new_id
> > is a loophole that allows a user (hopefully only root) to pass arbitrary
> > junk to the driver.
> 
> I think this is what this patch does. If the user intends to, let her
> pass arbitrary junk, let's not assume values on behalf of the user.

Yep, I agree, I was just trying to figure out if there was something
specific to KVM here.  But I don't think there is.

Bjorn
