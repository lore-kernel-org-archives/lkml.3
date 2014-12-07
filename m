Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaLGVPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:15:32 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:56627 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaLGVPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:15:30 -0500
Message-ID: <5484C36F.3050805@ti.com>
Date: Sun, 07 Dec 2014 15:15:27 -0600
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arch: arm: mach-omap2: omap-pm-noop.c: Remove some unused
 functions
References: <1417985346-16295-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1417985346-16295-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2014 02:49 PM, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> omap_pm_set_max_dev_wakeup_lat() omap_pm_if_exit() omap_pm_cpu_get_freq()
> omap_pm_cpu_set_freq() omap_pm_cpu_get_freq_table() omap_pm_dsp_get_opp()
> omap_pm_dsp_set_min_opp() omap_pm_dsp_get_opp_table()
> omap_pm_set_min_clk_rate() omap_pm_set_max_sdma_lat()
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   arch/arm/mach-omap2/omap-pm-noop.c |  196 ------------------------------------
>   arch/arm/mach-omap2/omap-pm.h      |  192 -----------------------------------
>   2 files changed, 388 deletions(-)
>


That kind of opens up as to if any of the functions make sense anymore...


> diff --git a/arch/arm/mach-omap2/omap-pm-noop.c b/arch/arm/mach-omap2/omap-pm-noop.c
> index 6a3be2b..a1ee806 100644
> --- a/arch/arm/mach-omap2/omap-pm-noop.c
> +++ b/arch/arm/mach-omap2/omap-pm-noop.c
> @@ -86,200 +86,10 @@ int omap_pm_set_min_bus_tput(struct device *dev, u8 agent_id, unsigned long r)
>   	return 0;
>   }
>
> -int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
> -				   long t)
> -{
> -	if (!req_dev || !dev || t < -1) {
> -		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
> -		return -EINVAL;
> -	}
> -
> -	if (t == -1)
> -		pr_debug("OMAP PM: remove max device latency constraint: dev %s\n",
> -			 dev_name(dev));
> -	else
> -		pr_debug("OMAP PM: add max device latency constraint: dev %s, t = %ld usec\n",
> -			 dev_name(dev), t);
> -
> -	/*
> -	 * For current Linux, this needs to map the device to a
> -	 * powerdomain, then go through the list of current max lat
> -	 * constraints on that powerdomain and find the smallest.  If
> -	 * the latency constraint has changed, the code should
> -	 * recompute the state to enter for the next powerdomain
> -	 * state.  Conceivably, this code should also determine
> -	 * whether to actually disable the device clocks or not,
> -	 * depending on how long it takes to re-enable the clocks.
> -	 *
> -	 * TI CDP code can call constraint_set here.
> -	 */
> -
> -	return 0;
> -}
> -
> -int omap_pm_set_max_sdma_lat(struct device *dev, long t)
> -{
> -	if (!dev || t < -1) {
> -		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
> -		return -EINVAL;
> -	}
> -
> -	if (t == -1)
> -		pr_debug("OMAP PM: remove max DMA latency constraint: dev %s\n",
> -			 dev_name(dev));
> -	else
> -		pr_debug("OMAP PM: add max DMA latency constraint: dev %s, t = %ld usec\n",
> -			 dev_name(dev), t);
> -
> -	/*
> -	 * For current Linux PM QOS params, this code should scan the
> -	 * list of maximum CPU and DMA latencies and select the
> -	 * smallest, then set cpu_dma_latency pm_qos_param
> -	 * accordingly.
> -	 *
> -	 * For future Linux PM QOS params, with separate CPU and DMA
> -	 * latency params, this code should just set the dma_latency param.
> -	 *
> -	 * TI CDP code can call constraint_set here.
> -	 */
> -
> -	return 0;
> -}
> -
> -int omap_pm_set_min_clk_rate(struct device *dev, struct clk *c, long r)
> -{
> -	if (!dev || !c || r < 0) {
> -		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
> -		return -EINVAL;
> -	}
> -
> -	if (r == 0)
> -		pr_debug("OMAP PM: remove min clk rate constraint: dev %s\n",
> -			 dev_name(dev));
> -	else
> -		pr_debug("OMAP PM: add min clk rate constraint: dev %s, rate = %ld Hz\n",
> -			 dev_name(dev), r);
> -
> -	/*
> -	 * Code in a real implementation should keep track of these
> -	 * constraints on the clock, and determine the highest minimum
> -	 * clock rate.  It should iterate over each OPP and determine
> -	 * whether the OPP will result in a clock rate that would
> -	 * satisfy this constraint (and any other PM constraint in effect
> -	 * at that time).  Once it finds the lowest-voltage OPP that
> -	 * meets those conditions, it should switch to it, or return
> -	 * an error if the code is not capable of doing so.
> -	 */
> -
> -	return 0;
> -}
> -
>   /*
>    * DSP Bridge-specific constraints
>    */
>
> -const struct omap_opp *omap_pm_dsp_get_opp_table(void)
> -{
> -	pr_debug("OMAP PM: DSP request for OPP table\n");
> -
> -	/*
> -	 * Return DSP frequency table here:  The final item in the
> -	 * array should have .rate = .opp_id = 0.
> -	 */
> -
> -	return NULL;
> -}
> -
> -void omap_pm_dsp_set_min_opp(u8 opp_id)
> -{
> -	if (opp_id == 0) {
> -		WARN_ON(1);
> -		return;
> -	}
> -
> -	pr_debug("OMAP PM: DSP requests minimum VDD1 OPP to be %d\n", opp_id);
> -
> -	/*
> -	 *
> -	 * For l-o dev tree, our VDD1 clk is keyed on OPP ID, so we
> -	 * can just test to see which is higher, the CPU's desired OPP
> -	 * ID or the DSP's desired OPP ID, and use whichever is
> -	 * highest.
> -	 *
> -	 * In CDP12.14+, the VDD1 OPP custom clock that controls the DSP
> -	 * rate is keyed on MPU speed, not the OPP ID.  So we need to
> -	 * map the OPP ID to the MPU speed for use with clk_set_rate()
> -	 * if it is higher than the current OPP clock rate.
> -	 *
> -	 */
> -}
> -
> -
> -u8 omap_pm_dsp_get_opp(void)
> -{
> -	pr_debug("OMAP PM: DSP requests current DSP OPP ID\n");
> -
> -	/*
> -	 * For l-o dev tree, call clk_get_rate() on VDD1 OPP clock
> -	 *
> -	 * CDP12.14+:
> -	 * Call clk_get_rate() on the OPP custom clock, map that to an
> -	 * OPP ID using the tables defined in board-*.c/chip-*.c files.
> -	 */
> -
> -	return 0;
> -}
> -
> -/*
> - * CPUFreq-originated constraint
> - *
> - * In the future, this should be handled by custom OPP clocktype
> - * functions.
> - */
> -
> -struct cpufreq_frequency_table **omap_pm_cpu_get_freq_table(void)
> -{
> -	pr_debug("OMAP PM: CPUFreq request for frequency table\n");
> -
> -	/*
> -	 * Return CPUFreq frequency table here: loop over
> -	 * all VDD1 clkrates, pull out the mpu_ck frequencies, build
> -	 * table
> -	 */
> -
> -	return NULL;
> -}
> -
> -void omap_pm_cpu_set_freq(unsigned long f)
> -{
> -	if (f == 0) {
> -		WARN_ON(1);
> -		return;
> -	}
> -
> -	pr_debug("OMAP PM: CPUFreq requests CPU frequency to be set to %lu\n",
> -		 f);
> -
> -	/*
> -	 * For l-o dev tree, determine whether MPU freq or DSP OPP id
> -	 * freq is higher.  Find the OPP ID corresponding to the
> -	 * higher frequency.  Call clk_round_rate() and clk_set_rate()
> -	 * on the OPP custom clock.
> -	 *
> -	 * CDP should just be able to set the VDD1 OPP clock rate here.
> -	 */
> -}
> -
> -unsigned long omap_pm_cpu_get_freq(void)
> -{
> -	pr_debug("OMAP PM: CPUFreq requests current CPU frequency\n");
> -
> -	/*
> -	 * Call clk_get_rate() on the mpu_ck.
> -	 */
> -
> -	return 0;
> -}
>
>   /**
>    * omap_pm_enable_off_mode - notify OMAP PM that off-mode is enabled
> @@ -363,9 +173,3 @@ int __init omap_pm_if_init(void)
>   {
>   	return 0;
>   }
> -
> -void omap_pm_if_exit(void)
> -{
> -	/* Deallocate CPUFreq frequency table here */
> -}
> -
> diff --git a/arch/arm/mach-omap2/omap-pm.h b/arch/arm/mach-omap2/omap-pm.h
> index 1d777e6..109bef5 100644
> --- a/arch/arm/mach-omap2/omap-pm.h
> +++ b/arch/arm/mach-omap2/omap-pm.h
> @@ -50,14 +50,6 @@ int __init omap_pm_if_early_init(void);
>    */
>   int __init omap_pm_if_init(void);
>
> -/**
> - * omap_pm_if_exit - OMAP PM exit code
> - *
> - * Exit code; currently unused.  The "_if_" is to avoid name
> - * collisions with the PM idle-loop code.
> - */
> -void omap_pm_if_exit(void);
> -
>   /*
>    * Device-driver-originated constraints (via board-*.c files, platform_data)
>    */
> @@ -132,163 +124,6 @@ int omap_pm_set_max_mpu_wakeup_lat(struct device *dev, long t);
>   int omap_pm_set_min_bus_tput(struct device *dev, u8 agent_id, unsigned long r);
>
>
> -/**
> - * omap_pm_set_max_dev_wakeup_lat - set the maximum device enable latency
> - * @req_dev: struct device * requesting the constraint, or NULL if none
> - * @dev: struct device * to set the constraint one
> - * @t: maximum device wakeup latency in microseconds
> - *
> - * Request that the maximum amount of time necessary for a device @dev
> - * to become accessible after its clocks are enabled should be no
> - * greater than @t microseconds.  Specifically, this represents the
> - * time from when a device driver enables device clocks with
> - * clk_enable(), to when the register reads and writes on the device
> - * will succeed.  This function should be called before clk_disable()
> - * is called, since the power state transition decision may be made
> - * during clk_disable().
> - *
> - * It is intended that underlying PM code will use this information to
> - * determine what power state to put the powerdomain enclosing this
> - * device into.
> - *
> - * Multiple calls to omap_pm_set_max_dev_wakeup_lat() will replace the
> - * previous wakeup latency values for this device.  To remove the
> - * wakeup latency restriction for this device, call with t = -1.
> - *
> - * Returns -EINVAL for an invalid argument, -ERANGE if the constraint
> - * is not satisfiable, or 0 upon success.
> - */
> -int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
> -				   long t);
> -
> -
> -/**
> - * omap_pm_set_max_sdma_lat - set the maximum system DMA transfer start latency
> - * @dev: struct device *
> - * @t: maximum DMA transfer start latency in microseconds
> - *
> - * Request that the maximum system DMA transfer start latency for this
> - * device 'dev' should be no greater than 't' microseconds.  "DMA
> - * transfer start latency" here is defined as the elapsed time from
> - * when a device (e.g., McBSP) requests that a system DMA transfer
> - * start or continue, to the time at which data starts to flow into
> - * that device from the system DMA controller.
> - *
> - * It is intended that underlying PM code will use this information to
> - * determine what power state to put the CORE powerdomain into.
> - *
> - * Since system DMA transfers may not involve the MPU, this function
> - * will not affect MPU wakeup latency.  Use set_max_cpu_lat() to do
> - * so.  Similarly, this function will not affect device wakeup latency
> - * -- use set_max_dev_wakeup_lat() to affect that.
> - *
> - * Multiple calls to set_max_sdma_lat() will replace the previous t
> - * value for this device.  To remove the maximum DMA latency for this
> - * device, call with t = -1.
> - *
> - * Returns -EINVAL for an invalid argument, -ERANGE if the constraint
> - * is not satisfiable, or 0 upon success.
> - */
> -int omap_pm_set_max_sdma_lat(struct device *dev, long t);
> -
> -
> -/**
> - * omap_pm_set_min_clk_rate - set minimum clock rate requested by @dev
> - * @dev: struct device * requesting the constraint
> - * @clk: struct clk * to set the minimum rate constraint on
> - * @r: minimum rate in Hz
> - *
> - * Request that the minimum clock rate on the device @dev's clk @clk
> - * be no less than @r Hz.
> - *
> - * It is expected that the OMAP PM code will use this information to
> - * find an OPP or clock setting that will satisfy this clock rate
> - * constraint, along with any other applicable system constraints on
> - * the clock rate or corresponding voltage, etc.
> - *
> - * omap_pm_set_min_clk_rate() differs from the clock code's
> - * clk_set_rate() in that it considers other constraints before taking
> - * any hardware action, and may change a system OPP rather than just a
> - * clock rate.  clk_set_rate() is intended to be a low-level
> - * interface.
> - *
> - * omap_pm_set_min_clk_rate() is easily open to abuse.  A better API
> - * would be something like "omap_pm_set_min_dev_performance()";
> - * however, there is no easily-generalizable concept of performance
> - * that applies to all devices.  Only a device (and possibly the
> - * device subsystem) has both the subsystem-specific knowledge, and
> - * the hardware IP block-specific knowledge, to translate a constraint
> - * on "touchscreen sampling accuracy" or "number of pixels or polygons
> - * rendered per second" to a clock rate.  This translation can be
> - * dependent on the hardware IP block's revision, or firmware version,
> - * and the driver is the only code on the system that has this
> - * information and can know how to translate that into a clock rate.
> - *
> - * The intended use-case for this function is for userspace or other
> - * kernel code to communicate a particular performance requirement to
> - * a subsystem; then for the subsystem to communicate that requirement
> - * to something that is meaningful to the device driver; then for the
> - * device driver to convert that requirement to a clock rate, and to
> - * then call omap_pm_set_min_clk_rate().
> - *
> - * Users of this function (such as device drivers) should not simply
> - * call this function with some high clock rate to ensure "high
> - * performance."  Rather, the device driver should take a performance
> - * constraint from its subsystem, such as "render at least X polygons
> - * per second," and use some formula or table to convert that into a
> - * clock rate constraint given the hardware type and hardware
> - * revision.  Device drivers or subsystems should not assume that they
> - * know how to make a power/performance tradeoff - some device use
> - * cases may tolerate a lower-fidelity device function for lower power
> - * consumption; others may demand a higher-fidelity device function,
> - * no matter what the power consumption.
> - *
> - * Multiple calls to omap_pm_set_min_clk_rate() will replace the
> - * previous rate value for the device @dev.  To remove the minimum clock
> - * rate constraint for the device, call with r = 0.
> - *
> - * Returns -EINVAL for an invalid argument, -ERANGE if the constraint
> - * is not satisfiable, or 0 upon success.
> - */
> -int omap_pm_set_min_clk_rate(struct device *dev, struct clk *c, long r);
> -
> -/*
> - * DSP Bridge-specific constraints
> - */
> -
> -/**
> - * omap_pm_dsp_get_opp_table - get OPP->DSP clock frequency table
> - *
> - * Intended for use by DSPBridge.  Returns an array of OPP->DSP clock
> - * frequency entries.  The final item in the array should have .rate =
> - * .opp_id = 0.
> - */
> -const struct omap_opp *omap_pm_dsp_get_opp_table(void);
> -
> -/**
> - * omap_pm_dsp_set_min_opp - receive desired OPP target ID from DSP Bridge
> - * @opp_id: target DSP OPP ID
> - *
> - * Set a minimum OPP ID for the DSP.  This is intended to be called
> - * only from the DSP Bridge MPU-side driver.  Unfortunately, the only
> - * information that code receives from the DSP/BIOS load estimator is the
> - * target OPP ID; hence, this interface.  No return value.
> - */
> -void omap_pm_dsp_set_min_opp(u8 opp_id);
> -
> -/**
> - * omap_pm_dsp_get_opp - report the current DSP OPP ID
> - *
> - * Report the current OPP for the DSP.  Since on OMAP3, the DSP and
> - * MPU share a single voltage domain, the OPP ID returned back may
> - * represent a higher DSP speed than the OPP requested via
> - * omap_pm_dsp_set_min_opp().
> - *
> - * Returns the current VDD1 OPP ID, or 0 upon error.
> - */
> -u8 omap_pm_dsp_get_opp(void);
> -
> -
>   /*
>    * CPUFreq-originated constraint
>    *
> @@ -296,33 +131,6 @@ u8 omap_pm_dsp_get_opp(void);
>    * functions.
>    */
>
> -/**
> - * omap_pm_cpu_get_freq_table - return a cpufreq_frequency_table array ptr
> - *
> - * Provide a frequency table usable by CPUFreq for the current chip/board.
> - * Returns a pointer to a struct cpufreq_frequency_table array or NULL
> - * upon error.
> - */
> -struct cpufreq_frequency_table **omap_pm_cpu_get_freq_table(void);
> -
> -/**
> - * omap_pm_cpu_set_freq - set the current minimum MPU frequency
> - * @f: MPU frequency in Hz
> - *
> - * Set the current minimum CPU frequency.  The actual CPU frequency
> - * used could end up higher if the DSP requested a higher OPP.
> - * Intended to be called by plat-omap/cpu_omap.c:omap_target().  No
> - * return value.
> - */
> -void omap_pm_cpu_set_freq(unsigned long f);
> -
> -/**
> - * omap_pm_cpu_get_freq - report the current CPU frequency
> - *
> - * Returns the current MPU frequency, or 0 upon error.
> - */
> -unsigned long omap_pm_cpu_get_freq(void);
> -
>
>   /*
>    * Device context loss tracking
>

