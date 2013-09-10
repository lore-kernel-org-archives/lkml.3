Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3IJQit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:38:49 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60850 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3IJQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:38:47 -0400
Message-ID: <522F4B14.1040606@linaro.org>
Date: Tue, 10 Sep 2013 09:38:44 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lin Ming <minggr@gmail.com>
CC: Gerlando Falauto <gerlando.falauto@keymile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org> <5225F8EF.3040701@keymile.com> <52261BBB.60904@linaro.org> <5226EB35.6080604@keymile.com> <522E2FBB.4070406@linaro.org> <CAF1ivSYVPtsyL-hO9o1i71ceG7fmvh+u+AdKGbJvrKH0k6mb_A@mail.gmail.com>
In-Reply-To: <CAF1ivSYVPtsyL-hO9o1i71ceG7fmvh+u+AdKGbJvrKH0k6mb_A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 01:59 AM, Lin Ming wrote:
>  On Tue, Sep 10, 2013 at 4:29 AM, John Stultz <john.stultz@linaro.org> wrote:
>
> [snip]
>
>> So I think I've managed to finally reproduce this and hunt it down.
>>
>> With Peter's "sched: Fix HRTICK" patch and HRTICK enabled, I found I
>> could trigger a hard hang at boot on my x86_64 kvm system. sysrq didn't
>> function, so I checked out info cpus and that pointed to both cpus being
> Hi,
>
> Is "info cpus" a command of kvm/qemu? That's very helpful.
Yes. If you switch into the qemu monitor, you can use "info cpus" to
show the current instruction pointers

> I can reproduce this bug, but there is no any output.
> How did you find out that both cpus being in ktime_get() and
> ktime_get_update_offsets().

Once I had the instruction pointers, I ran gdb on the vmlinux and used
"list *<address>" to show where it was stuck.

>> in ktime_get() and ktime_get_update_offsets(), which suggested a
>> seqcount deadlock (basically calling something that reads the seqlock
>> while we hold the write on it).
> HRTICK enabled, then I can reproduce this simply with,
>
> while [ 1 ] ;
>     adjtimex -t 9999
> done
>
> And your patch fixed it.

Great! Can I add a Tested-by: from you on the patch?

thanks
-john

