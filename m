Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737Ab3E1V1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:27:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53598 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934555Ab3E1V1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:27:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonas Heinrich <onny@project-insanity.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, len.brown@intel.com, pavel@ucw.cz,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Date: Tue, 28 May 2013 23:36:37 +0200
Message-ID: <2675025.1aYjLKmY02@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1536388.1prjkW6Efo@vostro.rjw.lan>
References: <20130218155439.GA902@onny> <20130503110705.GA3828@onny.Speedport_W_700V> <1536388.1prjkW6Efo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 01:37:45 PM Rafael J. Wysocki wrote:
> On Friday, May 03, 2013 11:07:05 AM Jonas Heinrich wrote:
> > On 05-03 01:29, Rafael J. Wysocki wrote:
> > > On Thursday, May 02, 2013 08:32:30 PM Jonas Heinrich wrote:
> > > > On 05-02 02:45, Rafael J. Wysocki wrote:
> > > > > On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> > > > > > On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > > > > > > Well, you could give me instructions on how to debug this (I'll do 
> > > > > > > everything ;)) or I could ship you the Thinkpad T43. I guess this
> > > > > > > would worth the effort since this bug is somehow critical.
> > > > > > > 
> > > > > > > Best regards, Jonas
> > > > > > 
> > > > > > I'll put together a debug patch unless I can trick Rafael into doing
> > > > > > it first...
> > > > > 
> > > > > I'm afraid that code has changed quite a bit since I looked at it last time.
> > > > > [Jarkko Sakkinen seems to have worked on it lately, CCed.]
> > > > > 
> > > > > Jonas, I wonder what happens if you drop the first hunk of the patch (it just
> > > > > uses a different register, which shouldn't matter)?  Does it still help then?
> > > > 
> > > > Hello Rafel, first of all, thank you for helping me out :)
> > > > You're right, the patch still solves the suspend bug, after removing the first 
> > > > hunk of the patch and applying it (see attachement:
> > > > suspendfix_first_hunk_dropped.patch).
> > > > 
> > > > > 
> > > > > If so, there are still a few things you can do to it, e.g:
> > > > > (1) drop the
> > > > > 
> > > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
> > > > > -       jnc     1f
> > > > > 
> > > > 
> > > > Still works :) (used suspendfix_1.patch)
> > > > 
> > > > > lines,
> > > > > (2) drop the
> > > > > 
> > > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
> > > > > -       jnc     1f
> > > > > 
> > > > > lines,
> > > > 
> > > > Still works :) (used suspendfix_2.patch)
> > > > 
> > > > > (3) drop the
> > > > > 
> > > > > +       jecxz   1f
> > > > > 
> > > > 
> > > > Still works :) (used suspendfix_3.patch)
> > > > 
> > > > > line,
> > > > > (4) drop the
> > > > > 
> > > > > +       movl    %eax, %ecx
> > > > > +       orl     %edx, %ecx
> > > > > +       jz      1f
> > > > > 
> > > > 
> > > > At this point, the bug reoccurs (used suspendfix_4.patch)! 
> > > > But that doesn't mean these lines are the only critical, because the more
> > > > minimal patch
> > > > 
> > > > @@ -119,6 +119,9 @@
> > > >         jnc     1f
> > > >         movl    pmode_efer, %eax
> > > >         movl    pmode_efer + 4, %edx
> > > > +       movl    %eax, %ecx
> > > > +       orl     %edx, %ecx
> > > > +       jz      1f
> > > >         movl    $MSR_EFER, %ecx
> > > >         wrmsr
> > > >  1:
> > > > 
> > > > 
> > > > with removing this part
> > > > 
> > > > -       movl    pmode_cr4, %eax
> > > > -       movl    %eax, %cr4
> > > > +       movl    pmode_cr4, %ecx
> > > > +       movl    %ecx, %cr4
> > > > 
> > > > also doesn't fix the issue (see suspendfix_5.patch).
> > > > 
> > > > > lines and see what the minimal patch needed for things to work again is.
> > > > > 
> > > > 
> > > > So the most minimal working patch is suspendfix_3.patch.
> > > 
> > > Thanks for doing that detective work!
> > > 
> > > The only explanation of why this particular patch can help that seems viable to
> > > us at the moment is that we have a memory corruption in the code region modified
> > > by it and the patch simply changes the alignment of the instructions that don't
> > > get corrupted.
> > > 
> > > It looks like this may be verified by putting a bunch of nops into the region
> > > in question, so can you please check if the attached patch helps too?
> > 
> > Unfortunately, your attached patch doesn't seem to fix the bug. 
> > Hope you still have some ideas to address this issue :)
> 
> Well, not really.
> 
> We'll need a dump of the wakeup structure from your system I suppose.
> I'll try to write a patch to get that over the weekend.

Can you try 3.10-rc3 by the way?  There is a fix in there that *might* make
a difference (although the odds are quite significant).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
