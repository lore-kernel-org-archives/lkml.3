Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3LTTzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:55:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36796 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3LTTz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:55:29 -0500
Date: Fri, 20 Dec 2013 20:55:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        santosh.shilimkar@ti.com
Subject: Re: [RFC/PATCH 1/3] pm: make PM macros more smart
Message-ID: <20131220195527.GA25927@amd.pavel.ucw.cz>
References: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
 <1386911905-2366-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131215175112.GA23298@Nokia-N900>
 <20131215192508.GA10514@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215192508.GA10514@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-12-15 11:25:08, David Cohen wrote:
> On Sun, Dec 15, 2013 at 06:51:12PM +0100, Pavel Machek wrote:
> > On Thu 2013-12-12 21:18:23, David Cohen wrote:
> > > This patch makes SET_SYSTEM_SLEEP_PM_OPS() and SET_RUNTIME_PM_OPS() more
> > > smart.
> > > 
> > > Despite those macros check for '#ifdef CONFIG_PM_SLEEP/RUNTIME' to avoid
> > > setting the callbacks when such #ifdef's aren't defined, they don't
> > > handle compiler to avoid messages like that:
> > > 
> > > drivers/usb/host/xhci-plat.c:200:12: warning: ???xhci_plat_suspend??? defined but not used [-Wunused-function]
> > > drivers/usb/host/xhci-plat.c:208:12: warning: ???xhci_plat_resume??? defined but not used [-Wunused-function]
> > > 
> > > As result, those macros get rid of #ifdef's when setting callbacks but
> > > not when implementing them.
> > > 
> > > With this patch, drivers using SET_*_PM_OPS() macros don't need to #ifdef
> > > the callbacks implementation as well.
> > 
> > Well... Interesting trickery, but it means that resulting kernel
> > will be bigge due to the dead functions no?
> 
> Actually, it doesn't get bigger. Before sending the patch I did this
> dummy test app:
> 
> --------------------------------------------------------------------------------
> #include <stdio.h>
> 
> #define USE_IT_OR_LOOSE_IT(fn)  ((void *)((unsigned long)(fn) - (unsigned long)(fn)))
> 
> #ifdef MAKE_ME_NULL
> static int func1(int a)
> {
>         printf("Hey!!\n");
>         return 0;
> }
> #endif

I thought that point of this patch series was getting rid of the
#ifdefs around the function...? Now I'm confused.

> struct global_data {
>         int (*func)(int);
> };
> 
> static struct global_data gd = {
> #ifdef MAKE_ME_NULL
>         .func = USE_IT_OR_LOOSE_IT(func1),

If you have ifdef around the function, why do you need magic here? Why
not

	.func = func1

?

Basically the warning tells you that you want the ifdef around the
function, too... (Otherwise you waste space). That seems like good
warning.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
