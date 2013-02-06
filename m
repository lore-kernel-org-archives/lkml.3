Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3BFNQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:16:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3BFNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:16:54 -0500
Date: Wed, 6 Feb 2013 11:16:45 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH 11/93] xen: Fix stack corruption in xen_failsafe_callback
 for 32bit PVOPS guests.
Message-ID: <20130206131644.GA2952@herton-Z68MA-D2H-B3>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
 <1360102042-10732-12-git-send-email-herton.krzesinski@canonical.com>
 <7CE799CC0E4DE04B88D5FDF226E18AC201058D458367@LONPMAILBOX01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC201058D458367@LONPMAILBOX01.citrite.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 10:18:54AM +0000, Frediano Ziglio wrote:
> At stated before I'm the author of this patch.
> 
> Please change the From: to
> 
> From: Frediano Ziglio <frediano.ziglio@citrix.com>
> 
> Frediano

I fixed this in my tree now. But note that the real problem is that this
got submitted, included and pushed in mainline with the wrong author, and
that's not going to be fixed, since would involve rebasing/rewriting the
history there. I just cherry-picked the commit as is from mainline
(Linus tree).

> 
> 
> On Tue, 2013-02-05 at 20:06 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andrew Cooper <andrew.cooper3@citrix.com>
> > 
> > commit 9174adbee4a9a49d0139f5d71969852b36720809 upstream.
> > 
> > This fixes CVE-2013-0190 / XSA-40
> > 
> > There has been an error on the xen_failsafe_callback path for failed
> > iret, which causes the stack pointer to be wrong when entering the
> > iret_exc error path.  This can result in the kernel crashing.
> > 
> > In the classic kernel case, the relevant code looked a little like:
> > 
> >         popl %eax      # Error code from hypervisor
> >         jz 5f
> >         addl $16,%esp
> >         jmp iret_exc   # Hypervisor said iret fault
> > 5:      addl $16,%esp
> >                        # Hypervisor said segment selector fault
> > 
> > Here, there are two identical addls on either option of a branch which
> > appears to have been optimised by hoisting it above the jz, and
> > converting it to an lea, which leaves the flags register unaffected.
> > 
> > In the PVOPS case, the code looks like:
> > 
> >         popl_cfi %eax         # Error from the hypervisor
> >         lea 16(%esp),%esp     # Add $16 before choosing fault path
> >         CFI_ADJUST_CFA_OFFSET -16
> >         jz 5f
> >         addl $16,%esp         # Incorrectly adjust %esp again
> >         jmp iret_exc
> > 
> > It is possible unprivileged userspace applications to cause this
> > behaviour, for example by loading an LDT code selector, then changing
> > the code selector to be not-present.  At this point, there is a race
> > condition where it is possible for the hypervisor to return back to
> > userspace from an interrupt, fault on its own iret, and inject a
> > failsafe_callback into the kernel.
> > 
> > This bug has been present since the introduction of Xen PVOPS support
> > in commit 5ead97c84 (xen: Core Xen implementation), in 2.6.23.
> > 
> > Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
> > Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> > ---
> >  arch/x86/kernel/entry_32.S |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 8f8e8ee..2a6919e 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -1065,7 +1065,6 @@ ENTRY(xen_failsafe_callback)
> >  	lea 16(%esp),%esp
> >  	CFI_ADJUST_CFA_OFFSET -16
> >  	jz 5f
> > -	addl $16,%esp
> >  	jmp iret_exc
> >  5:	pushl_cfi $-1 /* orig_ax = -1 => not a system call */
> >  	SAVE_ALL
> 

-- 
[]'s
Herton
