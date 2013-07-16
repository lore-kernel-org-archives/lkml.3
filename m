Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab3GPT0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:26:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:16198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab3GPT0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="346602092"
Message-ID: <51E59FEF.90404@linux.intel.com>
Date: Tue, 16 Jul 2013 12:33:03 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
References: <51E57631.2030805@linux.intel.com> <20130716164459.GB17827@kroah.com> <51E59116.2060801@linux.intel.com> <20130716183149.GA6164@kroah.com> <51E596E7.5040504@linux.intel.com> <20130716190422.GA1186@kroah.com>
In-Reply-To: <20130716190422.GA1186@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:04 PM, Greg KH wrote:
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
Glad to learn something new today.
>
> On Tue, Jul 16, 2013 at 11:54:31AM -0700, Srinivas Pandruvada wrote:
>> Hi,
>>
>> I am assigned to do add a powercap class. There are several
>> technologies, which will allow to add a power budget to an individual
>> device. For example, you can set a power budget to a individual
>> physical cpu package, each core and uncore devices, GPUs, DRAM etc.
> "classes" all reference a "device" in the system, I don't see that in
> your tree below, where does that come in?  How do I, as someone who
> created a device in the system know to create a your new powercap class
> for it?
>
> In other words, are you _sure_ you want a class here and not something
> else (i.e. a bus?)
>
>> +The Power Capping framework organizes power capping devices under a tree structure.
>> +At the root level, each device is under some "controller", which is the enabler
>> +of technology. For example this can be "RAPL".
>> +Under each controllers, there are multiple power zones, which can be independently
>> +monitored and controlled.
>> +Each power zone can be organized as a tree with parent, children and siblings.
>> +Each power zone defines attributes to enable power monitoring and constraints.
> Ah, this sounds like you want to be a bus, as you have a controller, and
> then devices attached to it.
>
>> +Example Sys-FS Interface
>> +
>> +/sys/class/power_cap/intel-rapl
>> +├── package-0
>> +│   ├── constraint-0
>> +│   │   ├── name
>> +│   │   ├── power_limit_uw
>> +│   │   └── time_window_us
>> +│   ├── constraint-1
>> +│   │   ├── name
>> +│   │   ├── power_limit_uw
>> +│   │   └── time_window_us
>> +│   ├── core
>> +│   │   ├── constraint-0
>> +│   │   │   ├── name
>> +│   │   │   ├── power_limit_uw
>> +│   │   │   └── time_window_us
>> +│   │   ├── energy_uj
>> +│   │   └── max_energy_range_uj
>> +│   ├── dram
>> +│   │   ├── constraint-0
>> +│   │   │   ├── name
>> +│   │   │   ├── power_limit_uw
>> +│   │   │   └── time_window_us
>> +│   │   ├── energy_uj
>> +│   │   └── max_energy_range_uj
>> +│   ├── energy_uj
>> +│   ├── max_energy_range_uj
>> +│   └── max_power_range_uw
>> +├── package-1
>> +│   ├── constraint-0
>> +│   │   ├── name
>> +│   │   ├── power_limit_uw
>> +│   │   └── time_window_us
>> +│   ├── constraint-1
>> +│   │   ├── name
>> +│   │   ├── power_limit_uw
>> +│   │   └── time_window_us
>> +│   ├── core
>> +│   │   ├── constraint-0
>> +│   │   │   ├── name
>> +│   │   │   ├── power_limit_uw
>> +│   │   │   └── time_window_us
>> +│   │   ├── energy_uj
>> +│   │   └── max_energy_range_uj
>> +│   ├── dram
>> +│   │   ├── constraint-0
>> +│   │   │   ├── name
>> +│   │   │   ├── power_limit_uw
>> +│   │   │   └── time_window_us
>> +│   │   ├── energy_uj
>> +│   │   └── max_energy_range_uj
>> +│   ├── energy_uj
>> +│   ├── max_energy_range_uj
>> +│   └── max_power_range_uw
>> +├── power
>> +│   ├── async
>> +│   ├── autosuspend_delay_ms
>> +│   ├── control
>> +│   ├── runtime_active_kids
>> +│   ├── runtime_active_time
>> +│   ├── runtime_enabled
>> +│   ├── runtime_status
>> +│   ├── runtime_suspended_time
>> +│   └── runtime_usage
>> +├── subsystem -> ../../../../class/power_cap
>> +└── uevent
> Ick.  Rewrite this to use a bus and you should be fine, right?  Don't
> use a class, a class is only to be used if you have a device that is a
> specific "type of thing".  Like a tty device, it is a class, as lots of
> different "real" devices can have tty ports on them (usb, pci, pcmcia,
> platform, etc.)
>
> Rethink this using a bus and see if that solves your issues.  You get a
> hierarchy with that.  And you can have different "types" of devices on
> your bus, making it easy to tell the difference between a "package" and
> a "constraint".
>
> Does that help?
I will experiment your suggestion. I see this class analogous to 
"/sys/class/thermal",
, where the thermal class provides a set of consistent interface for all 
thermal devices.
> greg k-h
>
Thanks,
Srinivas
