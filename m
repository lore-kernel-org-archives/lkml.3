Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab3LDTfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:35:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab3LDTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:35:00 -0500
Date: Wed, 4 Dec 2013 14:34:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131204193430.GF19087@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <8761rl73s7.fsf@xmission.com>
 <20131122015518.GA31921@redhat.com>
 <87txf4y304.fsf@xmission.com>
 <20131122141945.GE4046@redhat.com>
 <87li0fvm10.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li0fvm10.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 07:23:39PM -0800, Eric W. Biederman wrote:
> 
> > [..]
> >> >> There is also a huge missing piece of this in that your purgatory is not
> >> >> checking a hash of the loaded image before jumping too it.  Without that
> >> >> this is a huge regression at least for the kexec on panic case.  We
> >> >> absolutely need to check that the kernel sitting around in memory has
> >> >> not been corrupted before we let it run very far.
> >> >
> >> > Agreed. This should not be hard. It is just a matter of calcualting
> >> > digest of segments. I will store it in kimge and verify digest again
> >> > before passing control to control page. Will fix it in next version.
> >> 
> >> Nak.  The verification needs to happen in purgatory. 
> >> 
> >> The verification needs to happen in code whose runtime environment is
> >> does not depend on random parts of the kernel.  Anything else is a
> >> regression in maintainability and reliability.
> >> 
> >> It is the wrong direction to add any code to what needs to run in the
> >> known broken environment of the kernel when a panic happens.
> >> 
> >> Which means that you almost certainly need to go to the trouble of
> >> supporting the complexity needed to support purgatory code written in C.
> >> 
> >> (For those just tuning in purgatory is our term for the code that runs
> >> between the kernels to do those things that can not happen a priori).
> >
> > In general, I agree with not using kernel parts after crash.
> >
> > But what protects against that purgatory itself has been scribbled over.
> > IOW, how different purgatory memory is as compared to kernel memory where
> > digest routines are stored. They have got equal probably of being scribbled
> > over and if that's the case one is not better than other?
> >
> > And if they both got equal probability to getting corrupted, then there does
> > not seem to be an advantage in moving digest verification inside
> > purgatory.
> 
> The primary reason is that maintenance of code in the kernel that is
> safe during a crash dump is hard.  That is why we boot a second kernel
> after all.  If the code to do the signature verification resides in
> machine_kexec on the kexec on panic code path in the kernel that has
> called panic it is almost a given that at some point or other someone
> will add an option that will add a weird dependency that makes the code
> unsafe when the kernel is crashing.  I have seen it happen several times
> on the existing kexec on panic code path.  I have seen it on other code
> paths like netconsole.  Which can currently on some kernels I have
> running cause the kernel go go into an endless printk loop if you call
> printk from interrupt context.  So what we really gain by moving the
> verification into purgatory is protection from inappropriate code reuse.
> 
> So having a completely separate piece of code may be a little harder to
> write initially but the code is much simpler and more reliable to
> maintain.  Essentially requiring no maintenance effort.  Further getting
> to the point where purgatory is written in C makes small changes much
> more approachable.

Hi Eric,

So you want a separate purgatory code and that purgatory should be self
contained and should not share any code with rest of the kernel. No
inclusion of header files, no linking against kernel libraries? That means
even re-implementing sha256 functions separately (like user space)?

If code maintenance is a concern, then I think I can reimplement some
of the functions to calculate sha256 in separate crash files and invoke
those to reduce code sharing with rest of the kernel. And we should be
able to link against the kernel and not have to create separate
relocatable purgatory object and relocate it.

IOW, does purgatory still have to be a relocatable object? I think
user space had no choice but given the fact that we are implementing
thing in kernel, I should be able to implement my own hash calculation
and segment verification code and link it to existing kernel and invoke
these outside purgatory. Anyway, we call so many other functions after
crash to stop cpus, save registers, etc.

Thanks
Vivek
