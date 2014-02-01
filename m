Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaBAT15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:27:57 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:39432 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaBAT1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
Date: Sat, 1 Feb 2014 11:27:54 -0800
X-Google-Sender-Auth: _QfGvafHXnByc8UZOWPmPsr-Js8
Message-ID: <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <sbsiddha@gmail.com>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:33 PM, Suresh Siddha <sbsiddha@gmail.com> wrote:
>
> a. delayed dynamic allocation of FPU state area was not a good idea
> (from me). Given most of the future cases will be anyway using eager
> FPU (because of processor features like xsaveopt etc, applications
> implicitly using FPU because of optimizations in commonly used
> libraries etc), we should probably go back to allocation of FPU state
> area during thread creation for everyone (including non-eager cases).

Yes, I suspect that will help some, and probably fix this particular bug.

That said, regardless of the allocation issue, I do think that it's
stupid for kernel_fpu_{begin,end} to save the math state if
"used_math" was not set.  So I do think__kernel_fpu_end() as-s is
buggy and stupid. So I do think we should *either* say

 (a) "we don't want to restore at all, because once the kernel starts
using math, it might do so a lot, and saving/restoring is a bad idea":

  void __kernel_fpu_end(void)
  {
          stts();
  }

*or*

 (b) make the use_eager_fpu() case check tsk_used_math() (in which
case we had better already have an allocation!)

  void __kernel_fpu_end(void)
  {
          if (use_eager_fpu()) {
                  struct task_struct *me = current;

                  if (tsk_used_math(me) && likely(!restore_fpu_checking(me)))
                          return;
          }
          stts();
  }

Quite frankly, I'd almost lean towards (a). Comments? Does anybody
have any loads where the kernel does a lot of fpu stuff (ie network
encryption using the hw engines or something)? I'd really like to hear
if it makes a difference..

               Linus
