Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaHORZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaHORZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:25:46 -0400
Message-ID: <53EE4278.8030909@redhat.com>
Date: Fri, 15 Aug 2014 13:25:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
References: <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814132239.GA24465@redhat.com> <20140814174849.GA5091@redhat.com> <1408079971.5536.37.camel@marge.simpson.net> <20140815062819.GY19379@twins.programming.kicks-ass.net> <20140815163651.GA19331@redhat.com> <20140815164953.GA20197@redhat.com>
In-Reply-To: <20140815164953.GA20197@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/15/2014 12:49 PM, Oleg Nesterov wrote:

> Just in case... Yes, sure, "seqlock_t stats_lock" is more scalable.
> Just I do not know it's worth the trouble.

If we don't know whether it is worth the trouble, it is probably best
to stick to a well-known generic locking algorithm, instead of brewing
our own and trying to maintain it.

I have fixed the other locking issue you pointed out, Oleg.

Now to see if this change to cputime_adjust does the trick :)

+++ b/kernel/sched/cputime.c
@@ -605,9 +605,12 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
+	 * Atomic exchange protects against concurrent cputime_adjust.
 	 */
- -	prev->stime = max(prev->stime, stime);
- -	prev->utime = max(prev->utime, utime);
+	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
+		cmpxchg(&prev->stime, rtime, stime);
+	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
+		cmpxchg(&prev->utime, rtime, utime);

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT7kJ4AAoJEM553pKExN6Do/oH/2lA5X/CrVuhOLBK1sVq3kRh
gGiOTT9pDQZH1wwafVNHKWaro3T/s9GNqemgvgt4UiKbjFeYkaOycHp1cuntJj8j
Wk8zNnWBOuGqqcSxzk1Duco3CByxshLNXxuYJfpdkdEXPqRyvURAOL58pxSybZzh
E6lT747ntFJu3GIbfC6Ta3q58pWLpVrhWlvonhSaqat6tOvlzo4MKiJxz3SbT6i0
cCpmQ5p/JoQ5+IUEbTOZYbE2bK2y5tSrMggAFwKWLB3/0zJm1h4+2Q/5PenCX59X
VDFmaOJLkNxGcVXg8x87itvqzfq/LkvDtwl9tTJmA5ccG37MPvM3803XF5OWVo0=
=aKES
-----END PGP SIGNATURE-----
