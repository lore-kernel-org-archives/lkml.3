Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaGXAhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:37:46 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:39957 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbaGXAho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140723095327.GA23131@pd.tnic>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
	<20140723095327.GA23131@pd.tnic>
Date: Wed, 23 Jul 2014 17:37:43 -0700
X-Google-Sender-Auth: pxoYoQtYv6NBKTWUz6GYY6I_1BY
Message-ID: <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
Subject: Re: Linux 3.16-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 2:53 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> Well, it looks like we f*cked up something after -rc5 since I'm starting
> to see lockdep splats all over the place which I didn't see before. I'm
> running rc6 + tip/master.
>
> There was one in r8169 yesterday:
>
> https://lkml.kernel.org/r/20140722081840.GA6462@pd.tnic
>
> and now I'm seeing the following in a kvm guest. I'm adding some more
> lists to CC which look like might be related, judging from the stack
> traces.

Hmm. I'm not seeing the reason for this.

> [   31.704282] [ INFO: possible irq lock inversion dependency detected ]
> [   31.704282] 3.16.0-rc6+ #1 Not tainted
> [   31.704282] ---------------------------------------------------------
> [   31.704282] Xorg/3484 just changed the state of lock:
> [   31.704282]  (tasklist_lock){.?.+..}, at: [<ffffffff81184b19>] send_sigio+0x59/0x1b0
> [   31.704282] but this lock took another, HARDIRQ-unsafe lock in the past:
> [   31.704282]  (&(&p->alloc_lock)->rlock){+.+...}

Ok, so the claim is that there's a 'p->alloc_lock' (ie "task_lock()")
that is inside the tasklist_lock, which would indeed be wrong. But I'm
not seeing it. The "shortest dependencies" thing seems to imply
__set_task_comm(), but that only takes task_lock.

Unless there is something in tip/master. Can you check that this is
actually in plain -rc6?

Or maybe I'm just blind. Those lockdep splats are easy to get wrong.
Adding PeterZ and Ingo to the list just because they are my lockdep
go-to people.

                 Linus
