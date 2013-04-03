Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3DCEsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:48:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:9931 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab3DCEsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:48:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="222181901"
Date: Tue, 2 Apr 2013 21:48:18 -0700
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
Message-ID: <20130402214818.50f1ae89@chromoly>
In-Reply-To: <20130403001300.GA13838@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20130402230042.GA8713@kroah.com>
	<20130402165340.61b7da02@chromoly>
	<20130403001300.GA13838@kroah.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013 17:13:00 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Apr 02, 2013 at 04:53:40PM -0700, Jacob Pan wrote:
> > On Tue, 2 Apr 2013 16:00:42 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > And, one final complaint, never use "raw" kobjects, for loads of
> > > good reasons, not the least being you just prevented userspace
> > > from seeing what is happening with your devices.  Use the driver
> > > model, that's what it is there for, if you need "sub children",
> > > or subdirectories.
> > I chose to use to kobjects for the reason that userspace can see the
> > device linking more clearly.
> 
> Then use a 'struct device'.
> 
> > Let me try to paraphrase, I have two options:
> > 1. if I use the platform device model instead of raw kobjects, I
> > would have one platform device for each rapl domain. Then link
> > individual platform device with the generic thermal layer sysfs.
> 
> I don't understand.
> 
> > 2. In the current patch, I have one platform driver, then expose per
> > domain kobject that can be linked to the generic thermal layer.
> > Common attributes of all domains are grouped under the kset. 
> 
> Then use a 'struct device' that is attached to that kset, no need to
> use a platform device, as that's not what is needed here, right?
> 
> > I did consider both options. I thought using #2 option is better
> > since it allow user to discover the topologies easier by following
> > the sysfs link. If i use use #1, it would be hard to expose the
> > common attributes and more code too. Perhpas I misread
> > Documentation/kobjects.txt which i thought kobject/kset are perfect
> > for presenting situation like this.
> 
> No, kobjects are for things not using the device tree, like
> filesystems or other stuff.  You are in the device tree, so use a
> 'struct device'. If you use a "raw" kobject, you do not notify
> userspace what is going on, and you loose out on a bunch of other
> stuff that the driver model provides you.
> 
> But do you even need to use anything at all?
> 
> Let's step back and start over, what exactly are you trying to tell
> userspace?  What data do you have that you need to express to it?  How
> do you want userspace to see/use it?
> 
> greg k-h

It is a good idea to step back and let me explain what I wanted to
do here for userspace.

I have two kinds of applications that might use this driver.
1. simple use case where user sets a power limit for a RAPL domain.
e.g. set graphics unit power limit to 7w
2. advanced use case where use can do fine tuning on top of simple
power limit,e.g. the dynamic response parameters of power control
logic, event notifications, etc.

For #1, this driver register with the abstract generic thermal layer
(/sys/class/thermal) and presents itself as a set of cooling devices
with a single knob per domain for power limits.
root@chromoly:/sys/class/thermal/cooling_device15# echo 7000 > cur_state 

For #2, to give userspace complete control of the RAPL interface, which
is not generic, I put them under the device private sysfs area.
root@chromoly:/sys/class/thermal/cooling_device15/device# echo 1000 > time_window1 

As you mentioned about using device tree vs. fs, and how kobject are
used for fs. I do have the need to go between a generic thermal sysfs
and the true device tree. This is the reason why I used kobjects and
link them between device tree and its thermal sysfs representation.

e.g. a RAPL package cooling device linked with its platform device
kobj. (device is linked with rapl_domains/package, the line is too long)

root@chromoly:/sys/class/thermal# ls -l cooling_device15/
total 0
-rw-r--r-- 1 root root 4096 Apr  2 15:03 cur_state
lrwxrwxrwx 1 root root    0 Apr  2 21:28 device
-> ../../../platform/intel_rapl/rapl_domains/package
-r--r--r-- 1 root root 4096 Apr  2 15:03 max_state
drwxr-xr-x 2 root root    0 Apr  2 21:28 power
lrwxrwxrwx 1 root root    0 Apr  2 15:03 subsystem
-> ../../../../class/thermal
-r--r--r-- 1 root root 4096 Apr  2 15:03 type
-rw-r--r-- 1 root root 4096 Apr  2 15:03 uevent

For userspace which is not satisfied with the simple use case of a
single knob for setting power limit, it can follow the link to find the
device tree entry. Then get access to the complete knobs, including
event notifications.

I wanted to use generic thermal fs in that it gives a simple
representation of the most usable feature of RAPL. Basically, RAPL
domains can be enumerated by thermal control apps just as ACPI fans or
processor cooling.

-- 
Thanks,

Jacob
