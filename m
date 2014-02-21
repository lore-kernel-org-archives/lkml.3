Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaBUCRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:17:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:55233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaBUCRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:17:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,516,1389772800"; 
   d="scan'208";a="459204306"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Russ Anderson <rja@sgi.com>, Matthew Garrett <matthew.garrett@nebula.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLnhtHHqrgNtJQkeFFZTg6j/LB5q+DjEAgAAGvYCAAAGPAIAAA6AAgAAAfgCAAAfaAIAAAu6AgAAHs4CAAAWJgIAABTyAgAAGxACAAA3MgIAAprZA
Date: Fri, 21 Feb 2014 02:17:12 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024B228C@SHSMSX101.ccr.corp.intel.com>
References: <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
 <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
 <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230>
 <20140220224529.GV17949@sgi.com> <1392937781.20109.24.camel@x230>
 <20140220235904.GZ17949@sgi.com>
In-Reply-To: <20140220235904.GZ17949@sgi.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for interrupting you.
I have some information that may be helpful for your discussion.
Please find them in the inlined replies.
Well, I don't want to join the fight, just for your informations. :-)

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Russ Anderson
> Sent: Friday, February 21, 2014 7:59 AM
> 
> On Thu, Feb 20, 2014 at 11:09:42PM +0000, Matthew Garrett wrote:
> > On Thu, 2014-02-20 at 16:45 -0600, Russ Anderson wrote:
> > > On Thu, Feb 20, 2014 at 10:26:45PM +0000, Matthew Garrett wrote:
> >
> > > > Because I'm trying to ensure that the default behaviour of the kernel is
> > > > to *work*. Defaulting to having IPMI be modular means that the default
> > > > behaviour of the kernel, as far as the ACPI spec goes, is to be broken.
> > >
> > > The ACPI spec requires IPMI functionality before a module loads at
> > > boot time?  And the kernel is *broken* if it does not support ACIP IPMI
> > > functionality before module load time?  Really?
> >
> > There's no mechanism to ensure that IPMI support will be loaded before
> > ACPI calls attempt to access IPMI operation regions. Really.
> 
> And no mechanism can be added to ensure that ACPI call are
> not attempted before IPMI is initialized?  A flag or lock
> or exported symbol indicating IPMI support is ready.

In fact there is a workaround solution I've posted here:
https://patchwork.kernel.org/patch/2831851/
The updated version of this patch can be found at:
https://bugzilla.kernel.org/attachment.cgi?id=112611
It is the acpi-ipmi13.patch file.

This solution may change the meaning of ACPI spec defined _REG.
So we may need a better solution.

But after merging this patch, it is safe to unload acpi_ipmi at users' wishes.
Without solutions to solve region handler uninstallation races, it is not safe to unload acpi_ipmi module.
You can see crashes in the description of this patch.

The ipmi_si module is using a different way to unload itself which has not been tested by me.
You can find it in Documentation/IPMI.txt by searching "hot and remove of interfaces" in this file.

> 
> > > > ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
> > > > that the kernel will spend a significant amount of time (potentially
> > > > until a user manually loads a driver) failing to implement part of the
> > > > IPMI specification. That's a problem, and the correct fix is to ensure
> > > > that the kernel always implements IPMI support.
> > >
> > > The ACPI spec says ipmi_si cannot be a driver?  Really?
> > > What is the real problem you are trying to solve?
> >
> > The most straightforward case is that of an ACPI power meter.
> 
> So it is just a matter of making sure ipmi_si modules loads before
> the ACPI power meter module loads, right?  module dependency issue.

I agree.
I think there should be relationship between ACPI region and Linux kernel modules.
In fact on the well-known operating system, _REG is always invoked at the end of the IRP_PNP_START_DEVICE completions.
But we may still be able to return -EPROBE_DEFER in the power meter driver when it detects failures caused by the readiness state of the region handlers.

I didn't work further on this issue when solving the reported bug:
https://bugzilla.kernel.org/show_bug.cgi?id=46741

> 
> >                                                                Several
> > vendors implement this with an IPMI operation region. Calling any of the
> > power meter functions will trigger access to that IPMI operation region,
> > which will fail. This may result in driver initialisation failing. There
> > is no express dependency between the power meter driver and ipmi_si,
> > because the spec envisages IPMI support as basic kernel functionality.
> > It's meant to be there before you start loading any other drivers.
> 
> The spec "envisages"?  I get there is a dependency, that IPMI driver
> needs to be loaded before ACIP power meter.  This isn't the first
> case of a driver being dependent on another driver.  That doesn't
> mean IPMI driver must be built into the kernel.
> 
> > > > Now, you've described some other problems. I don't disagree that those
> > > > are problems. The correct thing for us to do with those problems is to
> > > > fix them, not to simply change the kernel defaults such that it's
> > > > possible for users to choose between two differently broken states. I'm
> > > > absolutely willing to help, as long as you're willing to put some
> > > > reasonable amount of effort into describing them.
> > >
> > > How about ACPI IPMI functionality starts when the ipmi_si
> > > module loads at boot time.

Actually, I have a solution implemented this.
You can find it at:
https://bugzilla.kernel.org/attachment.cgi?id=112611
It is the acpi-ipmi14.patch file.

The patch will hand the maintenance-ship of acpi_ipmi to IPMI community.
I'm not sure it is proper to merge it by Linux upstreams.

Thanks and best regards
-Lv

> >
> > I've repeatedly asked for you to provide detailed descriptions of the
> > problems you've seen because I have a genuine interest in fixing them.
> > If you're just going to childishly refuse then this discussion is
> > pointless.
> 
> The distro cases I would point you at are marked private.
> And you do not have access to our internal support system.
> A simple google search for "kipmi0" shows a lot of reports of
> high cpu utilization.
> 
> And I'm old enough to appreciate being called childishly.  :-)
> 
> --
> Russ Anderson,  Kernel and Performance Software Team Manager
> SGI - Silicon Graphics Inc          rja@sgi.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
