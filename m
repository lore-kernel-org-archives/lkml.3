Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3J3OWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:22:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3J3OWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:22:00 -0400
Date: Wed, 30 Oct 2013 07:23:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
Message-ID: <20131030142359.GA32196@kroah.com>
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
 <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
 <52700C24.9050001@linux.vnet.ibm.com>
 <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com>
 <52711121.9030606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52711121.9030606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:31:05PM +0530, Raghavendra K T wrote:
> On 10/30/2013 01:03 AM, Linus Torvalds wrote:
> > On Tue, Oct 29, 2013 at 12:27 PM, Raghavendra K T
> > <raghavendra.kt@linux.vnet.ibm.com> wrote:
> >>
> >> Could one solution be cascading actual error
> >> that is lost in fs/debugfs/inode.c:__create_file(), so that we could
> >> take correct action in case of failure of debugfs_create_dir()?
> >>
> >> (ugly side is we increase total number of params for __create_file to
> >> 6). or I hope there could be some better solution.
> >
> > The solution to this would be to simply return an error-pointer. See
> > <linux/err.h>. That's what we do for most complex subsystems that
> > return a pointer to a struct: rather than returning "NULL" as an
> > error, return the actual error number encoded in the pointer itself.
> 
> Thank you Linus. Yes, this would have been ideal.
> 
> >
> > But that would require every user of debugfs_create_dir() to be
> > updated to check errors using IS_ERR() instead of checking against
> > NULL, and there's quite a few of them.
> >
> > So I think just making the error be EEXIST is a simpler solution right now.
> >
> 
> Agree.
> I had below patch, and just before sending as formal mail I saw
> Paolo's pull request which already took care of it.
> ---8<---
> 
> 

> >From ac5d9f038c273f27bea7a54aab6af79b57f56317 Mon Sep 17 00:00:00 2001
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> Date: Wed, 30 Oct 2013 18:59:46 +0530
> Subject: [PATCH] Return EEXIST on debugfs_create_dir failure in kvm
> 
> As quoted by Linus,  EFAULT means "user passed in an invalid
> virtual address pointer", which is why the error string is Bad address.
> But when a debugfs directory creation fails, the above error is not valid.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  I understand that Tim's patch that renames directory to something like
>  kvm-pv would solve kvm-amd/kvm-intel modules insertion problem. 
>  This patch is to address error code  change complained by Linus.
> 
>  arch/x86/kernel/kvm.c | 2 +-
>  virt/kvm/kvm_main.c   | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a0e2a8a..e475fdb 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -622,7 +622,7 @@ static int __init kvm_spinlock_debugfs(void)
>  
>  	d_kvm = kvm_init_debugfs();
>  	if (d_kvm == NULL)
> -		return -ENOMEM;
> +		return -EEXIST;

Why even error out at all here?  You should never care about debugfs
file creation return values, so why pass any error back up the stack?

greg k-h
