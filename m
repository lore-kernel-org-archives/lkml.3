Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaHNB5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaHNB5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:57:40 -0400
Message-ID: <53EC176D.6080201@redhat.com>
Date: Wed, 13 Aug 2014 21:57:01 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814004318.GA2582@lerouge>
In-Reply-To: <20140814004318.GA2582@lerouge>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/13/2014 08:43 PM, Frederic Weisbecker wrote:
> On Wed, Aug 13, 2014 at 05:03:24PM -0400, Rik van Riel wrote:
>> --- a/kernel/time/posix-cpu-timers.c +++
>> b/kernel/time/posix-cpu-timers.c @@ -272,22 +272,8 @@ static int
>> posix_cpu_clock_get_task(struct task_struct *tsk, if
>> (same_thread_group(tsk, current)) err =
>> cpu_clock_sample(which_clock, tsk, &rtn); } else { -		unsigned
>> long flags; -		struct sighand_struct *sighand; - -		/* -		 *
>> while_each_thread() is not yet entirely RCU safe, -		 * keep
>> locking the group while sampling process -		 * clock for now. -
>> */ -		sighand = lock_task_sighand(tsk, &flags); -		if (!sighand) 
>> -			return err; - if (tsk == current ||
>> thread_group_leader(tsk)) err =
>> cpu_clock_sample_group(which_clock, tsk, &rtn); - -
>> unlock_task_sighand(tsk, &flags); }
> 
> I'm worried about such lockless solution based on RCU or read
> seqcount because we lose the guarantee that an update is
> immediately visible by all subsequent readers.
> 
> Say CPU 0 updates the thread time and both CPU 1 and CPU 2 right
> after that call clock_gettime(), with the spinlock we were
> guaranteed to see the new update. Now with a pure seqlock read
> approach, we guarantee a read sequence coherency but we don't
> guarantee the freshest update result.
> 
> So that looks like a source of non monotonic results.

Which update are you worried about, specifically?

The seq_write_lock to update the usage stat in p->signal will lock out
the seqlock read side used to check those results.

Is there another kind of thing read by cpu_clock_sample_group that you
believe is not excluded by the seq_lock?


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT7BdtAAoJEM553pKExN6DngEH/1CJuBb6xij08AoZNQuW4WNQ
geKakADsYTz8FmutbGi+lJEHNKAMZQ5wYbyFNczPAX/fVJsOlC92Qtfwy5z/VupN
QzlRHh79ZJR5/6xGddlu/8LjGrMIXwKqShIeKtTzoENS+rxA82l42zoXTagal4yX
Peb5/Q7cBMg9pFZzUMITEJssQhDtyTN1rXiU5IsEG54PhDbSgFk7HK1cO46tRefb
x1WbUKZKUViVKnoKYhJqd6FDSWuPtL5EpebvMVj9TZ29JBQTMDGx8saUezjuY0YL
STAv/wqigmbbcNnloJpr3gO1iJMkknv3jHk6Bfv1Dil8Um1D3mBAAKFK+Ov8Rk0=
=kU1O
-----END PGP SIGNATURE-----
