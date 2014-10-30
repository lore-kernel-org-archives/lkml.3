Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbaJ3QGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:06:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:36266 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ3QGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:06:34 -0400
Date: Thu, 30 Oct 2014 17:06:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        xen-devel@lists.xenproject.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 05/11] time: Convert all users of do_settimeofday()
 to use do_settimeofday64()
In-Reply-To: <CALAqxLV5EpXsfwUBj5-6uZb58Xaic+yzSON91-oOZm80LfCV1A@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410301659580.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-6-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1410301507350.5308@nanos> <CALAqxLV5EpXsfwUBj5-6uZb58Xaic+yzSON91-oOZm80LfCV1A@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, John Stultz wrote:
> On Thu, Oct 30, 2014 at 7:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > First of all this wants to be a seperate patch. Secondly it wants to
> > be a patch series which addresses the whole XEN space which is
> > involved in this. That involves other changes to x86 as well, but we
> > really can do better than mechanically pushing the problem one step
> > deeper just to get rid of the non safe do_settimeofday() variant.
> >
> > It does not matter WHEN we remove that. What matters is that we do the
> > conversion in sensible contexts and not by mechanically pushing the
> > problem one layer down, leave cryptic TODO comments around and think
> > we achieved something.
> 
> So agreed that this patch should be broken up.
> 
> And yea, as a side effect of your earlier feedback to add 64bit
> interfaces and slowly migrate, I guess it does make sense to handle
> all the interfaces first, and then cohesively address each subsystem,
> rather then addressing interface by interface through the whole
> system.  My suggested partitioning of the problem doesn't produce as
> nice to understand patches.

This is very different to the BKL push down, where we really had to
see the context in the particular file/subsystem to understand what it
was actually protecting or not.

> That said, this is a big project with a number of folks attacking it,
> and as seen in the Xen code (where xen's settime logic bleeds into the
> pv persistent clock logic), if we go subsystem by subsystem rather
> then interface by interface, there will be cases where subsystems
> interact and I think we'll still have to have similar TODOs notes and
> iterations. I think having some greppable tag in the comments will
> help as we iterate through things.

That's fine as long as we do not just go blindly and push stuff down
one level deeper w/o looking at the complete call chain first. Doing
the whole x86 rtc related stuff in one series (after the core
interfaces are in place) avoids the whole todo churn nicely.

Interactions are expected, but we should avoid them if possible by
partitioning the patches in a sensible manner.
 
> > John: What kind of weird hackery is that alarm-dev thing? This should
> > rather die than being fixed.
> 
> I think it was agreed at plumbers that we can drop alarm-dev from
> staging. But if its fixed before its dropped, or just dropped doesn't
> matter.

One pointless patch less :)

We really can leave that alone and either kill do_settimeofday() after
its gone or expedite its death by removing do_settimeofday().

Thanks,

	tglx
