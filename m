Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbaIDBC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:02:28 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45999 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbaIDBCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:02:25 -0400
Date: Wed, 3 Sep 2014 18:02:19 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>
Subject: [stable -3.14] PM backports for pm_test / CONFIG_PM_DEBUG
Message-ID: <20140904010219.GA18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If I enable CONFIG_PM_DEBUG on a 3.14.y kernel, I can see the following
results:

    # cat /sys/power/state
    freeze standby mem
    # cat /sys/power/pm_test
    [none] core processors platform devices freezer
    # echo core > /sys/power/pm_test
    # cat /sys/power/state
    [   22.581289] Unsupported pm_test mode for freeze state, please choose none/freezer/devices/platform.
    standby mem

Note how 'freeze' is dropped from the supported states, and I get an
extra printk message when I'm just checking if the state is valid.

It looks like if I backport a few fixes, I get more sane behavior, where
the warnings (and -EAGAIN) appear only when I actually try to enter an
unsupported test mode:

    # echo core > /sys/power/pm_test
    # cat /sys/power/state
    freeze standby mem
    # echo freeze > /sys/power/state
    [   27.833141] PM: Unsupported test mode for freeze state,please choose none/freezer/devices/platform.
    sh: echo: write error: Resource temporarily unavailable

I think I've narrowed it down to this commit that should be backported
to -stable (for 3.9+?):

    43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only

But it needs to drag along this dependency too:

    27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries

While at this, it looks like this commit might be deserving of -stable
(3.9+). I haven't tested this one, as I don't have a good freeze+cpuidle
setup; it just shows up in the commit log with an interesting
description and a 'Fixes' tag:

    f3f125324fc1 PM / suspend: Make cpuidle work in the "freeze" state

Regards,
Brian
