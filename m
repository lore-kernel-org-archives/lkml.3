Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaD1XiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:38:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39215 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaD1Xh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:37:58 -0400
Date: Mon, 28 Apr 2014 17:37:54 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bandan Das <bsd@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: rework new_id interface for known vendor/device
 values
Message-ID: <20140428233754.GA30008@google.com>
References: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
 <20140424224555.GK29593@google.com>
 <1398447576.24318.129.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398447576.24318.129.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 11:39:36AM -0600, Alex Williamson wrote:
> On Thu, 2014-04-24 at 16:45 -0600, Bjorn Helgaas wrote:
> > On Tue, Apr 01, 2014 at 09:32:59PM -0400, Bandan Das wrote:
> > > 
> > > While using the new_id interface, the user can unintentionally feed
> > > incorrect values if the driver static table has a matching entry.
> > > This is possible since only the device and vendor fields are
> > > mandatory and the rest are optional. As a result, store_new_id
> > > will fill in default values that are then passed on to the driver
> > > and can have unintended consequences.
> > > 
> > > As an example, consider the ixgbe driver and the 82599EB network card :
> > > echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
> > > 
> > > This will pass a driver_data value of 0 to the driver whereas
> > > the index 0 in ixgbe actually points to a different set of card
> > > operations.
> > > 
> > > This change returns an error if the user attempts to add a dynid for
> > > a vendor/device combination for which a static entry already exists.
> > > However, if the user intentionally wants a different set of values,
> > > she must provide all the 7 fields and that will be accepted.
> > > 
> > > In KVM/device assignment scenario, the user might want 
> > > to bind a device back to the host driver by writing to new_id
> > > and trip on a possible null pointer dereference.
> > 
> > I don't understand this last KVM comment.  If this patch fixes a null
> > pointer dereference, it must be because we return -EEXIST instead of
> > calling the driver's probe method.
> 
> Right, the NULL pointer dereference is because drivers implicitly trust
> the driver_data field supplied to their probe function.  This patch
> prevents the user from supplying a "shorthand" vendor/device new_id that
> would conflict with an existing static ID by returning -EEXIST on the
> new_id update.  This is not really a KVM problem, but prevention of a
> user error for the new_id interface; there is no reason for the user to
> add a new_id that duplicates an existing ID unless they want to modify
> the extended fields.

Yep, this all makes sense.  I think I'll just drop the KVM paragraph
from the changelog because the problem isn't KVM-specific.

> > I know you didn't add the new_id mechanism, and this patch makes it safer
> > than it was before, but I'm uneasy about it in general.  Most drivers do
> > not validate the driver_data value.  They assume it came out of the
> > id_table supplied by the driver and is therefore trustworthy.  But new_id
> > is a loophole that allows a user (hopefully only root) to pass arbitrary
> > junk to the driver.
> 
> The sysfs files are only accessible to root by default.  Your uneasiness
> seems to be the new_id mechanism in general.  It is a gap that drivers
> implicitly trust a field that can be supplied by the user.  I believe
> there's a test in the code somewhere that verifies that device_data at
> least matches an existing device_data as a small sanity check.  This
> patch closes another gap by disallowing new_ids that are not fully
> specified to supersede an existing entry. 

Yep, exactly.  This definitely makes it better than it was before.

> > I wonder if the device assignment machinery should be more integrated into
> > the PCI core instead of trying to be "just another driver."  It seems like
> > we're doing a lot of work to try to get the driver binding mechanism to do
> > what we need for device assignment.
> 
> This problem is only tangentially related to device assignment, any PCI
> driver can hit this.  Maybe in practice the reason for touching these
> files is often device assignment, but this interface pre-dates KVM.  Do
> you have suggestions how device assignment could be more integrated to
> PCI core?  Note that vfio is intentionally device agnostic and support
> for assignment of platform devices using vfio is being actively
> developed.

I don't have a suggestion, but I think using the driver model for this
feels a bit like putting a square peg in a round hole.  A device-
agnostic driver is sort of a strange concept to begin with, and the
machinations to tweak the driver/device binding order and pass a
device back and forth between host drivers and vfio seem sort of
artificial.  It feels like we're using the binding mechanism in a way
it wasn't designed for, and it's not surprising that there are issues.

> We do have a new binding mechanism awaiting review that
> tries to avoid some of the faults with the new_id/remove_id interface.
> In this case the user would not need to add a new_id and would use
> drivers_probe on both sides of the attach/re-attach.

I saw that go by, but haven't looked in detail.  I'm hoping Greg pays
attention to those, since he's more of an overall driver model guy
than I am.

Bjorn
