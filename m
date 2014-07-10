Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaGJXJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:09:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaGJXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:09:09 -0400
Date: Thu, 10 Jul 2014 16:09:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] kernel: Add support for restart notifier call
 chain
Message-Id: <20140710160907.da1024914366de947ebdf384@linux-foundation.org>
In-Reply-To: <1404877083-6552-1-git-send-email-linux@roeck-us.net>
References: <1404877083-6552-1-git-send-email-linux@roeck-us.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jul 2014 20:37:56 -0700 Guenter Roeck <linux@roeck-us.net> wrote:

> The existing mechanisms have a number of drawbacks. Typically only one scheme
> to restart the system is supported (at least if arm_pm_restart is used).
> At least in theory there can be mutliple means to restart the system, some of
> which may be less desirable (for example one mechanism may only reset the CPU,
> while another may reset the entire system).

So the callbacks need to be prioritized.

> Using arm_pm_restart can also be
> racy if the function pointer is set from a driver, as the driver may be in
> the process of being unloaded when arm_pm_restart is called.
> Using the reboot notifier is always racy, as it is unknown if and when
> other functions using the reboot notifier have completed execution
> by the time the watchdog fires.
> 
> To solve the problem, introduce a system restart notifier. This notifier
> is expected to be called from the architecture specific machine_restart()
> function. Drivers providing system restart functionality (such as the watchdog
> drivers mentioned above) are expected to register with this notifier.

It's worth mentioning here that the notifier_block priority scheme is
used to address the problem which was identified in the previous
paragraph.

If this scheme is to be successful we will need to set in place some
protocol for specifying how the priorities are managed.  If someone
sits down and writes a new restart handler, how is that person to
decide how to prioritize it against other handlers, both present and
future?

Also, looking at the patches, you don't appear to have actually *used*
the prioritization - everything is left at zero.  So we'll end up using
the most-recently-registered handler to restart the system.  The
patches don't actually solve the problem which was identified in the
above paragraph?
