Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3BDUUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:20:14 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39302 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab3BDUUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:20:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] PM: make VT switching to the suspend console optional v3
Date: Mon, 04 Feb 2013 21:26:26 +0100
Message-ID: <1452100.EKe1it2LWl@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 01:37:20 PM Jesse Barnes wrote:
> KMS drivers can potentially restore the display configuration without
> userspace help.  Such drivers can can call a new funciton,
> pm_vt_switch_required(false) if they support this feature.  In that
> case, the PM layer won't VT switch to the suspend console at suspend
> time and then back to the original VT on resume, but rather leave things
> alone for a nicer looking suspend and resume sequence.
> 
> v2: make a function so we can handle multiple drivers (Alan)
> v3: use a list to track device requests (Rafael)
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for all [1-3/3].

Thanks,
Rafael


> ---
>  include/linux/pm.h     |    4 ++
>  kernel/power/console.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 119 insertions(+)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 03d7bb1..98310eb 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -35,6 +35,10 @@ extern void (*pm_idle)(void);
>  extern void (*pm_power_off)(void);
>  extern void (*pm_power_off_prepare)(void);
>  
> +struct device; /* we have a circular dep with device.h */
> +extern void pm_vt_switch_required(struct device *dev, bool required);
> +extern void pm_vt_switch_unregister(struct device *dev);
> +
>  /*
>   * Device power management
>   */
> diff --git a/kernel/power/console.c b/kernel/power/console.c
> index b1dc456..4871ca9 100644
> --- a/kernel/power/console.c
> +++ b/kernel/power/console.c
> @@ -4,6 +4,7 @@
>   * Originally from swsusp.
>   */
>  
> +#include <linux/console.h>
>  #include <linux/vt_kern.h>
>  #include <linux/kbd_kern.h>
>  #include <linux/vt.h>
> @@ -14,8 +15,119 @@
>  
>  static int orig_fgconsole, orig_kmsg;
>  
> +DEFINE_MUTEX(vt_switch_mutex);
> +
> +struct pm_vt_switch {
> +	struct list_head head;
> +	struct device *dev;
> +	bool required;
> +};
> +
> +LIST_HEAD(pm_vt_switch_list);
> +
> +
> +/**
> + * pm_vt_switch_required - indicate VT switch at suspend requirements
> + * @dev: device
> + * @required: if true, caller needs VT switch at suspend/resume time
> + *
> + * The different console drivers may or may not require VT switches across
> + * suspend/resume, depending on how they handle restoring video state and
> + * what may be running.
> + *
> + * Drivers can indicate support for switchless suspend/resume, which can
> + * save time and flicker, by using this routine and passing 'false' as
> + * the argument.  If any loaded driver needs VT switching, or the
> + * no_console_suspend argument has been passed on the command line, VT
> + * switches will occur.
> + */
> +void pm_vt_switch_required(struct device *dev, bool required)
> +{
> +	struct pm_vt_switch *entry, *tmp;
> +
> +	mutex_lock(&vt_switch_mutex);
> +	list_for_each_entry(tmp, &pm_vt_switch_list, head) {
> +		if (tmp->dev == dev) {
> +			/* already registered, update requirement */
> +			tmp->required = required;
> +			goto out;
> +		}
> +	}
> +
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		goto out;
> +
> +	entry->required = required;
> +	entry->dev = dev;
> +
> +	list_add(&entry->head, &pm_vt_switch_list);
> +out:
> +	mutex_unlock(&vt_switch_mutex);
> +}
> +EXPORT_SYMBOL(pm_vt_switch_required);
> +
> +/**
> + * pm_vt_switch_unregister - stop tracking a device's VT switching needs
> + * @dev: device
> + *
> + * Remove @dev from the vt switch list.
> + */
> +void pm_vt_switch_unregister(struct device *dev)
> +{
> +	struct pm_vt_switch *tmp;
> +
> +	mutex_lock(&vt_switch_mutex);
> +	list_for_each_entry(tmp, &pm_vt_switch_list, head) {
> +		if (tmp->dev == dev) {
> +			list_del(&tmp->head);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&vt_switch_mutex);
> +}
> +
> +/*
> + * There are three cases when a VT switch on suspend/resume are required:
> + *   1) no driver has indicated a requirement one way or another, so preserve
> + *      the old behavior
> + *   2) console suspend is disabled, we want to see debug messages across
> + *      suspend/resume
> + *   3) any registered driver indicates it needs a VT switch
> + *
> + * If none of these conditions is present, meaning we have at least one driver
> + * that doesn't need the switch, and none that do, we can avoid it to make
> + * resume look a little prettier (and suspend too, but that's usually hidden,
> + * e.g. when closing the lid on a laptop).
> + */
> +static bool pm_vt_switch(void)
> +{
> +	struct pm_vt_switch *entry;
> +	bool ret = true;
> +
> +	mutex_lock(&vt_switch_mutex);
> +	if (list_empty(&pm_vt_switch_list))
> +		goto out;
> +
> +	if (!console_suspend_enabled)
> +		goto out;
> +
> +	list_for_each_entry(entry, &pm_vt_switch_list, head) {
> +		if (entry->required)
> +			goto out;
> +	}
> +
> +	ret = false;
> +out:
> +	mutex_unlock(&vt_switch_mutex);
> +	return ret;
> +}
> +
>  int pm_prepare_console(void)
>  {
> +	if (!pm_vt_switch())
> +		return 0;
> +
>  	orig_fgconsole = vt_move_to_console(SUSPEND_CONSOLE, 1);
>  	if (orig_fgconsole < 0)
>  		return 1;
> @@ -26,6 +138,9 @@ int pm_prepare_console(void)
>  
>  void pm_restore_console(void)
>  {
> +	if (!pm_vt_switch())
> +		return;
> +
>  	if (orig_fgconsole >= 0) {
>  		vt_move_to_console(orig_fgconsole, 0);
>  		vt_kmsg_redirect(orig_kmsg);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
