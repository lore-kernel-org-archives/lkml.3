Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765480Ab3DDXlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:41:32 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62906 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765146Ab3DDXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:41:31 -0400
MIME-Version: 1.0
In-Reply-To: <515DBB00.20208@sr71.net>
References: <515DBB00.20208@sr71.net>
Date: Fri, 5 Apr 2013 01:41:29 +0200
Message-ID: <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Hansen <dave@sr71.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/4 Dave Hansen <dave@sr71.net>:
> With the 3.9-rcs (and probably much earlier) I'm seeing some weird top
> output where the cpu time "spent" is millions of hours:
>
> 445 root      20   0     0    0    0 S    0  0.0  5124095h kworker/45:1
> 404 root      20   0     0    0    0 S    0  0.0  5124095h kworker/4:1
>
> I see it mostly with kernel threads, but it doesn't seem to happen on my
> distro kernel (3.5 era).  The suspect code is in thread_group_times():
>
>         sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);
>
> In my case, I caught it with rtime=34 and sig->prev_utime=35.  This code
> _looks_ to be pretty mature, coming in at commit 0cf55e1e in 2009.  The
> system I'm running on _does_ have some non-sync'd TSCs, but they are at
> least being detected, so I expect the fallout to be minimal:
>
>         tsc: Marking TSC unstable due to check_tsc_sync_source failed
>
> config:
>
>         http://sr71.net/~dave/linux/config-bigbox-04042013.txt
>
> The dumb fix here would seem to be to just check "rtime <
> sig->prev_utime".  Any thoughts?

Hi Dave,

Does this patch fix the issue for you?
https://lkml.org/lkml/2013/4/4/112
