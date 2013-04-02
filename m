Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab3DBXAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:00:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42599 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab3DBXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:00:45 -0400
Date: Tue, 2 Apr 2013 16:00:42 -0700
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
Message-ID: <20130402230042.GA8713@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 03:15:36PM -0700, Jacob Pan wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions. Since its first appearance on Sandy Bridge, more
> features have being added to extend its usage. In RAPL, platforms are
> divided into domains for fine grained control. These domains include
> package, DRAM controller, CPU core (Power Plane 0), graphics uncore
> (power plane 1), etc.
> 
> The purpose of this driver is to expose RAPL for userspace
> consumption. Overall, RAPL fits in the generic thermal layer in
> that platform level power capping and monitoring are mainly used for
> thermal management and thermal layer provides the abstracted interface
> needed to have portable applications.
> 
> Specifically, userspace is presented with per domain cooling device
> with sysfs links to its kobject. Although RAPL domain provides many
> parameters for fine tuning, long term power limit is exposed as the
> single knob via cooling device state. Whereas the rest of the
> parameters are still accessible via the linked kobject. This simplifies
> the interface for both simple and advanced use cases.
> 
> Eventfd is used to provide notifications to the userspace. At per domain
> level, use can choose any event capable parameters to register for
> threshold crossing notifications. This is shamelessly "borrowed" from
> cgroup with some trimming/fitting.
> 
> Zhang, Rui's initial RAPL driver was used as a reference and starting
> point. Many thanks.
> https://lkml.org/lkml/2011/5/26/93
> 
> Unlike the patch above, which is mainly for monitoring, this driver
> focus on the control and usability by user applications.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/platform/x86/Kconfig      |    8 +
>  drivers/platform/x86/Makefile     |    1 +
>  drivers/platform/x86/intel_rapl.c | 1323 +++++++++++++++++++++++++++++++++++++
>  drivers/platform/x86/intel_rapl.h |  249 +++++++
>  4 files changed, 1581 insertions(+)
>  create mode 100644 drivers/platform/x86/intel_rapl.c
>  create mode 100644 drivers/platform/x86/intel_rapl.h

You are creating new sysfs files, yet you forgot to document them in
Documentation/ABI, please do so as part of this patch.

> --- /dev/null
> +++ b/drivers/platform/x86/intel_rapl.c
> @@ -0,0 +1,1323 @@
> +/*
> + *  intel_rapl.c - Intel Running Average Power Limit Driver for MSR based
> + *                 RAPL interface
> + *
> + *  Copyright (c) 2013, Intel Corporation.
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or (at
> + *  your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.

You really want to track the FSF's address for the next 40 years and
keep your file up to date?  I didn't think so...

> +#include "intel_rapl.h"
> +#include "../../../fs/sysfs/sysfs.h"

WTF?

Oh, that's a sure sign you are not doing something properly, if you
think it's ok to muck around with the internals of sysfs.

There's a reason that file is "private", why do you think it's ok to use
it directly?  Did you just think that I somehow "forgot" to put it in
the proper include directory?

Kids these days...

Surely one of the internal Intel code reviews caught this when you ran
it through that process?

I'm not even going to review the rest of this file, please fix that up
first, before sending it out again.  And, when you do so, please cc: me.

Oh, I couldn't help myself:

> +static void rapl_domain_kobj_release(struct kobject *kobj)
> +{
> +	struct rapl_domain *rd = kobj_to_rapl_domain(kobj);
> +
> +	complete(&rd->kobj_unregister);
> +}

No, that's not how you do a release function (hint, you can lock up your
driver from userspace by holding your file open...)  Free the memory
here, where it is supposed to be free.

And, one final complaint, never use "raw" kobjects, for loads of good
reasons, not the least being you just prevented userspace from seeing
what is happening with your devices.  Use the driver model, that's what
it is there for, if you need "sub children", or subdirectories.

greg k-h
