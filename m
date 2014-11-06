Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaKFRIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:08:25 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:59811 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaKFRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:08:22 -0500
Date: Thu, 6 Nov 2014 09:08:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v5 00/48] kernel: Add support for power-off handler call
 chain
Message-ID: <20141106170818.GA30177@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.545BAB05.03A7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:42:44AM -0800, Guenter Roeck wrote:
> Various drivers implement architecture and/or device specific means to
> remove power from the system.  For the most part, those drivers set the
> global variable pm_power_off to point to a function within the driver.
> 
> This mechanism has a number of drawbacks.  Typically only one means
> to remove power is supported (at least if pm_power_off is used).
> At least in theory there can be multiple means to remove power, some of
> which may be less desirable.  For example, one mechanism might power off the
> entire system through an I/O port or gpio pin, while another might power off
> a board by disabling its power controller. Other mechanisms may really just
> execute a restart sequence or drop into the ROM monitor, or put the CPU into
> sleep mode.  Using pm_power_off can also be racy if the function pointer is
> set from a driver built as module, as the driver may be in the process of
> being unloaded when pm_power_off is called.  If there are multiple power-off
> handlers in the system, removing a module with such a handler may
> inadvertently reset the pointer to pm_power_off to NULL, leaving the system
> with no means to remove power.
> 
> Introduce a system power-off handler call chain to solve the described
> problems.  This call chain is expected to be executed from the architecture
> specific machine_power_off() function.  Drivers providing system power-off
> functionality are expected to register with this call chain.  By using the
> priority field in the notifier block, callers can control power-off handler
> execution sequence and thus ensure that the power-off handler with the
> optimal capabilities to remove power for a given system is called first.
> A call chain instead of a single call to the highest priority handler is
> used to provide fallback: If multiple power-off handlers are installed,
> all handlers will be called until one actually succeeds to power off the
> system.
> 
> Patch 01/48 implements the power-off handler API.
> 
> Patches 02/48 to 04/48 are cleanup patches to prepare for the move of
> pm_power_off to a common location.
> 
> Patches 05/48 to 07/48 remove references to pm_power_off from devicetree
> bindings descriptions.
> 
> Patch 08/48 moves the pm_power_off variable from architecture code to
> kernel/reboot.c. 
> 
> Patches 09/48 to 34/48 convert various drivers to register with the kernel
> power-off handler instead of setting pm_power_off directly.
> 
> Patches 35/48 to 47/48 do the same for architecture code.
> 
> Patch 48/48 finally removes pm_power_off.
> 
> For the most part, the individual patches include explanations why specific
> priorities were chosen, at least if the selected priority is not the default
> priority. Subsystem and architecture maintainers are encouraged to have a look
> at the selected priorities and suggest improvements.
> 
> I ran the final code through my normal build and qemu tests. Results are
> available at http://server.roeck-us.net:8010/builders in the 'poweroff-handler'
> column. I also built all available configurations for arm, mips, powerpc,
> m68k, and sh architectures.
> 
> The series is available in branch poweroff-handler of my repository at
> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git.
> It is based on 3.18-rc3 plus the power-off tracking branch from
> git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git (to merge
> powerpc related power-off changes).
> 
> A note on Cc: In the initial submission I had way too many Cc:, causing the
> patchset to be treated as spam by many mailers and mailing list handlers,
> which of course defeated the purpose. Starting with v3, the distribution
> list has been cut down significantly. Copied mailing lists and individuals are
> for the most part generated from the output of get_maintainer.pl for each
> individual patch.  My apologies to anyone I may have failed to copy; if you
> believe that some additional individuals or mailing lists should be copied
> on the entire series or on individual patches, please let me know.
> 
> Merge plan is to send the entire series directly to Linus during the next commit
> window, except for the last patch. The last patch would then be part of another
> pull request after -rc1, which would include any changes necessary due to newly
> merged power-off handling code.
> 

I should have added that I plan to have the series (except for the last patch)
added to -next shortly.

Linus,

are you ok with this plan ?

Thanks,
Guenter

> v5:
> - Rebased series to v3.18-rc3
> - Merge remote-tracking branch 'power/topic/pm-power-off'
>   from git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git
>   and implement powerpc conversion (patch 41/48).
> v4:
> - Do not use notifiers but internal functions and data structures to manage
>   the list of power-off handlers. Drop unused parameters from callbacks, and
>   make the power-off function type void.
>   Code to manage and walk the list of callbacks was derived from notifier.c.
>   Note that only patch 01/47 was sent for review of this version.
> v3:
> - Rebased series to v3.18-rc2.
> - Do not hold any locks while executing the power-off call chain.
>   This ensures that power-off handlers are executed in the state
>   selected by the machine_power_off function for a given architecture,
>   ie without changing the current semantics of power-off callbacks and
>   machine_power_off functions.
>   Power-off handler registration and de-registration is handled in atomic
>   context with interrupts disabled to ensure that those functions are not
>   interrupted by code which powers off the system.
> - Use [xxx_]power_off[_xxx] instead of [xxx_]poweroff[_xxx] for newly
>   introduced function and variable names.
> - Use power-off instead of poweroff in descriptive text and comments.
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> - Use ACPI: instead of acpi: for messages in acpi code.
> v2:
> - Rebased series to v3.18-rc1.
> - Use raw notifier with spinlock protection instead of atomic notifiers,
>   since some power-off handlers need to have interrupts enabled.
> - Renamed API functions from _poweroff to _power_off.
> - Added various Acks.
> - Build tested all configurations for arm, powerpc, and mips architectures.
> - Fixed two compile errors in mips patch.
> - Replaced dev_err and pr_err with dev_warn and pr_warn if an error is not
>   fatal.
> - Provide managed resources API and use where appropriate.
> - Provide and use definitions for standard priorities.
> - Added patches to convert newly introduced power-off handlers.
> - Various minor changes.
> v1 (from RFC):
> - Move API to new file kernel/power/power_off_handler.c.
> - Move pm_power_off pointer to kernel/power/power_off_handler.c. Call
>   pm_power_off from do_kernel_power_off, and only call do_kernel_power_off
>   from architecture code instead of calling both pm_power_off and
>   do_kernel_power_off.
> - Provide additional API function register_power_off_handler_simple
>   to simplify conversion of architecture code.
> - Provide additional API function have_kernel_power_off to check if
>   a power-off handler was installed.
> - Convert all drivers and architecture code to use the new API.
> - Remove pm_power_off as last patch of the series.
> 
> Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Romain Perier <romain.perier@gmail.com>
