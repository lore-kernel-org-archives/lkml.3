Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966537Ab3E2Tin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:38:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:64221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966298Ab3E2Tid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:38:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="321499521"
Date: Wed, 29 May 2013 12:38:28 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Shawn Nematbakhsh <shawnn@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
Message-ID: <20130529193828.GK32085@xanatos>
References: <20130524210503.GC15788@xanatos>
 <Pine.LNX.4.44L0.1305251005390.18146-100000@netrider.rowland.org>
 <CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
 <20130528205842.GE32085@xanatos>
 <CAODwPW8ynh3238T6gOVmneMqsbdR2m+wPnVLbS7c38mQxCpBSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW8ynh3238T6gOVmneMqsbdR2m+wPnVLbS7c38mQxCpBSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 02:41:18PM -0700, Julius Werner wrote:
> The policy we want to achieve is to disable runtime PM iff there is a
> device connected that doesn't have persist_enabled or a reset_resume()
> handler and whose parent/root hub resets on resume, right?

Makes sense.  However, not all distros may want that policy, so there
should be a way to change that policy via sysfs.  Some distros may
choose to take the power savings over having a particular USB device
work, especially in the server market.

Don, Oliver, what do you think of this patch:
http://marc.info/?l=linux-usb&m=136941922715772&w=2

Julius is proposing to limit the scope of the patch a bit, but the
impact will still be that TI hosts will be active more often than not.

> So couldn't
> we remove the HCD-specific XHCI_RESET_ON_RESUME and set the (existing)
> generic USB_QUIRK_RESET_RESUME on the root hub instead?  Then we could
> handle all of this in the USB core (during device initialization and
> when changing persist_enabled through sysfs) by just checking for
> udev->reset_resume on all parent hubs of the device in question (and
> use pm_runtime_get/put() on said device to prevent its parents from
> suspending as appropriate).

Alan, what happens if we set USB_QUIRK_RESET_RESUME on the roothub?
I don't think that currently translates into the host controller's Reset
register getting written, which is what I think Julius is proposing.

Sarah Sharp
