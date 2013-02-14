Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021Ab3BNV4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:56:52 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38009 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934964Ab3BNV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:56:50 -0500
Message-ID: <1360878870.3524.726.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 16:54:30 -0500
In-Reply-To: <20130214205720.GH16671@redhat.com>
References: <1360760195.3524.355.camel@falcor1.watson.ibm.com>
	 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
	 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
	 <20130213165922.GD6750@redhat.com>
	 <1360846636.3524.589.camel@falcor1.watson.ibm.com>
	 <20130214152339.GB16671@redhat.com>
	 <1360856159.3524.619.camel@falcor1.watson.ibm.com>
	 <20130214161719.GC16671@redhat.com>
	 <1360871356.3524.667.camel@falcor1.watson.ibm.com>
	 <20130214205445.GG16671@redhat.com> <20130214205720.GH16671@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021421-2398-0000-0000-00001112A5A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 15:57 -0500, Vivek Goyal wrote:
> On Thu, Feb 14, 2013 at 03:54:45PM -0500, Vivek Goyal wrote:
> > On Thu, Feb 14, 2013 at 02:49:16PM -0500, Mimi Zohar wrote:
> > 
> > [..]
> > > > > I think you're making this more complicated than it needs to be.  Allow
> > > > > the execution unless the file failed signature verification.  The
> > > > > additional capability is given only if the signature verification
> > > > > succeeds.
> > > > 
> > > > I am just trying to bring it inline with module signature verification.
> > > > There also module loading fails if signatures are present but kernel
> > > > can't verify it.
> > > 
> > > A specific hook is defined for kernel module signature verification,
> > > which is enabled/disabled in Kconfig.  When enabled, only signed modules
> > > are loaded.  The kernel module hook does not verify the integrity of the
> > > userspace application (eg. insmod, modprobe), but of the kernel module
> > > being loaded.
> > > 
> > > Your original patches verified the integrity of the userspace
> > > application kexec, not the image being loaded.  ima_bprm_check()
> > > verifies the integrity of executables.  To permit both signed and
> > > unsigned files to execute, we defined the 'optional' IMA policy flag,
> > > with the intention of giving more capability to signed executables.
> > > 
> > > Unless we define a kexec specific hook for verifying kernel images, it's
> > > not the same.
> > 
> > I think we are talking of two different things here.
> > 
> > I am referring to kernel module signing where signatures are appended
> > to module (not IMA hook).
> > 
> > Also I am just referring to behavior about what happens if some error
> > happens while signature verification.
> > 
> > - If signature verification fails, it is clear what to do.
> > - If signature verification passes, it is clear what to do.
> > - Grey area is, what happens if some error is encountered during signature
> >   verification. Should the module loading be allowed/disallowed. Looking
> >   at the module loading code, once it is determined that module has
> >   signature appended to it, module loading fails if some error occurs
> >   during signature verification.

There better not be any gray area, if CONFIG_MODULE_SIG_FORCE is
enabled, only validly signed modules should be loaded.

> > So I am just referring to that fact and trying to draw parallels between
> > error handling during module signature verification and error handling
> > when file appraisal happens in IMA. 

> > There can be two options.
> > 
> > - Disallow execution only if signature verification fails. If some error
> >   happens during verification, ignore it, let the executable continue.
> >   Just that it does not get extra capability.
> > 
> > - Disallow execution only if executable is not signed or it has valid
> >   signature. If executable is signed and some error happens during the
> >   process of verifying signature, execution is denied.
> > 
> 
> Little typo in second option. I meant "Allow execution only if executable
> is not signed or it has valid signatures".

Executables will be run with or without a valid signature.  The only
fair comparison would be between loading the kernel module and setting a
capability.  Both are only done based on a valid signature.  Of the two
options, I would choose the second.

Mimi


