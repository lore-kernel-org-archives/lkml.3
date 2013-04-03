Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258Ab3DCQfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:35:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42072 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab3DCQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:35:12 -0400
Date: Wed, 3 Apr 2013 09:35:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130403163509.GC21969@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <20130402230042.GA8713@kroah.com>
 <20130402165340.61b7da02@chromoly>
 <20130403001300.GA13838@kroah.com>
 <20130402214818.50f1ae89@chromoly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402214818.50f1ae89@chromoly>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 09:48:18PM -0700, Jacob Pan wrote:
> > Let's step back and start over, what exactly are you trying to tell
> > userspace?  What data do you have that you need to express to it?  How
> > do you want userspace to see/use it?
> 
> It is a good idea to step back and let me explain what I wanted to
> do here for userspace.
> 
> I have two kinds of applications that might use this driver.
> 1. simple use case where user sets a power limit for a RAPL domain.
> e.g. set graphics unit power limit to 7w
> 2. advanced use case where use can do fine tuning on top of simple
> power limit,e.g. the dynamic response parameters of power control
> logic, event notifications, etc.
> 
> For #1, this driver register with the abstract generic thermal layer
> (/sys/class/thermal) and presents itself as a set of cooling devices
> with a single knob per domain for power limits.
> root@chromoly:/sys/class/thermal/cooling_device15# echo 7000 > cur_state 

Great, how about submitting that functionality as patch 1 of your
series?  That seems like a very "normal" thermal driver, right?

> For #2, to give userspace complete control of the RAPL interface, which
> is not generic, I put them under the device private sysfs area.
> root@chromoly:/sys/class/thermal/cooling_device15/device# echo 1000 > time_window1 

I totally fail to understand the difference.  What do you want to show
to userspace that can't be expressed through the thermal interface
today?  Perhaps the thermal interface could be expanded to provide more
functionality that you need?  Why create a one-off API that will never
be used again and require userspace programs to be written just to
handle this one type of device?

> As you mentioned about using device tree vs. fs, and how kobject are
> used for fs. I do have the need to go between a generic thermal sysfs
> and the true device tree. This is the reason why I used kobjects and
> link them between device tree and its thermal sysfs representation.

I don't understand your leap to using kobjects.

> e.g. a RAPL package cooling device linked with its platform device
> kobj. (device is linked with rapl_domains/package, the line is too long)
> 
> root@chromoly:/sys/class/thermal# ls -l cooling_device15/
> total 0
> -rw-r--r-- 1 root root 4096 Apr  2 15:03 cur_state
> lrwxrwxrwx 1 root root    0 Apr  2 21:28 device
> -> ../../../platform/intel_rapl/rapl_domains/package
> -r--r--r-- 1 root root 4096 Apr  2 15:03 max_state
> drwxr-xr-x 2 root root    0 Apr  2 21:28 power
> lrwxrwxrwx 1 root root    0 Apr  2 15:03 subsystem
> -> ../../../../class/thermal
> -r--r--r-- 1 root root 4096 Apr  2 15:03 type
> -rw-r--r-- 1 root root 4096 Apr  2 15:03 uevent

I still don't understand.  What are you adding here, the device symlink?
Or something else?

> For userspace which is not satisfied with the simple use case of a
> single knob for setting power limit, it can follow the link to find the
> device tree entry. Then get access to the complete knobs, including
> event notifications.

And what is in that device directory?  What is rapl_domains?  Why isn't
that a normal 'struct device'?

Still confused.

greg k-h
