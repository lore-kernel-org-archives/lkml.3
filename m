Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3IJI7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:59:12 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61400 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3IJI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <522E2FBB.4070406@linaro.org>
References: <521F6D06.1040107@keymile.com>
	<E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net>
	<521FDD12.7050000@linaro.org>
	<52212511.9050206@keymile.com>
	<5221264F.4070402@linaro.org>
	<5225F8EF.3040701@keymile.com>
	<52261BBB.60904@linaro.org>
	<5226EB35.6080604@keymile.com>
	<522E2FBB.4070406@linaro.org>
Date: Tue, 10 Sep 2013 16:59:09 +0800
Message-ID: <CAF1ivSYVPtsyL-hO9o1i71ceG7fmvh+u+AdKGbJvrKH0k6mb_A@mail.gmail.com>
Subject: Re: kernel deadlock
From: Lin Ming <minggr@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Tue, Sep 10, 2013 at 4:29 AM, John Stultz <john.stultz@linaro.org> wrote:

[snip]

>
> So I think I've managed to finally reproduce this and hunt it down.
>
> With Peter's "sched: Fix HRTICK" patch and HRTICK enabled, I found I
> could trigger a hard hang at boot on my x86_64 kvm system. sysrq didn't
> function, so I checked out info cpus and that pointed to both cpus being

Hi,

Is "info cpus" a command of kvm/qemu? That's very helpful.
I can reproduce this bug, but there is no any output.
How did you find out that both cpus being in ktime_get() and
ktime_get_update_offsets().

> in ktime_get() and ktime_get_update_offsets(), which suggested a
> seqcount deadlock (basically calling something that reads the seqlock
> while we hold the write on it).

HRTICK enabled, then I can reproduce this simply with,

while [ 1 ] ;
    adjtimex -t 9999
done

And your patch fixed it.

Thanks,
Lin Ming

>
> Unfortunately the seqlock/seqcount infrastructure doesn't support
> lockdep, so I added some debug code to take and release the
> timekeeper_lock in every function that does a read on the timekeeper_seq.
