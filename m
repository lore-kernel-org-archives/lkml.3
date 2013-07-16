Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab3GPUEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:04:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:29656 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196Ab3GPUEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,679,1367996400"; 
   d="scan'208";a="371347425"
Message-ID: <51E5A8DF.8070908@linux.intel.com>
Date: Tue, 16 Jul 2013 13:11:11 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
References: <51E57631.2030805@linux.intel.com> <20130716164459.GB17827@kroah.com> <51E59116.2060801@linux.intel.com> <20130716183149.GA6164@kroah.com> <51E596E7.5040504@linux.intel.com> <20130716190422.GA1186@kroah.com> <51E59FEF.90404@linux.intel.com> <20130716193235.GA8142@kroah.com>
In-Reply-To: <20130716193235.GA8142@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:32 PM, Greg KH wrote:
> On Tue, Jul 16, 2013 at 12:33:03PM -0700, Srinivas Pandruvada wrote:
>>>> +Example Sys-FS Interface
>>>> +
>>>> +/sys/class/power_cap/intel-rapl
>>>> +├── package-0
>>>> +│   ├── constraint-0
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── constraint-1
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── core
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── dram
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── energy_uj
>>>> +│   ├── max_energy_range_uj
>>>> +│   └── max_power_range_uw
>>>> +├── package-1
>>>> +│   ├── constraint-0
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── constraint-1
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── core
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── dram
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── energy_uj
>>>> +│   ├── max_energy_range_uj
>>>> +│   └── max_power_range_uw
>>>> +├── power
>>>> +│   ├── async
>>>> +│   ├── autosuspend_delay_ms
>>>> +│   ├── control
>>>> +│   ├── runtime_active_kids
>>>> +│   ├── runtime_active_time
>>>> +│   ├── runtime_enabled
>>>> +│   ├── runtime_status
>>>> +│   ├── runtime_suspended_time
>>>> +│   └── runtime_usage
>>>> +├── subsystem -> ../../../../class/power_cap
>>>> +└── uevent
>>> Ick.  Rewrite this to use a bus and you should be fine, right?  Don't
>>> use a class, a class is only to be used if you have a device that is a
>>> specific "type of thing".  Like a tty device, it is a class, as lots of
>>> different "real" devices can have tty ports on them (usb, pci, pcmcia,
>>> platform, etc.)
>>>
>>> Rethink this using a bus and see if that solves your issues.  You get a
>>> hierarchy with that.  And you can have different "types" of devices on
>>> your bus, making it easy to tell the difference between a "package" and
>>> a "constraint".
>>>
>>> Does that help?
>> I will experiment your suggestion. I see this class analogous to
>> "/sys/class/thermal",
>> , where the thermal class provides a set of consistent interface for all
>> thermal devices.
> But thermal devices are not "real" at all.  There are just a number of
> "cooling devices" on a virtual bus and not attached to any type of a
> real device at all.
Similar to cooling drivers, the power cap client drivers don't have to 
be real.
For example intel rapl just uses x86 MSRs. But some other drivers can be 
using
PCIe and use this framework to export control to users.
> There's also no hierarchy that I can see with the thermal class, but you
> want to have this, so you will have to do something different because
> classes do not have hierarchies.
The reason, we tried not have hierarchy for ease of management from
a user space. If I use this flat model, then showing relationships need 
to use
some sort of linking like regulator class. Do you have preference for 
such model?
> So try using a device and a bus and see if that helps out.  If not,
> please let me know.
Looking at this possibility.
> thanks,
>
> greg k-h
>
Thanks,
Srinivas
