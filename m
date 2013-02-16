Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3BPXCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 18:02:33 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45485 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3BPXCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 18:02:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1302161302290.21380@eggly.anvils>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com> <alpine.LNX.2.00.1302141804400.3330@eggly.anvils>
 <CA+55aFyLDnmwy16V8TQRwJV2O51K-dmqBhuWi2ytRd4sYi8J+g@mail.gmail.com> <alpine.LNX.2.00.1302161302290.21380@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Feb 2013 15:02:11 -0800
X-Google-Sender-Auth: ixa6eNXwbtiMTqYwHR9U1TBCZMU
Message-ID: <CA+55aFwF1qZmPaL5LPA+0ys68s=TF7wfXpb5y9GWi0q5RJDJ-Q@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Hugh Dickins <hughd@google.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 1:45 PM, Hugh Dickins <hughd@google.com> wrote:
>
> I hacked around on your PM_TRACE set_magic_time() / read_magic_time()
> yesterday, to save an oopsing core kernel ip there, instead of hashed
> pm trace info (it makes sense in this case to invert your sequence,
> putting the high order into years and the low order into minutes).

That sounds like a good idea in general. The PM_TRACE() thing was done
to figure out things that locked up the PCI bus etc, but encoding the
oopses during suspend sounds like a really good idea too.

Is your patch clean enough to just be made part of the standard
PM_TRACE infrastructure, or was it something really hacky and one-off?

> Rewarded last night by reboot to Feb 21 14:45:53 2006.  Which is
> ffffffff812d60ed intel_choose_pipe_bpp_dither.isra.13+0x216/0x2d6
>
> /home/hugh/3087X/drivers/gpu/drm/i915/intel_display.c:4159
>          * enable dithering as needed, but that costs bandwidth.  So choose
>          * the minimum value that expresses the full color range of the fb but
>          * also stays within the max display bpc discovered above.
>          */
>
>         switch (fb->depth) {
> ffffffff812d60e9:       48 8b 55 c0             mov    -0x40(%rbp),%rdx
> ffffffff812d60ed:       8b 02                   mov    (%rdx),%eax
>
> (gcc chose to pass a pointer to fb->depth down to the function,
> instead of fb itself, since that is the only use of it there.)
>
> I expect that fb is NULL; but with an average of one failure to resume
> per day, and ~26 bits of info per crash, this is not a fast procedure!
>
> I notice that intel_pipe_set_base() allows for NULL fb,
> so I'm currently running with the oops-in-rtc hackery, plus
> -       switch (fb->depth) {
> +       if (WARN_ON(!fb))
> +               bpc = 8;
> +       else switch (fb->depth) {
>
> There's been a fair bit of change to intel_display.c since 3.7 (if
> my 3.7 was indeed good), mainly splitting intel_ into haswell_ versus
> ironlake_, but I've not yet spotted anything obvious; nor yet looked
> to see where fb would originate from anyway.
>
> Once I've got just a little more info out of it, I'll start another
> thread addressed principally to the drm/gpu/i915 guys.

I think it's worth it to give them a heads-up already. So I've cc'd
the main suspects here..

Daniel, Dave - any comments about a NULL fb in
intel_choose_pipe_bpp_dither() during either suspend or resume? Some
googling shows this:

    https://bugzilla.redhat.com/show_bug.cgi?id=895123

which sounds remarkably similar, and is also during a suspend attempt
(but apparently Satish got a full oops out).. Some timing race with a
worker entry?

                        Linus
