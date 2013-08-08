Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123Ab3HHNnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:43:43 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59885 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab3HHNnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:43:40 -0400
Date: Thu, 08 Aug 2013 08:43:37 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC v02 1/5] PowerCap: Documentation
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, rjw@sisk.pl,
        arjan@linux.intel.com, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com, corbet@lwn.net, joe@perches.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
In-Reply-To: <1375891965-6921-2-git-send-email-srinivas.pandruvada@linux.intel.com>
	(from srinivas.pandruvada@linux.intel.com on Wed Aug  7 11:12:41 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1375969417.2737.0@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 11:12:41 AM, Srinivas Pandruvada wrote:
> Added power cap framework documentation. This explains the use of  
> power capping
> framework, sysfs and programming interface.
> There are two documents:
> Documentation/powercap/PowerCappingFramework.txt: Explains use case  
> and API in
> details.
> Documentation/ABI/testing/sysfs-class-powercap: Explains ABIs.
> 
> Reviewed-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Srinivas Pandruvada  
> <srinivas.pandruvada@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  Documentation/ABI/testing/sysfs-class-powercap   | 165 ++++++
>  Documentation/powercap/PowerCappingFramework.txt | 686  
> +++++++++++++++++++++++
...
> --- /dev/null
> +++ b/Documentation/powercap/PowerCappingFramework.txt
> @@ -0,0 +1,686 @@
> +Power Capping Framework
> +==================================
> +
> +The Linux Power Capping Framework provides user-space with a common
> +API to kernel-mode power-capping drivers.  At the same time,
> +it provides the hardware-specific power-capping drivers with
> +a uniform API to user-space.

s/.  At the same time, it provides/, and/

> +Terminology
> +=========================
> +The Power Capping framework organizes power capping devices under a  
> tree structure.
> +At the root level, each device is under some "controller", which is  
> the enabler
> +of technology.

A controller is the enabler of technology?

What does that mean?

> For example this can be "RAPL".

Ah, clears it right up.

> +Under each controllers,

each doesn't take a plural.

> there are multiple power zones, which can be independently
> +monitored and controlled.
> +Each power zone can be organized as a tree with parent, children and  
> siblings.
> +Each power zone defines attributes to enable power monitoring and  
> constraints.
> +
> +Example sysfs interface tree:
> +
> +/sys/devices/virtual/power_cap
> +└── intel-rapl
... intel intel intel intel...
> +
> +For example, above powercap sysfs tree represents RAPL(Running  
> Average Power Limit)
> +type controls available in the Intel® 64 and IA-32 Processor  
> Architectures. Here

What are the chances of this ever being applied to a non-intel  
processor? (Should it be under Documentation/x86, or is it presented as  
something with a nonzero chance of actually ever being generic?)

> +under controller "intel-rapl" there are two CPU packages  
> (package-0/1), which can
> +provide power monitoring and controls (intel-rapl:0 and  
> intel-rapl:1). Each power
> +zone has a name.
> +For example:
> +cat /sys/class/power_cap/intel-rapl/intel-rapl:0/name
> +package-0
> +
> +In addition to providing monitoring and control at package level,  
> each package
> +is further divided into child power zones (called domains in the RAPL
> specifications).

Where are the RAPL specifications, and is this framework just an  
implementation of them or is it more generic?

> +Here zones represent controls for core and dram  parts. These zones  
> can be represented
> +as children of package.
> +For example:
> +cat /sys/class/power_cap/intel-rapl/intel-rapl:0/intel-rapl:0:1/name
> +dram
> +
> +Under RAPL framework there are two constraints, one for
> +short term and one for long term, with two different time windows.  
> These can be
> +represented as two constraints, with different time windows, power  
> limits and names.
> +For example:
> +	constraint_0_name
> +	constraint_0_power_limit_uw
> +	constraint_0_time_window_us
> +	constraint_1_name
> +	constraint_1_power_limit_uw
> +	constraint_1_time_window_us
> +
> +Power Zone Attributes
> +=================================
> +Monitoring attributes
> +----------------------
> +
> +energy_uj (rw): Current energy counter in micro joules. Write "0" to  
> reset.
> +If the counter can not be reset, then this attribute is read only.
> +
> +max_energy_range_uj (ro): Range of the above energy counter in  
> micro-joules.
> +
> +power_uw (rw): Current power in micro watts. Write "0" to resets the  
> value.
> +If the value can not be reset, then this attribute is read only.
> +
> +max_power_range_uw (ro): Range of the above power value in  
> micro-watts.
> +
> +name (ro): Name of this power zone.
> +
> +It is possible that some domains can have both power and energy  
> counters and
> +ranges, but at least one is mandatory.
> +
> +Constraints
> +----------------
> +constraint_X_power_limit_uw (rw): Power limit in micro watts, which  
> should be
> +applicable for the time window specified by  
> "constraint_X_time_window_us".
> +
> +constraint_X_time_window_us (rw): Time window in micro seconds.
> +
> +constraint_X_name (ro): An optional name of the constraint
> +
> +constraint_X_max_power_uw(ro): Maximum allowed power in micro watts.
> +
> +constraint_X_min_power_uw(ro): Minimum allowed power in micro watts.
> +
> +constraint_X_max_time_window_us(ro): Maximum allowed time window in  
> micro seconds.
> +
> +constraint_X_min_time_window_us(ro): Minimum allowed time window in  
> micro seconds.
> +
> +In addition each node has an attribute "type", which shows, whether  
> is a controller
> +or power zone. Except power_limit_uw and time_window_us other fields  
> are optional.
> +
> +Power Cap Client Driver Interface
> +==================================
> +The API summary:
> +
> +Call powercap_allocate_controller to define a controller with a name.
> +Call powercap_zone_register for each power zone for this controller.
> +power zones can have other power zone as a parent or don't have a
> +parent.

Trying not to nitpick "english isn't a first language here", but...

Power zones can have another power zone as a parent or no parent.

> +During powercap_zone_register defines number of constraints and  
> callbacks.
> +
> +To Free a power zone call powercap_zone_unregister.
> +To free a controller call powercap_deallocate_controller.
> +
> +Rest of this document is generated by using kernel-doc on
> +powercap.h

Isn't that what Documentation/DocBook is for? (If powercap.h is  
modified the need to update this file is nonobvious...)

Rob