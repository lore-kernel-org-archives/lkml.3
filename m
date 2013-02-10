Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158Ab3BJTyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 14:54:31 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38732 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021Ab3BJTy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 14:54:29 -0500
Date: Sun, 10 Feb 2013 11:54:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, tj@kernel.org, rusty@rustcorp.com.au,
        mingo@kernel.org, akpm@linux-foundation.org, namhyung@kernel.org,
        rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/45] percpu_rwlock: Implement the core design of
 Per-CPU Reader-Writer Locks
Message-ID: <20130210195417.GK2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
 <20130122073347.13822.85876.stgit@srivatsabhat.in.ibm.com>
 <20130208231017.GK2666@linux.vnet.ibm.com>
 <20130210180607.GA1375@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130210180607.GA1375@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021019-4834-0000-0000-0000038095A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 07:06:07PM +0100, Oleg Nesterov wrote:
> On 02/08, Paul E. McKenney wrote:

[ . . . ]

> > > +static inline void sync_reader(struct percpu_rwlock *pcpu_rwlock,
> > > +			       unsigned int cpu)
> > > +{
> > > +	smp_rmb(); /* Paired with smp_[w]mb() in percpu_read_[un]lock() */
> >
> > As I understand it, the purpose of this memory barrier is to ensure
> > that the stores in drop_writer_signal() happen before the reads from
> > ->reader_refcnt in reader_uses_percpu_refcnt(), thus preventing the
> > race between a new reader attempting to use the fastpath and this writer
> > acquiring the lock.  Unless I am confused, this must be smp_mb() rather
> > than smp_rmb().
> 
> And note that before sync_reader() we call announce_writer_active() which
> already adds mb() before sync_all_readers/sync_reader, so this rmb() looks
> unneeded.
> 
> But, at the same time, could you confirm that we do not need another mb()
> after sync_all_readers() in percpu_write_lock() ? I mean, without mb(),
> can't this reader_uses_percpu_refcnt() LOAD leak into the critical section
> protected by ->global_rwlock? Then this LOAD can be re-ordered with other
> memory operations done by the writer.

As soon as I get the rest of the way through Thomas's patchset.  ;-)

							Thanx, Paul

