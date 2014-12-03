Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbaLCAJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:09:33 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:52295 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaLCAJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:09:32 -0500
MIME-Version: 1.0
In-Reply-To: <547E4C14.6040509@oracle.com>
References: <20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<20141202193252.GB17595@redhat.com>
	<547E4C14.6040509@oracle.com>
Date: Tue, 2 Dec 2014 16:09:31 -0800
X-Google-Sender-Auth: TovhLLjxgb6LjBLj3wmEveBuGDA
Message-ID: <CA+55aFxms_9g9bVuVmbMa6Bx78yQGb34RSoE5DEtNt8Le-bRPA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 3:32 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I've disabled lock debugging to see if anything new will show up, and hit
> something that may be related:

Very interesting. But your source code doesn't match mine - can you
say what that

    kernel/sched/fair.c:4541:17

line is?

There are at least five multiplications there (all inlined):

 - "imbalance*min_load" from find_idlest_group()

 - "factor * p->wakee_flips" in wake_wide()

 - at least three in wake_affine:

    "prev_eff_load *= capacity_of(this_cpu)"
    "this_eff_load *= this_load + effective_load(tg, this_cpu, weight, weight)"
    "prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight)"

(There are other multiplications too, but they are by constants afaik
and don't match yours).

None of those seem to have anything to do with the 3.16..3.17 changes,
but I might be missing something, and obviously this also might have
nothing to do with the problems anyway.

Adding Ingo/PeterZ to the participants again.

                 Linus


---
> [  787.894288] ================================================================================
> [  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
> [  787.898981] signed integer overflow:
> [  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
> [  787.900066] ubsan_epilogue (lib/ubsan.c:159)
> [  787.900066] handle_overflow (lib/ubsan.c:191)
> [  787.900066] ? __do_page_fault (arch/x86/mm/fault.c:1220)
> [  787.900066] ? local_clock (kernel/sched/clock.c:392)
> [  787.900066] __ubsan_handle_mul_overflow (lib/ubsan.c:218)
> [  787.900066] select_task_rq_fair (kernel/sched/fair.c:4541 kernel/sched/fair.c:4755)
