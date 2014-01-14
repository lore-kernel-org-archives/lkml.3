Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaANWhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:37:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:2729 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaANWhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:37:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="438876254"
Date: Tue, 14 Jan 2014 14:42:11 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rjw@rjwysocki.net, len.brown@intel.com, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        santosh.shilimkar@ti.com
Subject: Re: [RFC/PATCH 1/3] pm: make PM macros more smart
Message-ID: <20140114224211.GA9834@psi-dev26.jf.intel.com>
References: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
 <1386911905-2366-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131215175112.GA23298@Nokia-N900>
 <20131215192508.GA10514@psi-dev26.jf.intel.com>
 <20131220195527.GA25927@amd.pavel.ucw.cz>
 <20131220202336.GB14693@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220202336.GB14693@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 12:23:36PM -0800, David Cohen wrote:
> On Fri, Dec 20, 2013 at 08:55:27PM +0100, Pavel Machek wrote:
> > On Sun 2013-12-15 11:25:08, David Cohen wrote:
> > > On Sun, Dec 15, 2013 at 06:51:12PM +0100, Pavel Machek wrote:
> > > > On Thu 2013-12-12 21:18:23, David Cohen wrote:
> > > > > This patch makes SET_SYSTEM_SLEEP_PM_OPS() and SET_RUNTIME_PM_OPS() more
> > > > > smart.
> > > > > 
> > > > > Despite those macros check for '#ifdef CONFIG_PM_SLEEP/RUNTIME' to avoid
> > > > > setting the callbacks when such #ifdef's aren't defined, they don't
> > > > > handle compiler to avoid messages like that:
> > > > > 
> > > > > drivers/usb/host/xhci-plat.c:200:12: warning: ???xhci_plat_suspend??? defined but not used [-Wunused-function]
> > > > > drivers/usb/host/xhci-plat.c:208:12: warning: ???xhci_plat_resume??? defined but not used [-Wunused-function]
> > > > > 
> > > > > As result, those macros get rid of #ifdef's when setting callbacks but
> > > > > not when implementing them.
> > > > > 
> > > > > With this patch, drivers using SET_*_PM_OPS() macros don't need to #ifdef
> > > > > the callbacks implementation as well.
> > > > 
> > > > Well... Interesting trickery, but it means that resulting kernel
> > > > will be bigge due to the dead functions no?
> > > 
> > > Actually, it doesn't get bigger. Before sending the patch I did this
> > > dummy test app:
> > > 
> > > --------------------------------------------------------------------------------
> > > #include <stdio.h>
> > > 
> > > #define USE_IT_OR_LOOSE_IT(fn)  ((void *)((unsigned long)(fn) - (unsigned long)(fn)))
> > > 
> > > #ifdef MAKE_ME_NULL
> > > static int func1(int a)
> > > {
> > >         printf("Hey!!\n");
> > >         return 0;
> > > }
> > > #endif
> > 
> > I thought that point of this patch series was getting rid of the
> > #ifdefs around the function...? Now I'm confused.
> 
> Maybe you're misinterpreting the test :)
> 
> This #ifdef is used to make this same test code to replicate both
> scenarios according to -DMAKE_ME_NULL (just pay attention to actual
> resulting code after #ifdef's are tested. the #ifdef here is nor related
> to actual #ifdef on kernel). Here are both scenarios:
> 
> (1) Not using my trickery (which needs the function to not be present).
> (2) Using my trickery (which needs to function to stay).
> 
> With -DMAKE_ME_NULL we replicate (2), then the function *is* there but
> gcc gets rid of it on resulting binary without warnings if used with -O2.
> 
> Without -DMAKE_ME_NULL we replicate (1). The #ifdef will fail and then
> remove the function which is an obvious scenario the function won't be
> part of resulting binary.
> 
> If we use -S option to have human readable resulting assembly code
> (which is kind of 1:1 for resulting binary), we can compare the result
> of (1) and (2) and check they are pretty similar.
> This proves gcc behaves as expected with my patch: do not need #ifdef
> and do not generate dead codes to resulting binary.
> 
> > 
> > > struct global_data {
> > >         int (*func)(int);
> > > };
> > > 
> > > static struct global_data gd = {
> > > #ifdef MAKE_ME_NULL
> > >         .func = USE_IT_OR_LOOSE_IT(func1),
> > 
> > If you have ifdef around the function, why do you need magic here? Why
> > not
> 
> This #ifdef is necessary to prevent the function to be used when it
> doesn't exist due to above #ifdef. But once again: don't misinterpret
> the #ifdefs in this test app with the ones in kernel. They are not
> related at all. If it's still confusing you just make 2 test apps
> without #ifdeds out of this one where one keeps the code inside #ifdefs
> and the other doesn't.
> 
> > 
> > 	.func = func1
> > 
> > ?
> > 
> > Basically the warning tells you that you want the ifdef around the
> > function, too... (Otherwise you waste space). That seems like good
> > warning.
> 
> Just check my first explanation.

Ping :)

Comments here?

Br, David Cohen
