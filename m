Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaBAUQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:16:45 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:60150 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaBAUQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:16:43 -0500
MIME-Version: 1.0
In-Reply-To: <74304a13-a3b1-451c-870e-034b66224dc4@email.android.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<52ED4C96.6020703@zytor.com>
	<CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
	<74304a13-a3b1-451c-870e-034b66224dc4@email.android.com>
Date: Sat, 1 Feb 2014 12:16:42 -0800
X-Google-Sender-Auth: 2BVcfr5zEj2q0GqknToWGdFafS4
Message-ID: <CA+55aFy=dbxtcm+V4vPV5czQz3atOPm72ksLpm3TD2ezmKQBqw@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 12:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Of course, if we are really doing all eager fpu, we could just leave cr0.ts always clear and not touch it at all...

That's what the eager fpu code tries to do now (apart from process
initialization, I think). But the problem is that even disregarding
the process init issue, it saves and restores around every kernel FPU
use. What the extra flag (and task_work/do_resume_suspend) would do is
to just save/restore *once* per kernel entry.

Now, the *common* situation is certainly that the kernel doesn't do
any FPU work at all, but there are clearly exceptions to that. If
certain wireless encryption modes end up actually using hw
acceleration, we might have a *lot* of overhead from the save/restore
code. In fact, I think it triggers even for the idle task, which
doesn't really care.

              Linus
