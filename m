Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaGaPQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:16:42 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52919 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaGaPQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:16:39 -0400
Date: Thu, 31 Jul 2014 17:16:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 2/5] x86,entry: Only call user_exit if TIF_NOHZ
Message-ID: <20140731151630.GA7842@localhost.localdomain>
References: <cover.1406604806.git.luto@amacapital.net>
 <7123b2489cc5d1d5abb7bcf1364ca729cab3e6ca.1406604806.git.luto@amacapital.net>
 <20140729193232.GA8153@redhat.com>
 <20140730164344.GA27954@localhost.localdomain>
 <CALCETrUVaz3JFiNbyU=r3M-E9muHa1ffn7RX+_-4V_0U-hVaPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUVaz3JFiNbyU=r3M-E9muHa1ffn7RX+_-4V_0U-hVaPw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:23:34AM -0700, Andy Lutomirski wrote:
> On Wed, Jul 30, 2014 at 9:43 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, Jul 29, 2014 at 09:32:32PM +0200, Oleg Nesterov wrote:
> >> On 07/28, Andy Lutomirski wrote:
> >> >
> >> > @@ -1449,7 +1449,12 @@ long syscall_trace_enter(struct pt_regs *regs)
> >> >  {
> >> >     long ret = 0;
> >> >
> >> > -   user_exit();
> >> > +   /*
> >> > +    * If TIF_NOHZ is set, we are required to call user_exit() before
> >> > +    * doing anything that could touch RCU.
> >> > +    */
> >> > +   if (test_thread_flag(TIF_NOHZ))
> >> > +           user_exit();
> >>
> >> Personally I still think this change just adds more confusion, but I leave
> >> this to you and Frederic.
> >>
> >> It is not that "If TIF_NOHZ is set, we are required to call user_exit()", we
> >> need to call user_exit() just because we enter the kernel. TIF_NOHZ is just
> >> the implementation detail which triggers this slow path.
> >>
> >> At least it should be correct, unless I am confused even more than I think.
> >
> > Agreed, Perhaps the confusion is on the syscall_trace_enter() name which suggests
> > this is only about tracing? syscall_slowpath_enter() could be an alternative.
> > But that's still tracing in a general sense so...
> 
> At the end of the day, the syscall slowpath code calls a bunch of
> functions depending on what TIF_XYZ flags are set.  As long as it's
> structured like "if (TIF_A) do_a(); if (TIF_B) do_b();" or something
> like that, it's comprehensible.  But once random functions with no
> explicit flag checks or comments start showing up, it gets confusing.

Yeah that's a point. I don't mind much the TIF_NOHZ test if you like.

> 
> If it's indeed all-or-nothing, I could remove the check and add a
> comment.  But please keep in mind that, currently, the slow path is
> *slow*, and my patches only improve the entry case.  So enabling
> context tracking on every task will hurt.

That's what we do anyway. I haven't found a safe way to enabled context tracking
without tracking all CPUs.

> 
> --Andy
