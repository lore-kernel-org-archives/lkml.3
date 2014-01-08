Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaAHN3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:29:01 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37280 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaAHN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:29:00 -0500
Date: Wed, 8 Jan 2014 05:28:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140108132852.GF10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140107181258.GA29288@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107181258.GA29288@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010813-9332-0000-0000-000002B2585C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 07:12:58PM +0100, Oleg Nesterov wrote:
> Hello.
> 
> I tried to audit the users of thread_group_empty() (we need
> to change it) and found rcu_my_thread_group_empty() which
> looks wrong.
> 
> The patches look simple, but I am not sure it is fine to use
> rcu_lock_acquire() directly. Perhaps it makes sense to add a
> new helper? Note that we have more users which take rcu lock
> only to shut up lockdep. Please review.
> 
> And I am a bit confused. Perhaps rcu_lock_acquire() should
> depend on CONFIG_PROVE_RCU, not on CONFIG_DEBUG_LOCK_ALLOC?
> We only need rcu_lock_map/etc for rcu_lockdep_assert().

I am not all that excited about invoking rcu_lock_acquire() outside
of RCU...

Another approach would be to add an argument to files_fdtable()
that is zero normally and one for "we know we don't need RCU
protection."  Then rcu_dereference_check() could be something
like the following:

#define files_fdtable(files, c) \
		(rcu_dereference_check_fdtable((files), (files)->fdt) || c)

Would that work?

							Thanx, Paul

> Oleg.
> 
>  fs/file.c                |   24 +++++++++++-------------
>  include/linux/fdtable.h  |   19 +++++++++++++------
>  include/linux/rcupdate.h |    2 --
>  kernel/rcu/update.c      |   11 -----------
>  4 files changed, 24 insertions(+), 32 deletions(-)
> 

