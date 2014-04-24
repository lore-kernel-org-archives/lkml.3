Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbaDXSnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbaDXSnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:43:37 -0400
Message-ID: <53595B36.70606@redhat.com>
Date: Thu, 24 Apr 2014 20:43:02 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/3] nohz: Fix iowait overcounting if iowait task migrates
References: <1398279636-21503-1-git-send-email-dvlasenk@redhat.com> <1398279636-21503-3-git-send-email-dvlasenk@redhat.com> <5358C909.6010208@jp.fujitsu.com>
In-Reply-To: <5358C909.6010208@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 10:19 AM, Hidetoshi Seto wrote:
> As I already mentioned in previous discussion with Peter, I have
> concern here that this change might have impact on performance.
> Especially in case if system is a kind of io-busy box, originally
> there may be no iowait time (and possibly also no idle time).
> For such case this change adds extra execution cost to manage
> value of iowait_exittime which might not used.

Everything has some cost. Correctness usually trumps a few extra
locked bus cycles.

Wouldn't it be nice if we'd know whether anyone even needs
the stats? If no one going to read /proc/stat on the box,
there's no point in going to all the trouble to maintain the counters...

> And if we successfully found a way to get the iowait_exittime
> within reasonable negligible cheap cost, then why we don't use
> it for NOHZ=n kernels too? 

Kernels without NOHZ maintain the counters based on timer interrupt
sampling. It should still work fine.

> As Frederic already pointed, seqcount must be better choice.

Yes, I'm switching to seqcounts.
