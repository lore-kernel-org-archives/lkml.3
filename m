Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbaGXTan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:30:43 -0400
Received: from mail.orcon.net.nz ([219.88.242.56]:55215 "EHLO
	mail.orcon.net.nz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933705AbaGXTam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:30:42 -0400
Date: Fri, 25 Jul 2014 07:30:25 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug: retry of clone() on Alpha can result in zeroed process
 thread pointer
Message-ID: <20140724193025.GA2540@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140723085244.GB4799@omega>
 <53D14E48.3040202@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D14E48.3040202@twiddle.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Bayes-Prob: 0.0001 (Score 0: No Bayes scoring rules defined, tokens from: outbound)
X-Spam-Score: -1.63 () [Hold at 3.00] FREEMAIL_FROM:0.001,FSL_HELO_NON_FQDN_1:0.001,HELO_NO_DOMAIN:0.001,PIPE_OBFUSCATION:1,RDNS_DYNAMIC:0.363,CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:outbound
X-Canit-Stats-ID: 01MujuvAt - 225f43fa560d - 20140725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:19:52AM -1000, Richard Henderson wrote:
> On 07/22/2014 10:52 PM, Michael Cree wrote:
> > Running strace on nptl/tst-eintr3 reveals that the clone() syscall
> > is retried by the kernel if an ERESTARTNOINTR error occurs.  At
> > $syscall_error in arch/alpha/kernel/entry.S the kernel handles the
> > error and in doing that it writes to 72(sp) which is where the value
> > of the a3 CPU register on entry to the kernel is stored.  Then the
> > kernel retries the clone() function.  But the alpha specific code
> > for copy_thread() in arch/alpha/kernel/process.c does not use the
> > passed a3 cpu register (the argument tls), instead it goes to the
> > saved stack to get the value of the a3 register, which on the
> > second call to clone() has been modified to no longer be the value
> > of the a3 cpu register on entry to the kernel.  And a latent bomb
> > is laid for userspace in the form of an incorrect process unique
> > value (which is the thread pointer) in the PCB.
> > 
> > Am I correct in my analysis and, if so, can we get a fix for this
> > please.
> 
> Well...  let me start with the assumption that we can't possibly restart unless
> the syscall fails with -ERESTART*.
> 
> Before we clobber 72($sp), $syscall_error saves the old value in $19.  This is
> the r19 parameter to do_work_pending, and is passed all the way down to
> syscall_restart where we do restore the original value of a3 for ERESTARTNOINTR.
> 
> So if there's a path that leads to restart, but doesn't save a3 before
> clobbering, I don't see it.  Do you have an strace dump that shows this?

Yes.  This is an example of a run of nptl/tst-eintr3 that fails after
cutting off quite a bit of stuff at the start to get to the relevant
section:

clone(child_stack=0x2000121eae0, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID, parent_tidptr=0x2000121f2c0, tls=0x2000121f8e0, child_tidptr=0x2000121f2c0) = ? ERESTARTNOINTR (To be restarted)
--- SIGUSR1 {si_signo=SIGUSR1, si_code=SI_TKILL, si_pid=20086, si_uid=1000} ---
write(1, ".", 1.)                        = 1
sigreturn() (mask [])                   = -1 ERRNO_312 (Unknown error 312)
clone(child_stack=0x2000121eae0, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID, parent_tidptr=0x2000121f2c0, tls=0, child_tidptr=0x2000121f2c0) = 20089
+++ killed by SIGSEGV +++


Note that the retry of clone() has zero for the tls argument.

Examining the resultant core dump reveals that tst-eintr3 segfaulted
when trying to access a thread local variable and that register v0,
used in calculating the TLS location and set up by the rduniq PALcall,
is zero.

Cheers
Michael.

