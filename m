Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaLARxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:53:18 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:50725 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaLARxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:53:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141201171036.GH18466@arm.com>
References: <alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
	<546D0530.8040800@mit.edu>
	<20141120152509.GA5412@redhat.com>
	<20141125122217.GA15280@arm.com>
	<20141201114854.GB18466@arm.com>
	<CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
	<20141201171036.GH18466@arm.com>
Date: Mon, 1 Dec 2014 09:53:16 -0800
X-Google-Sender-Auth: 9Jpi6m7QfzKnv1ON3QUpMg6JocM
Message-ID: <CA+55aFwooh31=GMVUoriev+t92=roye_ck+czqr48M1sQ3UOMg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>, Tejun Heo <tj@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 9:10 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> So I don't even have binfmt-misc compiled in. The two handlers I have are
> BINFMT_ELF and BINFMT_SCRIPT, but they both check for headers that we won't
> get back from oom_score afaict.

Hmm. So I can't even get that "oom_score" file to be executable in the
first place, which should mean that execve() should terminate very
quickly with an EACCES error.

The fact that you have a "flush_work()" that is waiting for completion
is interesting. Maybe the odd new thread is a worker thread for some
modprobe or similar, and we .  There's that whole

   request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2))

which ends up creating a new work. Maybe the flush_work() is waiting
for that whole mess. Adding Tejun to the cc, since there *were*
changes to workqueues etc since 3.16..

Tejun, full thread on lkml, I'm assuming you can find it in your mail archives..

                      Linus
