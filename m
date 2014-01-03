Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaACHzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 02:55:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43940 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaACHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 02:54:58 -0500
Date: Thu, 2 Jan 2014 23:54:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: eric.ernst@linux.intel.com
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Touzeau <gabrielx.touzeau@intel.com>,
        Yann Puech <yann.puech@intel.com>,
        Jeremy Compostella <jeremy.compostella@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH 1/1] watchdog: Adding Merrifield watchdog driver support
Message-ID: <20140103075447.GB10680@core.coreip.homeip.net>
References: <1388710602-18513-1-git-send-email-eric.ernst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388710602-18513-1-git-send-email-eric.ernst@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

On Thu, Jan 02, 2014 at 04:56:42PM -0800, eric.ernst@linux.intel.com wrote:
> +
> +/* Statics */
> +static struct intel_scu_watchdog_dev watchdog_device;
> +
> +/* Module params */
> +static bool disable_kernel_watchdog;
> +module_param(disable_kernel_watchdog, bool, S_IRUGO);
> +MODULE_PARM_DESC(disable_kernel_watchdog,
> +		"Disable kernel watchdog"
> +		"Set to 0, watchdog started at boot"
> +		"and left running; Set to 1; watchdog"
> +		"is not started until user space"
> +		"watchdog daemon is started; also if the"
> +		"timer is started by the iafw firmware, it"
> +		"will be disabled upon initialization of this"
> +		"driver if disable_kernel_watchdog is set");

You need to add spaces at the end of your strings otheriwse
concatenation will produce a mess.

> +
> +static int pre_timeout = DEFAULT_PRETIMEOUT;
> +module_param(pre_timeout, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(pre_timeout,
> +		"Watchdog pre timeout"
> +		"Time between interrupt and resetting the system"
> +		"The range is from 1 to 160");
> +
> +static int timeout = DEFAULT_TIMEOUT;
> +module_param(timeout, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(timeout,
> +		"Default Watchdog timer setting"
> +		"Complete cycle time"
> +		"The range is from 1 to 170"
> +		"This is the time for all keep alives to arrive");
> +
> +/* Setting reset_on_release will cause an immediate reset when the watchdog
> + * is released. If false, the watchdog timer is refreshed for one more
> + * interval. At the end of that interval, the watchdog timer will reset the
> + * system.
> + */

Multi-line comments in majority of kernel code are in form of

/*
 * Multi-line comment should be
 * formatted like this.
 */

> +static bool reset_on_release = true;
> +
> +/* Check current timeouts */
> +static int check_timeouts(int pre_timeout_time, int timeout_time)
> +{
> +	if (pre_timeout_time < timeout_time)
> +		return 0;
> +
> +	return -EINVAL;
> +}
> +
> +/* Set the different timeouts needed by the SCU FW and start the
> + * kernel watchdog */
> +static int watchdog_set_timeouts_and_start(int pretimeout,
> +					   int timeout)
> +{
> +	int ret, input_size;
> +	struct ipc_wd_start {
> +		u32 pretimeout;
> +		u32 timeout;
> +	} ipc_wd_start = { pretimeout, timeout };
> +
> +	/* SCU expects the input size for watchdog IPC to
> +	 * be based on double-word */
> +	input_size = (sizeof(ipc_wd_start) + 3) / 4;
> +
> +	ret = intel_scu_ipc_command(IPC_WATCHDOG,
> +				    SCU_WATCHDOG_START, (u32 *)&ipc_wd_start,
> +				    input_size, NULL, 0);
> +	if (ret) {
> +		pr_crit("Error configuring and starting watchdog: %d\n",
> +			ret);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Provisioning function for future enhancement : allow to fine tune timing
> +   according to watchdog action settings */
> +static int watchdog_set_appropriate_timeouts(void)
> +{
> +	pr_debug("Setting shutdown timeouts\n");
> +	return watchdog_set_timeouts_and_start(pre_timeout, timeout);
> +}
> +
> +/* Keep alive  */
> +static int watchdog_keepalive(void)
> +{
> +	int ret;
> +
> +	/* Pet the watchdog */
> +	ret = intel_scu_ipc_command(IPC_WATCHDOG,
> +					SCU_WATCHDOG_KEEPALIVE, NULL, 0, NULL, 0);
> +	if (ret) {
> +		pr_crit("Error executing keepalive: %x\n", ret);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +/* stops the timer */
> +static int watchdog_stop(void)
> +{
> +	int ret;
> +
> +	watchdog_device.started = false;
> +
> +	ret = intel_scu_ipc_command(IPC_WATCHDOG,
> +					SCU_WATCHDOG_STOP, NULL, 0, NULL, 0);
> +	if (ret) {
> +		pr_crit("Error stopping watchdog: %x\n", ret);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +/* warning interrupt handler */
> +static irqreturn_t watchdog_warning_interrupt(int irq, void *dev_id)
> +{
> +	pr_warn("[SHTDWN] %s, WATCHDOG TIMEOUT!\n", __func__);
> +
> +	/* Let's reset the platform after dumping some data */
> +	trigger_all_cpu_backtrace();
> +	panic("Kernel Watchdog");
> +
> +	/* This code should not be reached */
> +	return IRQ_HANDLED;
> +}
> +
> +/* Program and starts the timer */
> +static int watchdog_config_and_start(u32 newtimeout, u32 newpretimeout)
> +{
> +	int ret;
> +
> +	timeout = newtimeout;
> +	pre_timeout = newpretimeout;
> +
> +	pr_info("timeout=%ds, pre_timeout=%ds\n", timeout, pre_timeout);
> +
> +	/* Configure the watchdog */
> +	ret = watchdog_set_timeouts_and_start(pre_timeout, timeout);
> +	if (ret) {
> +		pr_err("%s: Cannot configure the watchdog\n", __func__);
> +
> +		/* Make sure the watchdog timer is stopped */
> +		watchdog_stop();
> +		return ret;
> +	}
> +
> +	watchdog_device.started = true;
> +
> +	return 0;
> +}
> +
> +/* Open */
> +static int intel_scu_open(struct inode *inode, struct file *file)
> +{
> +	/* Set flag to indicate that watchdog device is open */
> +	if (test_and_set_bit(0, &watchdog_device.driver_open)) {
> +		pr_err("watchdog device is busy\n");

You probably do not want to spam the logs. Returning -EBUSY should be
enough.

> +		return -EBUSY;
> +	}
> +
> +	return nonseekable_open(inode, file);
> +}
> +
> +/* Release */
> +static int intel_scu_release(struct inode *inode, struct file *file)
> +{
> +	/*
> +	 * This watchdog should not be closed after the timer
> +	 * is started with the WDIPC_SETTIMEOUT ioctl.
> +	 * If reset_on_release is set this  will cause an
> +	 * immediate reset. If reset_on_release is not set, the watchdog
> +	 * timer is refreshed for one more interval. At the end
> +	 * of that interval, the watchdog timer will reset the system.
> +	 */
> +
> +	if (!test_bit(0, &watchdog_device.driver_open)) {
> +		pr_err("intel_scu_release, without open\n");
> +		return -ENOTTY;
> +	}
> +
> +	if (!watchdog_device.started) {
> +		/* Just close, since timer has not been started */
> +		pr_err("Closed, without starting timer\n");

Why pr_err? It looks like it might be useful when debugging the driver,
but not for production code.

Thanks.

-- 
Dmitry
