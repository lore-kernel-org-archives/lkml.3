Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaKPUDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:03:07 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35197 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaKPUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:03:06 -0500
MIME-Version: 1.0
In-Reply-To: <393289076.116745.1416126792518.open-xchange@webmail.nmp.skynet.be>
References: <393289076.116745.1416126792518.open-xchange@webmail.nmp.skynet.be>
Date: Sun, 16 Nov 2014 12:03:04 -0800
X-Google-Sender-Auth: z3oP-zKwfXyp-BjbGM0dHcBLLBY
Message-ID: <CA+55aFwq2gash0+scfR_aefxyGfHeNT4CgNopgVMO-RA7dkiLQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4: revert suggestion
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 12:33 AM, Fabian Frederick <fabf@skynet.be> wrote:
>
>         Have you tried reverting the following patches (all from rc1) ?

Hmm. Any particular reason you're looking at those?

>         c6f4459 v3.18-rc1 smp: Add new wake_up_all_idle_cpus() function
>         bb964a9 v3.18-rc1 kernel misc: Replace __get_cpu_var uses
>         2ed903c v3.18-rc1 cpuidle: Use wake_up_all_idle_cpus() to wake up all idle cpus

It does strike me that the reschedule IPI is somewhat special in that
we don't try to serialize it at all, on the grounds that a lost IPI is
ok (ie smp_send_reschedule() is very much a special case of IPI). Or
am I mis-remembering? Does that series end up adding a lot more of
those things, rather than using the normal smp_call_function().

The normal smp_function_mask() thing tries to make sure only one entry
is ever active at a time (even a non-blocking one will use the whole
"queue it on a llist, only send the IPI if the llist was empty", so
this is not about the IPI's being synchronous).  The rescheduling
thing is rather special, isn't it.

The softlockup thing *did* look like some IPI got lost. Could an IPI
overflow on the RESCHEDULE_VECTOR end up affecting other vectors? It's
been too long since I worked with the APIC (and by "too long", I
obviously mean "thank God I haven't had to" ;^) but there used to be
grouping of the vectors..

Maybe that is all barking up the wrong tree, but I'm wondering why
Fabian picked that particular set of commits. Fabian?

                     Linus
