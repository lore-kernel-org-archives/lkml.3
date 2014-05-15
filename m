Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaEOP67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:58:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42607 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755286AbaEOP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:58:56 -0400
Date: Thu, 15 May 2014 11:58:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming
 runtime-suspended devices unnecessarily
In-Reply-To: <20140515000320.3c1c9256@jacob-desktop>
Message-ID: <Pine.LNX.4.44L0.1405151151560.910-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Jacob Pan wrote:

> On Thu, 15 May 2014 10:29:42 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Thu, 15 May 2014, Jacob Pan wrote:
> > 
> > > > > should we respect ignore_children flag here? not all parent
> > > > > devices create children with proper .prepare() function. this
> > > > > allows parents override children.
> > > > > I am looking at USB, a USB device could have logical children
> > > > > such as ep_xx, they don't go through the same
> > > > > subsystem .prepare().
> > > > 
> > > > Well, I'm not sure about that.  Let me consider that for a while.
> > > OK. let me be more clear about the situation i see in USB. Correct
> > > me if I am wrong, a USB device will always has at least one
> > > endpoint/ep_00 as a kid for control pipe, it is a logical device.
> > > So when device_prepare() is called, its call back is NULL which
> > > makes .direct_complete = 0. Since children device suspend is called
> > > before parents, the parents .direct_complete flag will always get
> > > cleared.
> > > 
> > > What i am trying to achieve here is to see if we avoid resuming
> > > built-in (hardwired connect_type) non-hub USB devices based on this
> > > new patchset. E.g. we don't want to resume/suspend USB camera every
> > > time in system suspend/resume cycle if they are already rpm
> > > suspended. We can save ~100ms resume time for the devices we have
> > > tested.
> > 
> > This is a good point, but I don't think it is at all related to 
> > ignore_children.
> > 
> > Instead, it seems that the best way to solve it would be to add a 
> > ->prepare() handler for usb_ep_device_type that would always turn 
> > on direct_complete.
> > 
> yeah, that would solve the problem with EP device type. But what about
> other subdevices. e.g. for USB camera, uvcvideo device? We can add
> .prepare(return 1;) for each level but would it be better to have a
> flag similar to ignore_children if not ignore_children itself.

Something like that could always be added.

> Actually, I don't understand why this is not related to
> ignore_children. Could you explain?

It's hard to explain why two things are totally separate.  Much better 
for you to describe why you think they _are_ related, so that I can 
explain how you are wrong.

> If the parent knows it can ignore children and already rpm suspended,
> why do we still ask children?

The "ignore_children" flag doesn't mean that the parent can ignore its 
children.  It means that the PM core is allowed to do a runtime suspend 
of the parent while leaving the children at full power.

In particular, it doesn't mean that the children's ->suspend() callback 
will work correctly if it is called while the parent is runtime 
suspended.

Alan Stern

