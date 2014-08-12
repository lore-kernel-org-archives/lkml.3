Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaHLGBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:01:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaHLGBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:01:49 -0400
Date: Tue, 12 Aug 2014 14:01:08 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
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
Message-ID: <20140812060108.GA13231@kroah.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 05:51:28AM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Decoupling the dependency between hyperv_keyboard and i8042 needs
> > > non-trivial efforts and is hence a long term goal.
> > >
> > > For now, let's make the dependency explicit so people can beware of this.
> >
> > You didn't make anyone "aware" of this, you just prevented people from
> > being able to select the module unless they build the driver into the
> > kernel, which isn't very nice.
> 
> Yes, exactly.
> 
> > What exactly needs to be done to fix this "correctly" that is going to
> > take too much work at the moment?
> Hi Greg,
> The current implementation of hyperv-keyboard.c borrows
> serio_interrupt() to pass the key strokes to the high level component.
> serio_interrupt() actually depends on atkbd.c and i8042.c, so this doesn't
> work for a Generation 2 hyper-v guest because no i8042 keyboard controller
> is emulated: http://technet.microsoft.com/en-us/library/dn282285.aspx
> 
> To decouple the dependency between the hyperv-keyboard and i8042
> modules, I suppose we probably have to re-implement hyperv-keyboard by
> using input_allocate_device(), input_register_device(), and using
> input_report_key() to pass the key strokes to the high level.

Yes, that would be the best thing to do, and shouldn't be that hard to
create an input driver, it's pretty simple code, right?

> I'll have to need some time for further investigation and a new
> implementation. Before the new code is completely ready, IMHO the
> patch can help to avoid a bad user experience like Arch Linux working
> as a Generation 2 hyper-v guest.

You are still preventing Arch from working here, as the driver can't be
built at all, right?

> BTW, looks most of Linux distros (like RHEL, Ubuntu, SUSE) have
> CONFIG_SERIO_I8042=y, probably because it's the result of
> "make defconfig". So the patch actually doesn't affect these distros.

Or maybe it is beause they use older kernels and like to turn on every
single possible option :)

thanks,

greg k-h
