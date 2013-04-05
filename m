Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162738Ab3DEVdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:33:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:4543 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162429Ab3DEVdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,417,1363158000"; 
   d="scan'208";a="290119204"
Date: Fri, 5 Apr 2013 14:33:40 -0700
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
Message-ID: <20130405143340.4ea36d2e@chromoly>
In-Reply-To: <20130405202309.GA3303@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20130402230042.GA8713@kroah.com>
	<20130402165340.61b7da02@chromoly>
	<20130403001300.GA13838@kroah.com>
	<20130402214818.50f1ae89@chromoly>
	<20130403163509.GC21969@kroah.com>
	<20130403103551.16e62eb6@chromoly>
	<20130405202309.GA3303@kroah.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013 13:23:09 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Apr 03, 2013 at 10:35:51AM -0700, Jacob Pan wrote:
> > On Wed, 3 Apr 2013 09:35:09 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Tue, Apr 02, 2013 at 09:48:18PM -0700, Jacob Pan wrote:
> > > > > Let's step back and start over, what exactly are you trying to
> > > > > tell userspace?  What data do you have that you need to
> > > > > express to it?  How do you want userspace to see/use it?
> > > > 
> > > > It is a good idea to step back and let me explain what I wanted
> > > > to do here for userspace.
> > > > 
> > > > I have two kinds of applications that might use this driver.
> > > > 1. simple use case where user sets a power limit for a RAPL
> > > > domain. e.g. set graphics unit power limit to 7w
> > > > 2. advanced use case where use can do fine tuning on top of
> > > > simple power limit,e.g. the dynamic response parameters of
> > > > power control logic, event notifications, etc.
> > > > 
> > > > For #1, this driver register with the abstract generic thermal
> > > > layer (/sys/class/thermal) and presents itself as a set of
> > > > cooling devices with a single knob per domain for power limits.
> > > > root@chromoly:/sys/class/thermal/cooling_device15# echo 7000 >
> > > > cur_state 
> > > 
> > > Great, how about submitting that functionality as patch 1 of your
> > > series?  That seems like a very "normal" thermal driver, right?
> > > 
> > yes, that would be a normal thermal cooling device driver. I will do
> > that first. Thanks for the suggestion.
> 
> Do that first, get it merged, and then let's work on the second part.
> The patch for that will be much more obvious as to what you are
> attempting to do.
> 
Sorry I was too busy to work on v2 before seeing this. I agree I need
to simplify the interface, I just need to come up with a more
intelligent way to abstract that and do the best guesses for the user.
Hopefully, v2 will serve as a confirmation on the comments I got from
v1. i.e. kobject->struct device, removed dependencies on sysfs internal
data struct, etc.

> > >  Perhaps the thermal interface could be expanded to provide
> > > more functionality that you need?
> > yes, some of them such as limits. But not all the data in the list
> > above are suitable for thermal interface. That is why I am trying to
> > balance between abstracted generic data and RAPL specific data while
> > still allow linking between the two.
> 
> What is not in the existing interface?  And as this is a thermal
> device, why can't you add them there?
existing interface has only cur_state and max_state, I have been
working with Rui (thermal maintainer) on adding more knobs for cooling
devices, such as limit low, limit high, event control. I believe they
can all be added.

What is not appropriate for thermal interface are the things like
energy counters, accumulated throttle time, time constants that used by
the internal control algorithm.
> 
> > The way I envisioned how a thermal/power management app would use
> > is: 1. go through generic thermal layer sysfs and find available
> > RAPL domains
> > 2. if the app wants to do more fine grained control, it follows the
> > device symlink to locate the RAPL domain specific sysfs area.
> 
> So any application will have to know all of the device-specific
> attributes?  That totally defeats the purpose of a generic api that
> the kernel is providing.  You are creating device-specific apis that
> will not work over the long-run (i.e. next 5-10 years.)  Please don't
> do that unless you have exhausted _all_ other alternatives.
> 
I agree we should improve the abstraction to avoid using device
specific attributes. Unfortunately, on the other side power tuning tends
to be very platform specific.
> So, get your first driver accepted, using the in-kernel thermal api,
> and then, if you still feel you wish to do device-specific
> extensions, we can discuss that then.
> 
Agreed. I just want to make sure the rapl class and per domain 'struct
device' layout in v2 is what you suggested. I avoided using raw kobjects
and sysfs internals.

The challenge for the simplified/abstract model is that the driver
would have to guess what is best for the user.
e.g. when user selects power limit of 8200mw for the core power plane.
Besides setting that limit, the driver will decide the following for
the user:
 - dynamics of the control, rise time, overshoot, steady state error
 - whether or not allow P/T states to go below OS request value
 - correlation with instantaneous power limit

I believe it is all doable, just need to strike a balance and for
different platforms. But I do believe it is a better interface for most
generic applications.

> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> platform-driver-x86" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

[Jacob Pan]

-- 
Thanks,

Jacob
