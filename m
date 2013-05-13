Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3EMOb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:31:58 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37178 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3EMOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:31:57 -0400
Date: Mon, 13 May 2013 07:25:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>, chuck.anderson@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: udev races with 'arch_register_cpu' to write 1 to
 /sys/devices/system/cpu/cpu1/online (which is not yet created)
Message-ID: <20130513142532.GA15808@kroah.com>
References: <20120430161716.GA991@phenom.dumpdata.com>
 <1368203674-23993-1-git-send-email-imammedo@redhat.com>
 <20130513133128.GJ6811@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513133128.GJ6811@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 09:31:28AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, May 10, 2013 at 06:34:34PM +0200, Igor Mammedov wrote:
> > >On Mon, Apr 30, 2012 at 11:51:49AM -0400, Greg KH wrote:
> > >> On Mon, Apr 30, 2012 at 11:50:18AM -0400, Greg KH wrote:
> > >> > On Mon, Apr 30, 2012 at 11:36:23AM -0400, Konrad Rzeszutek Wilk wrote:
> > >> > > Hey Greg,
> > >> > > 
> > >> > > Hoping you can help with some guidance on how to fix this.
> > >> > > 
> > >> > > The issue is with CPU hotplug is that when a CPU goes up
> > >> > > it calls 'arch_register_cpu' which eventually calls
> > >> > > register_cpu. That function does these two things:
> > >> > > 
> > >> > > 251         error = device_register(&cpu->dev);
> > >> > > 252         if (!error && cpu->hotpluggable)
> > >> > > 253                 register_cpu_control(cpu);
> > >> > > 
> > >> > > and the device_register creates a nice little SysFS directory:
> > >> > > 
> > >> > > /sys/devices/system/cpu/cpu2/ which at line 251 has the 'add' attribute
> > >> > > but no 'online' attribute. udev then tries to echo 1 to the 'online'
> > >> > > and it we get:
> > >> > > udevd-work[2421]: error opening ATTR{/sys/devices/system/cpu/cpu2/online} for writing: No such file or directory
> > >> > > 
> > >> > > Line 253 creates said 'online' and at that time udev [or the system admin]
> > >> > > can write 1 to 'online' and the CPU goes up.
> > >> > > 
> > >> > > So .. any thoughts? Is there some way to inhibit from uevent being sent
> > >> > > until line 253 has run?
> > >> > 
> > >> > Yes.
> > >> 
> > >> Oh, I imagine you want to know _how_ to do it too, right?  (sorry, I
> > >> couldn't resist...)
> > >
> > >Heh.
> > >> 
> > >> Make this a default attribute of the cpu device, and then it will be
> > >> created by the driver core before the uevent is sent to userspace.
> > >> That's what you are supposed to do in the first place, adding files "by
> > >> hand" is wrong, for this very reason.
> > >
> > >OK, will prep up a patch shortly.
> > 
> > Hello Konrad,
> > 
> > Is there a posted/accepted patch or idea was dropped?
> 
> Hey Igor,
> 
> CC-ing here Chuck here who is looking at that. My recollection (and Chuck please
> correct me if I am wrong) is that the idea Greg outlined won't work very well.
> The reason is that making 'online' an attribute of 'struct dev' means that:
>  1) A lot of SysFS attributes that have no notion of online/offline (say ISA bus)
>     will now have.

Then only create that attribute for busses that ask for it to be enabled.

>  2) The default action item (so function) to do something based on
>  writting/reading from 'online' will have to be overridden by the
>  driver using it. Which means another race - we can create an SysFS
>  attribute but the default points to something that does nothing.

I don't understand this at all, how will there be a race exactly?

greg k-h
