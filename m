Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaHLTXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaHLTXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:23:31 -0400
Message-ID: <53EA6992.8060608@redhat.com>
Date: Tue, 12 Aug 2014 15:22:58 -0400
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
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/12/2014 03:12 PM, Oleg Nesterov wrote:
> On 08/12, Rik van Riel wrote:
>> 
>> Back in 2009, Spencer Candland pointed out there is a race with 
>> do_sys_times, where multiple threads calling do_sys_times can 
>> sometimes get decreasing results.
>> 
>> https://lkml.org/lkml/2009/11/3/522
>> 
>> As a result of that discussion, some of the code in do_sys_times 
>> was moved under a spinlock.
>> 
>> However, that does not seem to actually make the race go away on 
>> larger systems. One obvious remaining race is that after one
>> thread is about to return from do_sys_times, it is preempted by
>> another thread, which also runs do_sys_times, and stores a larger
>> value in the shared variable than what the first thread got.
>> 
>> This race is on the kernel/userspace boundary, and not fixable 
>> with spinlocks.
> 
> Not sure I understand...
> 
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

Hmmm, that is not what the test case does.

The test case simply calls times() once in each thread, and saves
the value in a global variable for the next thread to use.

Does the seq_lock in task_cputime() prevent the problem you are
describing, or does the exit/zombie reaping code need to block the
seq_lock while it moves the stats from the zombie to the group?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT6mmSAAoJEM553pKExN6D+EkH/2BexZ8XfKpHAKfkidIhPrOy
nr5q8WhKU1mJmdEULNx6NQxAjRnpORTOfDElwRT1gzXqOyXrTxXZ207/anezhstU
kyu5wRNBz/pilXPDzVsiF+DqTxoBnVOIc0eltQ00jmUden08eVEfEY5mjevCJalz
2AbWFa8QQZgtGSCZB1UPaUF6NHTu/Z35u9UTEIkLirLCqfIYPz325Wdfs+W+fggS
8vEgHhO50BrIAm9HCO/vgY8SCAU/0Pml73ABV3+4sB7dnYVgDkYXzS0iMimuAcZ/
qL0NhRrKH4sRxGQXBlQv87GgMpR9Tr4RVFK6eH9xwjVwthYXnYeDTbYryjpmdco=
=haSd
-----END PGP SIGNATURE-----
