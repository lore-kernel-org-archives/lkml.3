Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3EaD3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:29:33 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:57032 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EaD31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:29:27 -0400
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
From: joeyli <jlee@suse.com>
To: Russ Anderson <rja@sgi.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <20130531021749.GA24287@sgi.com>
References: <20130524074331.GL14575@console-pimps.org>
	 <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	 <1369880172.17397.11.camel@linux-s257.site>
	 <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230>
	 <20130530222836.GB11105@sgi.com>
	 <alpine.LNX.2.00.1305310029560.30576@pobox.suse.cz>
	 <20130531021749.GA24287@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 May 2013 11:28:45 +0800
Message-ID: <1369970925.17397.80.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-05-30 於 21:17 -0500，Russ Anderson 提到：
> On Fri, May 31, 2013 at 12:30:43AM +0200, Jiri Kosina wrote:
> > On Thu, 30 May 2013, Russ Anderson wrote:
> > 
> > > > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > > > call from bootime to runtime, in efi_late_init().  The attached
> > > > > patch is consistent with the UEFI spec and avoids the problem.
> > > > 
> > > > No, that defeats the entire point of the original patch.
> > > 
> > > How so?  It is still calling QueryVariableInfo()
> > > before the data is used.
> > 
> > You lose information provided by QueryVariableInfo() about boot-only 
> > variables once the transition boot -> runtime has happened.
> 
> Is that information really more important than the ability
> to boot?
> 
> Correct me if I'm wrong, but linux was able to boot without
> the boottime QueryVariableInfo() call up until 3.9-rc7,
> and it still does on systems that do not use EFI stubs (ie
> grub and elilo).  It is only when linux uses EFI stubs (ie
> grub2) that linux makes the boottime QueryVariableInfo()
> call.  So why is that call, or whatever is dependent on it,
> more important than booting?
> 
> 
> 
> Thanks,

It related to BIOS's garbage collection behavior of UEFI variable
storage.

The used space of non volatile boottime variables is useful to us for
calculate the active_size, please reference 31ff2f2 patch:

https://lkml.org/lkml/2013/4/15/476

An earlier 68d9298 patch to avoid some machines bricked when more than
50% of the system flash is in use, because the garbage collection will
not trigger on those machines.

We need find out the size of system flash space indeed usage for avoid
this problem. So, cc5a080c5 patch call QueryVariableInfo() to grab the
usage information in boot time.

Calling QueryVariableInfo() at boot time should not causes side effect
until your issue show up. Before this issue happen, avoid bricking some
machines is also important.


Thanks a lot!
Joey Lee

