Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbaD1VNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:13:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43178 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbaD1VNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:13:54 -0400
Date: Mon, 28 Apr 2014 14:13:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usage of rcu_dereference_raw
Message-ID: <20140428211343.GJ4430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5355A006.9090502@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5355A006.9090502@gatech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042821-1542-0000-0000-00000168EF68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 06:47:34PM -0400, Pranith Kumar wrote:
> 
> On Mon, Apr 21, 2014 at 6:03 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >>   do most of the uses of rcu_dereference_raw() need to be changed to use other
> >>   dereference functions or are there cases where its usage is valid?
> >
> > The second call from iwl_op_mode_dvm_stop() -might- be valid.  For it
> > to be valid, there must be a grace period between the time that the
> > field was made inaccessible to readers and the time that iwl_uninit_drv()
> > was called.  Usually something like synchronize_rcu() waits for the
> > needed grace period.
> 
> So there are valid use cases of the rcu_dereference_raw() in scenarios where
> we can verify that a grace period has passed.
> 
> Thank you for the info. Mind adding it as a comment as in the patch below?
> 
> add comment for rcu_dereference_raw
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

If we are going to do that, we should probably have a complete list:

1.	The pointer has not yet been made available to readers,
	for example, the access happens during initialization.

2.	A grace period has elapsed since the last time that this
	pointer was available to readers, for example, this access
	happens during clean-up processing within an RCU callback
	function.

3.	Code that is shared among multiple flavors of RCU cannot
	say which flavor of RCU to specify.  Given SRCU, there might
	be an unbounded number to choose from.  This is the reason
	for use of rcu_dereference_raw() in list_for_each_entry_rcu()
	and similar RCU list-traversal macros.

4.	Code that uses a combination of RCU and per-data-structure
	locking, but where a given lock guards not just the data
	structure containing it, but a number of subordinate linked
	structures as well.  Code operating on one of the subordinate
	structures might not know which lock is protecting it.

There probably are others, but that is what comes to mind at the
moment.  Ah, and we should ask that uses of rcu_dereference_raw()
be commented.

							Thanx, Paul

> ---
>  include/linux/rcupdate.h |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 00a7fd6..af40a86 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -662,7 +662,13 @@ static inline void rcu_preempt_sleep_check(void)
>      __rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
>                  __rcu)
> 
> -#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
> +/* rcu_dereference_raw() - rcu_dereference with no checking
> + * @p: The pointer to read, prior to dereferencing
> + *
> + * Use this to dereference a rcu pointer if you are sure that there exists a
> + * grace period between the time this pointer was made inaccessible to readers
> + */
> +#define rcu_dereference_raw(p) rcu_dereference_check(p, 1)
> 
>  /*
>   * The tracing infrastructure traces RCU (we want that), but unfortunately
> -- 
> 1.7.9.5
> 
> 
> -- 
> Pranith
> 

