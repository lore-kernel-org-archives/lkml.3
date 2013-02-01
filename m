Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3BAP2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:28:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35238 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754766Ab3BAP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:28:20 -0500
Date: Fri, 1 Feb 2013 10:28:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Derek Basehore <dbasehore@chromium.org>, <JBottomley@parallels.com>,
        Jeff Garzik <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
In-Reply-To: <510BAC49.7000709@intel.com>
Message-ID: <Pine.LNX.4.44L0.1302011026070.1752-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Aaron Lu wrote:

> Hi Derek,
> 
> On 12/21/2012 12:35 PM, Derek Basehore wrote:
> > We no longer wait for the disk to spin up in sd_resume. It now enters the
> > request to spinup the disk into the elevator and returns.
> > 
> > A function is scheduled under the scsi_sd_probe_domain to wait for the command
> > to spinup the disk to complete. This function then checks for errors and cleans
> > up after the sd resume function.
> > 
> > This allows system resume to complete much faster on systems with an HDD since
> > spinning up the disk is a significant portion of resume time.
> 
> An alternative way of possibly solving this problem from PM's point of
> view might be:
> 1 Set both ata port and scsi device's runtime status to RPM_SUSPENDED
>   in their system suspend callback;
> 2 On resume, do nothing in their system resume callback;
> 3 With request based runtime PM introduced here:
>   http://thread.gmane.org/gmane.linux.power-management.general/30405
>   When a request comes for the HDD after system resume, both the ata
>   port and the scsi device will be runtime resumed, which involves
>   re-initialize the ata link(in ata port's runtime resume callback) and
>   spin up the HDD(in sd's runtime resume callback).
> 
> To make HDD un-affetcted by runtime PM during normal use, a large enough
> autosuspend_delay can be set for it.
> 
> Just my 2 cents, I've not verified or tried in any way yet :-)

It's a good idea.  The problem is that it won't work if CONFIG_PM_SLEEP
is enabled but CONFIG_PM_RUNTIME isn't.

Alan Stern

