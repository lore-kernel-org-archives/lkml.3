Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaIWF61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:58:27 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62026 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaIWF6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:58:07 -0400
Date: Tue, 23 Sep 2014 07:58:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140923055802.GA29052@gmail.com>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923053711.GA28704@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Fri, Sep 19, 2014 at 3:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > > >
> > > > Please pull the latest x86-urgent-for-linus git tree from:
> > > 
> > > I only just noticed, but this pull request causes my Sony Vaio 
> > > laptop to immediately reboot at startup.
> > > 
> > > I'm assuming it's one of the efi changes, but I'm bisecting now 
> > > to say exactly where it happens. It will get reverted.
> > 
> > I've Cc:-ed Matt.
> > 
> > My guess would be one of these two EFI commits:
> > 
> >       * Fix early boot regression affecting x86 EFI boot stub when loading
> >         initrds above 4GB - Yinghai Lu
> >     
> > 47226ad4f4cf x86/efi: Only load initrd above 4g on second try
> > 
> >       * Relocate GOT entries in the x86 EFI boot stub now that we have
> >         symbols with global visibility - Matt Fleming
> > 
> > 9cb0e394234d x86/efi: Fixup GOT in all boot code paths
> > 
> > If it's 9cb0e394234d - then it's perhaps a build quirk, or a bug 
> > in the assembly code. If so then we'd have to revert this, and 
> > reintroduce another regression, caused by EFI commit 
> > f23cf8bd5c1f49 in this merge window. The most recent commit is 
> > easy to revert, the older one not.
> > 
> > If it's 47226ad4f4cf then we'd reintroduce the regression caused 
> > by 4bf7111f501 in the previous merge window. They both revert 
> > cleanly after each other - but it might be safer to just revert 
> > the most recent one.
> >
> > My guess is that your regression is caused by 47226ad4f4cf.
> 
> Wrong sha1: my guess is on 9cb0e394234d, the GOT fixup.

So if it's the GOT fixup then I feel the safest option is to 
revert 9cb0e394234d straight away, and then to do a functional 
revert of f23cf8bd5c1f49 as a separate step, perhaps via 
something really crude like:

   #include "../..../drivers/firmware/efi/libstub/efi-stub-helper.c"

or so. (Maybe someone else can think of something 
cleaner/simpler, because this method is really ugly, as we'd have 
to #include the whole libstub library into eboot.c AFAICS...)

Thanks,

	Ingo
