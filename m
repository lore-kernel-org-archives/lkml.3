Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaFEKBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:01:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45889 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaFEKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:01:29 -0400
MIME-Version: 1.0
X-Originating-IP: [90.207.204.193]
In-Reply-To: <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
Date: Thu, 5 Jun 2014 11:01:28 +0100
Message-ID: <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Matt Fleming <matt@console-pimps.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 10:29, Stephane Eranian <eranian@google.com> wrote:
>
> If you know what you are doing (poweruser), then there are measurements
> which works fine with the HT erratum.  This is why we have the option.
>
> For instance if you only measure events 4x4 in system-wide mode
> and you know which counters these event are going to use, you don't
> need the workaround. For instance:
>
> # perf stat -a -e r81d0,r01d1,r08d0,r20d1 sleep 5
>
> Works well if you have a uniform workload across all CPUs.
> All those events leak, but the leaks balance themselves and you
> get the correct counts in the end. The advantage is that you don't
> have to multiplex. With the workaround enable, this would multiplex
> a lot.
>
> But as I said, this is for experts only.

Is it not possible to detect this in the kernel and only enable the
workaround for the case where the leaks don't balance? It may not be
possible (or practical) but I do think it's worth having the
discussion.

> Another reason is for systems with HT disabled. It turned out to be
> very difficult to determine at kernel BOOT TIME if HT was enabled
> or not. Note what I said: ENABLED and not SUPPORTED. The latter is
> easy to detect. The former needs some model specific code which is
> quite complicated. I wish the kernel had this capability abstracted
> somehow. Consequently, the workaround is always enabled. When
> HT is disabled, there won't be multiplexing because there will never
> be conflict, but you pay a little price for accessing the extra data
> state.

Does cpu_sibling_map not give you some indication of whether HT is
enabled? I think the topology_thread_cpumask() is the topology API for
that. But I could most definitely be wrong. Hopefully someone on the
Cc list will know.

>An init script could well detect HT is off and thus disable the workaround altogether.

This is exactly the kind of thing I think we should try to avoid. The
ideal is that things just work out of the box and don't require these
magic knobs to be tweaked.

> Those are the two main reasons for this control in sysfs.

Thanks for the info!
