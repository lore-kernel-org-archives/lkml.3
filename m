Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaG3Nnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaG3Nnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:43:45 -0400
Date: Wed, 30 Jul 2014 09:43:42 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
Message-ID: <20140730134342.GA7959@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com>
 <1406196811-5384-3-git-send-email-drjones@redhat.com>
 <615371508.17867577.1406277175913.JavaMail.zimbra@redhat.com>
 <20140725112510.GA3456@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725112510.GA3456@hawk.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:25:11PM +0200, Andrew Jones wrote:
> > to enable hard lockup detection explicitly.
> > 
> > I think changing the 'watchdog_thresh' while 'watchdog_running' is true should
> > _not_ enable hard lockup detection as a side-effect, because a user may have a
> > 'sysctl.conf' entry such as
> > 
> >    kernel.watchdog_thresh = ...
> > 
> > or may only want to change the 'watchdog_thresh' on the fly.
> > 
> > I think the following flow of execution could cause such undesired side-effect.
> > 
> >    proc_dowatchdog
> >      if (watchdog_user_enabled && watchdog_thresh) {
> > 
> >          watchdog_enable_hardlockup_detector
> >            hardlockup_detector_enabled = true
> > 
> >          watchdog_enable_all_cpus
> >            if (!watchdog_running) {
> >                ...
> >            } else if (sample_period_changed)
> >                       update_timers_all_cpus
> >                         for_each_online_cpu
> >                             update_timers
> >                               watchdog_nmi_disable
> >                               ...
> >                               watchdog_nmi_enable
> > 
> >                                 watchdog_hardlockup_detector_is_enabled
> >                                   return true
> > 
> >                                 enable perf counter for hard lockup detection
> > 
> > Regards,
> > 
> > Uli
> 
> Nice catch. Looks like this will need a v2. Paolo, do we have a
> consensus on the proc echoing? Or should that be revisited in the v2 as
> well?

As discussed privately, how about something like this to handle that case:
(applied on top of these patches)

Cheers,
Don

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 34eca29..027fb6c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -666,7 +666,12 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
 	if (watchdog_user_enabled && watchdog_thresh) {
-		watchdog_enable_hardlockup_detector(true);
+		/*
+		 * Prevent a change in watchdog_thresh accidentally overriding
+		 * the enablement of the hardlockup detector.
+		 */
+		if (watchdog_user_enabled != old_enabled)
+			watchdog_enable_hardlockup_detector(true);
 		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
 	} else
 		watchdog_disable_all_cpus();

