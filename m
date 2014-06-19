Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaFSOeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:34:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59860 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757420AbaFSOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:34:03 -0400
Date: Thu, 19 Jun 2014 10:34:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <3528855.Z370J7O75B@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1406191020140.1247-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Rafael J. Wysocki wrote:

> Well, we used to have the notion that runtime_status is not meaningful for
> devices with dev->power.disable_depth greater than 0 (except for the special
> case in the suspend code path where we know why it is greater than 0).  I think
> it was useful. :-)

Did we really have that notion?  My memory is a little cloudy, but I 
thought we decided that runtime_status would not be meaningful when 
dev->power.runtime_error was set -- not when dev->power.disable_depth 
was greater than 0.  Am I mixed up?

In any case, I think it is reasonable to regard runtime_status as 
meaningful when disable_depth > 0.  The PM core isn't allowed to invoke 
the runtime callbacks at such times, that's all.  This makes perfect 
sense for a device that doesn't support power management and hence must 
always be at full power.  Or when a driver knows that runtime_status is 
out of agreement with the device's actual power state and wants to 
update runtime_status directly.


> > So pm_runtime_resume() and pm_request_resume() would still fail, but 
> > pm_runtime_get() and pm_runtime_get_sync() would work?  I'm not sure 
> > about the reason for this distinction.
> 
> The meaning of pm_runtime_get()/pm_runtime_get_sync() is "prevent the
> device from being suspended from now on and resume it if necessary" while
> "runtime PM disabled and runtime_status == RPM_ACTIVE" may be interpreted
> as "not necessary to resume", so it is reasonable to special case this
> particular situation for these particular routines IMHO.

By the same reasoning, the meaning of pm_runtime_resume() is "resume 
the device now if necsesary".  Since "runtime PM disabled and 
runtime_status == RPM_ACTIVE" means "not necessary to resume", isn't it 
logical for pm_runtime_resume() also to succeed under that condition?

Alan Stern

