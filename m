Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaCIRnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:43:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51629 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752138AbaCIRnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:43:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Manuel Krause <manuelkrause@netscape.net>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org, rui.zhang@intel.com
Subject: Re: 3.13.?: Strange / dangerous fan policy...
Date: Sun, 09 Mar 2014 18:58:18 +0100
Message-ID: <2833205.f1U4jaAo8e@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <531BB171.1060208@netscape.net>
References: <531A1EEE.9090101@netscape.net> <531B3E4C.2040105@roeck-us.net> <531BB171.1060208@netscape.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 09, 2014 01:10:25 AM Manuel Krause wrote:
> On 2014-03-08 16:59, Guenter Roeck wrote:
> > On 03/08/2014 03:08 AM, Jean Delvare wrote:
> >> On Fri, 7 Mar 2014 14:52:30 -0800, Guenter Roeck wrote:
> >>> On Fri, Mar 07, 2014 at 11:04:29PM +0100, Manuel Krause wrote:
> >>>> Hi, and thanks for the quick response!
> >>>> No special fancy "fan control policy". 'fancontrol' isn't up or
> >>>> running.
> >>>> Vanilla kernels 3.11.* and 3.12.* had been working on here
> >>>> without
> >>>> any extra work.
> >>>> --
> >>>> # sensors
> >>>> acpitz-virtual-0
> >>>> Adapter: Virtual device
> >>>> temp1:        +71.0°C  (crit = +256.0°C)
> >>>> temp2:        +69.0°C  (crit = +110.0°C)
> >>>> temp3:        +52.0°C  (crit = +105.0°C)
> >>>> temp4:        +25.0°C  (crit = +110.0°C)
> >>>> temp5:        +58.0°C  (crit = +110.0°C)
> >>>>
> >>>> coretemp-isa-0000
> >>>> Adapter: ISA adapter
> >>>> Core 0:       +62.0°C  (high = +105.0°C, crit = +105.0°C)
> >>>> Core 1:       +60.0°C  (high = +105.0°C, crit = +105.0°C)
> >>>> --
> >>>> My notebook (HP/Compaq 6730b) does not have a seperate fan
> >>>> sensor.
> >>>> This is with 3.12.13 with my normal workload.
> >>>>
> >>>> Please, trust my above mentionned values of 94 °C vs. 74°C as I
> >>>> don't like to boot 3.13.6 anymore, to avoid harm to the
> >>>> notebook's
> >>>> casing.
> >>>
> >>> Understood. Unfortunately, we'll need to get information
> >>> from the new kernel to be able to track down the problem.
> >>
> >> Indeed. Not only the run-time temperatures, but also the high
> >> and crit
> >> limits.
> >>
> >>>> But I'd do to test any improvement-patch.
> >>>
> >>> So far I have no idea what is going on. I don't see anything
> >>> in the
> >>> drivers providing above data that would explain the behavior,
> >>> but I might be missing something.
> >>
> >> Looks like a regression in the acpi subsystem or in power
> >> management,
> >> not hwmon. Hwmon is merely reporting the temperatures, it's not
> >> responsible for the actual temperatures.
> >>
> >
> > I would agree. I don't think we have enough information to be sure,
> > though. There might be some unintended interaction or interference.
> >
> > gpu is a good hint ... for example, look at commit b9ed919f1c8
> > (drm/nouveau/drm/pm: remove everything except the hwmon interfaces
> > to THERM). nouveau does export pwm and fan control information,
> > so any change in that code may have unintended side effects.
> > Similar, I don't know how ec39f64bba (drm/radeon/dpm: Convert to
> > use devm_hwmon_register_with_groups) could have the observed impact,
> > as it is purely passive, but I prefer to be rather safe than sorry.
> >
> > This problem has now been submitted into bugzilla as
> > https://bugzilla.kernel.org/show_bug.cgi?id=71711.
> >
> > Guenter
> >
> 
> Sorry, for beeing late, had to search for/accumulate much info 
> for you...
> I hope, you like me to put it into one answer to you all CCing you.
> 
> My GFX is a GM45 Intel (mobile), shared memory, running the 
> opensource Mesa drivers/extensions.
> kernel-module: i915
> 
> According to the output of 'cpupower': I have
> CPUidle driver: acpi_idle
> CPUidle governor: menu
> 
> CPUfreq:
>    driver: acpi-cpufreq
>    available cpufreq governors: ondemand, performance
> -
> And "ondemand" is running.
> --
> 
> # sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:        +41.0°C  (crit = +256.0°C)
> temp2:        +92.0°C  (crit = +110.0°C)
> temp3:        +71.0°C  (crit = +105.0°C)
> temp4:        +26.5°C  (crit = +110.0°C)
> temp5:        +25.0°C  (crit = +110.0°C)
> 
> coretemp-isa-0000
> Adapter: ISA adapter
> Core 0:       +86.0°C  (high = +105.0°C, crit = +105.0°C)
> Core 1:       +84.0°C  (high = +105.0°C, crit = +105.0°C)
> 
> FROM a critical "smelly" situation today, kernel-compilation, fan 
> @100%.
> --
> 
> Additional findings:
> 
> Identification from bootup ACPI initialisation vs. sensors:
> temp1 = DTSZ
> temp2 = CPUZ --> triggering Cooling in 3.12.13 if > 74°C
> temp3 = SKNZ
> temp4 = BATZ "Battery Zone" always calm ~ +6°C of ambient T
> temp5 = FDTZ --- in 3.12.13 a representation of the cooling-fan 
> (25 - 45 - 58 - max?)
> Core 0 & Core 1 are the internal CPU T sensors.
> 
> With the 3.13.x (.5+) kernels the first gatherered cooling 
> settings from bootup do stay forever. Means, rebooting a hot 
> system will get a FDTZ @45°C+ and won't make any problems, as it 
> does cool enough (even for kernel compiling on here). If it gets 
> 25°C @bootup the system goes into emergency cooling somewhen. 
> Same is with a suspend/resume.
> 
> Kernel 3.12.13 adjusts the cooling on it's own, but appropriately.

This almost certainly is an ACPI regression, but I'm not sure whether
thermal management or CPU power management is broken on your system.

Can you compare the contents of /sys/class/thermal/ from working and
not working kernels, please?

Rafael

