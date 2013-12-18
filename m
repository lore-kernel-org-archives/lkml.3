Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3LRJ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:29:59 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64808 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:29:57 -0500
Date: Wed, 18 Dec 2013 10:29:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cirrusdrmfb broken with simplefb
Message-ID: <20131218092941.GA19210@gmail.com>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
 <CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Herrmann <dh.herrmann@gmail.com> wrote:

> Hi
> 
> On Wed, Dec 18, 2013 at 8:42 AM, Takashi Iwai <tiwai@suse.de> wrote:
> > Hi,
> >
> > with the recent enablement of simplefb on x86, cirrusdrmfb on QEMU/KVM
> > gets broken now, as reported at:
> >     https://bugzilla.novell.com/show_bug.cgi?id=855821
> >
> > The cirrus VGA resource is reserved at first as "BOOTFB" in
> > arch/x86/kernel/sysfb_simplefb.c, which is taken by simplefb platform
> > device.  This resource is, however, never released until the platform
> > device is destroyed, and the framebuffer switching doesn't trigger
> > it.  It calls fb's destroy callback, at most.  Then, cirrus driver
> > tries to assign the resource, fails and gives up, resulting in a
> > complete blank screen.
> >
> > The same problem should exist on other KMS drivers like mgag200 or
> > ast, not only cirrus.  Intel graphics doesn't hit this problem just
> > because the reserved iomem by BOOTFB isn't required by i915 driver.
> >
> > The patch below is a quick attempt to solve the issue.  It adds a new
> > API function for releasing resources of platform_device, and call it
> > in destroy op of simplefb.  But, forcibly releasing resources of a
> > parent device doesn't sound like a correct design.  We may take such
> > as a band aid, but definitely need a more fundamental fix.
> >
> > Any thoughts?
> 
> That bug always existed, simplefb is just the first driver to hit it 
> (vesafb/efifb didn't use resources). I'm aware of the issue but as a 
> workaround you can simply disable CONFIG_X86_SYSFB. That restores 
> the old behavior.

This looks like a regression, so we'll either need a fix or we'll have 
to mark CONFIG_X86_SYSFB as CONFIG_BROKEN.

> As a proper fix, I'd propose something like:
>   dev = platform_find_device("platform-framebuffer");
>   platform_remove_device(dev);
> 
> And we wrap this as:
>   sysfb_remove_framebuffers()
> in arch/x86/kernel/sysfb.c
> 
> This should cause a ->remove() event for the platform-driver and
> correctly release the resources. Comments?
> I will try to write a patch and send it later.

A fix would be awesome.

Thanks,

	Ingo
