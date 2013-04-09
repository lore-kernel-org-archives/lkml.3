Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab3DIMpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:45:41 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50928 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760019Ab3DIMpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:45:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtALCSR149RvcLmhJPBb9uM3t0wG_cFUTpinY26+=73mtw@mail.gmail.com>
References: <1364996263-12198-1-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hxt++4aRw_6uTDH4HDgac6-g1bU4Unq_BXuzwM5QBK_yQ@mail.gmail.com>
	<CAKfTPtALCSR149RvcLmhJPBb9uM3t0wG_cFUTpinY26+=73mtw@mail.gmail.com>
Date: Tue, 9 Apr 2013 14:45:38 +0200
Message-ID: <CAFTL4hwg4boZ_jqsZ4HUOBRv7Rhazh64gC=5g7MHJLJX_j9kdw@mail.gmail.com>
Subject: Re: [PATCH Resend v5] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/4 Vincent Guittot <vincent.guittot@linaro.org>:
> On 4 April 2013 19:07, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> Is it possible that we can be dealing here with a
>> sched_group/sched_group_power that is used on another CPU (from that
>> CPU's rq->rq_sd->sd) concurrently?
>> When we call build_sched_groups(), we might reuse an exisiting struct
>> sched_group used elsewhere right? If so, is there a race with the
>> above initialization?
>
> No we are not reusing an existing struct, the
> sched_group/sched_group_power that is initialized here, has just been
> created by __visit_domain_allocation_hell in build_sched_domains. The
> sched_group/sched_group_power is not already attached to any CPU

I see. Yeah the group allocations/initialization is done per domain
found in ndoms_new[]. And there is no further reuse of these groups
once these are attached.

Looking at the code it seems we can make some symetric conclusion with
group release? When we destroy a per cpu domain hierarchy and then put
our references to the struct sched_group, all the other per cpu
domains that reference these sched_group are about to put their
reference soon too, right? Because IIUC we always destroy these per
cpu domains per highest level partition (those found in doms_cur[])?

I'm just asking to make sure we don't need some
atomic_dec(nr_busy_cpus) on per cpu domain release, which is not
necessary the sched group is getting released soon.

Thanks for your patience :)
