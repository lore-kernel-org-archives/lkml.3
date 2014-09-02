Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaIBQok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:44:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:37451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbaIBQoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="scan'208";a="567245938"
Message-ID: <1409676229.15680.43.camel@spandruv-desktop.jf.intel.com>
Subject: Re: [PATCH] PM / sleep: Fix test_suspend= command line option
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 09:43:49 -0700
In-Reply-To: <3262231.p5bxWyAveH@vostro.rjw.lan>
References: <3262231.p5bxWyAveH@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-02 at 01:37 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit d431cbc53cb7 (PM / sleep: Simplify sleep states sysfs
> interface code) the pm_states[] array is not populated initially,
> which causes setup_test_suspend() to always fail and the suspend
> testing during boot doesn't work any more.
> 
> Fix the problem by using pm_labels[] instead of pm_states[] in
> setup_test_suspend() and storing a pointer to the label of the
> sleep state to test rather than the number representing it,
> because the connection between the state numbers and labels is
> only established by suspend_set_ops().
> 
This is still causing panic when I applied to 3.17.rc2.
Need further debug.

Thanks,
Srinivas

> Fixes: d431cbc53cb7 (PM / sleep: Simplify sleep states sysfs interface code)
> Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  kernel/power/power.h        |    1 +
>  kernel/power/suspend.c      |    2 +-
>  kernel/power/suspend_test.c |   29 +++++++++++++++++------------
>  3 files changed, 19 insertions(+), 13 deletions(-)
> 
> Index: linux-pm/kernel/power/power.h
> ===================================================================
> --- linux-pm.orig/kernel/power/power.h
> +++ linux-pm/kernel/power/power.h
> @@ -179,6 +179,7 @@ extern void swsusp_show_speed(struct tim
>  
>  #ifdef CONFIG_SUSPEND
>  /* kernel/power/suspend.c */
> +extern const char *pm_labels[];
>  extern const char *pm_states[];
>  
>  extern int suspend_devices_and_enter(suspend_state_t state);
> Index: linux-pm/kernel/power/suspend.c
> ===================================================================
> --- linux-pm.orig/kernel/power/suspend.c
> +++ linux-pm/kernel/power/suspend.c
> @@ -31,7 +31,7 @@
>  
>  #include "power.h"
>  
> -static const char *pm_labels[] = { "mem", "standby", "freeze", };
> +const char *pm_labels[] = { "mem", "standby", "freeze", NULL };
>  const char *pm_states[PM_SUSPEND_MAX];
>  
>  static const struct platform_suspend_ops *suspend_ops;
> Index: linux-pm/kernel/power/suspend_test.c
> ===================================================================
> --- linux-pm.orig/kernel/power/suspend_test.c
> +++ linux-pm/kernel/power/suspend_test.c
> @@ -129,20 +129,20 @@ static int __init has_wakealarm(struct d
>   * at startup time.  They're normally disabled, for faster boot and because
>   * we can't know which states really work on this particular system.
>   */
> -static suspend_state_t test_state __initdata = PM_SUSPEND_ON;
> +static const char *test_state_label __initdata;
>  
>  static char warn_bad_state[] __initdata =
>  	KERN_WARNING "PM: can't test '%s' suspend state\n";
>  
>  static int __init setup_test_suspend(char *value)
>  {
> -	suspend_state_t i;
> +	int i;
>  
>  	/* "=mem" ==> "mem" */
>  	value++;
> -	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
> -		if (!strcmp(pm_states[i], value)) {
> -			test_state = i;
> +	for (i = 0; pm_labels[i]; i++)
> +		if (!strcmp(pm_labels[i], value)) {
> +			test_state_label = pm_labels[i];
>  			return 0;
>  		}
>  
> @@ -158,13 +158,19 @@ static int __init test_suspend(void)
>  
>  	struct rtc_device	*rtc = NULL;
>  	struct device		*dev;
> +	suspend_state_t test_state;
>  
>  	/* PM is initialized by now; is that state testable? */
> -	if (test_state == PM_SUSPEND_ON)
> -		goto done;
> -	if (!pm_states[test_state]) {
> -		printk(warn_bad_state, pm_states[test_state]);
> -		goto done;
> +	if (!test_state_label)
> +		return 0;
> +
> +	for (test_state = PM_SUSPEND_MIN; test_state < PM_SUSPEND_MAX; test_state++)
> +		if (!strcmp(test_state_label, pm_states[test_state]))
> +			break;
> +
> +	if (test_state == PM_SUSPEND_MAX) {
> +		printk(warn_bad_state, test_state_label);
> +		return 0;
>  	}
>  
>  	/* RTCs have initialized by now too ... can we use one? */
> @@ -173,13 +179,12 @@ static int __init test_suspend(void)
>  		rtc = rtc_class_open(dev_name(dev));
>  	if (!rtc) {
>  		printk(warn_no_rtc);
> -		goto done;
> +		return 0;
>  	}
>  
>  	/* go for it */
>  	test_wakealarm(rtc, test_state);
>  	rtc_class_close(rtc);
> -done:
>  	return 0;
>  }
>  late_initcall(test_suspend);
> 


