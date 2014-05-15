Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaEOPEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:04:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:27438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbaEOPEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:04:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="541001182"
Date: Thu, 15 May 2014 00:03:20 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming
 runtime-suspended devices unnecessarily
Message-ID: <20140515000320.3c1c9256@jacob-desktop>
In-Reply-To: <Pine.LNX.4.44L0.1405151024060.1415-100000@iolanthe.rowland.org>
References: <20140515060924.69ae7486@ultegra>
	<Pine.LNX.4.44L0.1405151024060.1415-100000@iolanthe.rowland.org>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 10:29:42 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 15 May 2014, Jacob Pan wrote:
> 
> > > > should we respect ignore_children flag here? not all parent
> > > > devices create children with proper .prepare() function. this
> > > > allows parents override children.
> > > > I am looking at USB, a USB device could have logical children
> > > > such as ep_xx, they don't go through the same
> > > > subsystem .prepare().
> > > 
> > > Well, I'm not sure about that.  Let me consider that for a while.
> > OK. let me be more clear about the situation i see in USB. Correct
> > me if I am wrong, a USB device will always has at least one
> > endpoint/ep_00 as a kid for control pipe, it is a logical device.
> > So when device_prepare() is called, its call back is NULL which
> > makes .direct_complete = 0. Since children device suspend is called
> > before parents, the parents .direct_complete flag will always get
> > cleared.
> > 
> > What i am trying to achieve here is to see if we avoid resuming
> > built-in (hardwired connect_type) non-hub USB devices based on this
> > new patchset. E.g. we don't want to resume/suspend USB camera every
> > time in system suspend/resume cycle if they are already rpm
> > suspended. We can save ~100ms resume time for the devices we have
> > tested.
> 
> This is a good point, but I don't think it is at all related to 
> ignore_children.
> 
> Instead, it seems that the best way to solve it would be to add a 
> ->prepare() handler for usb_ep_device_type that would always turn 
> on direct_complete.
> 
yeah, that would solve the problem with EP device type. But what about
other subdevices. e.g. for USB camera, uvcvideo device? We can add
.prepare(return 1;) for each level but would it be better to have a
flag similar to ignore_children if not ignore_children itself.
Actually, I don't understand why this is not related to
ignore_children. Could you explain?

If the parent knows it can ignore children and already rpm suspended,
why do we still ask children?

> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

[Jacob Pan]
