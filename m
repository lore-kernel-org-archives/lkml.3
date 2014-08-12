Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaHLW2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaHLW2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:28:14 -0400
Message-ID: <53EA94DD.5040900@redhat.com>
Date: Tue, 12 Aug 2014 18:27:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com>
In-Reply-To: <20140812191218.GA15210@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/12/2014 03:12 PM, Oleg Nesterov wrote:

> Afaics, the problem is that a single thread can observe the
> decreasing (say) sum_exec_runtime if it calls do_sys_times() twice
> without the lock.
> 
> This is because it can account the exiting sub-thread twice if it
> races with __exit_signal() which increments sig->sum_sched_runtime,
> but this exiting thread can still be visible to
> thread_group_cputime().
> 
> IOW, it is not actually about decreasing, the problem is that the
> lockless thread_group_cputime() can return the wrong result, and
> the next ys_times() can show the right value.

You are right, changing the test case to call times() many
times in a row in each thread can result in the wrong value
being returned.

Not entirely sure what I can do there...

Replacing the spinlock with a seqlock, and taking it for
write in most places is pretty gross, and may lead to other
issues like reader livelock when there is a lot of write
activity.

Having a seqlock just for the stats?  Not sure the calls
to times() are a big enough issue for most workloads to
justify that...

Any other ideas?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT6pTdAAoJEM553pKExN6DMrIIAKFFHD8luyqgVUAm0jbV8JHm
O5PD81kot95POV7ZAl6crKmPi0OoeSdZIzcmuLFIvRJWqrbgWY6h4rQH9va5B830
F7TC2PRzWwUVwcuEoaUkuZMbUWkWqzUwXcwwFl1blYmkVJVRF27VcUB4S0jia1eq
l2TlQyC1HgXa3E7rbQ6vuKsOq50jB08MWwxEfhAEMNvndhos/fvZlsxL39UO3/X7
AVk+V/leE5tfAfyr6uPrWDR7/u9sJkqmi/dGJ/xjfWNU2swEPvMXk6UhspSIY+mg
KAMa+JWTPANeUSRM9HRA9YUpo0rqvy0Azmg84tIYr4nXsIyvzHuRgCUNQkOmEDQ=
=5ap3
-----END PGP SIGNATURE-----
