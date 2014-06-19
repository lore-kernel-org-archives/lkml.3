Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaFSO4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:56:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59896 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932490AbaFSO4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:56:31 -0400
Date: Thu, 19 Jun 2014 10:56:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Allen Yu <alleny@nvidia.com>, Kevin Hilman <khilman@ti.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <9E7892CE01168A46922BCCE04DB02F9828F863E9@HKMAIL01.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1406191049240.1247-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Allen Yu wrote:

> So what's the exact state of device if dev->power.is_suspended flag
> is set and runtime_status is RPM_ACTIVE? Is it a state like
> "suspended but still can be accessed"?
> 
> I'm just afraid the existing code would cause a device hang if we
> allow it to be accessed even though it's suspended (at this point
> RPM_ACTIVE could be meaningless). I don't understand the original
> motivation of these code. If it's a valid case, most likely it should
> be handled in the specific device driver instead of the PM core.

You should read the Changelog for commit 6f3c77b040f (PM / Runtime:  
let rpm_resume() succeed if RPM_ACTIVE, even when disabled, v2).  It
explains why the code looks the way it does.

However, I'm starting to think the reasoning in that commit may not be
valid.  While perhaps it is okay for some I2C devices (mentioned in the
commit log), it probably isn't okay in general.

Kevin, do have any comments on this matter?  What do you think about 
making the following change to rpm_resume():

 repeat:
	if (dev->power.runtime_error)
		retval = -EINVAL;
-	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
+	else if (dev->power.disable_depth > 0
	    && dev->power.runtime_status == RPM_ACTIVE)
		retval = 1;
	else if (dev->power.disable_depth > 0)

Or even:

+	else if (dev->power.disable_depth > 0 && !dev->power.is_suspended

although this would require the I2C driver you mentioned in your commit 
to change.

Alan Stern

