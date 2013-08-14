Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab3HNS02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811Ab3HNS0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:26:24 -0400
Date: Wed, 14 Aug 2013 21:27:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
Message-ID: <20130814182745.GB19640@redhat.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 04:04:07PM -0700, Andi Kleen wrote:
> The x86 user access functions (*_user) were originally very well tuned,
> with partial inline code and other optimizations.
> 
> Then over time various new checks -- particularly the sleep checks for
> a voluntary preempt kernel -- destroyed a lot of the tunings
> 
> A typical user access operation is now doing multiple useless
> function calls. Also the without force inline gcc's inlining
> policy makes it even worse, with adding more unnecessary calls.
> 
> Here's a typical example from ftrace:
> 
>      10)               |    might_fault() {
>      10)               |      _cond_resched() {
>      10)               |        should_resched() {
>      10)               |          need_resched() {
>      10)   0.063 us    |            test_ti_thread_flag();
>      10)   0.643 us    |          }
>      10)   1.238 us    |        }
>      10)   1.845 us    |      }
>      10)   2.438 us    |    }
> 
> So we spent 2.5us doing nothing (ok it's a bit less without
> ftrace, but still pretty bad)

Hmm, which kernel version is this?

I thought I fixed this for good in
	commit 114276ac0a3beb9c391a410349bd770653e185ce
	Author: Michael S. Tsirkin <mst@redhat.com>
	Date:   Sun May 26 17:32:13 2013 +0300
	    mm, sched: Drop voluntary schedule from might_fault()

might_fault shouldn't be calling cond_resched anymore.

Did this get reverted at some point?
I hope not, there's more code relying on this now
(see e.g. 662bbcb2747c2422cf98d3d97619509379eee466)

> Then in other cases we would have an out of line function,
> but would actually do the might_sleep() checks in the inlined
> caller. This doesn't make any sense at all.
> 
> There were also a few other problems, for example the x86-64 uaccess
> code regularly falls back to string functions, even though a simple
> mov would be enough. For example every futex access to the lock
> variable would actually use string instructions, even though 
> it's just 4 bytes.
> 
> This patch kit is an attempt to get us back to sane code, 
> mostly by doing proper inlining and doing sleep checks in the right
> place. Unfortunately I had to add one tree sweep to avoid an nasty
> include loop.
> 
> It costs a bit of text space, but I think it's worth it
> (if only to keep my blood pressure down while reading ftrace logs...)
> 
> I haven't done any particular benchmarks, but important low level
> functions just ought to be fast.
> 
> 64bit:
> 13249492        1881328 1159168 16289988         f890c4 vmlinux-before-uaccess
> 13260877        1877232 1159168 16297277         f8ad3d vmlinux-uaccess
> + 11k, +0.08%
> 
> 32bit:
> 11223248         899512 1916928 14039688         d63a88 vmlinux-before-uaccess
> 11230358         895416 1916928 14042702         d6464e vmlinux-uaccess
> + 7k, +0.06%
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
