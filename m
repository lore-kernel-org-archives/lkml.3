Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaCJPBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:01:21 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:40256 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaCJPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:01:16 -0400
Date: Mon, 10 Mar 2014 11:01:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: deadlock in lru_add_drain ? (3.14rc5)
Message-ID: <20140310150106.GD25290@htj.dyndns.org>
References: <20140308220024.GA814@redhat.com>
 <CA+55aFzLxY8Xsn90v1OAsmVBWYPZTiJ74YE=HaCPYR2hvRfk+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzLxY8Xsn90v1OAsmVBWYPZTiJ74YE=HaCPYR2hvRfk+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Mar 08, 2014 at 05:18:34PM -0800, Linus Torvalds wrote:
> Adding more appropriate people to the cc.
> 
> That semaphore was added by commit 5fbc461636c3 ("mm: make
> lru_add_drain_all() selective"), and acked by Tejun. But we've had

It's essentially custom static implementation of
schedule_on_each_cpu() which uses the mutex to protect the static
buffers.  schedule_on_each_cpu() is different in that it uses dynamic
allocation and can be reentered.

> problems before with holding locks and then calling flush_work(),
> since that has had a tendency of deadlocking. I think we have various
> lockdep hacks in place to make "flush_work()" trigger some of the
> problems, but I'm not convinced it necessarily works.

If this were caused by lru_add_drain_all() entering itself, the
offender must be pretty clear in its stack trace.  It probably
involves more elaborate dependency chain.  No idea why wq lockdep
annotation would trigger on it tho.  The flush_work() annotation is
pretty straight-forward.

> On Sat, Mar 8, 2014 at 2:00 PM, Dave Jones <davej@redhat.com> wrote:
> > I left my fuzzing box running for the weekend, and checked in on it this evening,
> > to find that none of the child processes were making any progress.
> > cat'ing /proc/n/stack shows them all stuck in the same place..
> > Some examples:

Dave, any chance you can post full sysrq-t dump?

Thanks.

-- 
tejun
