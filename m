Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFENmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:42:16 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38710 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFENmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140605132750.GA16811@pd.tnic>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
	<CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
	<CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
	<CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
	<CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
	<20140605132750.GA16811@pd.tnic>
Date: Thu, 5 Jun 2014 15:42:14 +0200
Message-ID: <CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 3:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 05, 2014 at 02:02:51PM +0200, Stephane Eranian wrote:
>> It is enabled by default. Nothing is done to try and disable it later
>> even once the kernel is fully booted. So this is mostly for testing
>> and power-users.
>
> You keep saying "power-users". What is the disadvantage for power users
> running with the workaround disabled? I.e., why would anyone want to
> disable it at all, what is the use case for that?
>
I gave a test case earlier:

# echo 0 >/proc/sys/kernel/nmi_watchdog
# run_my_uniform_workload_on_all_cpus &
# perf stat -a -e r81d0,r01d1,r08d0,r20d1 sleep 5

That run gives the correct answer.

If I just look at CPU0 CPU4 siblings:

CPU0, counter0 leaks N counts to CPU4, counter 0

but at the same time:

CPU4, counter0 leaks N counts to CPU0, counter 0

This is because we have the same event in the same
counter AND the workload is uniform, meaning the
event (here loads retired) occurs at the same rate
on both siblings.

You can test this by measuring only on one HT.
# perf stat -a -C0 -e r81d0,r01d1,r08d0,r20d1 sleep 5

Note that some events, leak more than they count.

Again, this is really for experts. The average users
should not have to deal with this. So we can drop
the sysfs entry.
