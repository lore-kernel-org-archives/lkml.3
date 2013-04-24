Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3DXVPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:15:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3DXVPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:15:01 -0400
Date: Wed, 24 Apr 2013 14:14:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] rtc: rtc-hid-sensor-time; add option hctosys to set
 time at boot
Message-Id: <20130424141459.df581d79e6e296f90eb1369c@linux-foundation.org>
In-Reply-To: <5176AD08.8090108@ahsoftware.de>
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
	<1366384452-14367-4-git-send-email-holler@ahsoftware.de>
	<20130422163830.4aaaef240b1572dc778dd620@linux-foundation.org>
	<51764B8E.9090402@ahsoftware.de>
	<51765D8C.1010008@ahsoftware.de>
	<51765ECD.6020601@ahsoftware.de>
	<51765FB9.2050009@ahsoftware.de>
	<5176AD08.8090108@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013 17:47:20 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

> >>> "time_was_set_once" and have choosen one day just in case something
> >>> needs really long to boot (e.g. because of some lengthy fsck or whatever
> >>> else).
> >>>
> >>> A solution to both problems might be to change the logic for hctosys
> >>> completly to read the time when the first RTC device appears (or when
> >>> the device mentioned in CONFIG_RTC_HCTOSYS_DEVICE appears). But that
> >>> would require a change to hctosys or the RTC subsystem, which would
> >>> involve more patches and discussion. As rtc-hid-sensor-time currently
> >>> seems to be the only RTC with the above problems, I've gone the easy
> >>> route and only modified this driver.
> >>
> >> Oh, damn. I've forgotten my example above with NTP. In that case setting
> >> the time when the first RTC appears doesn't work.
> >
> > So a general solution might be to set the system time when the first RTC
> > (or the one mentioned in CONFIG_RTC_HCTOSYS_DEVICE) appears AND nothing
> > else did set the time before.
> 
> To extend that idea a bit further, I think an option timewait (similiar 
> to rootwait) would be a nice to have.
> 
> If just time wouldn't be that rare ... ;)

Yes, some sort of notifier callout when the CONFIG_RTC_HCTOSYS_DEVICE
device is registered seems appropriate.  I didn't understand why that
is problematic for NTP.

Getting all the lifetime/reference stuff right will be tricky :( Can't
shut down or unload a driver when it is on that notification list.

And it assumes that the CONFIG_RTC_HCTOSYS_DEVICE driver is all ready
to go when it registers itself.  Hopefully that is true, but they
should be reviewed.

Adding the timewait thing sounds unpleasant - how to reliably tune the
interval for all possible users of your distro?  We should aim to make
things synchronous, deterministic and
stuff-happens-in-the-correct-order.

It all sounds like a moderate amount of work, but it would be great
to be able to fix this for all drivers, not just hid-sensor-time.  That's
assuming that other drivers have the same issue - perhaps they don't,
but perhaps things can go wrong if the module loading order is wrong?
