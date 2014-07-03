Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317AbaGCKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:25:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54072 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbaGCKZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:25:23 -0400
Date: Thu, 3 Jul 2014 11:24:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Kees Cook <keescook@chromium.org>,
        =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under
 PTRACE_O_TRACESECCOMP
Message-ID: <20140703102450.GD12958@arm.com>
References: <20140618202748.GA9022@www.outflux.net>
 <20140620102258.GA26626@arm.com>
 <CAGXu5jKJ07bXw_K+7uSAf=H_SDoeoaWPxS4rwuonbR71Svwwmw@mail.gmail.com>
 <20140620172330.GA30656@arm.com>
 <CAGXu5jKg0didhwZTUq8AbMnwD=RV=EaWiZWBWuar625JXGnL6w@mail.gmail.com>
 <CAGXu5j+bk3g0Dude8jfKM3dXxX8LE_46CMmcBCGdVMNX_Hu-6w@mail.gmail.com>
 <20140623084608.GA9316@arm.com>
 <CAGXu5jLJRU21YoBXjXRpfHW1-jwy_PV0hpH_oUfew23xLF4gYg@mail.gmail.com>
 <20140624085405.GA26013@arm.com>
 <53B5098B.9050801@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B5098B.9050801@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 08:43:07AM +0100, AKASHI Takahiro wrote:
> Hi Will,

Hi Akashi,

> On 06/24/2014 05:54 PM, Will Deacon wrote:
> > On Mon, Jun 23, 2014 at 08:46:52PM +0100, Kees Cook wrote:
> >> What's the state of seccomp on arm64? I saw a series back in March,
> >> but nothing since then? It looked complete, but I haven't set up a
> >> test environment yet to verify.
> >
> > I think Akashi was going to repost `real soon now' so we can include them
> > for 3.17. He missed the merge window last time around.
> 
> I took a quick look at the current implementation of ptrace.
> ptrace(PTRACE_GETREGSET/SETREGSET), eventually gpr_get/set(), handles only
> 'struct user_pt_regs', and we have no way to modify orig_x0 nor syscallno
> in 'struct pt_regs' directly.
> So it seems to me that we can't change a system call by ptrace().
> Do I misunderstand anything?

No, it looks like you have a point here. I don't think userspace has any
business with orig_x0, but changing syscallno is certainly useful. I can
think of two ways to fix this:

  (1) Updating syscallno based on w8, but this ties us to the current ABI
      and could get messy if this register changes in the future.

  (2) Adding a PTRACE_SET_SYSCALL request, like we have for arch/arm/,
      but that means adding arch-specific stuff to arch_ptrace (which
      currently goes straight to ptrace_request on arm64).

It looks like x86 uses orig_ax, which I *think* means we would go with
(1) above if we followed their lead.

Anybody else have an opinion about this?

Will
