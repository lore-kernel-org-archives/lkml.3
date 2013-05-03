Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3ECOtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab3ECOtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:49:20 -0400
Date: Fri, 3 May 2013 10:49:12 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
Message-ID: <20130503144912.GB1283@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130430212007.GB18598@redhat.com>
 <20130430213719.GA14988@redhat.com>
 <alpine.LFD.2.02.1305021234510.3972@ionos>
 <20130502154621.GA23990@redhat.com>
 <alpine.LFD.2.02.1305022152280.2891@ionos>
 <CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
 <alpine.LFD.2.02.1305022304370.2891@ionos>
 <CAE9FiQWFK_ropzW_qQLcNxLYyek8-PHGW-8SxfZJSijvdrss1A@mail.gmail.com>
 <alpine.LFD.2.02.1305022337470.2891@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305022337470.2891@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:49:20AM +0200, Thomas Gleixner wrote:

 > I'm fundamentally confused and Daves observation about slub debug does
 > not make it less confusing.
 > 
 > It'd be nice if you could add some more instrumentation or bisect the
 > issue.

Here's what I ended up with..

git bisect start
# good: [8cf90797fc2d7172480343cda0ff5898b92afc94] Merge branch 'master' of /home/davej/src/kernel/git-trees/linux
git bisect good 8cf90797fc2d7172480343cda0ff5898b92afc94
# bad: [a9754f91ed5255a992dc4c230f8b4b6ee57c399a] Merge branch 'master' of /home/davej/src/kernel/git-trees/linux
git bisect bad a9754f91ed5255a992dc4c230f8b4b6ee57c399a
# good: [ec25e246b94a3233ab064994ef05a170bdba0e7c] Merge tag 'usb-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good ec25e246b94a3233ab064994ef05a170bdba0e7c
# good: [8700c95adb033843fc163d112b9d21d4fda78018] Merge branch 'smp-hotplug-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 8700c95adb033843fc163d112b9d21d4fda78018
# good: [a6f5635e63ffa02c30a22ea4af21f3daa1e98cdf] [media] exynos4-is: Improve the ISP chain parameter count calculation
git bisect good a6f5635e63ffa02c30a22ea4af21f3daa1e98cdf
# good: [df90e2258950fd631cdbf322c1ee1f22068391aa] Merge branch 'devel-for-v3.10' into v4l_for_linus
git bisect good df90e2258950fd631cdbf322c1ee1f22068391aa
# bad: [19b344efa35dbc253e2d10403dafe6aafda73c56] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect bad 19b344efa35dbc253e2d10403dafe6aafda73c56
# bad: [74c7d2f5200a340ae6655e9adcf990381e387937] Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 74c7d2f5200a340ae6655e9adcf990381e387937
# bad: [77c675ba18836802f6b73d2d773481d06ebc0f04] timekeeping: Update tk->cycle_last in resume
git bisect bad 77c675ba18836802f6b73d2d773481d06ebc0f04
# bad: [0ed2aef9b3bffe598045b62a31a50d912eee92d8] Merge branch 'fortglx/3.10/time' of git://git.linaro.org/people/jstultz/linux into timers/core
git bisect bad 0ed2aef9b3bffe598045b62a31a50d912eee92d8
# good: [dd5d70e869f960bde6376f4447fff59f16186cf5] timekeeping: __timekeeping_set_tai_offset can be static
git bisect good dd5d70e869f960bde6376f4447fff59f16186cf5
# bad: [989dcb645ca715129c5a2b39102c8334a20d9615] tick: Handle broadcast wakeup of multiple cpus
git bisect bad 989dcb645ca715129c5a2b39102c8334a20d9615
# bad: [f9ae39d04ccdec8d8ecf532191b7056c279a22c0] tick: Pass broadcast device to tick_broadcast_set_event()
git bisect bad f9ae39d04ccdec8d8ecf532191b7056c279a22c0
# bad: [b352bc1cbc29134a356b5c16ee2281807a7b984e] tick: Convert broadcast cpu bitmaps to cpumask_var_t
git bisect bad b352bc1cbc29134a356b5c16ee2281807a7b984e
# good: [ad2b13536ace08dfcca4cf86b75a5d06efe06373] tick: Call tick_init late
git bisect good ad2b13536ace08dfcca4cf86b75a5d06efe06373

b352bc1cbc29134a356b5c16ee2281807a7b984e is the first bad commit
commit b352bc1cbc29134a356b5c16ee2281807a7b984e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Mar 5 14:25:32 2013 +0100

    tick: Convert broadcast cpu bitmaps to cpumask_var_t
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/r/20130306111537.366394000@linutronix.de
    Cc: Rusty Russell <rusty@rustcorp.com.au>

:040000 040000 689609c27a2c8da0b09f8136f4552ab8814a0094 9e59b78318177ec8267e1fabfdede034c3fb6b4f M	kernel



