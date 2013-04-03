Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864Ab3DCRgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:36:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:24816 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593Ab3DCRgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,402,1363158000"; 
   d="scan'208";a="222438119"
Date: Wed, 3 Apr 2013 10:35:51 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130403103551.16e62eb6@chromoly>
In-Reply-To: <20130403163509.GC21969@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20130402230042.GA8713@kroah.com>
	<20130402165340.61b7da02@chromoly>
	<20130403001300.GA13838@kroah.com>
	<20130402214818.50f1ae89@chromoly>
	<20130403163509.GC21969@kroah.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013 09:35:09 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Apr 02, 2013 at 09:48:18PM -0700, Jacob Pan wrote:
> > > Let's step back and start over, what exactly are you trying to
> > > tell userspace?  What data do you have that you need to express
> > > to it?  How do you want userspace to see/use it?
> > 
> > It is a good idea to step back and let me explain what I wanted to
> > do here for userspace.
> > 
> > I have two kinds of applications that might use this driver.
> > 1. simple use case where user sets a power limit for a RAPL domain.
> > e.g. set graphics unit power limit to 7w
> > 2. advanced use case where use can do fine tuning on top of simple
> > power limit,e.g. the dynamic response parameters of power control
> > logic, event notifications, etc.
> > 
> > For #1, this driver register with the abstract generic thermal layer
> > (/sys/class/thermal) and presents itself as a set of cooling devices
> > with a single knob per domain for power limits.
> > root@chromoly:/sys/class/thermal/cooling_device15# echo 7000 >
> > cur_state 
> 
> Great, how about submitting that functionality as patch 1 of your
> series?  That seems like a very "normal" thermal driver, right?
> 
yes, that would be a normal thermal cooling device driver. I will do
that first. Thanks for the suggestion.
> > For #2, to give userspace complete control of the RAPL interface,
> > which is not generic, I put them under the device private sysfs
> > area. root@chromoly:/sys/class/thermal/cooling_device15/device#
> > echo 1000 > time_window1 
> 
> I totally fail to understand the difference.  What do you want to show
> to userspace that can't be expressed through the thermal interface
> today?
The difference is one single knob (long term power limit) in the thermal
interface vs multiple fine grained control and data in the complete RAPL
interface.

Here is what a complete RAPL interface for package domain looks like.
root@chromoly:/sys/class/thermal/cooling_device15/device# grep . *
domain_name:package
energy:22396031
lock:0
max_power:0
max_window:0
min_power:0
pl1_clamp:0
pl1_enable:1
pl2_clamp:0
pl2_enable:1
power:7841
power_limit1:25000
power_limit2:31250
thermal_spec_power:17000
throttle_time: 
time_window1:28000
time_window2:0


>  Perhaps the thermal interface could be expanded to provide
> more functionality that you need?
yes, some of them such as limits. But not all the data in the list
above are suitable for thermal interface. That is why I am trying to
balance between abstracted generic data and RAPL specific data while
still allow linking between the two.

The way I envisioned how a thermal/power management app would use is:
1. go through generic thermal layer sysfs and find available RAPL
domains
2. if the app wants to do more fine grained control, it follows the
device symlink to locate the RAPL domain specific sysfs area.

>  Why create a one-off API that will
> never be used again and require userspace programs to be written just
> to handle this one type of device?
> 
why is that a one-off API? RAPL interface is maintained identical across
Intel CPUs after Sandy Bridges. I agree with you that it is still one
type of device with some of its data unique. Should i create a RAPL
class device?

> > As you mentioned about using device tree vs. fs, and how kobject are
> > used for fs. I do have the need to go between a generic thermal
> > sysfs and the true device tree. This is the reason why I used
> > kobjects and link them between device tree and its thermal sysfs
> > representation.
> 
> I don't understand your leap to using kobjects.
> 
I use kobjects mainly for its symlink to allow userspace locate the
'true' device behind generic thermal layers' cooling device.


> > e.g. a RAPL package cooling device linked with its platform device
> > kobj. (device is linked with rapl_domains/package, the line is too
> > long)
> > 
> > root@chromoly:/sys/class/thermal# ls -l cooling_device15/
> > total 0
> > -rw-r--r-- 1 root root 4096 Apr  2 15:03 cur_state
> > lrwxrwxrwx 1 root root    0 Apr  2 21:28 device
> > -> ../../../platform/intel_rapl/rapl_domains/package
> > -r--r--r-- 1 root root 4096 Apr  2 15:03 max_state
> > drwxr-xr-x 2 root root    0 Apr  2 21:28 power
> > lrwxrwxrwx 1 root root    0 Apr  2 15:03 subsystem
> > -> ../../../../class/thermal
> > -r--r--r-- 1 root root 4096 Apr  2 15:03 type
> > -rw-r--r-- 1 root root 4096 Apr  2 15:03 uevent
> 
> I still don't understand.  What are you adding here, the device
> symlink? Or something else?
> 
> > For userspace which is not satisfied with the simple use case of a
> > single knob for setting power limit, it can follow the link to find
> > the device tree entry. Then get access to the complete knobs,
> > including event notifications.
> 
> And what is in that device directory? 
 
the device directory contains the complete RAPL interface
representation. paste the example of package domain again.

root@chromoly:/sys/class/thermal/cooling_device15/device# grep . *
domain_name:package
energy:22396031
lock:0
max_power:0
max_window:0
min_power:0
pl1_clamp:0
pl1_enable:1
pl2_clamp:0
pl2_enable:1
power:7841
power_limit1:25000
power_limit2:31250
thermal_spec_power:17000
grep: throttle_time: Input/output error
time_window1:28000
time_window2:0

> What is rapl_domains?  Why
> isn't that a normal 'struct device'?
>
RAPL domains can be viewed as sub devices of RAPL interface. On a given
platform they can be a complete or partial list of 
package, power plane 0 (processor core), power plane 1 (graphics),
dram controller, pch, etc.

Yes, I can create a RAPL class and create_device for each domain based
on 'struct device'. I can still use the kobj symlink to link to generic
thermal layer. I just thought it is an overkill as compared to
simply using kobjects and kset.

I don't understand the benefit of using 'struct device' in this
case. RAPL interface as a whole has its device, I am not creating
standalone kobjects.


> Still confused.
> 
> greg k-h

[Jacob Pan]

-- 
Thanks,

Jacob
