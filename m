Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaGCUIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:08:47 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:59720 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGCUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:08:46 -0400
Message-ID: <1404418122.3179.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2014 13:08:42 -0700
In-Reply-To: <1404416236.3179.18.camel@buesod1.americas.hpqcorp.net>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <1404416236.3179.18.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding lkml.

On Thu, 2014-07-03 at 12:37 -0700, Davidlohr Bueso wrote:
> On Thu, 2014-07-03 at 11:50 -0700, Jason Low wrote:
> > On Wed, Jul 2, 2014 at 7:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > This is what the kernel profile looks like on the strided run:
> > >
> > > -  83.06%  [kernel]  [k] osq_lock
> > >    - osq_lock
> > >       - 100.00% rwsem_down_write_failed
> > >          - call_rwsem_down_write_failed
> > >             - 99.55% sys_mprotect
> > >                  tracesys
> > >                  __GI___mprotect
> > > -  12.02%  [kernel]  [k] rwsem_down_write_failed
> > 
> > Hi Dave,
> > 
> > So with no sign of rwsem_spin_on_owner(), yet with such heavy contention in
> > osq_lock, this makes me wonder if it's spending most of its time spinning
> > on !owner while a reader has the lock? (We don't set sem->owner for the readers.)
> 
> That would explain the long hold times with the memory allocation
> patterns between read and write locking described by Dave.
> 
> > If that's an issue, maybe the below is worth a test, in which we'll just
> > avoid spinning if rwsem_can_spin_on_owner() finds that there is no owner.
> > If we just had to enter the slowpath yet there is no owner, we'll be conservative
> > and assume readers have the lock.
> 
> I do worry a bit about the effects here when this is not an issue.
> Workloads that have smaller hold times could very well take a
> performance hit by blocking right away instead of wasting a few extra
> cycles just spinning.
> 
> > (David, you've tested something like this in the original patch with AIM7 and still
> > got the big performance boosts right?)
> 
> I have not, but will. I wouldn't mind sacrificing a bit of the great
> performance numbers we're getting on workloads that mostly take the lock
> for writing, if it means not being so devastating for when readers are
> in the picture. This is a major difference with mutexes wrt optimistic
> spinning.
> 
> Thanks,
> Davidlohr


