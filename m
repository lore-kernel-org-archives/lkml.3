Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab3DCARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:17:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:61769 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab3DCARR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,396,1363158000"; 
   d="scan'208";a="222116990"
Date: Tue, 2 Apr 2013 17:17:14 -0700
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
Message-ID: <20130402171714.7309cdf2@chromoly>
In-Reply-To: <20130402234805.GA11880@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20130402230042.GA8713@kroah.com>
	<20130402163357.72dac902@chromoly>
	<20130402234805.GA11880@kroah.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013 16:48:05 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Apr 02, 2013 at 04:33:57PM -0700, Jacob Pan wrote:
> > On Tue, 2 Apr 2013 16:00:42 -0700
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > > +#include "intel_rapl.h"
> > > > +#include "../../../fs/sysfs/sysfs.h"  
> > > 
> > > WTF?
> > > 
> > > Oh, that's a sure sign you are not doing something properly, if
> > > you think it's ok to muck around with the internals of sysfs.
> > > 
> > > There's a reason that file is "private", why do you think it's ok
> > > to use it directly?  Did you just think that I somehow "forgot"
> > > to put it in the proper include directory?
> > I did feel unsure about this but i saw some precedence in the
> > kernel.
> 
> Someone else is doing this with the sysfs api?  I don't see any other
> code in Linus's tree doing this at the moment, where did you see this?
> Let me know and I'll fix it up right away.
> 
no, i did not mean sysfs api. I mean include internal header files via
#include ../../ 
e.g.in drivers/usb/image/microtek.c

#include "../../scsi/scsi.h"
#include <scsi/scsi_host.h>

> > Anyway, I needed a way to validate a userspace file passed to rapl
> > driver belong to the same sysfs directory. I will look for
> > alternative ways.
> 
> What do you mean by this?  What exactly are you trying to do?  No
> normal driver code should _ever_ call sysfs functions directly, nor
> should they ever care about sysfs internals.
> 
i did not call sysfs internal calls, just need to use 
struct sysfs_dirent {}

to do the following sanity check against user passed event control file,
it is still not a 100% strong check. 
	/* check if the cfile belongs to the same rapl domain */
	if (strcmp(rd->kobj.sd->s_name,
			cfile->f_dentry->d_parent->d_name.name)) {
		pr_debug("cfile does not belong to domain %s\n",
			rd->kobj.sd->s_name);
		ret = -EINVAL;
		goto exit_cleanup_fds;
	}

> And, odds are, you didn't test your code as a module, right, as any
> internal sysfs function that you could get from this .h file, wouldn't
> be exported for a module to use, unless I missed one somewhere?
> 
I did run the driver as module since i didn't use sysfs internal
functions, just the struct. I may be hitting a corner case here, but
for drivers who need to discover sysfs hierarchy would it be useful to
expose some info in struct sysfs_dirent{}?

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
