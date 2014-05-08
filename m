Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaEHVIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:08:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42635 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755646AbaEHVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:08:17 -0400
Date: Thu, 8 May 2014 17:08:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of
 runtime-suspended devices
In-Reply-To: <3058268.hrHgpxktTP@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405081700480.995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Rafael J. Wysocki wrote:

> > Wait a minute.  Following ->runtime_suspend(), you are going to call 
> > ->suspend() and then ->runtime_resume()?  That doesn't seem like what 
> > you really want; a ->suspend() call should always have a matching 
> > ->resume().
> 
> Yes, it should, but I didn't see any other way to do that.
> 
> > I guess you did it this way to allow for runtime-resumes and -suspends 
> > between ->prepare() and ->suspend(), but it still seems wrong.
> 
> No.  I did that to allow ->suspend() to check whether or not the device is
> in the right state.  ->prepare() could do that, arguably, but then there's
> the case when ->runtime_suspend() may still be running in parallel with it.
> And the device may be runtime-suspended immediately before its ->suspend()
> in theory if its children do pm_runtime_put_sync(parent).
> 
> Also, this is a bus type ->suspend(), so the *driver* ->suspend()
> won't be called at this point in the ACPI PM domain case for example.
> 
> > How about asking drivers to set leave_runtime_suspended in their
> > ->runtime_suspend() callbacks, as well as during ->prepare()?  Then
> > intervening runtime resume/suspend cycles wouldn't matter and you
> > wouldn't need to call ->suspend(); you could skip it along with the
> > other PM callbacks.
> 
> That wouldn't work, because they cannot know the target sleep state of the
> system in advance.  This only is known during the given suspend sequence.

Argh!  We're both being foolish.  Runtime suspends can't occur between 
->prepare() and ->suspend(), because device_prepare() does a 
pm_runtime_get_noresume.

You might still have to worry about a runtime suspend concurrent with
->prepare(), though.  An appropriate barrier could fix that.

Alan Stern

