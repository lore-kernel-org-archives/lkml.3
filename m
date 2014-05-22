Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaEVSOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:14:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42716 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751158AbaEVSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:14:41 -0400
Date: Thu, 22 May 2014 14:14:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Will Deacon <will.deacon@arm.com>
cc: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: Runtime PM workqueue killing system performance with USB
In-Reply-To: <20140522173951.GD14641@arm.com>
Message-ID: <Pine.LNX.4.44L0.1405221401350.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Will Deacon wrote:

> > Anyway, there are two possible ways of handling this.  One is to avoid 
> > changing the error code to -EBUSY when the device in question is a root 
> > hub.  Just let it go into a runtime-PM error state; it won't matter 
> > since the controller doesn't support runtime PM anyway.  You can test 
> > this by changing the "if (status != 0)" line in usb_runtime_suspend to
> > 
> > 	if (status != 0 && udev->parent)
> 
> I'd tried something like this already, but I prefer your patch below. Plus,
> this hack results in a failure being logged to dmesg on the initial suspend
> attempt.
> 
> > The other approach is to disable runtime PM for the root hub when the 
> > host controller driver doesn't have a bus_suspend or bus_resume method.
> > This seems like a cleaner approach; the patch below implements it.
> 
> Thanks for this! I can confirm that your patch below fixes the issue for me,
> so:
> 
>   Reported-by: Will Deacon <will.deacon@arm.com>
>   Tested-by: Will Deacon <will.deacon@arm.com>

You know, I think it might be best to make both changes.  Even though 
runtime PM will be disabled by default, the user can always override 
this setting.  If that happens, the suspend should fail with the proper 
error code instead of going into a loop.

Do you mind if I add the change to usb_runtime_suspend() in the patch?

Alan Stern

