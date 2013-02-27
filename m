Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444Ab3B0RK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:10:58 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33930 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab3B0RK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <512E376D.70105@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	<tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
	<CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
	<511BE4A3.8050607@redhat.com>
	<CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
	<511C1204.9040608@redhat.com>
	<CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
	<511C24A6.8020409@redhat.com>
	<CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
	<512E376D.70105@redhat.com>
Date: Wed, 27 Feb 2013 09:10:55 -0800
X-Google-Sender-Auth: kAA9hxOFhlyyVh_p2Gxj78s5opg
Message-ID: <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 8:42 AM, Rik van Riel <riel@redhat.com> wrote:
>
> To keep the results readable and relevant, I am reporting the
> plateau performance numbers. Comments are given where required.
>
>                 3.7.6 vanilla   3.7.6 w/ backoff
>
> all_utime               333000          333000
> alltests        300000-470000   180000-440000   large variability
> compute                 528000          528000
> custom          290000-320000   250000-330000   4 fast runs, 1 slow
> dbase                   920000          925000
> disk                    100000   90000-120000   similar plateau, wild
>                                                 swings with patches
> five_sec                140000          140000
> fserver         160000-300000   250000-430000   w/ patch drops off at
>                                                 higher number of users
> high_systime     80000-110000    30000-125000   w/ patch mostly 40k-70k,
>                                                 wild wings
> long            no performance platform, equal performance for both
> new_dbase               960000          96000
> new_fserver     150000-300000   210000-420000   vanilla drops off,
>                                                 w/ patches wild swings
> shared          270000-440000   120000-440000   all runs ~equal to
>                                                 vanilla up to 1000
>                                                 users, one out of 5
>                                                 runs slows down past
>                                                 1100 users
> short                   120000          190000

Ugh. That really is rather random. "short" and fserver seems to
improve a lot (including the "new" version), the others look like they
are either unchanged or huge regressions.

Is there any way to get profiles for the improved versions vs the
regressed ones? It might well be that we have two different classes of
spinlocks. Maybe we could make the back-off version be *explicit* (ie
not part of the normal "spin_lock()", but you'd use a special
"spin_lock_backoff()" function for it) because it works well for some
cases but not for others?

Hmm? At the very least, it would give us an idea of *which* spinlock
it is that causes the most pain. I think your earlier indications was
that it's the mutex->wait_lock or something?

                   Linus
