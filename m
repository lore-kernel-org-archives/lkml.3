Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3GOAGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:06:47 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42715 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3GOAGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:06:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: yanmin_zhang@linux.intel.com
Cc: shuox.liu@intel.com, linux-kernel@vger.kernel.org, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM: avoid 'autosleep' in shutdown progress
Date: Mon, 15 Jul 2013 02:16:38 +0200
Message-ID: <152678399.VWEAi22Dp4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373609651.4432.122.camel@ymzhang.sh.intel.com>
References: <1373529825-20741-1-git-send-email-shuox.liu@intel.com> <1373609651.4432.122.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 12, 2013 02:14:11 PM Yanmin Zhang wrote:
> On Thu, 2013-07-11 at 16:03 +0800, shuox.liu@intel.com wrote:
> > From: Liu ShuoX <shuox.liu@intel.com>
> > 
> > In shutdown progress, system is possible to do power transition
> > (such as suspend-to-ram) in parallel. It is unreasonable. So,
> > fixes it by adding a system_state checking and queue try_to_suspend
> > again when system status is not running.
> > 
> > Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> > ---
> >  kernel/power/autosleep.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> Without this patch, we hit an hang issue on Android.
> 
> Scenario:
> Kernel starts shutdown and calls all device driver's shutdown callback.
> When a driver's shutdown is called, the last wakelock is released and
> suspend-to-ram starts. However, as some driver's shut down callbacks
> already shut down devices and disable runtime pm, the suspend-to-ram
> calls driver's suspend callback without noticing that device is already
> off and causes crash.

OK, queued up as a fix for 3.11, with a modified changelog (I used your
scenario above in it).

Thanks,
Rafael


> We know the drivers should be fixed, but can we also change generic
> codes a little to make it stronger?
> 
> > diff --git a/kernel/power/autosleep.c b/kernel/power/autosleep.c
> > index c6422ff..9012ecf 100644
> > --- a/kernel/power/autosleep.c
> > +++ b/kernel/power/autosleep.c
> > @@ -32,7 +32,8 @@ static void try_to_suspend(struct work_struct *work)
> >  
> >  	mutex_lock(&autosleep_lock);
> >  
> > -	if (!pm_save_wakeup_count(initial_count)) {
> > +	if (!pm_save_wakeup_count(initial_count) ||
> > +		system_state != SYSTEM_RUNNING) {
> >  		mutex_unlock(&autosleep_lock);
> >  		goto out;
> >  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
