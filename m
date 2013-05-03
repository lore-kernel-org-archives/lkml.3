Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab3ECMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:16:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:29443 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab3ECMQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,604,1363158000"; 
   d="scan'208";a="328214276"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
To: Jonas Heinrich <onny@project-insanity.org>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Date: Fri, 3 May 2013 15:15:55 +0300
User-Agent: KMail/1.13.7 (Linux/3.8.0-19-generic; KDE/4.8.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20130218155439.GA902@onny> <1487368.CBCgti1nd5@vostro.rjw.lan> <20130503110705.GA3828@onny.Speedport_W_700V>
In-Reply-To: <20130503110705.GA3828@onny.Speedport_W_700V>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305031515.55595.jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday, May 03, 2013 02:07:05 PM Jonas Heinrich wrote:
> On 05-03 01:29, Rafael J. Wysocki wrote:
> > On Thursday, May 02, 2013 08:32:30 PM Jonas Heinrich wrote:
> > > On 05-02 02:45, Rafael J. Wysocki wrote:
> > > > On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> > > > > On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > > > > > Well, you could give me instructions on how to debug this (I'll
> > > > > > do everything ;)) or I could ship you the Thinkpad T43. I guess
> > > > > > this would worth the effort since this bug is somehow critical.
> > > > > > 
> > > > > > Best regards, Jonas
> > > > > 
> > > > > I'll put together a debug patch unless I can trick Rafael into
> > > > > doing it first...
> > > > 
> > > > I'm afraid that code has changed quite a bit since I looked at it
> > > > last time. [Jarkko Sakkinen seems to have worked on it lately,
> > > > CCed.]
> > > > 
> > > > Jonas, I wonder what happens if you drop the first hunk of the patch
> > > > (it just uses a different register, which shouldn't matter)?  Does
> > > > it still help then?
> > > 
> > > Hello Rafel, first of all, thank you for helping me out :)
> > > You're right, the patch still solves the suspend bug, after removing
> > > the first hunk of the patch and applying it (see attachement:
> > > suspendfix_first_hunk_dropped.patch).
> > > 
> > > > If so, there are still a few things you can do to it, e.g:
> > > > (1) drop the
> > > > 
> > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
> > > > -       jnc     1f
> > > 
> > > Still works :) (used suspendfix_1.patch)
> > > 
> > > > lines,
> > > > (2) drop the
> > > > 
> > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
> > > > -       jnc     1f
> > > > 
> > > > lines,
> > > 
> > > Still works :) (used suspendfix_2.patch)
> > > 
> > > > (3) drop the
> > > > 
> > > > +       jecxz   1f
> > > 
> > > Still works :) (used suspendfix_3.patch)
> > > 
> > > > line,
> > > > (4) drop the
> > > > 
> > > > +       movl    %eax, %ecx
> > > > +       orl     %edx, %ecx
> > > > +       jz      1f
> > > 
> > > At this point, the bug reoccurs (used suspendfix_4.patch)!
> > > But that doesn't mean these lines are the only critical, because the
> > > more minimal patch
> > > 
> > > @@ -119,6 +119,9 @@
> > > 
> > >         jnc     1f
> > >         movl    pmode_efer, %eax
> > >         movl    pmode_efer + 4, %edx
> > > 
> > > +       movl    %eax, %ecx
> > > +       orl     %edx, %ecx
> > > +       jz      1f
> > > 
> > >         movl    $MSR_EFER, %ecx
> > >         wrmsr
> > >  
> > >  1:
> > > with removing this part
> > > 
> > > -       movl    pmode_cr4, %eax
> > > -       movl    %eax, %cr4
> > > +       movl    pmode_cr4, %ecx
> > > +       movl    %ecx, %cr4
> > > 
> > > also doesn't fix the issue (see suspendfix_5.patch).
> > > 
> > > > lines and see what the minimal patch needed for things to work again
> > > > is.
> > > 
> > > So the most minimal working patch is suspendfix_3.patch.
> > 
> > Thanks for doing that detective work!
> > 
> > The only explanation of why this particular patch can help that seems
> > viable to us at the moment is that we have a memory corruption in the
> > code region modified by it and the patch simply changes the alignment of
> > the instructions that don't get corrupted.
> > 
> > It looks like this may be verified by putting a bunch of nops into the
> > region in question, so can you please check if the attached patch helps
> > too?
> 
> Unfortunately, your attached patch doesn't seem to fix the bug.
> Hope you still have some ideas to address this issue :)

Kind of had to experiment with this since I don't have access to
T43. Did you already try:

- EFER handling only is reverted as it was before 73201dbe.
- CR4 handling only is reverted as it was before 73201dbe.

Thanks.

/Jarkko

> 
> - Jonas
> 
> > Rafael
