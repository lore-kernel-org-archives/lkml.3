Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaBBJL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:11:59 -0500
Received: from git.silcnet.org ([81.89.56.81]:47663 "EHLO git.silcnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaBBJLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:11:55 -0500
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 04:11:55 EST
Date: Sun, 2 Feb 2014 09:45:13 +0100 (CET)
From: Pekka Riikonen <priikone@iki.fi>
X-X-Sender: priikone@git.silcnet.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
In-Reply-To: <CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
Message-ID: <alpine.GSO.2.00.1402020900270.7559@git.silcnet.org>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan> <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com> <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com> <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
 <52ED4C96.6020703@zytor.com> <CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014, Linus Torvalds wrote:

> We could do that with the whole "task_work" thing (or perhaps just
> do_notify_resume(), especially after merging the "don't necessarily
> return with iret" patch I sent out earlier), with additionally making
> sure that scheduling does the right thing wrt a "currently dirty math
> state due to kernel use".
>
> The advantage of that would be that we really could do a *lot* of FP
> math very cheaply in the kernel, because we'd pay the overhead of
> kernel_fpu_begin/end() just once (well, the "end" part would be just
> setting the bit that we now have dirty state, the cost would be in the
> return-to-user-space-and-restore-fp-state part).
>
> Comments? That would be much more invasive than just changing
> __kernel_fpu_end(), but would bring in possibly quite noticeable
> advantages under loads that use the FP/vector resources in the kernel.
>
This would be very good and it needs to work in interrupt context 
(softirq) also, and when we interrupt idle task.  It's with networking we 
can really hit kernel_fpu_begin()/end() millions of times per second and 
there's really only need to do it once per interrupt.  This is actually 
similar what I was doing (in do_softirq)) when I noticed eagerfpu was 
broken and now Nate's bug AFAICS happens there as well.

 	Pekka
