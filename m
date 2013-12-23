Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3LWGnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:43:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab3LWGnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:43:41 -0500
Date: Mon, 23 Dec 2013 14:43:49 +0800
From: Dave Young <dyoung@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, sebastian.capella@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use initmpfs even if there's root= cmdline
Message-ID: <20131223064349.GB9279@dhcp-16-126.nay.redhat.com>
References: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com>
 <20131213023814.GA5519@dhcp-16-126.nay.redhat.com>
 <52B1E0A2.2030202@landley.net>
 <20131219023524.GB2070@darkstar.nay.redhat.com>
 <52B7C0CF.4030209@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B7C0CF.4030209@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't do anything about dracut. (Otherwise userspace could look at
> ROOT= which is not parsed by existing kernel code to have a special
> meaning...)

The root= requirement for dracut is not necessary just there's no one
is working on removing the limitation. I think that is not the key
problem here.

> 
> >>>Discussed with Vivek Goyal about the kdump use case, I missed one thing that
> >>>tmpfs has default size limit though we can tune it.
> >>>
> >>>So I will think more about it, will address this later, please ignore this
> >>>patch.
> >>
> >>I have a vague todo item of feeding rootflags= through to initmpfs,
> >>but that's really intended to specify flags for root=. There isn't
> >>really an existing command line option to specify initramfs flags
> >>because ramfs doesn't care.
> >>
> >>It was one of those "only parse rootflags= for initmpfs when there's
> >>no root=" vs "create a new rdrootflags= ala rdinit= even though
> >>that's a subtly wrong name these days..." and it went on the todo
> >>list because neither approach was obviously superior.
> >>
> >>Happy to take suggestions and whip up a patch if this is
> >>inconveniencing somebody. :)
> >
> >It would be great that initmpfs can use the whole memory on demand by default at
> >the same time we can avoid the deadlock mentioned about OOM handler.
> 
> Except that if initmpfs size=100% uses all the memory, we're back to
> "fill up the filesystem and the kernel deadlocks" same as initramfs.
> 
> Possibly I could tell it to go to 100% during extract and then
> remount to 50% afterwards? (The cpio archive filling up memory is
> pilot error. I wonder what happens if tmpfs is told to remount using
> less space than the filesystem currently has, does it fail or does
> it adjust the amount to what's currently used, or...?)

Tested that remounting to less space will success if there's enough free
space in the original mount. But I think it's hard to guess how much the
initrd will use while booting, it might need create other files dynamically. 

> 
> If necessary I could query the filesystem size after extract and
> remount to that amount or 50% (whichever is greater), but this is
> getting more complicated than seems strictly necessary? (If
> rootflags= got passed through we'd then want to only do this if they
> _didn't_ specify a size, or else have the "actual size or size= the
> user passed"...)
> 
> Implementing behavior is easy. Determing what the correct behavior
> should be is hard.
> 
> >For this purpose no need for extra flags? For other flags maybe "initmpfsflags="?
> 
> You can already say rootfstype=ramfs if you want to drop back to a
> filesystem that doesn't care about size checks. I could trivially
> make it so rootfstype=tmpfs overrides the root= check, but then
> there's that 50% memory limitation on the filesystem size. (Beyond
> which the disk cache reaping logic gets VERY UNHAPPY, by the way.
> The automatic load balancing stuff is... touchy. Better now than it
> used to be, but I still trust it about as far as I could comfortably
> spit out a rat. Then again I'm generally not using systems with half
> a terabyte of ram, which is what they all seem to be optimizing for
> these days...)

Yes, use rootfstype=ramfs is ok for dropping back to initramfs. But
rethinking about using tmpfs as default type, it might break current
users which using initramfs which does not have size limitation.
So I think for now keep the current logic is fine until we have a
better way to improve tmpfs.

> 
> Adding initrdflags= to specify a size= other than 50% makes sense,
> but you might have to modify your dracut thing to do a du on the
> filesystem before packaging it and feed in the correct number of
> kilobytes.

initrdflags looks more like for the original block device based initrd?
maybe tmpfs.default_size=?

> 
> If you want a different behavior than that, please explain what it
> should do in a little more detail?

I think I have given up the idea based on problems we have talked about..

Thanks
Dave
