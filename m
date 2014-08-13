Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaHMSri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:47:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaHMSrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:47:37 -0400
Date: Wed, 13 Aug 2014 20:45:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813184511.GA9663@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EBADB1.2020403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rik van Riel wrote:
>
> On 08/13/2014 02:08 PM, Oleg Nesterov wrote:
> >
> > Well, I disagree. This is more complex, and this adds yet another lock
> > which only protects the stats...
>
> The other lock is what can tell us that there is a writer active
> NOW, which may be useful when it comes to guaranteeing forward
> progress for readers when there are lots of threads exiting...

I don't really understand why seqcount_t is better in this sense, either
way we need to to taking the lock if we want to guarantee a forward
progress. read_seqbegin_or_lock() doesn't even work "automagically",
and it can't be used in this case anyway.

That said, it is not that I am really sure that seqcount_t in ->signal
is actually worse, not to mention that this is subjective anyway. IOW,
I am not going to really fight with your approach ;)

> > Whatever we do, we should convert thread_group_cputime() to use
> > for_each_thread() first().
>
> What is the advantage of for_each_thread over while_each_thread,
> besides getting rid of that t = tsk line?

It is buggy and should die, see 0c740d0afc3bff0a097ad.

Oleg.

