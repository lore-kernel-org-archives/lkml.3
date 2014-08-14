Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaHNPiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaHNPiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:38:20 -0400
Message-ID: <53ECD7C8.6040202@redhat.com>
Date: Thu, 14 Aug 2014 11:37:44 -0400
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
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814142404.GA28211@redhat.com>
In-Reply-To: <20140814142404.GA28211@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/14/2014 10:24 AM, Oleg Nesterov wrote:
> On 08/13, Rik van Riel wrote:
>> 
>> @@ -862,11 +862,9 @@ void do_sys_times(struct tms *tms) { 
>> cputime_t tgutime, tgstime, cutime, cstime;
>> 
>> -	spin_lock_irq(&current->sighand->siglock); 
>> thread_group_cputime_adjusted(current, &tgutime, &tgstime); 
>> cutime = current->signal->cutime; cstime =
>> current->signal->cstime; -
>> spin_unlock_irq(&current->sighand->siglock);
> 
> Ah, wait, there is another problem afaics...

Last night I worked on another problem with this code.

After propagating the stats from a dying task to the signal struct,
we need to make sure that that task's stats are not counted twice.

This requires zeroing the stats under the write_seqlock, which was
easy enough to add. We cannot rely on any state in the task that
was set outside of the write_seqlock...

> thread_group_cputime_adjusted()->cputime_adjust() plays with 
> signal->prev_cputime and thus it needs siglock or stats_lock to
> ensure it can't race with itself. Not sure it is safe to simply
> take the lock in cputime_adjust(), this should be checked.
> 
> OTOH, do_task_stat() already calls task_cputime_adjusted() lockless
> and this looks wrong or I missed something. So perhaps we need a
> lock in or around cputime_adjust() anyway.

I'll take a look at this.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT7NfHAAoJEM553pKExN6DTVIH/RIFVl42fM+cBpiSavSa2s4k
B0ykVu/VwFbqoYVo5I5joSl25IpU5Xma3AwMBQHoJ7aY9a8w63iGFMoycKcDWbrY
nOyaOTvR92aMdn/GuGwS/XlU83PwIbLEyYWFrvn0CrnBqJw9pHz/sLYsvP/jASem
LbUStuWFzqGyasb4lJVZmLQKaIVhy30CM5Y3llTFuc16zyH/YG65tUasG+aR2miA
g3CiPOHP/IY0vZ+L3YYlLthLY4acVX/bwImE0vsx9fY+rG4hgj5xF9b0CnbaN41g
62oJ4jkFSH/voNFPjR7I5AnKpSeMsBqW2/l1tHlcaKcNCtkd9nri/HinxXN5bN4=
=dfSt
-----END PGP SIGNATURE-----
