Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaIDTVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:21:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62359 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755254AbaIDTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:21:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [stable -3.14] PM backports for pm_test / CONFIG_PM_DEBUG
Date: Thu, 04 Sep 2014 21:40:41 +0200
Message-ID: <1849024.CHOUso6H2K@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140904010219.GA18411@ld-irv-0074>
References: <20140904010219.GA18411@ld-irv-0074>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 03, 2014 06:02:19 PM Brian Norris wrote:
> Hi,
> 
> If I enable CONFIG_PM_DEBUG on a 3.14.y kernel, I can see the following
> results:
> 
>     # cat /sys/power/state
>     freeze standby mem
>     # cat /sys/power/pm_test
>     [none] core processors platform devices freezer
>     # echo core > /sys/power/pm_test
>     # cat /sys/power/state
>     [   22.581289] Unsupported pm_test mode for freeze state, please choose none/freezer/devices/platform.
>     standby mem
> 
> Note how 'freeze' is dropped from the supported states, and I get an
> extra printk message when I'm just checking if the state is valid.
> 
> It looks like if I backport a few fixes, I get more sane behavior, where
> the warnings (and -EAGAIN) appear only when I actually try to enter an
> unsupported test mode:
> 
>     # echo core > /sys/power/pm_test
>     # cat /sys/power/state
>     freeze standby mem
>     # echo freeze > /sys/power/state
>     [   27.833141] PM: Unsupported test mode for freeze state,please choose none/freezer/devices/platform.
>     sh: echo: write error: Resource temporarily unavailable
> 
> I think I've narrowed it down to this commit that should be backported
> to -stable (for 3.9+?):
> 
>     43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only
> 
> But it needs to drag along this dependency too:
> 
>     27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries

That sounds OK.

Can you please send a formal request to include the two commits above to Greg/stable?

> While at this, it looks like this commit might be deserving of -stable
> (3.9+). I haven't tested this one, as I don't have a good freeze+cpuidle
> setup; it just shows up in the commit log with an interesting
> description and a 'Fixes' tag:
> 
>     f3f125324fc1 PM / suspend: Make cpuidle work in the "freeze" state

Well, it basically makes the freeze state save energy, but it's not essential.

I'm not seeing the "Fixes:" tag on it, though.

Rafael

