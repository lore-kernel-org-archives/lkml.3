Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3EMNbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:31:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29992 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3EMNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:31:36 -0400
Date: Mon, 13 May 2013 09:31:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>, chuck.anderson@oracle.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: udev races with 'arch_register_cpu' to write 1 to
 /sys/devices/system/cpu/cpu1/online (which is not yet created)
Message-ID: <20130513133128.GJ6811@phenom.dumpdata.com>
References: <20120430161716.GA991@phenom.dumpdata.com>
 <1368203674-23993-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368203674-23993-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 06:34:34PM +0200, Igor Mammedov wrote:
> >On Mon, Apr 30, 2012 at 11:51:49AM -0400, Greg KH wrote:
> >> On Mon, Apr 30, 2012 at 11:50:18AM -0400, Greg KH wrote:
> >> > On Mon, Apr 30, 2012 at 11:36:23AM -0400, Konrad Rzeszutek Wilk wrote:
> >> > > Hey Greg,
> >> > > 
> >> > > Hoping you can help with some guidance on how to fix this.
> >> > > 
> >> > > The issue is with CPU hotplug is that when a CPU goes up
> >> > > it calls 'arch_register_cpu' which eventually calls
> >> > > register_cpu. That function does these two things:
> >> > > 
> >> > > 251         error = device_register(&cpu->dev);
> >> > > 252         if (!error && cpu->hotpluggable)
> >> > > 253                 register_cpu_control(cpu);
> >> > > 
> >> > > and the device_register creates a nice little SysFS directory:
> >> > > 
> >> > > /sys/devices/system/cpu/cpu2/ which at line 251 has the 'add' attribute
> >> > > but no 'online' attribute. udev then tries to echo 1 to the 'online'
> >> > > and it we get:
> >> > > udevd-work[2421]: error opening ATTR{/sys/devices/system/cpu/cpu2/online} for writing: No such file or directory
> >> > > 
> >> > > Line 253 creates said 'online' and at that time udev [or the system admin]
> >> > > can write 1 to 'online' and the CPU goes up.
> >> > > 
> >> > > So .. any thoughts? Is there some way to inhibit from uevent being sent
> >> > > until line 253 has run?
> >> > 
> >> > Yes.
> >> 
> >> Oh, I imagine you want to know _how_ to do it too, right?  (sorry, I
> >> couldn't resist...)
> >
> >Heh.
> >> 
> >> Make this a default attribute of the cpu device, and then it will be
> >> created by the driver core before the uevent is sent to userspace.
> >> That's what you are supposed to do in the first place, adding files "by
> >> hand" is wrong, for this very reason.
> >
> >OK, will prep up a patch shortly.
> 
> Hello Konrad,
> 
> Is there a posted/accepted patch or idea was dropped?

Hey Igor,

CC-ing here Chuck here who is looking at that. My recollection (and Chuck please
correct me if I am wrong) is that the idea Greg outlined won't work very well.
The reason is that making 'online' an attribute of 'struct dev' means that:
 1) A lot of SysFS attributes that have no notion of online/offline (say ISA bus)
    will now have.
 2) The default action item (so function) to do something based on writting/reading
    from 'online' will have to be overridden by the driver using it. Which means
    another race - we can create an SysFS attribute but the default points to something
    that does nothing.

Chuck, does that sound right?
> 
> 
