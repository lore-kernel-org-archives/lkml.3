Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaFMWgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 18:36:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55705 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751262AbaFMWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 18:36:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kees Cook <keescook@chromium.org>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
Date: Sat, 14 Jun 2014 00:54:07 +0200
Message-ID: <1737131.VlQuirUC3S@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGXu5jLB8e2ZP6a2Q+_9R6qvHXwUoRr6eRVifdOVe0QmrfaTVw@mail.gmail.com>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org> <9502843.K96nxmtL8f@vostro.rjw.lan> <CAGXu5jLB8e2ZP6a2Q+_9R6qvHXwUoRr6eRVifdOVe0QmrfaTVw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 13, 2014 03:07:19 PM Kees Cook wrote:
> On Fri, Jun 13, 2014 at 3:14 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Friday, June 13, 2014 10:32:56 AM Kees Cook wrote:
> >> On Fri, Jun 13, 2014 at 3:51 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >> > Hi!
> >> >
> >> >
> >> >> >>> Any way we can make them work together instead?
> >> >> >>
> >> >> >> I'm sure there is, but I don't know the solution. :)
> >> >> >>
> >> >> >> At the very least this gets us one step closer (we can build them together).
> >> >> >>
> >> >> >
> >> >> > But it is really invasive.
> >> >>
> >> >> Well, I don't agree there. I actually would like to be able to turn
> >> >> off hibernation support on distro kernels regardless of kASLR, so I
> >> >> think this is really killing two birds with one stone.
> >> >>
> >> >> > I have to admit to being somewhat fuzzy on what the core problem with
> >> >> > hibernation and kASLR is... in both cases there is a set of pages that
> >> >> > need to be installed, some of which will overlap the loader kernel.
> >> >> > What am I missing?
> >> >>
> >> >> I don't know how resume works, but I have assumed that the newly
> >> >> loaded kernel stays in memory and pulls in the vmalloc, kmalloc,
> >> >> modules, and userspace memory maps from disk. Since these things can
> >> >> easily contain references to kernel text, if the newly loaded kernel
> >> >> has moved with regard to the hibernated image, everything breaks.
> >> >> IIUC, this is similar why you can't rebuild your kernel and resume
> >> >> from a different version.
> >> >
> >> > x86-64 can resume from different kernel that did the suspend. kASLR
> >> > should not be too different from that. (You just include kernel text
> >> > in the hibernation image. It is small enough to do that.)
> >>
> >> Oooh, that's very exciting! How does that work (what happens to the
> >> kernel that booted first, etc)? I assume physical memory layout can't
> >> change between hibernation and resume? Or, where should I be reading
> >> code that does this?
> >
> > I guess it would help if you were a bit less sarcastic, but perhaps that's
> > just me.
> 
> Oh, er, I think that got misunderstood. I'm very rarely sarcastic in
> online communication. I wasn't being sarcastic here at all. I _do_
> find it exciting that one can resume with a different kernel! That's
> been a limitation that plagued me for years. I had no idea that
> restriction got lifted. I really did mean I was excited. Sorry if that
> was misunderstood!

Sorry about my misunderstanding. :-)

> > Anyway, the core hibernation code actually works with page frames rather
> > than with virtual addresses.  Essentially, it creates a bitmap where each
> > page frame is represented by a single bit and the bits representing free
> > page frames are unset.  It then allocates as many new pages as there are
> > set bits in the bitmap and copies the entire contents of the page frames
> > represented by those bits to new pages it's just allocated. That covers
> > the entire kernel with its data and all process memory and is saved to
> > disk storage along with the PFNs of the page frames whose contents have
> > been copied.
> >
> > During resume it simply restores the contents of the saved page frames
> > into those same page frames if they are available at that time.  For the
> > page frames that aren't free then it allocates memory to store their
> > contents temporarily and creates a list of PFNs where that contents should
> > be moved eventually.  Then, it quiesces all activity of the system and
> > jumps to arch-specific code that copies data from the temporary memory to
> > the target page frames (that generally overwrites the boot kernel, so there's
> > no way back from it).  Finally, it jumps to a specific address where the
> > hibernated kernel trampoline code should be present.
> >
> > I think what fails with kASLR is that last step, because everything else
> > should be entirely agnostic to the way the virtual addresses are laid out.
> > I'm not sure how to fix that at the moment, but it should be fixable at
> > least on x86_64.
> 
> Very cool. How does the kernel doing the resume identify the
> trampoline location in the hibernated kernel? If it can handle a
> different kernel in the hibernation image, I assume there's been some
> specific identification in the image instead of using what
> kernel-doing-the-resume thinks the trampoline is (based on its own
> offsets).

There is a simple mechanism to pass the address to jump to in the image
header.  Unfortunately, that *is* a virtual address if I remember correctly.

I'll have a closer look at that shortly (it's been quite some time since
I wrote that code).

Rafael

