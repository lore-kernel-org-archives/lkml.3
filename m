Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3KVVAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:00:02 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38996 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:59:58 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
From: William Dauchy <wdauchy@gmail.com>
Date: Fri, 22 Nov 2013 21:59:37 +0100
Message-ID: <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
Subject: Re: 3.10.16 cgroup_mutex deadlock
To: Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 3:17 AM, Hugh Dickins <hughd@google.com> wrote:
> Sorry for the delay: I was on the point of reporting success last
> night, when I tried a debug kernel: and that didn't work so well
> (got spinlock bad magic report in pwd_adjust_max_active(), and
> tests wouldn't run at all).
>
> Even the non-early cgroup_init() is called well before the
> early_initcall init_workqueues(): though only the debug (lockdep
> and spinlock debug) kernel appeared to have a problem with that.
>
> Here's the patch I ended up with successfully on a 3.11.7-based
> kernel (though below I've rediffed it against 3.11.8): the
> schedule_work->queue_work hunks are slightly different on 3.11
> than in your patch against current, and I did alloc_workqueue()
> from a separate core_initcall.
>
> The interval between cgroup_init and that is a bit of a worry;
> but we don't seem to have suffered from the interval between
> cgroup_init and init_workqueues before (when system_wq is NULL)
> - though you may have more courage than I to reorder them!
>
> Initially I backed out my system_highpri_wq workaround, and
> verified that it was still easy to reproduce the problem with
> one of our cgroup stresstests.  Yes it was, then your modified
> patch below convincingly fixed it.
>
> I ran with Johannes's patch adding extra mem_cgroup_reparent_charges:
> as I'd expected, that didn't solve this issue (though it's worth
> our keeping it in to rule out another source of problems).  And I
> checked back on dumps of failures: they indeed show the tell-tale
> 256 kworkers doing cgroup_offline_fn, just as you predicted.

Hugh, Tejun,

Do we have some news about this patch? I'm also hitting this bug on a 3.10.x

Thanks,
-- 
William
