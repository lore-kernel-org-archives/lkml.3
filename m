Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3JJCXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:23:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33951 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab3JJCXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:23:50 -0400
Date: Thu, 10 Oct 2013 03:23:45 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
In-Reply-To: <20131008080625.GA25034@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
References: <20131006082340.GA24568@localhost> <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com> <20131007021118.GA27927@localhost> <20131007051038.GA9764@localhost> <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost> <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com> <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com> <20131008020918.GA1220@localhost> <20131008021452.GA6456@localhost>
 <20131008080625.GA25034@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think David Arlie also needs a quiet talking to about how to use the
> device model:
> 
> int drm_sysfs_device_add(struct drm_minor *minor)
> {
>         minor->kdev.release = drm_sysfs_device_release;
> ...
>         err = device_register(&minor->kdev);
> }
> 
> static void drm_sysfs_device_release(struct device *dev)
> {
>         memset(dev, 0, sizeof(struct device));
>         return;
> }
> 
> Since when has that been acceptable in a release function?

Well the commit that added it had a reason that seems to cover some other 
device model abuses, so maybe someone who actually understands the device 
model (all 2 people) can review usage.

Dave.

commit 77d26dc9b9805f322f5a1f6e559b18ad66205bd9
Author: Ma Ling <ling.ma@intel.com>
Date:   Thu Apr 16 17:51:25 2009 +0800

    drm: clean dirty memory after device release
    
    In current code we register/unregister connector object by
    drm_sysfs_connector_add/remove function.
    
    However under some cases, we need to dynamically register or 
unregister device
    multiple times, so we have to go through register -> unregister 
->register
    routine.
    
    Because after device_unregister function our memory is dirty, we need 
to do
    clean operation in order to re-register the device, otherwise the 
system
    will crash.  The patch intends to clean device after device release.
    
    Signed-off-by: Ma Ling <ling.ma@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>


