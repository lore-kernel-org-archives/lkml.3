Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEZIcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:32:31 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56951 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:32:29 -0400
Message-ID: <5382FBD2.3070908@linux.vnet.ibm.com>
Date: Mon, 26 May 2014 14:01:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument
 for sleep state enumeration
References: <1817539.9KW2IGGbDV@vostro.rjw.lan> <2280756.TV3GPFuASb@vostro.rjw.lan> <1579932.qSkFQPvI6f@vostro.rjw.lan>
In-Reply-To: <1579932.qSkFQPvI6f@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052608-1618-0000-0000-0000004BF176
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:33 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> On some systems the platform doesn't support neither
> PM_SUSPEND_MEM nor PM_SUSPEND_STANDBY, so PM_SUSPEND_FREEZE is the
> only available system sleep state.  However, some user space frameworks
> only use the "mem" and (sometimes) "standby" sleep state labels, so
> the users of those systems need to modify user space in order to be
> able to use system suspend at all and that is not always possible.
>

So, is this going to be a temporary solution until all the user-space
frameworks have been fixed? I certainly hope so, because this clearly looks
like a bug (or a lack of feature) in user-space to me... in the sense that
those user-space frameworks don't have support for (i.e., don't know how to
deal with) freeze-only systems yet.

The more elegant long term solution would have been to teach the kernel to
export *truly* relative names such as SUSPEND_DEEP, SUSPEND_SHALLOW,
and SUSPEND_LIGHT or something like that (of course, we can debate on what
naming would suit best).

But this patch continues to keep the names 'SUSPEND_MEM' ("mem") etc., which
still implies that we are doing Suspend-to-RAM, because the name itself betrays
that info. So IMHO it doesn't really match what the command-line-switch
'relative_sleep_states' says.

But I understand that this is a quick hack to make existing user-space work
with systems that support only the freeze state. However, for the reasons
mentioned above, I hope that this is a temporary solution and we can remove
or enhance this once all those user-space frameworks have been fixed.

Regards,
Srivatsa S. Bhat
 
