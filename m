Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaFAOJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 10:09:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45227 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaFAOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 10:09:01 -0400
Message-ID: <538B33D5.8070002@oracle.com>
Date: Sun, 01 Jun 2014 10:08:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: mm,console: circular dependency between console_sem and zone
 lock
References: <536AE5DC.6070307@oracle.com> <20140512162811.GD3685@quack.suse.cz>
In-Reply-To: <20140512162811.GD3685@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 12:28 PM, Jan Kara wrote:
> On Wed 07-05-14 22:03:08, Sasha Levin wrote:
>> > Hi all,
>> > 
>> > While fuzzing with trinity inside a KVM tools guest running the latest -next
>> > kernel I've stumbled on the following spew:
>   Thanks for report. So the problem seems to be maginally valid but I'm not
> 100% sure whom to blame :). So printk() code calls up() which calls
> try_to_wake_up() under console_sem.lock spinlock. That function can take
> rq->lock which is all expected.
> 
> The next part of the chain is that during CPU initialization we call
> __sched_fork() with rq->lock which calls into hrtimer_init() which can
> allocate memory which creates a dependency rq->lock => zone.lock.rlock.
> 
> And memory management code calls printk() which zone.lock.rlock held which
> closes the loop. Now I suspect the second link in the chain can happen only
> while CPU is booting and might even happen only if some debug options are
> enabled. But I don't really know scheduler code well enough. Steven?

I've cc'ed Peter and Ingo who may be able to answer that, as it still happens
on -next.


Thanks,
Sasha
