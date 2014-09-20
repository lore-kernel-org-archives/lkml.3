Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbaITOnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:43:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaITOnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:43:46 -0400
Date: Sat, 20 Sep 2014 07:42:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4 PATCH 1/1] init: fix race between rootfs mount and firmware
 loading
Message-ID: <20140920144257.GD14094@kroah.com>
References: <20140918174127.GB340@redhat.com>
 <1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
 <20140919214257.GA27574@kroah.com>
 <CACZ9PQVEmzCSjaVX53ZoNw0MHCGeMVpXg63+URq8rYLXns6C0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQVEmzCSjaVX53ZoNw0MHCGeMVpXg63+URq8rYLXns6C0w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 10:18:39PM +0900, Roman Peniaev wrote:
> On Sat, Sep 20, 2014 at 6:42 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Fri, Sep 19, 2014 at 09:44:24PM +0900, Roman Pen wrote:
> >> The thing is that built-in modules are being inited before
> >> rootfs mount.  Some of the modules can request firmware loading
> >> from another thread using async 'request_firmware_nowait' call
> >> on inition, so we can catch this kind of race:
> >>    rootfs does not exist yet, but we are going to open and load
> >>    firmware file requesting it from the kernel thread.
> >>
> >> Solution is simple: before any rootfs access firmware loader
> >> must wait for rootfs mount.
> >
> > Even simpler solution, don't do that :)
> >
> > If your hardware needs firmware this early, and you don't put the
> > firmare into the initrd/initramfs, then it will just be loaded later on,
> > when the root filesystem is needed and the driver asks for it again
> > (your driver is failing "nicely" and allows the firmware to be loaded
> > later, right?  If not, that should be fixed...)
> >
> > Or, build the firmware into the kernel, I think we still have that
> > option for some drivers that really wanted/needed this.
> >
> > What has changed recently that requires this type of patch?  What is
> > wrong with the above solutions?
> 
> 
> I definitely agree with that "do not do that", I do agree.

Great, no need for a patch, we can move on now.  :)

> But, I did not find any other solution, because in my case this "to be loaded
> later" really matters. The source of the problem is the rtlwifi, which randomly
> delays the startup, it randomly warns me about "firmware loading failed" and
> repeats loading later. This later costs around one second. For my tiny arm
> setup it is important. And it happens because of this race.

What "costs one second"?  I don't understand, if the firmware isn't
there, are you timing out?  Fix the driver to do async firmware loading
and that timeout shouldn't be an issue.

> So, all I want to say with this patch is:
> 
> 1. 'mount / firmware loading' race exists, and it can cost time.

Switch the driver to do async firmware loading and you should be able to
fix this.

thanks,

greg k-h
