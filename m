Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaHMP4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:56:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34415 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:56:48 -0400
Date: Wed, 13 Aug 2014 08:56:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Message-ID: <20140813155644.GA6940@core.coreip.homeip.net>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812060108.GA13231@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920EAF@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812175435.GA22386@core.coreip.homeip.net>
 <EE124450C0AAF944A40DD71E61F878C9925D21@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9925D21@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 05:24:35AM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Dmitry Torokhov
> > Sent: Wednesday, August 13, 2014 1:55 AM
> > > > > To decouple the dependency between the hyperv-keyboard and i8042
> > > > > modules, I suppose we probably have to re-implement hyperv-
> > keyboard by
> > > > > using input_allocate_device(), input_register_device(), and using
> > > > > input_report_key() to pass the key strokes to the high level.
> > > >
> > > > Yes, that would be the best thing to do,
> > 
> > Why? The backend still delivers AT keyboard data, so why does it make
> > sense to write a new driver instead of making sure you can load
> > atkbd/libps2 even without i8042 loaded?
> 
> Hi Dmitry,
> Thanks for pointing this out!
> I didn't realize input_report_key() can't accept AT keyboard scan codes.
> 
> > > The issue is: the latest Arch Linux release doesn't have a working (virtual)
> > > keyboard when it runs as Generation 2 hyper-v guest -- when it runs as
> > > a "traditional" Generation 1 hyper-v guest, everything works fine.
> > > I hope this patch can temporarily help Arch users if they find the issue
> > > and if they can rebuild the kernel.
> > 
> > The Arch users can simply select to build i8042 into the kernel as a
> > workaround.
> I agree.
> 
> > The proper solution is to allow loading libps2 module even if i8042 did
> > not find its device. I wish I could simply drop this i8042_lock_chip and
> > stuff, but unfortunately i8042 ports are not truly independent. We need
> > to figure a way for libps2 to engage locking in i8042 if the driver is
> > loaded, otherwise just ignore it.
> > 
> > Dmitry
> Yeah, this seems the right solution.
> 
> How about this:
> in libps2.c let's add  and export a function pointer
> i8042_lock_chip_if_port_owner: it is used to replace the current 
> 	if (i8042_check_port_owner(ps2dev->serio))
> 		i8042_lock_chip();
> The function pointer has a default value NULL, and in i8042.c: i8042_init()
> we set the function pointer if an i8042 device is found?

Hmm, that would make i8042 depend on libps2, which might be OK, but how
do you deal with the locking here? I.e. what happens if you unload i8042
right when we go through this sequence?

Maybe we need to split i8042_lock_chip() and friends into a separate
module that always loads, even if i8042 is not present.

Thanks.

-- 
Dmitry
