Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbaCSRPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:15:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58047 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236AbaCSRP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:15:26 -0400
Date: Wed, 19 Mar 2014 10:15:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com
Subject: Re: [PATCH 30/31] arch,doc: Convert smp_mb__*
Message-ID: <20140319171521.GF4405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140319064729.660482086@infradead.org>
 <20140319065205.370836264@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319065205.370836264@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031917-1344-0000-0000-000000631B97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 07:47:59AM +0100, Peter Zijlstra wrote:
> Update the documentation to reflect the change of barrier primitives.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Rest of series:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  Documentation/atomic_ops.txt      |   31 ++++++++++----------------
>  Documentation/memory-barriers.txt |   44 ++++++++++----------------------------
>  2 files changed, 24 insertions(+), 51 deletions(-)
> 
> --- a/Documentation/atomic_ops.txt
> +++ b/Documentation/atomic_ops.txt
> @@ -285,15 +285,13 @@ If a caller requires memory barrier sema
>  operation which does not return a value, a set of interfaces are
>  defined which accomplish this:
> 
> -	void smp_mb__before_atomic_dec(void);
> -	void smp_mb__after_atomic_dec(void);
> -	void smp_mb__before_atomic_inc(void);
> -	void smp_mb__after_atomic_inc(void);
> +	void smp_mb__before_atomic(void);
> +	void smp_mb__after_atomic(void);
> 
> -For example, smp_mb__before_atomic_dec() can be used like so:
> +For example, smp_mb__before_atomic() can be used like so:
> 
>  	obj->dead = 1;
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&obj->ref_count);
> 
>  It makes sure that all memory operations preceding the atomic_dec()
> @@ -302,15 +300,10 @@ operation.  In the above example, it gua
>  "1" to obj->dead will be globally visible to other cpus before the
>  atomic counter decrement.
> 
> -Without the explicit smp_mb__before_atomic_dec() call, the
> +Without the explicit smp_mb__before_atomic() call, the
>  implementation could legally allow the atomic counter update visible
>  to other cpus before the "obj->dead = 1;" assignment.
> 
> -The other three interfaces listed are used to provide explicit
> -ordering with respect to memory operations after an atomic_dec() call
> -(smp_mb__after_atomic_dec()) and around atomic_inc() calls
> -(smp_mb__{before,after}_atomic_inc()).
> -
>  A missing memory barrier in the cases where they are required by the
>  atomic_t implementation above can have disastrous results.  Here is
>  an example, which follows a pattern occurring frequently in the Linux
> @@ -487,12 +480,12 @@ memory operation done by test_and_set_bi
>  Which returns a boolean indicating if bit "nr" is set in the bitmask
>  pointed to by "addr".
> 
> -If explicit memory barriers are required around clear_bit() (which
> -does not return a value, and thus does not need to provide memory
> -barrier semantics), two interfaces are provided:
> +If explicit memory barriers are required around {set,clear}_bit() (which do
> +not return a value, and thus does not need to provide memory barrier
> +semantics), two interfaces are provided:
> 
> -	void smp_mb__before_clear_bit(void);
> -	void smp_mb__after_clear_bit(void);
> +	void smp_mb__before_atomic(void);
> +	void smp_mb__after_atomic(void);
> 
>  They are used as follows, and are akin to their atomic_t operation
>  brothers:
> @@ -500,13 +493,13 @@ They are used as follows, and are akin t
>  	/* All memory operations before this call will
>  	 * be globally visible before the clear_bit().
>  	 */
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit( ... );
> 
>  	/* The clear_bit() will be visible before all
>  	 * subsequent memory operations.
>  	 */
> -	 smp_mb__after_clear_bit();
> +	 smp_mb__after_atomic();
> 
>  There are two special bitops with lock barrier semantics (acquire/release,
>  same as spinlocks). These operate in the same way as their non-_lock/unlock
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1583,20 +1583,21 @@ CPU from reordering them.
>       insert anything more than a compiler barrier in a UP compilation.
> 
> 
> - (*) smp_mb__before_atomic_dec();
> - (*) smp_mb__after_atomic_dec();
> - (*) smp_mb__before_atomic_inc();
> - (*) smp_mb__after_atomic_inc();
> -
> -     These are for use with atomic add, subtract, increment and decrement
> -     functions that don't return a value, especially when used for reference
> -     counting.  These functions do not imply memory barriers.
> + (*) smp_mb__before_atomic();
> + (*) smp_mb__after_atomic();
> +
> +     These are for use with atomic (such as add, subtract, increment and
> +     decrement) functions that don't return a value, especially when used for
> +     reference counting.  These functions do not imply memory barriers.
> +
> +     These are also used for atomic bitop functions that do not return a
> +     value (such as set_bit and clear_bit).
> 
>       As an example, consider a piece of code that marks an object as being dead
>       and then decrements the object's reference count:
> 
>  	obj->dead = 1;
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&obj->ref_count);
> 
>       This makes sure that the death mark on the object is perceived to be set
> @@ -1606,27 +1607,6 @@ CPU from reordering them.
>       operations" subsection for information on where to use these.
> 
> 
> - (*) smp_mb__before_clear_bit(void);
> - (*) smp_mb__after_clear_bit(void);
> -
> -     These are for use similar to the atomic inc/dec barriers.  These are
> -     typically used for bitwise unlocking operations, so care must be taken as
> -     there are no implicit memory barriers here either.
> -
> -     Consider implementing an unlock operation of some nature by clearing a
> -     locking bit.  The clear_bit() would then need to be barriered like this:
> -
> -	smp_mb__before_clear_bit();
> -	clear_bit( ... );
> -
> -     This prevents memory operations before the clear leaking to after it.  See
> -     the subsection on "Locking Functions" with reference to RELEASE operation
> -     implications.
> -
> -     See Documentation/atomic_ops.txt for more information.  See the "Atomic
> -     operations" subsection for information on where to use these.
> -
> -
>  MMIO WRITE BARRIER
>  ------------------
> 
> @@ -2283,11 +2263,11 @@ barriers, but might be used for implemen
>  	change_bit();
> 
>  With these the appropriate explicit memory barrier should be used if necessary
> -(smp_mb__before_clear_bit() for instance).
> +(smp_mb__before_atomic() for instance).
> 
> 
>  The following also do _not_ imply memory barriers, and so may require explicit
> -memory barriers under some circumstances (smp_mb__before_atomic_dec() for
> +memory barriers under some circumstances (smp_mb__before_atomic() for
>  instance):
> 
>  	atomic_add();
> 
> 

