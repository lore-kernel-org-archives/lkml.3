Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3FFOMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:12:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36023 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751751Ab3FFOMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:12:05 -0400
Date: Thu, 6 Jun 2013 10:12:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zoran Markovic <zoran.markovic@linaro.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Colin Cross <ccross@android.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend/resume.
In-Reply-To: <CAME+o4mkBknj0jiUW=Z77fG1bJYy1jHF7=shNQ_ixeL_oJDjFg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1306061006070.1069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Zoran Markovic wrote:

> > It does block in my environment, AFAICS. Looking a bit further in the
> > code, it looks like dpm_suspend() does an async_synchronize_full()
> > which would wait for all async tasks to complete. This is a
> > show-stopper because (under the circumstances) the assumption that
> > every async suspend routine eventually completes doesn't hold.
> >
> > We could possibly select which async tasks to wait for, but this would
> > add unnecessary complexity to a feature targeted for debugging. It
> > seems that this approach - although sounding reasonable - needs to
> > wait until we have a mechanism to cancel an async task.
> 
> Looks like the implementation of proposal for an async suspend +
> wait_for_completion_timeout is quite complex due to above limitations.
> How do we proceed from here? We have the following options:
> 1. Give up on the idea of having a suspend/resume watchdog.
> 2. Use the timer implementation (with possible modifications).
> 3. Wait for the implementation of (or implement) killing of an already
> running async work.
> 
> Are there any other ideas floating around?

In general, the kernel is not designed to operate when kernel threads 
get killed at random times.  It's also not designed to operate normally 
while in the middle of a system suspend.

This means there is basically no hope of recovering from a hung async 
suspend task.  (In much the same way, there is no hope of recovering 
from any hung kernel thread.)  The best you can accomplish is to store 
some useful information somewhere and either panic or force a reboot.

Given that the usual storage media may be inaccessible, it may not be 
easy to find a place to store the information.

(By the way, what do you do if a _synchronous_ suspend routine hangs?  
The two problems are fairly similar.)

Alan Stern

