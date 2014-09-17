Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaIQO0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:26:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54119 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaIQO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:26:52 -0400
Date: Wed, 17 Sep 2014 10:25:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Pavel Machek <pavel@denx.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Dinh Nguyen <dinguyen@altera.com>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.17-rc2: root=/dev/mmcblk0p2 command line parsing fails
Message-ID: <20140917142542.GA5225@windriver.com>
References: <1405397216-909-1-git-send-email-dinguyen@altera.com>
 <53C4D874.2040206@samsung.com>
 <20140814184710.GA11558@amd.pavel.ucw.cz>
 <53ED2262.50604@gmail.com>
 <20140814210252.GB26857@amd.pavel.ucw.cz>
 <20140826114707.GA16372@amd>
 <CADhT+wdx2SsHnk=zML7a6mUVJxvLQ9ARO16QoYYsopAqhw7cow@mail.gmail.com>
 <20140909114941.GE15404@amd>
 <20140917132002.GS12361@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917132002.GS12361@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: 3.17-rc2: root=/dev/mmcblk0p2 command line parsing fails] On 17/09/2014 (Wed 14:20) Russell King - ARM Linux wrote:

[...]

> I think the problem may be 4dfe694f616e00e6fd83e5bbcd7a3c4d7113493d
> ("init: make rootdelay=N consistent with rootwait behaviour") which
> was merged during the recent window.  This moved the delay after the
> saved_root_name[] handling.  As we can see in the SDP4430 case, the
> order was:

[...]

> 
> 
> If ROOT_DEV was still zero, and root_wait was set (it isn't) we'd then
> try to re-evaluate ROOT_DEV.  ROOT_DEV must be set to mount the rootfs,
> and we can see from the above failure messages that it was still zero.
> That works out, because this code would never be run with root_wait=false.
> 
> The reason it used to work is because the delay came _before_ the first
> "if" above, so causing the first ROOT_DEV lookup to succeed.
> 
> I think it may be better to move the root_delay handling either immediately
> after md_run_setup(), or we need to re-lookup ROOT_DEV after the delay.
> Paul, any thoughts?

After discussing it more on irc, it seems like moving the delay/wait
handling after md_run_setup [i.e. to the original location of delay vs.
the original location of wait] is probably best.

But, given as the original commit log indicated -- there may be a risk
of other corner cases subtly being broken by such a change, it is
probably best if we just revert the original now, and then try again in
the alternate location in the next dev cycle.  I'll send a revert
shortly.

Thanks for diagnosing this.
Paul.
--

> 
> -- 
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
