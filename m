Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab3GPSsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:48:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:22846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353Ab3GPSsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="371316029"
Message-ID: <51E596E7.5040504@linux.intel.com>
Date: Tue, 16 Jul 2013 11:54:31 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
References: <51E57631.2030805@linux.intel.com> <20130716164459.GB17827@kroah.com> <51E59116.2060801@linux.intel.com> <20130716183149.GA6164@kroah.com>
In-Reply-To: <20130716183149.GA6164@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am assigned to do add a powercap class. There are several 
technologies, which will allow to
add a power budget to an individual device. For example, you can set a 
power budget to
a individual physical cpu package, each core and uncore devices, GPUs, 
DRAM etc.

+The Power Capping framework organizes power capping devices under a tree structure.
+At the root level, each device is under some "controller", which is the enabler
+of technology. For example this can be "RAPL".
+Under each controllers, there are multiple power zones, which can be independently
+monitored and controlled.
+Each power zone can be organized as a tree with parent, children and siblings.
+Each power zone defines attributes to enable power monitoring and constraints.
+
+Example Sys-FS Interface
+
+/sys/class/power_cap/intel-rapl
+├── package-0
+│   ├── constraint-0
+│   │   ├── name
+│   │   ├── power_limit_uw
+│   │   └── time_window_us
+│   ├── constraint-1
+│   │   ├── name
+│   │   ├── power_limit_uw
+│   │   └── time_window_us
+│   ├── core
+│   │   ├── constraint-0
+│   │   │   ├── name
+│   │   │   ├── power_limit_uw
+│   │   │   └── time_window_us
+│   │   ├── energy_uj
+│   │   └── max_energy_range_uj
+│   ├── dram
+│   │   ├── constraint-0
+│   │   │   ├── name
+│   │   │   ├── power_limit_uw
+│   │   │   └── time_window_us
+│   │   ├── energy_uj
+│   │   └── max_energy_range_uj
+│   ├── energy_uj
+│   ├── max_energy_range_uj
+│   └── max_power_range_uw
+├── package-1
+│   ├── constraint-0
+│   │   ├── name
+│   │   ├── power_limit_uw
+│   │   └── time_window_us
+│   ├── constraint-1
+│   │   ├── name
+│   │   ├── power_limit_uw
+│   │   └── time_window_us
+│   ├── core
+│   │   ├── constraint-0
+│   │   │   ├── name
+│   │   │   ├── power_limit_uw
+│   │   │   └── time_window_us
+│   │   ├── energy_uj
+│   │   └── max_energy_range_uj
+│   ├── dram
+│   │   ├── constraint-0
+│   │   │   ├── name
+│   │   │   ├── power_limit_uw
+│   │   │   └── time_window_us
+│   │   ├── energy_uj
+│   │   └── max_energy_range_uj
+│   ├── energy_uj
+│   ├── max_energy_range_uj
+│   └── max_power_range_uw
+├── power
+│   ├── async
+│   ├── autosuspend_delay_ms
+│   ├── control
+│   ├── runtime_active_kids
+│   ├── runtime_active_time
+│   ├── runtime_enabled
+│   ├── runtime_status
+│   ├── runtime_suspended_time
+│   └── runtime_usage
+├── subsystem -> ../../../../class/power_cap
+└── uevent
+
+For example, above powercap sys-fs tree represents RAPL(Running Average Power Limit)
+type controls available in the Intel® 64 and IA-32 Processor Architectures. Here
+under controller "intel-rapl" there are two CPU packages (package-0/1), which can
+provide power monitoring and controls. A RAPL controller provides control for each
+CPU package, so it can have one node for each package. In addition to providing
+monitoring and control at package level, each package is further divided into
+power zones (called domains in the RAPL specifications). Here zones represent controls
+for core and dram  parts. These zones can be represented as children of package.
+Under RAPL framework there are two constraints, one for short term and one for long term,
+with two different time windows. These can be represented as two constraints, with
+different time windows, power limits and names.


Thanks,
Srinivas




On 07/16/2013 11:31 AM, Greg KH wrote:
> On Tue, Jul 16, 2013 at 11:29:42AM -0700, Srinivas Pandruvada wrote:
>> Thanks for the quick response. Here I am creating virtual devices using
>> device_register.
>> I have attached a simple test program, which will give error.
>>
>> This is my intention:
>>
>> $> cd /sys/class/test_class
>> $> ls
>> power_zone_cpu_package_0
>> power_zone_cpu_package_1
> Wait, you are mixing a class and a "real" bus up.  This will fail as
> your devices all end up on the virtual "bus" with the same name, in the
> same location on the bus (look in /sys/devices/virtual/ for where they
> will end up at.
>
> That will fail, and rightly so.
>
> Try using this with the proper 'struct bus_type' and let me know if
> creating a device there with the same name will also fail.
>
> Oh crud, it will, because we can't create symlinks with the same bus
> type in the /sys/bus/BUSTYPE/devices/ directory.
>
> So, don't use the same name for a device on the same bus, that way
> causes confusion :)
>
> Let's get back to your original "problem", what again are you trying to
> solve?  There should be a way to resolve this without having to deal
> with duplicate names, perhaps you just want an attribute group with a
> common name?
>
> thanks,
>
> greg k-h
>

