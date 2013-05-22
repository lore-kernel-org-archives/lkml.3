Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3EVGAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:00:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3EVGAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:00:18 -0400
Message-ID: <1369202385.5782.33.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
From: Mike Galbraith <bitbucket@online.de>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Date: Wed, 22 May 2013 07:59:45 +0200
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:QnQY83PLI/a1uwV1S1WPySSh6xCJ+7HfPIiEVNYphJN
 FPlOaDktnH19ufmNFURATqT5H9YtSwt3vM4btyKFVajhgXH23F
 zPAek/UsCU1XLhkNf2srs9XQU6qH19Ywc73dR8HoJQez8cg5Ub
 PJqC4ZoYI09ybpYnz7xfOh3NBagafCgDAqxSXNbLF/te4u2Zju
 Oe7Wzz8Qicjx3OadUkNKKc2PeZN1SHsn8iKD/ajhkH7/8bQINe
 4RkdrF/TApgOnsURJIPqJmaso/4/AqSnZgOIVNCPy2t6p6jUY1
 SHCz0+FliyXGzdL/AcswTjVRN/RA39dwXXyIeOEsyCm8BiIsoB
 RVXrx6STqGh5ySaMGUEhGfaZmpv3W8/iJHqeKB3hmU9MaKXmS8
 SH53DDBiYyO7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 14:30 -0700, Peter Boonstoppel wrote: 
> RT throttling aims to prevent starvation of non-SCHED_FIFO threads
> when a rogue RT thread is hogging the CPU. It does so by piggybacking
> on the rt_bandwidth system and allocating at most rt_runtime per
> rt_period to SCHED_FIFO tasks (e.g. 950ms out of every second,
> allowing 'regular' tasks to run for at least 50ms every second).
> 
> However, when multiple cores are available, rt_bandwidth allows cores
> to borrow rt_runtime from one another. This means that a core with a
> rogue RT thread, consuming 100% CPU cycles, can borrow enough runtime
> from other cores to allow the RT thread to run continuously, with no
> runtime for regular tasks on this core.
> 
> Although regular tasks can get scheduled on other available cores
> (which are guaranteed to have some non-RT runtime avaible, since they
> just lent some RT time to us), tasks that are specifically affined to
> a particular core may not be able to make progress (e.g. workqueues,
> timer functions). This can break e.g. watchdog-like functionality that
> is supposed to kill the rogue RT thread.
> 
> This patch changes do_balance_runtime() in such a way that no core can
> aquire (borrow) more runtime than the globally set rt_runtime /
> rt_period ratio. This guarantees there will always be some non-RT
> runtime available on every individual core.

Seems to me it's be better to just invert RT_RUNTIME_SHARE default
setting, since the real world throttle mission tends to be saving the
user from his own brilliance a lot more often than any group scheduling
or debugging.

I see this fairly frequently: "My application is the most important
thing in the universe, so of course I run it SCHED_FIFO priority 99.
Why does all kinds of bad juju happen, frequently ending with box
ignoring all gefingerpoken und mittenmgrabben, when I do something as
innocuous as turning my pet cpuhog from hell loose in godmode?"

-Mike

