Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaIDHLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:11:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:44680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIDHLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:11:44 -0400
Date: Thu, 4 Sep 2014 09:11:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Kautuk Consul <consul.kautuk@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: task_numa_fault() && TASK_DEAD
Message-ID: <20140904071139.GH3190@worktop.ger.corp.intel.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
 <20140901153935.GQ27892@worktop.ger.corp.intel.com>
 <20140901175851.GA15210@redhat.com>
 <20140901190931.GD5806@worktop.ger.corp.intel.com>
 <20140902155208.GA28668@redhat.com>
 <20140902164714.GA17033@redhat.com>
 <20140903160819.GA7682@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903160819.GA7682@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 06:08:19PM +0200, Oleg Nesterov wrote:
> On 09/02, Oleg Nesterov wrote:
> >
> > The usage of TASK_DEAD in task_numa_fault() is wrong in any case.
> 
> Rik, I can't understand why task_numa_fault() needs this check at all,
> but "if (p->state == TASK_DEAD)" looks certainly wrong. You could replace
> this check with BUG_ON(p->state == TASK_DEAD). Perhaps you meant PF_EXITING?

Looking at 82727018b it appears the intent was to make sure we don't
re-create ->numa_fault after we free it. But you're right, we should
never get there with TASK_DEAD.

Also, given that task_numa_free() is called from __put_task_struct() I
tihnk we can safely delete this clause.

> And a stupid (really, I don't understand this code) question:
> 
> 	/* for example, ksmd faulting in a user's mm */
> 	if (!p->mm)
> 		return;

In general kernel threads have !->mm, and those cannot do the
accounting. The only way to get here is through get_user_pages() with
tsk != current and/or mm != current->mm.

> OK, but perhaps it make sense to pass "mm" as another argument and do
> 
> 	/* ksmd faulting in a user's mm, or debugger, or kthread use_mm() caller */
> 	if (p->mm != mm)
> 		return;
> 
> ?

I'm still somewhat fuzzy in the brain but that doesn't appear to
actually work, use_mm() explicitly sets ->mm so in that case it would
match just fine.

That said; I don't think we really need to worry about this. The !->mm
case is special in that that cannot ever work, the other cases are
extremely rare and will not skew accounting much if anything.



