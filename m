Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764092Ab3DDRkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:40:13 -0400
Received: from www.sr71.net ([198.145.64.142]:37507 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763865Ab3DDRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:40:11 -0400
Message-ID: <515DBB00.20208@sr71.net>
Date: Thu, 04 Apr 2013 10:40:16 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: sched/cputime: sig->prev_stime underflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 3.9-rcs (and probably much earlier) I'm seeing some weird top
output where the cpu time "spent" is millions of hours:

445 root      20   0     0    0    0 S    0  0.0  5124095h kworker/45:1
404 root      20   0     0    0    0 S    0  0.0  5124095h kworker/4:1

I see it mostly with kernel threads, but it doesn't seem to happen on my
distro kernel (3.5 era).  The suspect code is in thread_group_times():

	sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);

In my case, I caught it with rtime=34 and sig->prev_utime=35.  This code
_looks_ to be pretty mature, coming in at commit 0cf55e1e in 2009.  The
system I'm running on _does_ have some non-sync'd TSCs, but they are at
least being detected, so I expect the fallout to be minimal:

	tsc: Marking TSC unstable due to check_tsc_sync_source failed

config:

	http://sr71.net/~dave/linux/config-bigbox-04042013.txt

The dumb fix here would seem to be to just check "rtime <
sig->prev_utime".  Any thoughts?
