Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3GHM4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:56:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34386 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3GHM4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:56:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonas Heinrich <onny@project-insanity.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, len.brown@intel.com, pavel@ucw.cz,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Date: Mon, 08 Jul 2013 15:05:43 +0200
Message-ID: <3442698.l2vNEGx5aV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130708095042.GA20797@onny.Speedport_W_700V>
References: <20130218155439.GA902@onny> <201305031515.55595.jarkko.sakkinen@intel.com> <20130708095042.GA20797@onny.Speedport_W_700V>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 08, 2013 09:50:43 AM Jonas Heinrich wrote:
> On 05-03 15:15, Jarkko Sakkinen wrote:
> > Hi
> > 
> > On Friday, May 03, 2013 02:07:05 PM Jonas Heinrich wrote:
> > > On 05-03 01:29, Rafael J. Wysocki wrote:
> > > > On Thursday, May 02, 2013 08:32:30 PM Jonas Heinrich wrote:
> > > > > On 05-02 02:45, Rafael J. Wysocki wrote:
> > > > > > On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> > > > > > > On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > > > > > > > Well, you could give me instructions on how to debug this (I'll
> > > > > > > > do everything ;)) or I could ship you the Thinkpad T43. I guess
> > > > > > > > this would worth the effort since this bug is somehow critical.
> > > > > > > > 
> > > > > > > > Best regards, Jonas
> > > > > > > 
> > > > > > > I'll put together a debug patch unless I can trick Rafael into
> > > > > > > doing it first...
> > > > > > 
> > > > > > I'm afraid that code has changed quite a bit since I looked at it
> > > > > > last time. [Jarkko Sakkinen seems to have worked on it lately,
> > > > > > CCed.]
> > > > > > 
> > > > > > Jonas, I wonder what happens if you drop the first hunk of the patch
> > > > > > (it just uses a different register, which shouldn't matter)?  Does
> > > > > > it still help then?
> > > > > 
> > > > > Hello Rafel, first of all, thank you for helping me out :)
> > > > > You're right, the patch still solves the suspend bug, after removing
> > > > > the first hunk of the patch and applying it (see attachement:
> > > > > suspendfix_first_hunk_dropped.patch).
> > > > > 
> > > > > > If so, there are still a few things you can do to it, e.g:
> > > > > > (1) drop the
> > > > > > 
> > > > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
> > > > > > -       jnc     1f
> > > > > 
> > > > > Still works :) (used suspendfix_1.patch)
> > > > > 
> > > > > > lines,
> > > > > > (2) drop the
> > > > > > 
> > > > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
> > > > > > -       jnc     1f
> > > > > > 
> > > > > > lines,
> > > > > 
> > > > > Still works :) (used suspendfix_2.patch)
> > > > > 
> > > > > > (3) drop the
> > > > > > 
> > > > > > +       jecxz   1f
> > > > > 
> > > > > Still works :) (used suspendfix_3.patch)
> > > > > 
> > > > > > line,
> > > > > > (4) drop the
> > > > > > 
> > > > > > +       movl    %eax, %ecx
> > > > > > +       orl     %edx, %ecx
> > > > > > +       jz      1f
> > > > > 
> > > > > At this point, the bug reoccurs (used suspendfix_4.patch)!
> > > > > But that doesn't mean these lines are the only critical, because the
> > > > > more minimal patch
> > > > > 
> > > > > @@ -119,6 +119,9 @@
> > > > > 
> > > > >         jnc     1f
> > > > >         movl    pmode_efer, %eax
> > > > >         movl    pmode_efer + 4, %edx
> > > > > 
> > > > > +       movl    %eax, %ecx
> > > > > +       orl     %edx, %ecx
> > > > > +       jz      1f
> > > > > 
> > > > >         movl    $MSR_EFER, %ecx
> > > > >         wrmsr
> > > > >  
> > > > >  1:
> > > > > with removing this part
> > > > > 
> > > > > -       movl    pmode_cr4, %eax
> > > > > -       movl    %eax, %cr4
> > > > > +       movl    pmode_cr4, %ecx
> > > > > +       movl    %ecx, %cr4
> > > > > 
> > > > > also doesn't fix the issue (see suspendfix_5.patch).
> > > > > 
> > > > > > lines and see what the minimal patch needed for things to work again
> > > > > > is.
> > > > > 
> > > > > So the most minimal working patch is suspendfix_3.patch.
> > > > 
> > > > Thanks for doing that detective work!
> > > > 
> > > > The only explanation of why this particular patch can help that seems
> > > > viable to us at the moment is that we have a memory corruption in the
> > > > code region modified by it and the patch simply changes the alignment of
> > > > the instructions that don't get corrupted.
> > > > 
> > > > It looks like this may be verified by putting a bunch of nops into the
> > > > region in question, so can you please check if the attached patch helps
> > > > too?
> > > 
> > > Unfortunately, your attached patch doesn't seem to fix the bug.
> > > Hope you still have some ideas to address this issue :)
> > 
> > Kind of had to experiment with this since I don't have access to
> > T43. Did you already try:
> > 
> > - EFER handling only is reverted as it was before 73201dbe.
> > - CR4 handling only is reverted as it was before 73201dbe.
> Hi Jarkko,
> thank you for your response!
> Can you please be more specific about that instruction? I don't really
> know what to do, sorry :/
> 
> @Rafael: Bug still present in kernel 3.10 final :(

That's because no one knows how to fix it.  Actually, we don't even know
what the root cause of it is.  Sorry about that.

Are you still able to make things work again by reverting the commit you
bisected to?

Rafael


--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
