Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3FAEVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:21:12 -0400
Received: from relay3.sgi.com ([192.48.152.1]:39937 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750759Ab3FAEVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:21:03 -0400
Date: Fri, 31 May 2013 23:20:59 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130601042058.GB15199@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org> <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com> <20130531144826.GB5850@srcf.ucam.org> <20130531154348.GA17145@sgi.com> <20130531162815.GA8082@srcf.ucam.org> <20130531225730.GB14752@sgi.com> <20130601000311.GA15126@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601000311.GA15126@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 01:03:11AM +0100, Matthew Garrett wrote:
> On Fri, May 31, 2013 at 05:57:31PM -0500, Russ Anderson wrote:
> > On Fri, May 31, 2013 at 05:28:16PM +0100, Matthew Garrett wrote:
> > >                                           If nvram becaomes full, some 
> > > systems crash during firmware initialisation. So we can't let nvram 
> > > become full. The obvious thing to do here is to look at the values from 
> > > QueryVariableInfo, but many systems won't perform any garbage collection 
> > > until they're almost out of space and so variables that have been 
> > > deleted still show up as used space.
> > 
> > OK.  I get nvram looks full due to lack of garbage collection
> > on some systems.  Does QueryVariableInfo (at runtime) tell you
> > it is full?  Is the problem that it says it is full when it
> > is not, or does not tell you it is full when it is?
> 
> QueryVariableInfo reports the amount used *including garbage*. This 
> makes it useless for determining how much space is available for the 
> firmware to use.

So when QueryVariableInfo reports there is space available, the
write works and everything is fine.

And when QueryVariableInfo reports insufficient space, don't write
and everything is fine.

But when QueryVariableInfo reports insufficient space and you
write anyway, the system can get bricked.  Is that the problem?



According to the UEFI spec for QueryVariableInfo()

  RemainingVariableStorageSize
                      Returns the remaining size of the storage
                      space available for EFI variables associated
                      with the attributes specified.

It also says:

   The returned MaximumVariableStorageSize, RemainingVariableStorageSize,
   MaximumVariableSize information may change immediately after
   the call based on other runtime activities including asynchronous
   error events. Also, these values associated with different
   attributes are not additive in nature.

Note that "other runtime activities including asynchronous error
events."  That means runtime services may be using nvram without
the OS knowing about it.


Some bios implementation may be "*including garbage*", but can
you definitively say ALL do?  The spec explicitly says "the
implementation of variable storage is not defined in this
specification".  You can't assume any form of garbage collection.

   7.2 Variable Services

   Although the implementation of variable storage is not defined
   in this specification, variables must be persistent in most cases.
   This implies that the EFI implementation on a platform must arrange
   it so that variables passed in for storage are retained and
   available for use each time the system boots, at least until they
   are explicitly deleted or overwritten. Provision of this type of
   nonvolatile storage may be very limited on some platforms, so
   variables should be used sparingly in cases where other means of
   communicating information cannot be used.

I don't see anything in here about the OS being free to use
more nvram than QueryVariableInfo() reported as being available.
What happened to following the spec?


> > >                                       We can work around that by adding 
> > > up the size of the variables ourselves, but that only gives us the value 
> > > for runtime-visible variables. We also need to know how much space is 
> > > used by variables that are only visible during boot,
> > 
> > Is it valid to assume that only the kernel writes to nvram at
> > runtime?  Can bios log error information to nvram on an SMM
> > interrupt (for example)?
> 
> There's a limited number of situations where the firmware can write to 
> nvram, but they're basically uninteresting. Practically speaking, it's 
> always via the kernel once ExitBootServices() has been called.

How can you say "they're basically uninteresting"???
Do you know what EVERY bios implementation does???


> > >                                                      hence calling 
> > > QueryVariableInfo before ExitBootServices.
> > 
> > Correct me if I am wrong, but that is called from EFI stubs,
> > which is only used by some bootloaders (sometimes grub2).
> > Does that mean EFI/grub and EFI/elilo will not hit the problem,
> > or will not have your fix?
> 
> Will not have the fix. Boot EFI systems via the EFI stub.

Thanks for that clarification.

> Boot EFI systems via the EFI stub.

Fortunately all our shipping systems are EFI/grub and EFI/elilo
right now, so they boot.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