> For this reason, add a new kernel command line argument,
> relative_sleep_states, allowing the users of those systems to change
> the way in which the kernel assigns labels to system sleep states.
> Namely, for relative_sleep_states=1, the "mem", "standby" and "freeze"
> labels will enumerate the available system sleem states from the
> deepest to the shallowest, respectively, so that "mem" is always
> present in /sys/power/state and the other state strings may or may
> not be presend depending on what is supported by the platform.
> 
> Update system sleep states documentation to reflect this change.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> This update is needed after patch [2/3] has been updated.
> 
> Thanks!
> 
> ---
>  Documentation/ABI/testing/sysfs-power |   29 +++++++----
>  Documentation/kernel-parameters.txt   |    7 ++
>  Documentation/power/states.txt        |   89 +++++++++++++++++++++-------------
>  kernel/power/main.c                   |   12 ++--
>  kernel/power/suspend.c                |   33 +++++++++++-
>  5 files changed, 120 insertions(+), 50 deletions(-)
> 
> Index: linux-pm/kernel/power/suspend.c
> ===================================================================
> --- linux-pm.orig/kernel/power/suspend.c
> +++ linux-pm/kernel/power/suspend.c
> @@ -86,19 +86,46 @@ static bool valid_state(suspend_state_t
>  	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
>  }
> 
> +/*
> + * If this is set, the "mem" label always corresponds to the deepest sleep state
> + * available, the "standby" label corresponds to the second deepest sleep state
> + * available (if any), and the "freeze" label corresponds to the remaining
> + * available sleep state (if there is one).
> + */
> +static bool relative_states;
> +
> +static int __init sleep_states_setup(char *str)
> +{
> +	relative_states = !strncmp(str, "1", 1);
> +	if (relative_states) {
> +		pm_states[PM_SUSPEND_MEM].state = PM_SUSPEND_FREEZE;
> +		pm_states[PM_SUSPEND_FREEZE].state = 0;
> +	}
> +	return 1;
> +}
> +
> +__setup("relative_sleep_states=", sleep_states_setup);
> +
>  /**
>   * suspend_set_ops - Set the global suspend method table.
>   * @ops: Suspend operations to use.
>   */
>  void suspend_set_ops(const struct platform_suspend_ops *ops)
>  {
> -	suspend_state_t i;
> +	suspend_state_t i, j = PM_SUSPEND_MAX - 1;
> 
>  	lock_system_sleep();
> 
>  	suspend_ops = ops;
> -	for (i = PM_SUSPEND_STANDBY; i <= PM_SUSPEND_MEM; i++)
> -		pm_states[i].state = valid_state(i) ? i : 0;
> +	for (i = PM_SUSPEND_MEM; i >= PM_SUSPEND_STANDBY; i--)
> +		if (valid_state(i))
> +			pm_states[j--].state = i;
> +		else if (!relative_states)
> +			pm_states[j--].state = 0;
> +
> +	pm_states[j--].state = PM_SUSPEND_FREEZE;
> +	while (j >= PM_SUSPEND_MIN)
> +		pm_states[j--].state = 0;
> 
>  	unlock_system_sleep();
>  }
> Index: linux-pm/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-pm.orig/Documentation/kernel-parameters.txt
> +++ linux-pm/Documentation/kernel-parameters.txt
> @@ -2889,6 +2889,13 @@ bytes respectively. Such letter suffixes
>  			[KNL, SMP] Set scheduler's default relax_domain_level.
>  			See Documentation/cgroups/cpusets.txt.
> 
> +	relative_sleep_states=
> +			[SUSPEND] Use sleep state labeling where the deepest
> +			state available other than hibernation is always "mem".
> +			Format: { "0" | "1" }
> +			0 -- Traditional sleep state labels.
> +			1 -- Relative sleep state labels.
> +
>  	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
> 
>  	reservetop=	[X86-32]
> Index: linux-pm/kernel/power/main.c
> ===================================================================
> --- linux-pm.orig/kernel/power/main.c
> +++ linux-pm/kernel/power/main.c
> @@ -279,14 +279,14 @@ static inline void pm_print_times_init(v
>  struct kobject *power_kobj;
> 
>  /**
> - *	state - control system power state.
> + * state - control system sleep states.
>   *
> - *	show() returns what states are supported, which is hard-coded to
> - *	'freeze' (Low-Power Idle), 'standby' (Power-On Suspend),
> - *	'mem' (Suspend-to-RAM), and 'disk' (Suspend-to-Disk).
> + * show() returns available sleep state labels, which may be "mem", "standby",
> + * "freeze" and "disk" (hibernation).  See Documentation/power/states.txt for a
> + * description of what they mean.
>   *
> - *	store() accepts one of those strings, translates it into the
> - *	proper enumerated value, and initiates a suspend transition.
> + * store() accepts one of those strings, translates it into the proper
> + * enumerated value, and initiates a suspend transition.
>   */
>  static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
>  			  char *buf)
> Index: linux-pm/Documentation/ABI/testing/sysfs-power
> ===================================================================
> --- linux-pm.orig/Documentation/ABI/testing/sysfs-power
> +++ linux-pm/Documentation/ABI/testing/sysfs-power
> @@ -7,19 +7,30 @@ Description:
>  		subsystem.
> 
>  What:		/sys/power/state
> -Date:		August 2006
> +Date:		May 2014
>  Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
>  Description:
> -		The /sys/power/state file controls the system power state.
> -		Reading from this file returns what states are supported,
> -		which is hard-coded to 'freeze' (Low-Power Idle), 'standby'
> -		(Power-On Suspend), 'mem' (Suspend-to-RAM), and 'disk'
> -		(Suspend-to-Disk).
> +		The /sys/power/state file controls system sleep states.
> +		Reading from this file returns the available sleep state
> +		labels, which may be "mem", "standby", "freeze" and "disk"
> +		(hibernation).  The meanings of the first three labels depend on
> +		the relative_sleep_states command line argument as follows:
> +		 1) relative_sleep_states = 1
> +		    "mem", "standby", "freeze" represent non-hibernation sleep
> +		    states from the deepest ("mem", always present) to the
> +		    shallowest ("freeze").  "standby" and "freeze" may or may
> +		    not be present depending on the capabilities of the
> +		    platform.  "freeze" can only be present if "standby" is
> +		    present.
> +		 2) relative_sleep_states = 0 (default)
> +		    "mem" - "suspend-to-RAM", present if supported.
> +		    "standby" - "power-on suspend", present if supported.
> +		    "freeze" - "suspend-to-idle", always present.
> 
>  		Writing to this file one of these strings causes the system to
> -		transition into that state. Please see the file
> -		Documentation/power/states.txt for a description of each of
> -		these states.
> +		transition into the corresponding state, if available.  See
> +		Documentation/power/states.txt for a description of what
> +		"suspend-to-RAM", "power-on suspend" and "suspend-to-idle" mean.
> 
>  What:		/sys/power/disk
>  Date:		September 2006
> Index: linux-pm/Documentation/power/states.txt
> ===================================================================
> --- linux-pm.orig/Documentation/power/states.txt
> +++ linux-pm/Documentation/power/states.txt
> @@ -1,62 +1,87 @@
> +System Power Management Sleep States
> 
> -System Power Management States
> +(C) 2014 Intel Corp., Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> +The kernel supports up to four system sleep states generically, although three
> +of them depend on the platform support code to implement the low-level details
> +for each state.
> +
> +The states are represented by strings that can be read or written to the
> +/sys/power/state file.  Those strings may be "mem", "standby", "freeze" and
> +"disk", where the last one always represents hibernation (Suspend-To-Disk) and
> +the meaning of the remaining ones depends on the relative_sleep_states command
> +line argument.
> +
> +For relative_sleep_states=1, the strings "mem", "standby" and "freeze" label the
> +available non-hibernation sleep states from the deepest to the shallowest,
> +respectively.  In that case, "mem" is always present in /sys/power/state,
> +because there is at least one non-hibernation sleep state in every system.  If
> +the given system supports two non-hibernation sleep states, "standby" is present
> +in /sys/power/state in addition to "mem".  If the system supports three
> +non-hibernation sleep states, "freeze" will be present in /sys/power/state in
> +addition to "mem" and "standby".
> 
> -The kernel supports four power management states generically, though
> -one is generic and the other three are dependent on platform support
> -code to implement the low-level details for each state.
> -This file describes each state, what they are
> -commonly called, what ACPI state they map to, and what string to write
> -to /sys/power/state to enter that state
> +For relative_sleep_states=0, which is the default, the following descriptions
> +apply.
> 
> -state:		Freeze / Low-Power Idle
> +state:		Suspend-To-Idle
>  ACPI state:	S0
> -String:		"freeze"
> +Label:		"freeze"
> 
> -This state is a generic, pure software, light-weight, low-power state.
> -It allows more energy to be saved relative to idle by freezing user
> +This state is a generic, pure software, light-weight, system sleep state.
> +It allows more energy to be saved relative to runtime idle by freezing user
>  space and putting all I/O devices into low-power states (possibly
>  lower-power than available at run time), such that the processors can
>  spend more time in their idle states.
> -This state can be used for platforms without Standby/Suspend-to-RAM
> +
> +This state can be used for platforms without Power-On Suspend/Suspend-to-RAM
>  support, or it can be used in addition to Suspend-to-RAM (memory sleep)
> -to provide reduced resume latency.
> +to provide reduced resume latency.  It is always supported.
> 
> 
>  State:		Standby / Power-On Suspend
>  ACPI State:	S1
> -String:		"standby"
> +Label:		"standby"
> 
> -This state offers minimal, though real, power savings, while providing
> -a very low-latency transition back to a working system. No operating
> -state is lost (the CPU retains power), so the system easily starts up
> +This state, if supported, offers moderate, though real, power savings, while
> +providing a relatively low-latency transition back to a working system.  No
> +operating state is lost (the CPU retains power), so the system easily starts up
>  again where it left off. 
> 
> -We try to put devices in a low-power state equivalent to D1, which
> -also offers low power savings, but low resume latency. Not all devices
> -support D1, and those that don't are left on. 
> +In addition to freezing user space and putting all I/O devices into low-power
> +states, which is done for Suspend-To-Idle too, nonboot CPUs are taken offline
> +and all low-level system functions are suspended during transitions into this
> +state.  For this reason, it should allow more energy to be saved relative to
> +Suspend-To-Idle, but the resume latency will generally be greater than for that
> +state.
> 
> 
>  State:		Suspend-to-RAM
>  ACPI State:	S3
> -String:		"mem"
> +Label:		"mem"
> 
> -This state offers significant power savings as everything in the
> -system is put into a low-power state, except for memory, which is
> -placed in self-refresh mode to retain its contents. 
> -
> -System and device state is saved and kept in memory. All devices are
> -suspended and put into D3. In many cases, all peripheral buses lose
> -power when entering STR, so devices must be able to handle the
> -transition back to the On state. 
> +This state, if supported, offers significant power savings as everything in the
> +system is put into a low-power state, except for memory, which should be placed
> +into the self-refresh mode to retain its contents.  All of the steps carried out
> +when entering Power-On Suspend are also carried out during transitions to STR.
> +Additional operations may take place depending on the platform capabilities.  In
> +particular, on ACPI systems the kernel passes control to the BIOS (platform
> +firmware) as the last step during STR transitions and that usually results in
> +powering down some more low-level components that aren't directly controlled by
> +the kernel.
> +
> +System and device state is saved and kept in memory.  All devices are suspended
> +and put into low-power states.  In many cases, all peripheral buses lose power
> +when entering STR, so devices must be able to handle the transition back to the
> +"on" state.
> 
> -For at least ACPI, STR requires some minimal boot-strapping code to
> -resume the system from STR. This may be true on other platforms. 
> +For at least ACPI, STR requires some minimal boot-strapping code to resume the
> +system from it.  This may be the case on other platforms too.
> 
> 
>  State:		Suspend-to-disk
>  ACPI State:	S4
> -String:		"disk"
> +Label:		"disk"
> 
>  This state offers the greatest power savings, and can be used even in
>  the absence of low-level platform support for power management. This
> 

