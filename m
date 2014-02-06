Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaBFV3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:29:16 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:50262 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBFV3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:29:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
	<20140206005534.GA27848@node.dhcp.inet.fi>
	<CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
	<CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
Date: Thu, 6 Feb 2014 13:29:13 -0800
X-Google-Sender-Auth: oIPov5p0JmFYPXfOyE2VWd6zMjw
Message-ID: <CA+55aFyq31f=30YeRbZbqgBFp13Zdk=Gb-UiLRqeR48MOfVwag@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 8:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Doing the gang-lookup is hard, since it's all abstracted away, but the
> attached patch kind of tries to do what I described.
>
> This patch probably doesn't work, but something *like* this might be
> worth playing with.

Interesting. Here are some pte fault statistics with and without the patch.

I added a few new count_vm_event() counters: PTEFAULT, PTEFILE,
PTEANON, PTEWP, PTESPECULATIVE for the handle_pte_fault,
do_linear_fault, do_anonymous_page, do_wp_page and the "let's
speculatively fill the page tables" case.

This is what the statistics look like for me doing a "make -j" of a
fully built almodconfig build:

  5007450       ptefault
  3272038       ptefile
  1470242       pteanon
   265121       ptewp
        0       ptespeculative

where obviously the ptespeculative count is zero, and I was wrong
about anon faults being most common - the file mapping faults really
are the most common for this load (it's fairly fork/exec heavy, I
guess).

This is what happens with that patch I posted:

  2962090       ptefault
  1195130       ptefile
  1490460       pteanon
   276479       ptewp
  5690724       ptespeculative

about 200k page faults went away, and the numbers make sense (ie they
got removed from the ptefile column - the other number changes are
just noise).

Now, we filled 600k extra page table entries to do that (that
ptespeculative number), so the "hitrate" for the speculative filling
was basically about 33%. Which doesn't sound crazy - the code
basically populates the 8 aligned pages around the faulting page.

Now, because I didn't make this easily dynamically configurable I have
no good way to really test timing, but the numbers says at least the
concept works.

Whether the reduced number of page faults and presumably better
locality for the speculative prefilling makes up for the fact that 66%
of the prefilled entries never get used is very debatable. But I think
it's a somewhat interesting experiment, and the patch was certainly
not hugely complicated.

I should add a switch to turn this on/off and then do many builds in
sequence to get some kind of idea of whether it actually changes
performance. But if 5% of the overall time was literally spent on the
*exception* part of the page fault (ie not counting all the work we do
in the kernel), I think it's worth looking at this.

                        Linus
