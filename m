Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936779Ab3DHKsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:48:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54057 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933985Ab3DHKsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:48:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: chenhc@lemote.com
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] PM/reboot: call syscore_shutdown() after disable_nonboot_cpus()
Date: Mon, 08 Apr 2013 12:55:48 +0200
Message-ID: <11388244.eyJZJtFod3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <6c971a50f7639f17b1c419b6a885409b.squirrel@mail.lemote.com>
References: <1365300854-3133-1-git-send-email-chenhc@lemote.com> <2582863.XOOaeZz0rz@vostro.rjw.lan> <6c971a50f7639f17b1c419b6a885409b.squirrel@mail.lemote.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 08, 2013 10:51:45 AM chenhc@lemote.com wrote:
> > On Sunday, April 07, 2013 08:29:32 AM Greg KH wrote:
> >> On Sun, Apr 07, 2013 at 10:46:00AM +0200, Rafael J. Wysocki wrote:
> >> > On Sunday, April 07, 2013 10:14:14 AM Huacai Chen wrote:
> >> > > As commit 40dc166c (PM / Core: Introduce struct syscore_ops for core
> >> > > subsystems PM) say, syscore_ops operations should be carried with
> >> one
> >> > > CPU on-line and interrupts disabled. However, after commit f96972f2d
> >> > > (kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()),
> >> > > syscore_shutdown() is called before disable_nonboot_cpus(), so break
> >> > > the rules. We have a MIPS machine with a 8259A PIC, and there is an
> >> > > external timer (HPET) linked at 8259A. Since 8259A has been shutdown
> >> > > too early (by syscore_shutdown()), disable_nonboot_cpus() runs
> >> without
> >> > > timer interrupt, so it hangs and reboot fails. This patch call
> >> > > syscore_shutdown() a little later (after disable_nonboot_cpus()) to
> >> > > avoid reboot failure, this is the same way as poweroff does.
> >> > >
> >> > > BTW, add disable_nonboot_cpus() in kernel_halt() for consistency.
> >> > >
> >> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >> > > Cc: <stable@vger.kernel.org>
> >> >
> >> > While I agree with the changes, I'm not sure if I'm the right
> >> maintainer,
> >> > as this isn't really PM code.
> >> >
> >> > Andrew, should I take this?
> >>
> >> Andrew is on vacation for a few weeks, so you might need to take this
> >> through your tree.
> >
> > OK
> >
> > But, it looks like we should actually disable interrupts on the remaining
> > CPU after we've called disable_nonboot_cpus() so that the
> > syscore_shutdown()
> > assumptions are satisfied which the patch doesn't do.
> >
> > Chen (I apologize if that's not the right part of your full name to use
> > here),
> > do you think that's not necessary and if so, then for what reason?
> 
> Reboot and poweroff are both OK after I move syscore_shutdown(), I also don't
> know whether we should disable interrupts. Since you are the author of
> commit 40dc166c (PM / Core: Introduce struct syscore_ops for core subsystems
>  PM), please tell me why syscore_shutdown() need interrupt disabled?

Well, the syscore_ callbacks generally do things that may go wrong when an
interrupt comes in while they are being done.  At least that's what happens
for the suspend/resume syscore_ callbacks, but I'm not really sure about the
shutdown ones.

I suppose we can leave it as is for the time being.  At least I'm not aware of
any problems related to that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
