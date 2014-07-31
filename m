Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaGaQt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:49:28 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:56367 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaGaQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:49:25 -0400
Date: Thu, 31 Jul 2014 18:49:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <20140731164918.GC7842@localhost.localdomain>
References: <cover.1406604806.git.luto@amacapital.net>
 <7123b2489cc5d1d5abb7bcf1364ca729cab3e6ca.1406604806.git.luto@amacapital.net>
 <20140729193232.GA8153@redhat.com>
 <20140730164344.GA27954@localhost.localdomain>
 <CALCETrUVaz3JFiNbyU=r3M-E9muHa1ffn7RX+_-4V_0U-hVaPw@mail.gmail.com>
 <20140731151630.GA7842@localhost.localdomain>
 <20140731164246.GA15974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731164246.GA15974@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:42:46PM +0200, Oleg Nesterov wrote:
> On 07/31, Frederic Weisbecker wrote:
> >
> > On Wed, Jul 30, 2014 at 10:23:34AM -0700, Andy Lutomirski wrote:
> > >
> > > At the end of the day, the syscall slowpath code calls a bunch of
> > > functions depending on what TIF_XYZ flags are set.  As long as it's
> > > structured like "if (TIF_A) do_a(); if (TIF_B) do_b();" or something
> > > like that, it's comprehensible.  But once random functions with no
> > > explicit flag checks or comments start showing up, it gets confusing.
> >
> > Yeah that's a point. I don't mind much the TIF_NOHZ test if you like.
> 
> And in my opinion
> 
> 	if (work & TIF_XYZ)
> 		user_exit();
> 
> looks even more confusing. Because, once again, TIF_XYZ is not the
> reason to call user_exit().
> 
> Not to mention this adds a minor performance penalty.

That's a point too! You guys both convinced me! ;-)

> 
> > > If it's indeed all-or-nothing, I could remove the check and add a
> > > comment.  But please keep in mind that, currently, the slow path is
> > > *slow*, and my patches only improve the entry case.  So enabling
> > > context tracking on every task will hurt.
> >
> > That's what we do anyway. I haven't found a safe way to enabled context tracking
> > without tracking all CPUs.
> 
> And if we change this, then the code above becomes racy. The state of
> TIF_XYZ can be changed right after the check. OK, it is racy anyway ;)
> but still this adds more confusion.

No because all running tasks have this flag set when context tracking is
enabled. And context tracking can't be disabled on runtime.
