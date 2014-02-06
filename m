Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaBFTMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:12:15 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51798 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaBFTMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:12:09 -0500
Date: Thu, 6 Feb 2014 11:12:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com
Subject: Re: [RFC][PATCH 3/5] arch:
 s/smp_mb__(before|after)_(atomic|clear)_(dec,inc,bit)/smp_mb__\1/g
Message-ID: <20140206191204.GG4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140206134825.305510953@infradead.org>
 <20140206135001.180858022@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206135001.180858022@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020619-1542-0000-0000-000005D50543
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:48:28PM +0100, Peter Zijlstra wrote:
> Because atomic ops are implemented the same across an architecture,
> the current incomplete set of extra barriers:
> 
>   smp_mb__before_atomic_inc()
>   smp_mb__after_atomic_inc()
>   smp_mb__before_atomic_dec()
>   smp_mb__after_atomic_dec()
>   smp_mb__before_clear_bit()
>   smp_mb__after_clear_bit()
> 
> is both incomplete and superfluous.
> 
> It is incomplete because there are far more atomic operations that do
> not return values -- such as atomic_add(), set_bit() etc. And it is
> superfluous because they're all the same anyway.
> 
> Simplify things by reducing the triplicate set into a single set of
> barriers that is valid for all void atomic ops:
> 
>   smp_mb__before_atomic()
>   smp_mb__after_atomic()
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

I very much like the API shrinkage.  The RCU changes are good, and
I believe that the rest is OK too, though my eyes were going a bit
buggy towards the end...

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  Documentation/atomic_ops.txt                      |   31 ++++--------
>  Documentation/memory-barriers.txt                 |   44 ++++-------------
>  arch/alpha/include/asm/atomic.h                   |    5 -
>  arch/alpha/include/asm/bitops.h                   |    3 -
>  arch/arc/include/asm/atomic.h                     |    5 -
>  arch/arc/include/asm/bitops.h                     |    5 -
>  arch/arm/include/asm/atomic.h                     |    5 -
>  arch/arm/include/asm/barrier.h                    |    3 +
>  arch/arm/include/asm/bitops.h                     |    4 -
>  arch/arm64/include/asm/atomic.h                   |    5 -
>  arch/arm64/include/asm/barrier.h                  |    3 +
>  arch/arm64/include/asm/bitops.h                   |    9 ---
>  arch/avr32/include/asm/atomic.h                   |    5 -
>  arch/avr32/include/asm/bitops.h                   |    9 ---
>  arch/blackfin/include/asm/barrier.h               |    3 +
>  arch/blackfin/include/asm/bitops.h                |   14 -----
>  arch/c6x/include/asm/bitops.h                     |    8 ---
>  arch/cris/include/asm/atomic.h                    |    7 --
>  arch/cris/include/asm/bitops.h                    |    9 ---
>  arch/frv/include/asm/atomic.h                     |    7 --
>  arch/frv/include/asm/bitops.h                     |    6 --
>  arch/hexagon/include/asm/atomic.h                 |    6 --
>  arch/hexagon/include/asm/bitops.h                 |    4 -
>  arch/ia64/include/asm/atomic.h                    |    6 --
>  arch/ia64/include/asm/barrier.h                   |    3 +
>  arch/ia64/include/asm/bitops.h                    |    6 --
>  arch/m32r/include/asm/atomic.h                    |    7 --
>  arch/m32r/include/asm/bitops.h                    |    6 --
>  arch/m68k/include/asm/atomic.h                    |    8 ---
>  arch/m68k/include/asm/bitops.h                    |    7 --
>  arch/metag/include/asm/atomic.h                   |    6 --
>  arch/metag/include/asm/barrier.h                  |    3 +
>  arch/metag/include/asm/bitops.h                   |    6 --
>  arch/mips/include/asm/atomic.h                    |    9 ---
>  arch/mips/include/asm/barrier.h                   |    3 +
>  arch/mips/include/asm/bitops.h                    |   11 ----
>  arch/mips/kernel/irq.c                            |    4 -
>  arch/mn10300/include/asm/atomic.h                 |    7 --
>  arch/mn10300/include/asm/bitops.h                 |    4 -
>  arch/mn10300/mm/tlb-smp.c                         |    4 -
>  arch/openrisc/include/asm/bitops.h                |    9 ---
>  arch/parisc/include/asm/atomic.h                  |    6 --
>  arch/parisc/include/asm/bitops.h                  |    4 -
>  arch/powerpc/include/asm/atomic.h                 |    6 --
>  arch/powerpc/include/asm/barrier.h                |    3 +
>  arch/powerpc/include/asm/bitops.h                 |    6 --
>  arch/powerpc/kernel/crash.c                       |    2 
>  arch/s390/include/asm/atomic.h                    |    6 --
>  arch/s390/include/asm/barrier.h                   |    5 +
>  arch/s390/include/asm/bitops.h                    |    1 
>  arch/score/include/asm/bitops.h                   |    7 --
>  arch/sh/include/asm/atomic.h                      |    6 --
>  arch/sh/include/asm/bitops.h                      |    7 --
>  arch/sparc/include/asm/atomic_32.h                |    7 --
>  arch/sparc/include/asm/atomic_64.h                |    7 --
>  arch/sparc/include/asm/barrier_64.h               |    3 +
>  arch/sparc/include/asm/bitops_32.h                |    4 -
>  arch/sparc/include/asm/bitops_64.h                |    4 -
>  arch/tile/include/asm/atomic_32.h                 |   10 ---
>  arch/tile/include/asm/atomic_64.h                 |    6 --
>  arch/tile/include/asm/barrier.h                   |   14 +++++
>  arch/tile/include/asm/bitops.h                    |    1 
>  arch/tile/include/asm/bitops_32.h                 |    8 ---
>  arch/tile/include/asm/bitops_64.h                 |    4 -
>  arch/x86/include/asm/atomic.h                     |    7 --
>  arch/x86/include/asm/barrier.h                    |    4 +
>  arch/x86/include/asm/bitops.h                     |    6 --
>  arch/x86/include/asm/sync_bitops.h                |    2 
>  arch/x86/kernel/apic/hw_nmi.c                     |    2 
>  arch/xtensa/include/asm/atomic.h                  |    7 --
>  arch/xtensa/include/asm/bitops.h                  |    4 -
>  block/blk-iopoll.c                                |    4 -
>  crypto/chainiv.c                                  |    2 
>  drivers/base/power/domain.c                       |    2 
>  drivers/block/mtip32xx/mtip32xx.c                 |    4 -
>  drivers/cpuidle/coupled.c                         |    2 
>  drivers/firewire/ohci.c                           |    2 
>  drivers/gpu/drm/drm_irq.c                         |   10 +--
>  drivers/gpu/drm/i915/i915_irq.c                   |    2 
>  drivers/md/bcache/bcache.h                        |    2 
>  drivers/md/bcache/closure.h                       |    2 
>  drivers/md/dm-bufio.c                             |    8 +--
>  drivers/md/dm-snap.c                              |    4 -
>  drivers/md/dm.c                                   |    2 
>  drivers/md/raid5.c                                |    2 
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c       |    6 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |    6 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   34 ++++++-------
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |   26 +++++-----
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |   12 ++--
>  drivers/net/ethernet/broadcom/cnic.c              |    8 +--
>  drivers/net/ethernet/brocade/bna/bnad.c           |    6 +-
>  drivers/net/ethernet/chelsio/cxgb/cxgb2.c         |    2 
>  drivers/net/ethernet/chelsio/cxgb3/sge.c          |    6 +-
>  drivers/net/ethernet/chelsio/cxgb4/sge.c          |    2 
>  drivers/net/ethernet/chelsio/cxgb4vf/sge.c        |    2 
>  drivers/net/ethernet/intel/i40e/i40e_main.c       |    2 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    4 -
>  drivers/net/wireless/ti/wlcore/main.c             |    2 
>  drivers/pci/xen-pcifront.c                        |    4 -
>  drivers/scsi/isci/remote_device.c                 |    2 
>  drivers/target/loopback/tcm_loop.c                |    4 -
>  drivers/target/target_core_alua.c                 |   26 +++++-----
>  drivers/target/target_core_device.c               |    6 +-
>  drivers/target/target_core_iblock.c               |    2 
>  drivers/target/target_core_pr.c                   |   56 +++++++++++-----------
>  drivers/target/target_core_transport.c            |   16 +++---
>  drivers/target/target_core_ua.c                   |   10 +--
>  drivers/tty/n_tty.c                               |    2 
>  drivers/tty/serial/mxs-auart.c                    |    4 -
>  drivers/usb/gadget/tcm_usb_gadget.c               |    4 -
>  drivers/usb/serial/usb_wwan.c                     |    2 
>  drivers/vhost/scsi.c                              |    2 
>  drivers/w1/w1_family.c                            |    4 -
>  drivers/xen/xen-pciback/pciback_ops.c             |    4 -
>  fs/btrfs/btrfs_inode.h                            |    2 
>  fs/btrfs/extent_io.c                              |    2 
>  fs/btrfs/inode.c                                  |    6 +-
>  fs/buffer.c                                       |    2 
>  fs/ext4/resize.c                                  |    2 
>  fs/gfs2/glock.c                                   |    8 +--
>  fs/gfs2/glops.c                                   |    2 
>  fs/gfs2/lock_dlm.c                                |    4 -
>  fs/gfs2/recovery.c                                |    2 
>  fs/gfs2/sys.c                                     |    4 -
>  fs/jbd2/commit.c                                  |    6 +-
>  fs/nfs/dir.c                                      |   12 ++--
>  fs/nfs/inode.c                                    |    2 
>  fs/nfs/nfs4filelayoutdev.c                        |    4 -
>  fs/nfs/nfs4state.c                                |    4 -
>  fs/nfs/pagelist.c                                 |    6 +-
>  fs/nfs/pnfs.c                                     |    2 
>  fs/nfs/pnfs.h                                     |    2 
>  fs/nfs/write.c                                    |    4 -
>  fs/ubifs/lpt_commit.c                             |    4 -
>  fs/ubifs/tnc_commit.c                             |    4 -
>  include/asm-generic/atomic.h                      |    7 --
>  include/asm-generic/barrier.h                     |    8 +++
>  include/asm-generic/bitops.h                      |    8 ---
>  include/asm-generic/bitops/atomic.h               |    2 
>  include/asm-generic/bitops/lock.h                 |    2 
>  include/linux/buffer_head.h                       |    2 
>  include/linux/genhd.h                             |    2 
>  include/linux/interrupt.h                         |    8 +--
>  include/linux/netdevice.h                         |    2 
>  include/linux/sched.h                             |    6 --
>  include/linux/sunrpc/sched.h                      |    8 +--
>  include/linux/sunrpc/xprt.h                       |    8 +--
>  include/linux/tracehook.h                         |    2 
>  include/net/ip_vs.h                               |    4 -
>  kernel/debug/debug_core.c                         |    4 -
>  kernel/futex.c                                    |    2 
>  kernel/kmod.c                                     |    2 
>  kernel/rcu/tree.c                                 |   22 ++++----
>  kernel/rcu/tree_plugin.h                          |    8 +--
>  kernel/sched/cpupri.c                             |    6 +-
>  kernel/sched/wait.c                               |    2 
>  mm/backing-dev.c                                  |    2 
>  mm/filemap.c                                      |    4 -
>  net/atm/pppoatm.c                                 |    2 
>  net/bluetooth/hci_event.c                         |    4 -
>  net/core/dev.c                                    |    8 +--
>  net/core/link_watch.c                             |    2 
>  net/ipv4/inetpeer.c                               |    2 
>  net/netfilter/nf_conntrack_core.c                 |    2 
>  net/rds/ib_recv.c                                 |    4 -
>  net/rds/iw_recv.c                                 |    4 -
>  net/rds/send.c                                    |    6 +-
>  net/rds/tcp_send.c                                |    2 
>  net/sunrpc/auth.c                                 |    2 
>  net/sunrpc/auth_gss/auth_gss.c                    |    2 
>  net/sunrpc/backchannel_rqst.c                     |    4 -
>  net/sunrpc/xprt.c                                 |    4 -
>  net/sunrpc/xprtsock.c                             |   16 +++---
>  net/unix/af_unix.c                                |    2 
>  sound/pci/bt87x.c                                 |    4 -
>  176 files changed, 415 insertions(+), 642 deletions(-)
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
> @@ -1553,20 +1553,21 @@ CPU from reordering them.
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
> @@ -1576,27 +1577,6 @@ CPU from reordering them.
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
> @@ -2222,11 +2202,11 @@ barriers, but might be used for implemen
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
> --- a/arch/alpha/include/asm/atomic.h
> +++ b/arch/alpha/include/asm/atomic.h
> @@ -292,9 +292,4 @@ static inline long atomic64_dec_if_posit
>  #define atomic_dec(v) atomic_sub(1,(v))
>  #define atomic64_dec(v) atomic64_sub(1,(v))
> 
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  #endif /* _ALPHA_ATOMIC_H */
> --- a/arch/alpha/include/asm/bitops.h
> +++ b/arch/alpha/include/asm/bitops.h
> @@ -53,9 +53,6 @@ __set_bit(unsigned long nr, volatile voi
>  	*m |= 1 << (nr & 31);
>  }
> 
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -
>  static inline void
>  clear_bit(unsigned long nr, volatile void * addr)
>  {
> --- a/arch/arc/include/asm/atomic.h
> +++ b/arch/arc/include/asm/atomic.h
> @@ -190,11 +190,6 @@ static inline void atomic_clear_mask(uns
> 
>  #endif /* !CONFIG_ARC_HAS_LLSC */
> 
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  /**
>   * __atomic_add_unless - add unless the number is a given value
>   * @v: pointer of type atomic_t
> --- a/arch/arc/include/asm/bitops.h
> +++ b/arch/arc/include/asm/bitops.h
> @@ -19,6 +19,7 @@
> 
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * Hardware assisted read-modify-write using ARC700 LLOCK/SCOND insns.
> @@ -496,10 +497,6 @@ static inline __attribute__ ((const)) in
>   */
>  #define ffz(x)	__ffs(~(x))
> 
> -/* TODO does this affect uni-processor code */
> -#define smp_mb__before_clear_bit()  barrier()
> -#define smp_mb__after_clear_bit()   barrier()
> -
>  #include <asm-generic/bitops/hweight.h>
>  #include <asm-generic/bitops/fls64.h>
>  #include <asm-generic/bitops/sched.h>
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -211,11 +211,6 @@ static inline int __atomic_add_unless(at
> 
>  #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
> 
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  #ifndef CONFIG_GENERIC_ATOMIC64
>  typedef struct {
>  	long long counter;
> --- a/arch/arm/include/asm/barrier.h
> +++ b/arch/arm/include/asm/barrier.h
> @@ -79,5 +79,8 @@ do {									\
> 
>  #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
> 
> +#define smp_mb__before_atomic()	smp_mb()
> +#define smp_mb__after_atomic()	smp_mb()
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* __ASM_BARRIER_H */
> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -25,9 +25,7 @@
> 
>  #include <linux/compiler.h>
>  #include <linux/irqflags.h>
> -
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> +#include <asm/barrier.h>
> 
>  /*
>   * These functions are the basis of our bit ops.
> --- a/arch/arm64/include/asm/atomic.h
> +++ b/arch/arm64/include/asm/atomic.h
> @@ -154,11 +154,6 @@ static inline int __atomic_add_unless(at
> 
>  #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
> 
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  /*
>   * 64-bit atomic operations.
>   */
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -97,6 +97,9 @@ do {									\
>  #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
>  #define nop()		asm volatile("nop");
> 
> +#define smp_mb__before_atomic()	smp_mb()
> +#define smp_mb__after_atomic()	smp_mb()
> +
>  #endif	/* __ASSEMBLY__ */
> 
>  #endif	/* __ASM_BARRIER_H */
> --- a/arch/arm64/include/asm/bitops.h
> +++ b/arch/arm64/include/asm/bitops.h
> @@ -17,17 +17,8 @@
>  #define __ASM_BITOPS_H
> 
>  #include <linux/compiler.h>
> -
>  #include <asm/barrier.h>
> 
> -/*
> - * clear_bit may not imply a memory barrier
> - */
> -#ifndef smp_mb__before_clear_bit
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -#endif
> -
>  #ifndef _LINUX_BITOPS_H
>  #error only <linux/bitops.h> can be included directly
>  #endif
> --- a/arch/avr32/include/asm/atomic.h
> +++ b/arch/avr32/include/asm/atomic.h
> @@ -183,9 +183,4 @@ static inline int atomic_sub_if_positive
> 
>  #define atomic_dec_if_positive(v) atomic_sub_if_positive(1, v)
> 
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /*  __ASM_AVR32_ATOMIC_H */
> --- a/arch/avr32/include/asm/bitops.h
> +++ b/arch/avr32/include/asm/bitops.h
> @@ -13,12 +13,7 @@
>  #endif
> 
>  #include <asm/byteorder.h>
> -
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler
> - */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> +#include <asm/barrier.h>
> 
>  /*
>   * set_bit - Atomically set a bit in memory
> @@ -67,7 +62,7 @@ static inline void set_bit(int nr, volat
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static inline void clear_bit(int nr, volatile void * addr)
> --- a/arch/blackfin/include/asm/barrier.h
> +++ b/arch/blackfin/include/asm/barrier.h
> @@ -27,6 +27,9 @@
> 
>  #endif /* !CONFIG_SMP */
> 
> +#define smp_mb__before_atomic()	barrier()
> +#define smp_mb__after_atomic()	barrier()
> +
>  #include <asm-generic/barrier.h>
> 
>  #endif /* _BLACKFIN_BARRIER_H */
> --- a/arch/blackfin/include/asm/bitops.h
> +++ b/arch/blackfin/include/asm/bitops.h
> @@ -27,21 +27,17 @@
> 
>  #include <asm-generic/bitops/ext2-atomic.h>
> 
> +#include <asm/barrier.h>
> +
>  #ifndef CONFIG_SMP
>  #include <linux/irqflags.h>
> -
>  /*
>   * clear_bit may not imply a memory barrier
>   */
> -#ifndef smp_mb__before_clear_bit
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -#endif
>  #include <asm-generic/bitops/atomic.h>
>  #include <asm-generic/bitops/non-atomic.h>
>  #else
> 
> -#include <asm/barrier.h>
>  #include <asm/byteorder.h>	/* swab32 */
>  #include <linux/linkage.h>
> 
> @@ -101,12 +97,6 @@ static inline int test_and_change_bit(in
>  	return __raw_bit_test_toggle_asm(a, nr & 0x1f);
>  }
> 
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  #define test_bit __skip_test_bit
>  #include <asm-generic/bitops/non-atomic.h>
>  #undef test_bit
> --- a/arch/c6x/include/asm/bitops.h
> +++ b/arch/c6x/include/asm/bitops.h
> @@ -14,14 +14,8 @@
>  #ifdef __KERNEL__
> 
>  #include <linux/bitops.h>
> -
>  #include <asm/byteorder.h>
> -
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit() barrier()
> -#define smp_mb__after_clear_bit()  barrier()
> +#include <asm/barrier.h>
> 
>  /*
>   * We are lucky, DSP is perfect for bitops: do it in 3 cycles
> --- a/arch/cris/include/asm/atomic.h
> +++ b/arch/cris/include/asm/atomic.h
> @@ -6,6 +6,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
>  #include <arch/atomic.h>
> 
>  /*
> @@ -151,10 +152,4 @@ static inline int __atomic_add_unless(at
>  	return ret;
>  }
> 
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()    barrier()
> -#define smp_mb__after_atomic_dec()     barrier()
> -#define smp_mb__before_atomic_inc()    barrier()
> -#define smp_mb__after_atomic_inc()     barrier()
> -
>  #endif
> --- a/arch/cris/include/asm/bitops.h
> +++ b/arch/cris/include/asm/bitops.h
> @@ -21,6 +21,7 @@
>  #include <arch/bitops.h>
>  #include <linux/atomic.h>
>  #include <linux/compiler.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * set_bit - Atomically set a bit in memory
> @@ -42,7 +43,7 @@
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
> 
> @@ -84,12 +85,6 @@ static inline int test_and_set_bit(int n
>  	return retval;
>  }
> 
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()      barrier()
> -#define smp_mb__after_clear_bit()       barrier()
> -
>  /**
>   * test_and_clear_bit - Clear a bit and return its old value
>   * @nr: Bit to clear
> --- a/arch/frv/include/asm/atomic.h
> +++ b/arch/frv/include/asm/atomic.h
> @@ -17,6 +17,7 @@
>  #include <linux/types.h>
>  #include <asm/spr-regs.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #ifdef CONFIG_SMP
>  #error not SMP safe
> @@ -29,12 +30,6 @@
>   * We do not have SMP systems, so we don't have to deal with that.
>   */
> 
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #define ATOMIC_INIT(i)		{ (i) }
>  #define atomic_read(v)		(*(volatile int *)&(v)->counter)
>  #define atomic_set(v, i)	(((v)->counter) = (i))
> --- a/arch/frv/include/asm/bitops.h
> +++ b/arch/frv/include/asm/bitops.h
> @@ -25,12 +25,6 @@
> 
>  #include <asm-generic/bitops/ffz.h>
> 
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
>  static inline
>  unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
> --- a/arch/hexagon/include/asm/atomic.h
> +++ b/arch/hexagon/include/asm/atomic.h
> @@ -24,6 +24,7 @@
> 
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #define ATOMIC_INIT(i)		{ (i) }
>  #define atomic_set(v, i)	((v)->counter = (i))
> @@ -163,9 +164,4 @@ static inline int __atomic_add_unless(at
>  #define atomic_inc_return(v) (atomic_add_return(1, v))
>  #define atomic_dec_return(v) (atomic_sub_return(1, v))
> 
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif
> --- a/arch/hexagon/include/asm/bitops.h
> +++ b/arch/hexagon/include/asm/bitops.h
> @@ -25,12 +25,10 @@
>  #include <linux/compiler.h>
>  #include <asm/byteorder.h>
>  #include <asm/atomic.h>
> +#include <asm/barrier.h>
> 
>  #ifdef __KERNEL__
> 
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  /*
>   * The offset calculations for these are based on BITS_PER_LONG == 32
>   * (i.e. I get to shift by #5-2 (32 bits per long, 4 bytes per access),
> --- a/arch/ia64/include/asm/atomic.h
> +++ b/arch/ia64/include/asm/atomic.h
> @@ -208,10 +208,4 @@ atomic64_add_negative (__s64 i, atomic64
>  #define atomic64_inc(v)			atomic64_add(1, (v))
>  #define atomic64_dec(v)			atomic64_sub(1, (v))
> 
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* _ASM_IA64_ATOMIC_H */
> --- a/arch/ia64/include/asm/barrier.h
> +++ b/arch/ia64/include/asm/barrier.h
> @@ -55,6 +55,9 @@
> 
>  #endif
> 
> +#define smp_mb__before_atomic()	barrier()
> +#define smp_mb__after_atomic()	barrier()
> +
>  /*
>   * IA64 GCC turns volatile stores into st.rel and volatile loads into ld.acq no
>   * need for asm trickery!
> --- a/arch/ia64/include/asm/bitops.h
> +++ b/arch/ia64/include/asm/bitops.h
> @@ -16,6 +16,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <asm/intrinsics.h>
> +#include <asm/barrier.h>
> 
>  /**
>   * set_bit - Atomically set a bit in memory
> @@ -65,9 +66,6 @@ __set_bit (int nr, volatile void *addr)
>  	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
>  }
> 
> -#define smp_mb__before_clear_bit()	barrier();
> -#define smp_mb__after_clear_bit()	barrier();
> -
>  /**
>   * clear_bit - Clears a bit in memory
>   * @nr: Bit to clear
> @@ -75,7 +73,7 @@ __set_bit (int nr, volatile void *addr)
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static __inline__ void
> --- a/arch/m32r/include/asm/atomic.h
> +++ b/arch/m32r/include/asm/atomic.h
> @@ -13,6 +13,7 @@
>  #include <asm/assembler.h>
>  #include <asm/cmpxchg.h>
>  #include <asm/dcache_clear.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
> @@ -308,10 +309,4 @@ static __inline__ void atomic_set_mask(u
>  	local_irq_restore(flags);
>  }
> 
> -/* Atomic operations are already serializing on m32r */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif	/* _ASM_M32R_ATOMIC_H */
> --- a/arch/m32r/include/asm/bitops.h
> +++ b/arch/m32r/include/asm/bitops.h
> @@ -21,6 +21,7 @@
>  #include <asm/byteorder.h>
>  #include <asm/dcache_clear.h>
>  #include <asm/types.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * These have to be done with inline assembly: that way the bit-setting
> @@ -73,7 +74,7 @@ static __inline__ void set_bit(int nr, v
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static __inline__ void clear_bit(int nr, volatile void * addr)
> @@ -103,9 +104,6 @@ static __inline__ void clear_bit(int nr,
>  	local_irq_restore(flags);
>  }
> 
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  /**
>   * change_bit - Toggle a bit in memory
>   * @nr: Bit to clear
> --- a/arch/m68k/include/asm/atomic.h
> +++ b/arch/m68k/include/asm/atomic.h
> @@ -4,6 +4,7 @@
>  #include <linux/types.h>
>  #include <linux/irqflags.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
> @@ -209,11 +210,4 @@ static __inline__ int __atomic_add_unles
>  	return c;
>  }
> 
> -
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* __ARCH_M68K_ATOMIC __ */
> --- a/arch/m68k/include/asm/bitops.h
> +++ b/arch/m68k/include/asm/bitops.h
> @@ -13,6 +13,7 @@
>  #endif
> 
>  #include <linux/compiler.h>
> +#include <asm/barrier.h>
> 
>  /*
>   *	Bit access functions vary across the ColdFire and 68k families.
> @@ -67,12 +68,6 @@ static inline void bfset_mem_set_bit(int
>  #define __set_bit(nr, vaddr)	set_bit(nr, vaddr)
> 
> 
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  static inline void bclr_reg_clear_bit(int nr, volatile unsigned long *vaddr)
>  {
>  	char *p = (char *)vaddr + (nr ^ 31) / 8;
> --- a/arch/metag/include/asm/atomic.h
> +++ b/arch/metag/include/asm/atomic.h
> @@ -4,6 +4,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #if defined(CONFIG_METAG_ATOMICITY_IRQSOFF)
>  /* The simple UP case. */
> @@ -39,11 +40,6 @@
> 
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> 
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif
> 
>  #define atomic_dec_if_positive(v)       atomic_sub_if_positive(1, v)
> --- a/arch/metag/include/asm/barrier.h
> +++ b/arch/metag/include/asm/barrier.h
> @@ -97,4 +97,7 @@ do {									\
>  	___p1;								\
>  })
> 
> +#define smp_mb__before_atomic()	barrier()
> +#define smp_mb__after_atomic()	barrier()
> +
>  #endif /* _ASM_METAG_BARRIER_H */
> --- a/arch/metag/include/asm/bitops.h
> +++ b/arch/metag/include/asm/bitops.h
> @@ -5,12 +5,6 @@
>  #include <asm/barrier.h>
>  #include <asm/global_lock.h>
> 
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  #ifdef CONFIG_SMP
>  /*
>   * These functions are the basis of our bit ops.
> --- a/arch/mips/include/asm/atomic.h
> +++ b/arch/mips/include/asm/atomic.h
> @@ -761,13 +761,4 @@ static __inline__ int atomic64_add_unles
> 
>  #endif /* CONFIG_64BIT */
> 
> -/*
> - * atomic*_return operations are serializing but not the non-*_return
> - * versions.
> - */
> -#define smp_mb__before_atomic_dec()	smp_mb__before_llsc()
> -#define smp_mb__after_atomic_dec()	smp_llsc_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb__before_llsc()
> -#define smp_mb__after_atomic_inc()	smp_llsc_mb()
> -
>  #endif /* _ASM_ATOMIC_H */
> --- a/arch/mips/include/asm/barrier.h
> +++ b/arch/mips/include/asm/barrier.h
> @@ -195,4 +195,7 @@ do {									\
>  	___p1;								\
>  })
> 
> +#define smp_mb__before_atomic()	smp_mb__before_llsc()
> +#define smp_mb__after_atomic()	smp_llsc_mb()
> +
>  #endif /* __ASM_BARRIER_H */
> --- a/arch/mips/include/asm/bitops.h
> +++ b/arch/mips/include/asm/bitops.h
> @@ -38,13 +38,6 @@
>  #endif
> 
>  /*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	smp_mb__before_llsc()
> -#define smp_mb__after_clear_bit()	smp_llsc_mb()
> -
> -
> -/*
>   * These are the "slower" versions of the functions and are in bitops.c.
>   * These functions call raw_local_irq_{save,restore}().
>   */
> @@ -120,7 +113,7 @@ static inline void set_bit(unsigned long
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static inline void clear_bit(unsigned long nr, volatile unsigned long *addr)
> @@ -175,7 +168,7 @@ static inline void clear_bit(unsigned lo
>   */
>  static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(nr, addr);
>  }
> 
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -62,9 +62,9 @@ void __init alloc_legacy_irqno(void)
> 
>  void free_irqno(unsigned int irq)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(irq, irq_map);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  /*
> --- a/arch/mn10300/include/asm/atomic.h
> +++ b/arch/mn10300/include/asm/atomic.h
> @@ -13,6 +13,7 @@
> 
>  #include <asm/irqflags.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #ifndef CONFIG_SMP
>  #include <asm-generic/atomic.h>
> @@ -234,12 +235,6 @@ static inline void atomic_set_mask(unsig
>  #endif
>  }
> 
> -/* Atomic operations are already serializing on MN10300??? */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* __KERNEL__ */
>  #endif /* CONFIG_SMP */
>  #endif /* _ASM_ATOMIC_H */
> --- a/arch/mn10300/include/asm/bitops.h
> +++ b/arch/mn10300/include/asm/bitops.h
> @@ -18,9 +18,7 @@
>  #define __ASM_BITOPS_H
> 
>  #include <asm/cpu-regs.h>
> -
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> +#include <asm/barrier.h>
> 
>  /*
>   * set bit
> --- a/arch/mn10300/mm/tlb-smp.c
> +++ b/arch/mn10300/mm/tlb-smp.c
> @@ -78,9 +78,9 @@ void smp_flush_tlb(void *unused)
>  	else
>  		local_flush_tlb_page(flush_mm, flush_va);
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	cpumask_clear_cpu(cpu_id, &flush_cpumask);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  out:
>  	put_cpu();
>  }
> --- a/arch/openrisc/include/asm/bitops.h
> +++ b/arch/openrisc/include/asm/bitops.h
> @@ -27,14 +27,7 @@
> 
>  #include <linux/irqflags.h>
>  #include <linux/compiler.h>
> -
> -/*
> - * clear_bit may not imply a memory barrier
> - */
> -#ifndef smp_mb__before_clear_bit
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -#endif
> +#include <asm/barrier.h>
> 
>  #include <asm/bitops/__ffs.h>
>  #include <asm-generic/bitops/ffz.h>
> --- a/arch/parisc/include/asm/atomic.h
> +++ b/arch/parisc/include/asm/atomic.h
> @@ -7,6 +7,7 @@
> 
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
> @@ -143,11 +144,6 @@ static __inline__ int __atomic_add_unles
> 
>  #define ATOMIC_INIT(i)	{ (i) }
> 
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  #ifdef CONFIG_64BIT
> 
>  #define ATOMIC64_INIT(i) { (i) }
> --- a/arch/parisc/include/asm/bitops.h
> +++ b/arch/parisc/include/asm/bitops.h
> @@ -8,6 +8,7 @@
>  #include <linux/compiler.h>
>  #include <asm/types.h>		/* for BITS_PER_LONG/SHIFT_PER_LONG */
>  #include <asm/byteorder.h>
> +#include <asm/barrier.h>
>  #include <linux/atomic.h>
> 
>  /*
> @@ -19,9 +20,6 @@
>  #define CHOP_SHIFTCOUNT(x) (((unsigned long) (x)) & (BITS_PER_LONG - 1))
> 
> 
> -#define smp_mb__before_clear_bit()      smp_mb()
> -#define smp_mb__after_clear_bit()       smp_mb()
> -
>  /* See http://marc.theaimsgroup.com/?t=108826637900003 for discussion
>   * on use of volatile and __*_bit() (set/clear/change):
>   *	*_bit() want use of volatile.
> --- a/arch/powerpc/include/asm/atomic.h
> +++ b/arch/powerpc/include/asm/atomic.h
> @@ -8,6 +8,7 @@
>  #ifdef __KERNEL__
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #define ATOMIC_INIT(i)		{ (i) }
> 
> @@ -270,11 +271,6 @@ static __inline__ int atomic_dec_if_posi
>  }
>  #define atomic_dec_if_positive atomic_dec_if_positive
> 
> -#define smp_mb__before_atomic_dec()     smp_mb()
> -#define smp_mb__after_atomic_dec()      smp_mb()
> -#define smp_mb__before_atomic_inc()     smp_mb()
> -#define smp_mb__after_atomic_inc()      smp_mb()
> -
>  #ifdef __powerpc64__
> 
>  #define ATOMIC64_INIT(i)	{ (i) }
> --- a/arch/powerpc/include/asm/barrier.h
> +++ b/arch/powerpc/include/asm/barrier.h
> @@ -84,4 +84,7 @@ do {									\
>  	___p1;								\
>  })
> 
> +#define smp_mb__before_atomic()     smp_mb()
> +#define smp_mb__after_atomic()      smp_mb()
> +
>  #endif /* _ASM_POWERPC_BARRIER_H */
> --- a/arch/powerpc/include/asm/bitops.h
> +++ b/arch/powerpc/include/asm/bitops.h
> @@ -51,11 +51,7 @@
>  #define PPC_BIT(bit)		(1UL << PPC_BITLSHIFT(bit))
>  #define PPC_BITMASK(bs, be)	((PPC_BIT(bs) - PPC_BIT(be)) | PPC_BIT(bs))
> 
> -/*
> - * clear_bit doesn't imply a memory barrier
> - */
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> +#include <asm/barrier.h>
> 
>  /* Macro for generating the ***_bits() functions */
>  #define DEFINE_BITOP(fn, op, prefix)		\
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -81,7 +81,7 @@ void crash_ipi_callback(struct pt_regs *
>  	}
> 
>  	atomic_inc(&cpus_in_crash);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
> 
>  	/*
>  	 * Starting the kdump boot.
> --- a/arch/s390/include/asm/atomic.h
> +++ b/arch/s390/include/asm/atomic.h
> @@ -16,6 +16,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #define ATOMIC_INIT(i)  { (i) }
> 
> @@ -398,9 +399,4 @@ static inline long long atomic64_dec_if_
>  #define atomic64_dec_and_test(_v)	(atomic64_sub_return(1, _v) == 0)
>  #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
> 
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  #endif /* __ARCH_S390_ATOMIC__  */
> --- a/arch/s390/include/asm/barrier.h
> +++ b/arch/s390/include/asm/barrier.h
> @@ -27,8 +27,9 @@
>  #define smp_rmb()			rmb()
>  #define smp_wmb()			wmb()
>  #define smp_read_barrier_depends()	read_barrier_depends()
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> +
> +#define smp_mb__before_atomic()	smp_mb()
> +#define smp_mb__after_atomic()	smp_mb()
> 
>  #define set_mb(var, value)		do { var = value; mb(); } while (0)
> 
> --- a/arch/s390/include/asm/bitops.h
> +++ b/arch/s390/include/asm/bitops.h
> @@ -47,6 +47,7 @@
> 
>  #include <linux/typecheck.h>
>  #include <linux/compiler.h>
> +#include <asm/barrier.h>
> 
>  #ifndef CONFIG_64BIT
> 
> --- a/arch/score/include/asm/bitops.h
> +++ b/arch/score/include/asm/bitops.h
> @@ -2,12 +2,7 @@
>  #define _ASM_SCORE_BITOPS_H
> 
>  #include <asm/byteorder.h> /* swab32 */
> -
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> +#include <asm/barrier.h>
> 
>  #include <asm-generic/bitops.h>
>  #include <asm-generic/bitops/__fls.h>
> --- a/arch/sh/include/asm/atomic.h
> +++ b/arch/sh/include/asm/atomic.h
> @@ -10,6 +10,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #define ATOMIC_INIT(i)	{ (i) }
> 
> @@ -62,9 +63,4 @@ static inline int __atomic_add_unless(at
>  	return c;
>  }
> 
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  #endif /* __ASM_SH_ATOMIC_H */
> --- a/arch/sh/include/asm/bitops.h
> +++ b/arch/sh/include/asm/bitops.h
> @@ -9,6 +9,7 @@
> 
>  /* For __swab32 */
>  #include <asm/byteorder.h>
> +#include <asm/barrier.h>
> 
>  #ifdef CONFIG_GUSA_RB
>  #include <asm/bitops-grb.h>
> @@ -22,12 +23,6 @@
>  #include <asm-generic/bitops/non-atomic.h>
>  #endif
> 
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -
>  #ifdef CONFIG_SUPERH32
>  static inline unsigned long ffz(unsigned long word)
>  {
> --- a/arch/sparc/include/asm/atomic_32.h
> +++ b/arch/sparc/include/asm/atomic_32.h
> @@ -14,6 +14,7 @@
>  #include <linux/types.h>
> 
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
>  #include <asm-generic/atomic64.h>
> 
> 
> @@ -52,10 +53,4 @@ extern void atomic_set(atomic_t *, int);
>  #define atomic_dec_and_test(v) (atomic_dec_return(v) == 0)
>  #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
> 
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* !(__ARCH_SPARC_ATOMIC__) */
> --- a/arch/sparc/include/asm/atomic_64.h
> +++ b/arch/sparc/include/asm/atomic_64.h
> @@ -9,6 +9,7 @@
> 
>  #include <linux/types.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #define ATOMIC_INIT(i)		{ (i) }
>  #define ATOMIC64_INIT(i)	{ (i) }
> @@ -108,10 +109,4 @@ static inline long atomic64_add_unless(a
> 
>  extern long atomic64_dec_if_positive(atomic64_t *v);
> 
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* !(__ARCH_SPARC64_ATOMIC__) */
> --- a/arch/sparc/include/asm/barrier_64.h
> +++ b/arch/sparc/include/asm/barrier_64.h
> @@ -68,4 +68,7 @@ do {									\
>  	___p1;								\
>  })
> 
> +#define smp_mb__before_atomic()	barrier()
> +#define smp_mb__after_atomic()	barrier()
> +
>  #endif /* !(__SPARC64_BARRIER_H) */
> --- a/arch/sparc/include/asm/bitops_32.h
> +++ b/arch/sparc/include/asm/bitops_32.h
> @@ -11,6 +11,7 @@
> 
>  #include <linux/compiler.h>
>  #include <asm/byteorder.h>
> +#include <asm/barrier.h>
> 
>  #ifdef __KERNEL__
> 
> @@ -90,9 +91,6 @@ static inline void change_bit(unsigned l
> 
>  #include <asm-generic/bitops/non-atomic.h>
> 
> -#define smp_mb__before_clear_bit()	do { } while(0)
> -#define smp_mb__after_clear_bit()	do { } while(0)
> -
>  #include <asm-generic/bitops/ffz.h>
>  #include <asm-generic/bitops/__ffs.h>
>  #include <asm-generic/bitops/sched.h>
> --- a/arch/sparc/include/asm/bitops_64.h
> +++ b/arch/sparc/include/asm/bitops_64.h
> @@ -13,6 +13,7 @@
> 
>  #include <linux/compiler.h>
>  #include <asm/byteorder.h>
> +#include <asm/barrier.h>
> 
>  extern int test_and_set_bit(unsigned long nr, volatile unsigned long *addr);
>  extern int test_and_clear_bit(unsigned long nr, volatile unsigned long *addr);
> @@ -23,9 +24,6 @@ extern void change_bit(unsigned long nr,
> 
>  #include <asm-generic/bitops/non-atomic.h>
> 
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  #include <asm-generic/bitops/fls.h>
>  #include <asm-generic/bitops/__fls.h>
>  #include <asm-generic/bitops/fls64.h>
> --- a/arch/tile/include/asm/atomic_32.h
> +++ b/arch/tile/include/asm/atomic_32.h
> @@ -169,16 +169,6 @@ static inline void atomic64_set(atomic64
>  #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
>  #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
> 
> -/*
> - * We need to barrier before modifying the word, since the _atomic_xxx()
> - * routines just tns the lock and then read/modify/write of the word.
> - * But after the word is updated, the routine issues an "mf" before returning,
> - * and since it's a function call, we don't even need a compiler barrier.
> - */
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_dec()	do { } while (0)
> -#define smp_mb__after_atomic_inc()	do { } while (0)
> 
>  #endif /* !__ASSEMBLY__ */
> 
> --- a/arch/tile/include/asm/atomic_64.h
> +++ b/arch/tile/include/asm/atomic_64.h
> @@ -105,12 +105,6 @@ static inline long atomic64_add_unless(a
> 
>  #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
> 
> -/* Atomic dec and inc don't implement barrier, so provide them if needed. */
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  /* Define this to indicate that cmpxchg is an efficient operation. */
>  #define __HAVE_ARCH_CMPXCHG
> 
> --- a/arch/tile/include/asm/barrier.h
> +++ b/arch/tile/include/asm/barrier.h
> @@ -72,6 +72,20 @@ mb_incoherent(void)
>  #define mb()		fast_mb()
>  #define iob()		fast_iob()
> 
> +#ifndef __tilegx__ /* 32 bit */
> +/*
> + * We need to barrier before modifying the word, since the _atomic_xxx()
> + * routines just tns the lock and then read/modify/write of the word.
> + * But after the word is updated, the routine issues an "mf" before returning,
> + * and since it's a function call, we don't even need a compiler barrier.
> + */
> +#define smp_mb__before_atomic()	smp_mb()
> +#define smp_mb__after_atomic()	do { } while (0)
> +#else /* 64 bit */
> +#define smp_mb__before_atomic()	smp_mb()
> +#define smp_mb__after_atomic()	smp_mb()
> +#endif
> +
>  #include <asm-generic/barrier.h>
> 
>  #endif /* !__ASSEMBLY__ */
> --- a/arch/tile/include/asm/bitops.h
> +++ b/arch/tile/include/asm/bitops.h
> @@ -17,6 +17,7 @@
>  #define _ASM_TILE_BITOPS_H
> 
>  #include <linux/types.h>
> +#include <asm/barrier.h>
> 
>  #ifndef _LINUX_BITOPS_H
>  #error only <linux/bitops.h> can be included directly
> --- a/arch/tile/include/asm/bitops_32.h
> +++ b/arch/tile/include/asm/bitops_32.h
> @@ -49,8 +49,8 @@ static inline void set_bit(unsigned nr,
>   * restricted to acting on a single-word quantity.
>   *
>   * clear_bit() may not contain a memory barrier, so if it is used for
> - * locking purposes, you should call smp_mb__before_clear_bit() and/or
> - * smp_mb__after_clear_bit() to ensure changes are visible on other cpus.
> + * locking purposes, you should call smp_mb__before_atomic() and/or
> + * smp_mb__after_atomic() to ensure changes are visible on other cpus.
>   */
>  static inline void clear_bit(unsigned nr, volatile unsigned long *addr)
>  {
> @@ -121,10 +121,6 @@ static inline int test_and_change_bit(un
>  	return (_atomic_xor(addr, mask) & mask) != 0;
>  }
> 
> -/* See discussion at smp_mb__before_atomic_dec() in <asm/atomic_32.h>. */
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	do {} while (0)
> -
>  #include <asm-generic/bitops/ext2-atomic.h>
> 
>  #endif /* _ASM_TILE_BITOPS_32_H */
> --- a/arch/tile/include/asm/bitops_64.h
> +++ b/arch/tile/include/asm/bitops_64.h
> @@ -32,10 +32,6 @@ static inline void clear_bit(unsigned nr
>  	__insn_fetchand((void *)(addr + nr / BITS_PER_LONG), ~mask);
>  }
> 
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -
> -
>  static inline void change_bit(unsigned nr, volatile unsigned long *addr)
>  {
>  	unsigned long mask = (1UL << (nr % BITS_PER_LONG));
> --- a/arch/x86/include/asm/atomic.h
> +++ b/arch/x86/include/asm/atomic.h
> @@ -7,6 +7,7 @@
>  #include <asm/alternative.h>
>  #include <asm/cmpxchg.h>
>  #include <asm/rmwcc.h>
> +#include <asm/barrier.h>
> 
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
> @@ -243,12 +244,6 @@ static inline void atomic_or_long(unsign
>  		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
>  		     : "memory")
> 
> -/* Atomic operations are already serializing on x86 */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #ifdef CONFIG_X86_32
>  # include <asm/atomic64_32.h>
>  #else
> --- a/arch/x86/include/asm/barrier.h
> +++ b/arch/x86/include/asm/barrier.h
> @@ -141,6 +141,10 @@ do {									\
> 
>  #endif
> 
> +/* Atomic operations are already serializing on x86 */
> +#define smp_mb__before_atomic()	barrier()
> +#define smp_mb__after_atomic()	barrier()
> +
>  /*
>   * Stop RDTSC speculation. This is needed when you need to use RDTSC
>   * (or get_cycles or vread that possibly accesses the TSC) in a defined
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -15,6 +15,7 @@
>  #include <linux/compiler.h>
>  #include <asm/alternative.h>
>  #include <asm/rmwcc.h>
> +#include <asm/barrier.h>
> 
>  #if BITS_PER_LONG == 32
>  # define _BITOPS_LONG_SHIFT 5
> @@ -102,7 +103,7 @@ static inline void __set_bit(long nr, vo
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static __always_inline void
> @@ -156,9 +157,6 @@ static inline void __clear_bit_unlock(lo
>  	__clear_bit(nr, addr);
>  }
> 
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> -
>  /**
>   * __change_bit - Toggle a bit in memory
>   * @nr: the bit to change
> --- a/arch/x86/include/asm/sync_bitops.h
> +++ b/arch/x86/include/asm/sync_bitops.h
> @@ -41,7 +41,7 @@ static inline void sync_set_bit(long nr,
>   *
>   * sync_clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static inline void sync_clear_bit(long nr, volatile unsigned long *addr)
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -57,7 +57,7 @@ void arch_trigger_all_cpu_backtrace(void
>  	}
> 
>  	clear_bit(0, &backtrace_flag);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static int __kprobes
> --- a/arch/xtensa/include/asm/atomic.h
> +++ b/arch/xtensa/include/asm/atomic.h
> @@ -19,6 +19,7 @@
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #define ATOMIC_INIT(i)	{ (i) }
> 
> @@ -387,12 +388,6 @@ static inline void atomic_set_mask(unsig
>  #endif
>  }
> 
> -/* Atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* __KERNEL__ */
> 
>  #endif /* _XTENSA_ATOMIC_H */
> --- a/arch/xtensa/include/asm/bitops.h
> +++ b/arch/xtensa/include/asm/bitops.h
> @@ -21,9 +21,7 @@
> 
>  #include <asm/processor.h>
>  #include <asm/byteorder.h>
> -
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> +#include <asm/barrier.h>
> 
>  #include <asm-generic/bitops/non-atomic.h>
> 
> --- a/block/blk-iopoll.c
> +++ b/block/blk-iopoll.c
> @@ -52,7 +52,7 @@ EXPORT_SYMBOL(blk_iopoll_sched);
>  void __blk_iopoll_complete(struct blk_iopoll *iop)
>  {
>  	list_del(&iop->list);
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit_unlock(IOPOLL_F_SCHED, &iop->state);
>  }
>  EXPORT_SYMBOL(__blk_iopoll_complete);
> @@ -164,7 +164,7 @@ EXPORT_SYMBOL(blk_iopoll_disable);
>  void blk_iopoll_enable(struct blk_iopoll *iop)
>  {
>  	BUG_ON(!test_bit(IOPOLL_F_SCHED, &iop->state));
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit_unlock(IOPOLL_F_SCHED, &iop->state);
>  }
>  EXPORT_SYMBOL(blk_iopoll_enable);
> --- a/crypto/chainiv.c
> +++ b/crypto/chainiv.c
> @@ -126,7 +126,7 @@ static int async_chainiv_schedule_work(s
>  	int err = ctx->err;
> 
>  	if (!ctx->queue.qlen) {
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
> 
>  		if (!ctx->queue.qlen ||
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -106,7 +106,7 @@ static bool genpd_sd_counter_dec(struct
>  static void genpd_sd_counter_inc(struct generic_pm_domain *genpd)
>  {
>  	atomic_inc(&genpd->sd_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  static void genpd_acquire_lock(struct generic_pm_domain *genpd)
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -224,9 +224,9 @@ static int get_slot(struct mtip_port *po
>   */
>  static inline void release_slot(struct mtip_port *port, int tag)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(tag, port->allocated);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  /*
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -159,7 +159,7 @@ void cpuidle_coupled_parallel_barrier(st
>  {
>  	int n = dev->coupled->online_count;
> 
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_inc(a);
> 
>  	while (atomic_read(a) < n)
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -3509,7 +3509,7 @@ static int ohci_flush_iso_completions(st
>  		}
> 
>  		clear_bit_unlock(0, &ctx->flushing_completions);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  	}
> 
>  	tasklet_enable(&ctx->context.tasklet);
> --- a/drivers/gpu/drm/drm_irq.c
> +++ b/drivers/gpu/drm/drm_irq.c
> @@ -156,7 +156,7 @@ static void vblank_disable_and_save(stru
>  	 */
>  	if ((vblrc > 0) && (abs64(diff_ns) > 1000000)) {
>  		atomic_inc(&dev->vblank[crtc].count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  	}
> 
>  	/* Invalidate all timestamps while vblank irq's are off. */
> @@ -864,9 +864,9 @@ static void drm_update_vblank_count(stru
>  		vblanktimestamp(dev, crtc, tslot) = t_vblank;
>  	}
> 
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_add(diff, &dev->vblank[crtc].count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  /**
> @@ -1330,9 +1330,9 @@ bool drm_handle_vblank(struct drm_device
>  		/* Increment cooked vblank count. This also atomically commits
>  		 * the timestamp computed above.
>  		 */
> -		smp_mb__before_atomic_inc();
> +		smp_mb__before_atomic();
>  		atomic_inc(&dev->vblank[crtc].count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  	} else {
>  		DRM_DEBUG("crtc %d: Redundant vblirq ignored. diff_ns = %d\n",
>  			  crtc, (int) diff_ns);
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -1996,7 +1996,7 @@ static void i915_error_work_func(struct
>  			 * updates before
>  			 * the counter increment.
>  			 */
> -			smp_mb__before_atomic_inc();
> +			smp_mb__before_atomic();
>  			atomic_inc(&dev_priv->gpu_error.reset_counter);
> 
>  			kobject_uevent_env(&dev->primary->kdev->kobj,
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -841,7 +841,7 @@ static inline bool cached_dev_get(struct
>  		return false;
> 
>  	/* Paired with the mb in cached_dev_attach */
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	return true;
>  }
> 
> --- a/drivers/md/bcache/closure.h
> +++ b/drivers/md/bcache/closure.h
> @@ -243,7 +243,7 @@ static inline void set_closure_fn(struct
>  	cl->fn = fn;
>  	cl->wq = wq;
>  	/* between atomic_dec() in closure_put() */
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  }
> 
>  static inline void closure_queue(struct closure *cl)
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -607,9 +607,9 @@ static void write_endio(struct bio *bio,
> 
>  	BUG_ON(!test_bit(B_WRITING, &b->state));
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(B_WRITING, &b->state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	wake_up_bit(&b->state, B_WRITING);
>  }
> @@ -997,9 +997,9 @@ static void read_endio(struct bio *bio,
> 
>  	BUG_ON(!test_bit(B_READING, &b->state));
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(B_READING, &b->state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	wake_up_bit(&b->state, B_READING);
>  }
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -642,7 +642,7 @@ static void free_pending_exception(struc
>  	struct dm_snapshot *s = pe->snap;
> 
>  	mempool_free(pe, s->pending_pool);
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&s->pending_exceptions_count);
>  }
> 
> @@ -783,7 +783,7 @@ static int init_hash_tables(struct dm_sn
>  static void merge_shutdown(struct dm_snapshot *s)
>  {
>  	clear_bit_unlock(RUNNING_MERGE, &s->state_bits);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&s->state_bits, RUNNING_MERGE);
>  }
> 
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2451,7 +2451,7 @@ static void dm_wq_work(struct work_struc
>  static void dm_queue_flush(struct mapped_device *md)
>  {
>  	clear_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	queue_work(md->wq, &md->work);
>  }
> 
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4406,7 +4406,7 @@ static void raid5_unplug(struct blk_plug
>  			 * STRIPE_ON_UNPLUG_LIST clear but the stripe
>  			 * is still in our list
>  			 */
> -			smp_mb__before_clear_bit();
> +			smp_mb__before_atomic();
>  			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
>  			/*
>  			 * STRIPE_ON_RELEASE_LIST could be set here. In that
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -399,7 +399,7 @@ static int dvb_usb_stop_feed(struct dvb_
> 
>  	/* clear 'streaming' status bit */
>  	clear_bit(ADAP_STREAMING, &adap->state_bits);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&adap->state_bits, ADAP_STREAMING);
>  skip_feed_stop:
> 
> @@ -550,7 +550,7 @@ static int dvb_usb_fe_init(struct dvb_fr
>  err:
>  	if (!adap->suspend_resume_active) {
>  		clear_bit(ADAP_INIT, &adap->state_bits);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		wake_up_bit(&adap->state_bits, ADAP_INIT);
>  	}
> 
> @@ -591,7 +591,7 @@ static int dvb_usb_fe_sleep(struct dvb_f
>  	if (!adap->suspend_resume_active) {
>  		adap->active_fe = -1;
>  		clear_bit(ADAP_SLEEP, &adap->state_bits);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
>  	}
> 
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -2779,7 +2779,7 @@ int bnx2x_nic_load(struct bnx2x *bp, int
> 
>  	case LOAD_OPEN:
>  		netif_tx_start_all_queues(bp->dev);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		break;
> 
>  	case LOAD_DIAG:
> @@ -4773,9 +4773,9 @@ void bnx2x_tx_timeout(struct net_device
>  		bnx2x_panic();
>  #endif
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	set_bit(BNX2X_SP_RTNL_TX_TIMEOUT, &bp->sp_rtnl_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	/* This allows the netif to be shutdown gracefully before resetting */
>  	schedule_delayed_work(&bp->sp_rtnl_task, 0);
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -1837,10 +1837,10 @@ void bnx2x_sp_event(struct bnx2x_fastpat
>  	/* SRIOV: reschedule any 'in_progress' operations */
>  	bnx2x_iov_sp_event(bp, cid, true);
> 
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_inc(&bp->cq_spq_left);
>  	/* push the change in bp->spq_left and towards the memory */
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
> 
>  	DP(BNX2X_MSG_SP, "bp->cq_spq_left %x\n", atomic_read(&bp->cq_spq_left));
> 
> @@ -1855,11 +1855,11 @@ void bnx2x_sp_event(struct bnx2x_fastpat
>  		 * sp_state is cleared, and this order prevents
>  		 * races
>  		 */
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(BNX2X_AFEX_PENDING_VIFSET_MCP_ACK, &bp->sp_state);
>  		wmb();
>  		clear_bit(BNX2X_AFEX_FCOE_Q_UPDATE_PENDING, &bp->sp_state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  		/* schedule the sp task as mcp ack is required */
>  		bnx2x_schedule_sp_task(bp);
> @@ -3878,9 +3878,9 @@ static void bnx2x_fan_failure(struct bnx
>  	 * This is due to some boards consuming sufficient power when driver is
>  	 * up to overheat if fan fails.
>  	 */
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	set_bit(BNX2X_SP_RTNL_FAN_FAILURE, &bp->sp_rtnl_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	schedule_delayed_work(&bp->sp_rtnl_task, 0);
>  }
> 
> @@ -5137,9 +5137,9 @@ static void bnx2x_after_function_update(
>  		__clear_bit(RAMROD_COMP_WAIT, &queue_params.ramrod_flags);
> 
>  		/* mark latest Q bit */
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(BNX2X_AFEX_FCOE_Q_UPDATE_PENDING, &bp->sp_state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  		/* send Q update ramrod for FCoE Q */
>  		rc = bnx2x_queue_state_change(bp, &queue_params);
> @@ -5282,10 +5282,10 @@ static void bnx2x_eq_int(struct bnx2x *b
>  				 * sp_rtnl task as all Queue SP operations
>  				 * should run under rtnl_lock.
>  				 */
> -				smp_mb__before_clear_bit();
> +				smp_mb__before_atomic();
>  				set_bit(BNX2X_SP_RTNL_AFEX_F_UPDATE,
>  					&bp->sp_rtnl_state);
> -				smp_mb__after_clear_bit();
> +				smp_mb__after_atomic();
> 
>  				schedule_delayed_work(&bp->sp_rtnl_task, 0);
>  			}
> @@ -5368,7 +5368,7 @@ static void bnx2x_eq_int(struct bnx2x *b
>  		spqe_cnt++;
>  	} /* for */
> 
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_add(spqe_cnt, &bp->eq_spq_left);
> 
>  	bp->eq_cons = sw_cons;
> @@ -12065,9 +12065,9 @@ static void bnx2x_set_rx_mode(struct net
>  	} else {
>  		/* Schedule an SP task to handle rest of change */
>  		DP(NETIF_MSG_IFUP, "Scheduling an Rx mode change\n");
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(BNX2X_SP_RTNL_RX_MODE, &bp->sp_rtnl_state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		schedule_delayed_work(&bp->sp_rtnl_task, 0);
>  	}
>  }
> @@ -12101,10 +12101,10 @@ void bnx2x_set_rx_mode_inner(struct bnx2
>  			/* configuring mcast to a vf involves sleeping (when we
>  			 * wait for the pf's response).
>  			 */
> -			smp_mb__before_clear_bit();
> +			smp_mb__before_atomic();
>  			set_bit(BNX2X_SP_RTNL_VFPF_MCAST,
>  				&bp->sp_rtnl_state);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
>  			schedule_delayed_work(&bp->sp_rtnl_task, 0);
>  		}
>  	}
> @@ -13723,9 +13723,9 @@ static int bnx2x_drv_ctl(struct net_devi
>  	case DRV_CTL_RET_L2_SPQ_CREDIT_CMD: {
>  		int count = ctl->data.credit.credit_count;
> 
> -		smp_mb__before_atomic_inc();
> +		smp_mb__before_atomic();
>  		atomic_add(count, &bp->cq_spq_left);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		break;
>  	}
>  	case DRV_CTL_ULP_REGISTER_CMD: {
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> @@ -258,16 +258,16 @@ static bool bnx2x_raw_check_pending(stru
> 
>  static void bnx2x_raw_clear_pending(struct bnx2x_raw_obj *o)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(o->state, o->pstate);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static void bnx2x_raw_set_pending(struct bnx2x_raw_obj *o)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	set_bit(o->state, o->pstate);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  /**
> @@ -2131,7 +2131,7 @@ static int bnx2x_set_rx_mode_e1x(struct
> 
>  	/* The operation is completed */
>  	clear_bit(p->state, p->pstate);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return 0;
>  }
> @@ -3576,16 +3576,16 @@ int bnx2x_config_mcast(struct bnx2x *bp,
> 
>  static void bnx2x_mcast_clear_sched(struct bnx2x_mcast_obj *o)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(o->sched_state, o->raw.pstate);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static void bnx2x_mcast_set_sched(struct bnx2x_mcast_obj *o)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	set_bit(o->sched_state, o->raw.pstate);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static bool bnx2x_mcast_check_sched(struct bnx2x_mcast_obj *o)
> @@ -4210,7 +4210,7 @@ int bnx2x_queue_state_change(struct bnx2
>  		if (rc) {
>  			o->next_state = BNX2X_Q_STATE_MAX;
>  			clear_bit(pending_bit, pending);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
>  			return rc;
>  		}
> 
> @@ -4298,7 +4298,7 @@ static int bnx2x_queue_comp_cmd(struct b
>  	wmb();
> 
>  	clear_bit(cmd, &o->pending);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return 0;
>  }
> @@ -5242,7 +5242,7 @@ static inline int bnx2x_func_state_chang
>  	wmb();
> 
>  	clear_bit(cmd, &o->pending);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return 0;
>  }
> @@ -5877,7 +5877,7 @@ int bnx2x_func_state_change(struct bnx2x
>  		if (rc) {
>  			o->next_state = BNX2X_F_STATE_MAX;
>  			clear_bit(cmd, pending);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
>  			return rc;
>  		}
> 
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -971,10 +971,10 @@ static void bnx2x_vfop_qsetup(struct bnx
>  op_done:
>  	case BNX2X_VFOP_QSETUP_DONE:
>  		vf->cfg_flags |= VF_CFG_VLAN;
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(BNX2X_SP_RTNL_HYPERVISOR_VLAN,
>  			&bp->sp_rtnl_state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		schedule_delayed_work(&bp->sp_rtnl_task, 0);
>  		bnx2x_vfop_end(bp, vf, vfop);
>  		return;
> @@ -2354,9 +2354,9 @@ static
>  void bnx2x_vf_handle_filters_eqe(struct bnx2x *bp,
>  				 struct bnx2x_virtf *vf)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(BNX2X_FILTER_RX_MODE_PENDING, &vf->filter_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  int bnx2x_iov_eq_sp_event(struct bnx2x *bp, union event_ring_elem *elem)
> @@ -3737,10 +3737,10 @@ void bnx2x_timer_sriov(struct bnx2x *bp)
> 
>  	/* if channel is down we need to self destruct */
>  	if (bp->old_bulletin.valid_bitmap & 1 << CHANNEL_DOWN) {
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(BNX2X_SP_RTNL_VFPF_CHANNEL_DOWN,
>  			&bp->sp_rtnl_state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		schedule_delayed_work(&bp->sp_rtnl_task, 0);
>  	}
>  }
> --- a/drivers/net/ethernet/broadcom/cnic.c
> +++ b/drivers/net/ethernet/broadcom/cnic.c
> @@ -436,7 +436,7 @@ static int cnic_offld_prep(struct cnic_s
>  static int cnic_close_prep(struct cnic_sock *csk)
>  {
>  	clear_bit(SK_F_CONNECT_START, &csk->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	if (test_and_clear_bit(SK_F_OFFLD_COMPLETE, &csk->flags)) {
>  		while (test_and_set_bit(SK_F_OFFLD_SCHED, &csk->flags))
> @@ -450,7 +450,7 @@ static int cnic_close_prep(struct cnic_s
>  static int cnic_abort_prep(struct cnic_sock *csk)
>  {
>  	clear_bit(SK_F_CONNECT_START, &csk->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	while (test_and_set_bit(SK_F_OFFLD_SCHED, &csk->flags))
>  		msleep(1);
> @@ -3645,7 +3645,7 @@ static int cnic_cm_destroy(struct cnic_s
> 
>  	csk_hold(csk);
>  	clear_bit(SK_F_INUSE, &csk->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	while (atomic_read(&csk->ref_count) != 1)
>  		msleep(1);
>  	cnic_cm_cleanup(csk);
> @@ -4025,7 +4025,7 @@ static void cnic_cm_process_kcqe(struct
>  			 L4_KCQE_COMPLETION_STATUS_PARITY_ERROR)
>  			set_bit(SK_F_HW_ERR, &csk->flags);
> 
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(SK_F_OFFLD_SCHED, &csk->flags);
>  		cnic_cm_upcall(cp, csk, opcode);
>  		break;
> --- a/drivers/net/ethernet/brocade/bna/bnad.c
> +++ b/drivers/net/ethernet/brocade/bna/bnad.c
> @@ -249,7 +249,7 @@ bnad_tx_complete(struct bnad *bnad, stru
>  	if (likely(test_bit(BNAD_TXQ_TX_STARTED, &tcb->flags)))
>  		bna_ib_ack(tcb->i_dbell, sent);
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(BNAD_TXQ_FREE_SENT, &tcb->flags);
> 
>  	return sent;
> @@ -1125,7 +1125,7 @@ bnad_tx_cleanup(struct delayed_work *wor
> 
>  		bnad_txq_cleanup(bnad, tcb);
> 
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(BNAD_TXQ_FREE_SENT, &tcb->flags);
>  	}
> 
> @@ -2999,7 +2999,7 @@ bnad_start_xmit(struct sk_buff *skb, str
>  			sent = bnad_txcmpl_process(bnad, tcb);
>  			if (likely(test_bit(BNAD_TXQ_TX_STARTED, &tcb->flags)))
>  				bna_ib_ack(tcb->i_dbell, sent);
> -			smp_mb__before_clear_bit();
> +			smp_mb__before_atomic();
>  			clear_bit(BNAD_TXQ_FREE_SENT, &tcb->flags);
>  		} else {
>  			netif_stop_queue(netdev);
> --- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> +++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> @@ -281,7 +281,7 @@ static int cxgb_close(struct net_device
>  	if (adapter->params.stats_update_period &&
>  	    !(adapter->open_device_map & PORT_MASK)) {
>  		/* Stop statistics accumulation. */
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		spin_lock(&adapter->work_lock);   /* sync with update task */
>  		spin_unlock(&adapter->work_lock);
>  		cancel_mac_stats_update(adapter);
> --- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> @@ -1379,7 +1379,7 @@ static inline int check_desc_avail(struc
>  		struct sge_qset *qs = txq_to_qset(q, qid);
> 
>  		set_bit(qid, &qs->txq_stopped);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  		if (should_restart_tx(q) &&
>  		    test_and_clear_bit(qid, &qs->txq_stopped))
> @@ -1492,7 +1492,7 @@ static void restart_ctrlq(unsigned long
> 
>  	if (!skb_queue_empty(&q->sendq)) {
>  		set_bit(TXQ_CTRL, &qs->txq_stopped);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  		if (should_restart_tx(q) &&
>  		    test_and_clear_bit(TXQ_CTRL, &qs->txq_stopped))
> @@ -1697,7 +1697,7 @@ again:	reclaim_completed_tx(adap, q, TX_
> 
>  		if (unlikely(q->size - q->in_use < ndesc)) {
>  			set_bit(TXQ_OFLD, &qs->txq_stopped);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
> 
>  			if (should_restart_tx(q) &&
>  			    test_and_clear_bit(TXQ_OFLD, &qs->txq_stopped))
> --- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
> @@ -2003,7 +2003,7 @@ static void sge_rx_timer_cb(unsigned lon
>  			struct sge_fl *fl = s->egr_map[id];
> 
>  			clear_bit(id, s->starving_fl);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
> 
>  			if (fl_starving(fl)) {
>  				rxq = container_of(fl, struct sge_eth_rxq, fl);
> --- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
> @@ -1951,7 +1951,7 @@ static void sge_rx_timer_cb(unsigned lon
>  			struct sge_fl *fl = s->egr_map[id];
> 
>  			clear_bit(id, s->starving_fl);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
> 
>  			/*
>  			 * Since we are accessing fl without a lock there's a
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -4576,7 +4576,7 @@ static void i40e_service_event_complete(
>  	BUG_ON(!test_bit(__I40E_SERVICE_SCHED, &pf->state));
> 
>  	/* flush memory to make sure state is correct before next watchog */
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(__I40E_SERVICE_SCHED, &pf->state);
>  }
> 
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -318,7 +318,7 @@ static void ixgbe_service_event_complete
>  	BUG_ON(!test_bit(__IXGBE_SERVICE_SCHED, &adapter->state));
> 
>  	/* flush memory to make sure state is correct before next watchdog */
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(__IXGBE_SERVICE_SCHED, &adapter->state);
>  }
> 
> @@ -4607,7 +4607,7 @@ static void ixgbe_up_complete(struct ixg
>  	if (hw->mac.ops.enable_tx_laser)
>  		hw->mac.ops.enable_tx_laser(hw);
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(__IXGBE_DOWN, &adapter->state);
>  	ixgbe_napi_enable_all(adapter);
> 
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -547,7 +547,7 @@ static int wlcore_irq_locked(struct wl12
>  		 * wl1271_ps_elp_wakeup cannot be called concurrently.
>  		 */
>  		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  		ret = wlcore_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
>  		if (ret < 0)
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -662,9 +662,9 @@ static void pcifront_do_aer(struct work_
>  	notify_remote_via_evtchn(pdev->evtchn);
> 
>  	/*in case of we lost an aer request in four lines time_window*/
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(_PDEVB_op_active, &pdev->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	schedule_pcifront_aer_op(pdev);
> 
> --- a/drivers/scsi/isci/remote_device.c
> +++ b/drivers/scsi/isci/remote_device.c
> @@ -1541,7 +1541,7 @@ void isci_remote_device_release(struct k
>  	clear_bit(IDEV_STOP_PENDING, &idev->flags);
>  	clear_bit(IDEV_IO_READY, &idev->flags);
>  	clear_bit(IDEV_GONE, &idev->flags);
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(IDEV_ALLOCATED, &idev->flags);
>  	wake_up(&ihost->eventq);
>  }
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -942,7 +942,7 @@ static int tcm_loop_port_link(
>  	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
> 
>  	atomic_inc(&tl_tpg->tl_tpg_port_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	/*
>  	 * Add Linux/SCSI struct scsi_device by HCTL
>  	 */
> @@ -977,7 +977,7 @@ static void tcm_loop_port_unlink(
>  	scsi_device_put(sd);
> 
>  	atomic_dec(&tl_tpg->tl_tpg_port_count);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
> 
>  	pr_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
>  }
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -393,7 +393,7 @@ target_emulate_set_target_port_groups(st
>  					continue;
> 
>  				atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -				smp_mb__after_atomic_inc();
> +				smp_mb__after_atomic();
> 
>  				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> 
> @@ -404,7 +404,7 @@ target_emulate_set_target_port_groups(st
> 
>  				spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  				atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				break;
>  			}
>  			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> @@ -997,7 +997,7 @@ static void core_alua_do_transition_tg_p
>  		 * TARGET PORT GROUPS command
>  		 */
>  		atomic_inc(&mem->tg_pt_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
> 
>  		spin_lock_bh(&port->sep_alua_lock);
> @@ -1027,7 +1027,7 @@ static void core_alua_do_transition_tg_p
> 
>  		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
>  		atomic_dec(&mem->tg_pt_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
>  	/*
> @@ -1061,7 +1061,7 @@ static void core_alua_do_transition_tg_p
>  		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
>  	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> 
>  	if (tg_pt_gp->tg_pt_gp_transition_complete)
> @@ -1123,7 +1123,7 @@ static int core_alua_do_transition_tg_pt
>  	 */
>  	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  	atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> 
>  	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs) {
> @@ -1166,7 +1166,7 @@ int core_alua_do_port_transition(
>  	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
>  	lu_gp = local_lu_gp_mem->lu_gp;
>  	atomic_inc(&lu_gp->lu_gp_ref_cnt);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
>  	/*
>  	 * For storage objects that are members of the 'default_lu_gp',
> @@ -1183,7 +1183,7 @@ int core_alua_do_port_transition(
>  		rc = core_alua_do_transition_tg_pt(l_tg_pt_gp,
>  						   new_state, explicit);
>  		atomic_dec(&lu_gp->lu_gp_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		return rc;
>  	}
>  	/*
> @@ -1197,7 +1197,7 @@ int core_alua_do_port_transition(
> 
>  		dev = lu_gp_mem->lu_gp_mem_dev;
>  		atomic_inc(&lu_gp_mem->lu_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock(&lu_gp->lu_gp_lock);
> 
>  		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> @@ -1226,7 +1226,7 @@ int core_alua_do_port_transition(
>  				tg_pt_gp->tg_pt_gp_alua_nacl = NULL;
>  			}
>  			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  			/*
>  			 * core_alua_do_transition_tg_pt() will always return
> @@ -1237,7 +1237,7 @@ int core_alua_do_port_transition(
> 
>  			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -			smp_mb__after_atomic_dec();
> +			smp_mb__after_atomic();
>  			if (rc)
>  				break;
>  		}
> @@ -1245,7 +1245,7 @@ int core_alua_do_port_transition(
> 
>  		spin_lock(&lu_gp->lu_gp_lock);
>  		atomic_dec(&lu_gp_mem->lu_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock(&lu_gp->lu_gp_lock);
> 
> @@ -1259,7 +1259,7 @@ int core_alua_do_port_transition(
>  	}
> 
>  	atomic_dec(&lu_gp->lu_gp_ref_cnt);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  	return rc;
>  }
> 
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -225,7 +225,7 @@ struct se_dev_entry *core_get_se_deve_fr
>  			continue;
> 
>  		atomic_inc(&deve->pr_ref_count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock_irq(&nacl->device_list_lock);
> 
>  		return deve;
> @@ -1392,7 +1392,7 @@ int core_dev_add_initiator_node_lun_acl(
>  	spin_lock(&lun->lun_acl_lock);
>  	list_add_tail(&lacl->lacl_list, &lun->lun_acl_list);
>  	atomic_inc(&lun->lun_acl_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	spin_unlock(&lun->lun_acl_lock);
> 
>  	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
> @@ -1426,7 +1426,7 @@ int core_dev_del_initiator_node_lun_acl(
>  	spin_lock(&lun->lun_acl_lock);
>  	list_del(&lacl->lacl_list);
>  	atomic_dec(&lun->lun_acl_count);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  	spin_unlock(&lun->lun_acl_lock);
> 
>  	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -324,7 +324,7 @@ static void iblock_bio_done(struct bio *
>  		 * Bump the ib_bio_err_cnt and release bio.
>  		 */
>  		atomic_inc(&ibr->ib_bio_err_cnt);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  	}
> 
>  	bio_put(bio);
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -675,7 +675,7 @@ static struct t10_pr_registration *__cor
>  	spin_lock(&dev->se_port_lock);
>  	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
>  		atomic_inc(&port->sep_tg_pt_ref_cnt);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock(&dev->se_port_lock);
> 
>  		spin_lock_bh(&port->sep_alua_lock);
> @@ -710,7 +710,7 @@ static struct t10_pr_registration *__cor
>  				continue;
> 
>  			atomic_inc(&deve_tmp->pr_ref_count);
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  			spin_unlock_bh(&port->sep_alua_lock);
>  			/*
>  			 * Grab a configfs group dependency that is released
> @@ -723,9 +723,9 @@ static struct t10_pr_registration *__cor
>  				pr_err("core_scsi3_lunacl_depend"
>  						"_item() failed\n");
>  				atomic_dec(&port->sep_tg_pt_ref_cnt);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				atomic_dec(&deve_tmp->pr_ref_count);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				goto out;
>  			}
>  			/*
> @@ -740,9 +740,9 @@ static struct t10_pr_registration *__cor
>  						sa_res_key, all_tg_pt, aptpl);
>  			if (!pr_reg_atp) {
>  				atomic_dec(&port->sep_tg_pt_ref_cnt);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				atomic_dec(&deve_tmp->pr_ref_count);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				core_scsi3_lunacl_undepend_item(deve_tmp);
>  				goto out;
>  			}
> @@ -755,7 +755,7 @@ static struct t10_pr_registration *__cor
> 
>  		spin_lock(&dev->se_port_lock);
>  		atomic_dec(&port->sep_tg_pt_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock(&dev->se_port_lock);
> 
> @@ -1110,7 +1110,7 @@ static struct t10_pr_registration *__cor
>  					continue;
>  			}
>  			atomic_inc(&pr_reg->pr_res_holders);
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  			spin_unlock(&pr_tmpl->registration_lock);
>  			return pr_reg;
>  		}
> @@ -1125,7 +1125,7 @@ static struct t10_pr_registration *__cor
>  			continue;
> 
>  		atomic_inc(&pr_reg->pr_res_holders);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock(&pr_tmpl->registration_lock);
>  		return pr_reg;
>  	}
> @@ -1155,7 +1155,7 @@ static struct t10_pr_registration *core_
>  static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
>  {
>  	atomic_dec(&pr_reg->pr_res_holders);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  }
> 
>  static int core_scsi3_check_implicit_release(
> @@ -1349,7 +1349,7 @@ static void core_scsi3_tpg_undepend_item
>  			&tpg->tpg_group.cg_item);
> 
>  	atomic_dec(&tpg->tpg_pr_ref_count);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  }
> 
>  static int core_scsi3_nodeacl_depend_item(struct se_node_acl *nacl)
> @@ -1369,7 +1369,7 @@ static void core_scsi3_nodeacl_undepend_
> 
>  	if (nacl->dynamic_node_acl) {
>  		atomic_dec(&nacl->acl_pr_ref_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		return;
>  	}
> 
> @@ -1377,7 +1377,7 @@ static void core_scsi3_nodeacl_undepend_
>  			&nacl->acl_group.cg_item);
> 
>  	atomic_dec(&nacl->acl_pr_ref_count);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  }
> 
>  static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
> @@ -1408,7 +1408,7 @@ static void core_scsi3_lunacl_undepend_i
>  	 */
>  	if (!lun_acl) {
>  		atomic_dec(&se_deve->pr_ref_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		return;
>  	}
>  	nacl = lun_acl->se_lun_nacl;
> @@ -1418,7 +1418,7 @@ static void core_scsi3_lunacl_undepend_i
>  			&lun_acl->se_lun_group.cg_item);
> 
>  	atomic_dec(&se_deve->pr_ref_count);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  }
> 
>  static sense_reason_t
> @@ -1552,14 +1552,14 @@ core_scsi3_decode_spec_i_port(
>  				continue;
> 
>  			atomic_inc(&tmp_tpg->tpg_pr_ref_count);
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  			spin_unlock(&dev->se_port_lock);
> 
>  			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
>  				pr_err(" core_scsi3_tpg_depend_item()"
>  					" for tmp_tpg\n");
>  				atomic_dec(&tmp_tpg->tpg_pr_ref_count);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  				goto out_unmap;
>  			}
> @@ -1573,7 +1573,7 @@ core_scsi3_decode_spec_i_port(
>  						tmp_tpg, i_str);
>  			if (dest_node_acl) {
>  				atomic_inc(&dest_node_acl->acl_pr_ref_count);
> -				smp_mb__after_atomic_inc();
> +				smp_mb__after_atomic();
>  			}
>  			spin_unlock_irq(&tmp_tpg->acl_node_lock);
> 
> @@ -1587,7 +1587,7 @@ core_scsi3_decode_spec_i_port(
>  				pr_err("configfs_depend_item() failed"
>  					" for dest_node_acl->acl_group\n");
>  				atomic_dec(&dest_node_acl->acl_pr_ref_count);
> -				smp_mb__after_atomic_dec();
> +				smp_mb__after_atomic();
>  				core_scsi3_tpg_undepend_item(tmp_tpg);
>  				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  				goto out_unmap;
> @@ -1647,7 +1647,7 @@ core_scsi3_decode_spec_i_port(
>  			pr_err("core_scsi3_lunacl_depend_item()"
>  					" failed\n");
>  			atomic_dec(&dest_se_deve->pr_ref_count);
> -			smp_mb__after_atomic_dec();
> +			smp_mb__after_atomic();
>  			core_scsi3_nodeacl_undepend_item(dest_node_acl);
>  			core_scsi3_tpg_undepend_item(dest_tpg);
>  			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> @@ -3165,14 +3165,14 @@ core_scsi3_emulate_pro_register_and_move
>  			continue;
> 
>  		atomic_inc(&dest_se_tpg->tpg_pr_ref_count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock(&dev->se_port_lock);
> 
>  		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
>  			pr_err("core_scsi3_tpg_depend_item() failed"
>  				" for dest_se_tpg\n");
>  			atomic_dec(&dest_se_tpg->tpg_pr_ref_count);
> -			smp_mb__after_atomic_dec();
> +			smp_mb__after_atomic();
>  			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  			goto out_put_pr_reg;
>  		}
> @@ -3270,7 +3270,7 @@ core_scsi3_emulate_pro_register_and_move
>  				initiator_str);
>  	if (dest_node_acl) {
>  		atomic_inc(&dest_node_acl->acl_pr_ref_count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock_irq(&dest_se_tpg->acl_node_lock);
> 
> @@ -3286,7 +3286,7 @@ core_scsi3_emulate_pro_register_and_move
>  		pr_err("core_scsi3_nodeacl_depend_item() for"
>  			" dest_node_acl\n");
>  		atomic_dec(&dest_node_acl->acl_pr_ref_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		dest_node_acl = NULL;
>  		ret = TCM_INVALID_PARAMETER_LIST;
>  		goto out;
> @@ -3311,7 +3311,7 @@ core_scsi3_emulate_pro_register_and_move
>  	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
>  		pr_err("core_scsi3_lunacl_depend_item() failed\n");
>  		atomic_dec(&dest_se_deve->pr_ref_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		dest_se_deve = NULL;
>  		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  		goto out;
> @@ -3877,7 +3877,7 @@ core_scsi3_pri_read_full_status(struct s
>  		add_desc_len = 0;
> 
>  		atomic_inc(&pr_reg->pr_res_holders);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		spin_unlock(&pr_tmpl->registration_lock);
>  		/*
>  		 * Determine expected length of $FABRIC_MOD specific
> @@ -3891,7 +3891,7 @@ core_scsi3_pri_read_full_status(struct s
>  				" out of buffer: %d\n", cmd->data_length);
>  			spin_lock(&pr_tmpl->registration_lock);
>  			atomic_dec(&pr_reg->pr_res_holders);
> -			smp_mb__after_atomic_dec();
> +			smp_mb__after_atomic();
>  			break;
>  		}
>  		/*
> @@ -3953,7 +3953,7 @@ core_scsi3_pri_read_full_status(struct s
> 
>  		spin_lock(&pr_tmpl->registration_lock);
>  		atomic_dec(&pr_reg->pr_res_holders);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		/*
>  		 * Set the ADDITIONAL DESCRIPTOR LENGTH
>  		 */
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -728,7 +728,7 @@ void target_qf_do_work(struct work_struc
>  	list_for_each_entry_safe(cmd, cmd_tmp, &qf_cmd_list, se_qf_node) {
>  		list_del(&cmd->se_qf_node);
>  		atomic_dec(&dev->dev_qf_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
> 
>  		pr_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
>  			" context: %s\n", cmd->se_tfo->get_fabric_name(), cmd,
> @@ -1140,7 +1140,7 @@ transport_check_alloc_task_attr(struct s
>  	 * Dormant to Active status.
>  	 */
>  	cmd->se_ordered_id = atomic_inc_return(&dev->dev_ordered_id);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	pr_debug("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
>  			cmd->se_ordered_id, cmd->sam_task_attr,
>  			dev->transport->name);
> @@ -1692,7 +1692,7 @@ static bool target_handle_task_attr(stru
>  		return false;
>  	case MSG_ORDERED_TAG:
>  		atomic_inc(&dev->dev_ordered_sync);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
> 
>  		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list, "
>  			 " se_ordered_id: %u\n",
> @@ -1710,7 +1710,7 @@ static bool target_handle_task_attr(stru
>  		 * For SIMPLE and UNTAGGED Task Attribute commands
>  		 */
>  		atomic_inc(&dev->simple_cmds);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		break;
>  	}
> 
> @@ -1806,7 +1806,7 @@ static void transport_complete_task_attr
> 
>  	if (cmd->sam_task_attr == MSG_SIMPLE_TAG) {
>  		atomic_dec(&dev->simple_cmds);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  		dev->dev_cur_ordered_id++;
>  		pr_debug("Incremented dev->dev_cur_ordered_id: %u for"
>  			" SIMPLE: %u\n", dev->dev_cur_ordered_id,
> @@ -1818,7 +1818,7 @@ static void transport_complete_task_attr
>  			cmd->se_ordered_id);
>  	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
>  		atomic_dec(&dev->dev_ordered_sync);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
> 
>  		dev->dev_cur_ordered_id++;
>  		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED:"
> @@ -1877,7 +1877,7 @@ static void transport_handle_queue_full(
>  	spin_lock_irq(&dev->qf_cmd_lock);
>  	list_add_tail(&cmd->se_qf_node, &cmd->se_dev->qf_cmd_list);
>  	atomic_inc(&dev->dev_qf_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	spin_unlock_irq(&cmd->se_dev->qf_cmd_lock);
> 
>  	schedule_work(&cmd->se_dev->qf_work_queue);
> @@ -2805,7 +2805,7 @@ void transport_send_task_abort(struct se
>  	if (cmd->data_direction == DMA_TO_DEVICE) {
>  		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
>  			cmd->transport_state |= CMD_T_ABORTED;
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  			return;
>  		}
>  	}
> --- a/drivers/target/target_core_ua.c
> +++ b/drivers/target/target_core_ua.c
> @@ -162,7 +162,7 @@ int core_scsi3_ua_allocate(
>  		spin_unlock_irq(&nacl->device_list_lock);
> 
>  		atomic_inc(&deve->ua_count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		return 0;
>  	}
>  	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
> @@ -175,7 +175,7 @@ int core_scsi3_ua_allocate(
>  		asc, ascq);
> 
>  	atomic_inc(&deve->ua_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	return 0;
>  }
> 
> @@ -190,7 +190,7 @@ void core_scsi3_ua_release_all(
>  		kmem_cache_free(se_ua_cache, ua);
> 
>  		atomic_dec(&deve->ua_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock(&deve->ua_lock);
>  }
> @@ -251,7 +251,7 @@ void core_scsi3_ua_for_check_condition(
>  		kmem_cache_free(se_ua_cache, ua);
> 
>  		atomic_dec(&deve->ua_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock(&deve->ua_lock);
>  	spin_unlock_irq(&nacl->device_list_lock);
> @@ -310,7 +310,7 @@ int core_scsi3_ua_clear_for_request_sens
>  		kmem_cache_free(se_ua_cache, ua);
> 
>  		atomic_dec(&deve->ua_count);
> -		smp_mb__after_atomic_dec();
> +		smp_mb__after_atomic();
>  	}
>  	spin_unlock(&deve->ua_lock);
>  	spin_unlock_irq(&nacl->device_list_lock);
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -2042,7 +2042,7 @@ static int canon_copy_from_read_buf(stru
> 
>  	if (found)
>  		clear_bit(eol, ldata->read_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	ldata->read_tail += c;
> 
>  	if (found) {
> --- a/drivers/tty/serial/mxs-auart.c
> +++ b/drivers/tty/serial/mxs-auart.c
> @@ -200,7 +200,7 @@ static void dma_tx_callback(void *param)
> 
>  	/* clear the bit used to serialize the DMA tx. */
>  	clear_bit(MXS_AUART_DMA_TX_SYNC, &s->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	/* wake up the possible processes. */
>  	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> @@ -275,7 +275,7 @@ static void mxs_auart_tx_chars(struct mx
>  			mxs_auart_dma_tx(s, i);
>  		} else {
>  			clear_bit(MXS_AUART_DMA_TX_SYNC, &s->flags);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
>  		}
>  		return;
>  	}
> --- a/drivers/usb/gadget/tcm_usb_gadget.c
> +++ b/drivers/usb/gadget/tcm_usb_gadget.c
> @@ -1846,7 +1846,7 @@ static int usbg_port_link(struct se_port
>  	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
> 
>  	atomic_inc(&tpg->tpg_port_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	return 0;
>  }
> 
> @@ -1856,7 +1856,7 @@ static void usbg_port_unlink(struct se_p
>  	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
> 
>  	atomic_dec(&tpg->tpg_port_count);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  }
> 
>  static int usbg_check_stop_free(struct se_cmd *se_cmd)
> --- a/drivers/usb/serial/usb_wwan.c
> +++ b/drivers/usb/serial/usb_wwan.c
> @@ -325,7 +325,7 @@ static void usb_wwan_outdat_callback(str
> 
>  	for (i = 0; i < N_OUT_URB; ++i) {
>  		if (portdata->out_urbs[i] == urb) {
> -			smp_mb__before_clear_bit();
> +			smp_mb__before_atomic();
>  			clear_bit(i, &portdata->out_busy);
>  			break;
>  		}
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1244,7 +1244,7 @@ vhost_scsi_set_endpoint(struct vhost_scs
>  			tpg->tv_tpg_vhost_count++;
>  			tpg->vhost_scsi = vs;
>  			vs_tpg[tpg->tport_tpgt] = tpg;
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  			match = true;
>  		}
>  		mutex_unlock(&tpg->tv_tpg_mutex);
> --- a/drivers/w1/w1_family.c
> +++ b/drivers/w1/w1_family.c
> @@ -131,9 +131,9 @@ void w1_family_get(struct w1_family *f)
> 
>  void __w1_family_get(struct w1_family *f)
>  {
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_inc(&f->refcnt);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  EXPORT_SYMBOL(w1_unregister_family);
> --- a/drivers/xen/xen-pciback/pciback_ops.c
> +++ b/drivers/xen/xen-pciback/pciback_ops.c
> @@ -348,9 +348,9 @@ void xen_pcibk_do_op(struct work_struct
>  	notify_remote_via_irq(pdev->evtchn_irq);
> 
>  	/* Mark that we're done. */
> -	smp_mb__before_clear_bit(); /* /after/ clearing PCIF_active */
> +	smp_mb__before_atomic(); /* /after/ clearing PCIF_active */
>  	clear_bit(_PDEVF_op_active, &pdev->flags);
> -	smp_mb__after_clear_bit(); /* /before/ final check for work */
> +	smp_mb__after_atomic(); /* /before/ final check for work */
> 
>  	/* Check to see if the driver domain tried to start another request in
>  	 * between clearing _XEN_PCIF_active and clearing _PDEVF_op_active.
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -279,7 +279,7 @@ static inline void btrfs_inode_block_unl
> 
>  static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK,
>  		  &BTRFS_I(inode)->runtime_flags);
>  }
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3451,7 +3451,7 @@ static int lock_extent_buffer_for_io(str
>  static void end_extent_buffer_writeback(struct extent_buffer *eb)
>  {
>  	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
>  }
> 
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7078,7 +7078,7 @@ static void btrfs_end_dio_bio(struct bio
>  		 * before atomic variable goto zero, we must make sure
>  		 * dip->errors is perceived to be set.
>  		 */
> -		smp_mb__before_atomic_dec();
> +		smp_mb__before_atomic();
>  	}
> 
>  	/* if there are more bios still pending for this dio, just exit */
> @@ -7258,7 +7258,7 @@ static int btrfs_submit_direct_hook(int
>  	 * before atomic variable goto zero, we must
>  	 * make sure dip->errors is perceived to be set.
>  	 */
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	if (atomic_dec_and_test(&dip->pending_bios))
>  		bio_io_error(dip->orig_bio);
> 
> @@ -7401,7 +7401,7 @@ static ssize_t btrfs_direct_IO(int rw, s
>  		return 0;
> 
>  	atomic_inc(&inode->i_dio_count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
> 
>  	/*
>  	 * The generic stuff only does filemap_write_and_wait_range, which isn't
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -77,7 +77,7 @@ EXPORT_SYMBOL(__lock_buffer);
>  void unlock_buffer(struct buffer_head *bh)
>  {
>  	clear_bit_unlock(BH_Lock, &bh->b_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&bh->b_state, BH_Lock);
>  }
>  EXPORT_SYMBOL(unlock_buffer);
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -42,7 +42,7 @@ int ext4_resize_begin(struct super_block
>  void ext4_resize_end(struct super_block *sb)
>  {
>  	clear_bit_unlock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static ext4_group_t ext4_meta_bg_first_group(struct super_block *sb,
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -275,7 +275,7 @@ static inline int may_grant(const struct
>  static void gfs2_holder_wake(struct gfs2_holder *gh)
>  {
>  	clear_bit(HIF_WAIT, &gh->gh_iflags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
>  }
> 
> @@ -409,7 +409,7 @@ static void gfs2_demote_wake(struct gfs2
>  {
>  	gl->gl_demote_state = LM_ST_EXCLUSIVE;
>  	clear_bit(GLF_DEMOTE, &gl->gl_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
>  }
> 
> @@ -618,7 +618,7 @@ __acquires(&gl->gl_spin)
> 
>  out_sched:
>  	clear_bit(GLF_LOCK, &gl->gl_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	gl->gl_lockref.count++;
>  	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
>  		gl->gl_lockref.count--;
> @@ -626,7 +626,7 @@ __acquires(&gl->gl_spin)
> 
>  out_unlock:
>  	clear_bit(GLF_LOCK, &gl->gl_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	return;
>  }
> 
> --- a/fs/gfs2/glops.c
> +++ b/fs/gfs2/glops.c
> @@ -219,7 +219,7 @@ static void inode_go_sync(struct gfs2_gl
>  	 * Writeback of the data mapping may cause the dirty flag to be set
>  	 * so we have to clear it again here.
>  	 */
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(GLF_DIRTY, &gl->gl_flags);
>  }
> 
> --- a/fs/gfs2/lock_dlm.c
> +++ b/fs/gfs2/lock_dlm.c
> @@ -1132,7 +1132,7 @@ static void gdlm_recover_done(void *arg,
>  		queue_delayed_work(gfs2_control_wq, &sdp->sd_control_work, 0);
> 
>  	clear_bit(DFL_DLM_RECOVERY, &ls->ls_recover_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&ls->ls_recover_flags, DFL_DLM_RECOVERY);
>  	spin_unlock(&ls->ls_recover_spin);
>  }
> @@ -1269,7 +1269,7 @@ static int gdlm_mount(struct gfs2_sbd *s
> 
>  	ls->ls_first = !!test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags);
>  	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
>  	return 0;
> 
> --- a/fs/gfs2/recovery.c
> +++ b/fs/gfs2/recovery.c
> @@ -587,7 +587,7 @@ void gfs2_recover_func(struct work_struc
>  	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
>  done:
>  	clear_bit(JDF_RECOVERY, &jd->jd_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
>  }
> 
> --- a/fs/gfs2/sys.c
> +++ b/fs/gfs2/sys.c
> @@ -332,7 +332,7 @@ static ssize_t block_store(struct gfs2_s
>  		set_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
>  	else if (val == 0) {
>  		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		gfs2_glock_thaw(sdp);
>  	} else {
>  		ret = -EINVAL;
> @@ -481,7 +481,7 @@ static ssize_t jid_store(struct gfs2_sbd
>  		rv = jid = -EINVAL;
>  	sdp->sd_lockstruct.ls_jid = jid;
>  	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
>  out:
>  	spin_unlock(&sdp->sd_jindex_spin);
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -43,7 +43,7 @@ static void journal_end_buffer_io_sync(s
>  		clear_buffer_uptodate(bh);
>  	if (orig_bh) {
>  		clear_bit_unlock(BH_Shadow, &orig_bh->b_state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		wake_up_bit(&orig_bh->b_state, BH_Shadow);
>  	}
>  	unlock_buffer(bh);
> @@ -239,7 +239,7 @@ static int journal_submit_data_buffers(j
>  		spin_lock(&journal->j_list_lock);
>  		J_ASSERT(jinode->i_transaction == commit_transaction);
>  		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  	}
>  	spin_unlock(&journal->j_list_lock);
> @@ -277,7 +277,7 @@ static int journal_finish_inode_data_buf
>  		}
>  		spin_lock(&journal->j_list_lock);
>  		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  	}
> 
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -1985,9 +1985,9 @@ static void nfs_access_free_entry(struct
>  {
>  	put_rpccred(entry->cred);
>  	kfree(entry);
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_long_dec(&nfs_access_nr_entries);
> -	smp_mb__after_atomic_dec();
> +	smp_mb__after_atomic();
>  }
> 
>  static void nfs_access_free_list(struct list_head *head)
> @@ -2035,9 +2035,9 @@ nfs_access_cache_scan(struct shrinker *s
>  		else {
>  remove_lru_entry:
>  			list_del_init(&nfsi->access_cache_inode_lru);
> -			smp_mb__before_clear_bit();
> +			smp_mb__before_atomic();
>  			clear_bit(NFS_INO_ACL_LRU_SET, &nfsi->flags);
> -			smp_mb__after_clear_bit();
> +			smp_mb__after_atomic();
>  		}
>  		spin_unlock(&inode->i_lock);
>  	}
> @@ -2185,9 +2185,9 @@ void nfs_access_add_cache(struct inode *
>  	nfs_access_add_rbtree(inode, cache);
> 
>  	/* Update accounting */
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_long_inc(&nfs_access_nr_entries);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
> 
>  	/* Add inode to global LRU list */
>  	if (!test_bit(NFS_INO_ACL_LRU_SET, &NFS_I(inode)->flags)) {
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -1058,7 +1058,7 @@ int nfs_revalidate_mapping(struct inode
>  	trace_nfs_invalidate_mapping_exit(inode, ret);
> 
>  	clear_bit_unlock(NFS_INO_INVALIDATING, bitlock);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(bitlock, NFS_INO_INVALIDATING);
>  out:
>  	return ret;
> --- a/fs/nfs/nfs4filelayoutdev.c
> +++ b/fs/nfs/nfs4filelayoutdev.c
> @@ -789,9 +789,9 @@ static void nfs4_wait_ds_connect(struct
> 
>  static void nfs4_clear_ds_conn_bit(struct nfs4_pnfs_ds *ds)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(NFS4DS_CONNECTING, &ds->ds_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&ds->ds_state, NFS4DS_CONNECTING);
>  }
> 
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -1145,9 +1145,9 @@ static int nfs4_run_state_manager(void *
> 
>  static void nfs4_clear_state_manager_bit(struct nfs_client *clp)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&clp->cl_state, NFS4CLNT_MANAGER_RUNNING);
>  	rpc_wake_up(&clp->cl_rpcwaitq);
>  }
> --- a/fs/nfs/pagelist.c
> +++ b/fs/nfs/pagelist.c
> @@ -95,7 +95,7 @@ nfs_iocounter_dec(struct nfs_io_counter
>  {
>  	if (atomic_dec_and_test(&c->io_count)) {
>  		clear_bit(NFS_IO_INPROGRESS, &c->flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		wake_up_bit(&c->flags, NFS_IO_INPROGRESS);
>  	}
>  }
> @@ -193,9 +193,9 @@ void nfs_unlock_request(struct nfs_page
>  		printk(KERN_ERR "NFS: Invalid unlock attempted\n");
>  		BUG();
>  	}
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(PG_BUSY, &req->wb_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&req->wb_flags, PG_BUSY);
>  }
> 
> --- a/fs/nfs/pnfs.c
> +++ b/fs/nfs/pnfs.c
> @@ -1795,7 +1795,7 @@ static void pnfs_clear_layoutcommitting(
>  	unsigned long *bitlock = &NFS_I(inode)->flags;
> 
>  	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
>  }
> 
> --- a/fs/nfs/pnfs.h
> +++ b/fs/nfs/pnfs.h
> @@ -275,7 +275,7 @@ pnfs_get_lseg(struct pnfs_layout_segment
>  {
>  	if (lseg) {
>  		atomic_inc(&lseg->pls_refcount);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  	}
>  	return lseg;
>  }
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -405,7 +405,7 @@ int nfs_writepages(struct address_space
>  	nfs_pageio_complete(&pgio);
> 
>  	clear_bit_unlock(NFS_INO_FLUSHING, bitlock);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(bitlock, NFS_INO_FLUSHING);
> 
>  	if (err < 0)
> @@ -1458,7 +1458,7 @@ static int nfs_commit_set_lock(struct nf
>  static void nfs_commit_clear_lock(struct nfs_inode *nfsi)
>  {
>  	clear_bit(NFS_INO_COMMIT, &nfsi->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_bit(&nfsi->flags, NFS_INO_COMMIT);
>  }
> 
> --- a/fs/ubifs/lpt_commit.c
> +++ b/fs/ubifs/lpt_commit.c
> @@ -460,9 +460,9 @@ static int write_cnodes(struct ubifs_inf
>  		 * important.
>  		 */
>  		clear_bit(DIRTY_CNODE, &cnode->flags);
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(COW_CNODE, &cnode->flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		offs += len;
>  		dbg_chk_lpt_sz(c, 1, len);
>  		cnode = cnode->cnext;
> --- a/fs/ubifs/tnc_commit.c
> +++ b/fs/ubifs/tnc_commit.c
> @@ -895,9 +895,9 @@ static int write_index(struct ubifs_info
>  		 * the reason for the second barrier.
>  		 */
>  		clear_bit(DIRTY_ZNODE, &znode->flags);
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(COW_ZNODE, &znode->flags);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  		/*
>  		 * We have marked the znode as clean but have not updated the
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -16,6 +16,7 @@
>  #define __ASM_GENERIC_ATOMIC_H
> 
>  #include <asm/cmpxchg.h>
> +#include <asm/barrier.h>
> 
>  #ifdef CONFIG_SMP
>  /* Force people to define core atomics */
> @@ -182,11 +183,5 @@ static inline void atomic_set_mask(unsig
>  }
>  #endif
> 
> -/* Assume that atomic operations are already serializing */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> -
>  #endif /* __KERNEL__ */
>  #endif /* __ASM_GENERIC_ATOMIC_H */
> --- a/include/asm-generic/barrier.h
> +++ b/include/asm-generic/barrier.h
> @@ -62,6 +62,14 @@
>  #define set_mb(var, value)  do { (var) = (value); mb(); } while (0)
>  #endif
> 
> +#ifndef smp_mb__before_atomic
> +#define smp_mb__before_atomic()	smp_mb()
> +#endif
> +
> +#ifndef smp_mb__after_atomic
> +#define smp_mb__after_atomic()	smp_mb()
> +#endif
> +
>  #define smp_store_release(p, v)						\
>  do {									\
>  	compiletime_assert_atomic_type(*p);				\
> --- a/include/asm-generic/bitops.h
> +++ b/include/asm-generic/bitops.h
> @@ -11,14 +11,8 @@
> 
>  #include <linux/irqflags.h>
>  #include <linux/compiler.h>
> +#include <asm/barrier.h>
> 
> -/*
> - * clear_bit may not imply a memory barrier
> - */
> -#ifndef smp_mb__before_clear_bit
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> -#endif
> 
>  #include <asm-generic/bitops/__ffs.h>
>  #include <asm-generic/bitops/ffz.h>
> --- a/include/asm-generic/bitops/atomic.h
> +++ b/include/asm-generic/bitops/atomic.h
> @@ -80,7 +80,7 @@ static inline void set_bit(int nr, volat
>   *
>   * clear_bit() is atomic and may not be reordered.  However, it does
>   * not contain a memory barrier, so if it is used for locking purposes,
> - * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
> + * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
>   * in order to ensure changes are visible on other processors.
>   */
>  static inline void clear_bit(int nr, volatile unsigned long *addr)
> --- a/include/asm-generic/bitops/lock.h
> +++ b/include/asm-generic/bitops/lock.h
> @@ -20,7 +20,7 @@
>   */
>  #define clear_bit_unlock(nr, addr)	\
>  do {					\
> -	smp_mb__before_clear_bit();	\
> +	smp_mb__before_atomic();	\
>  	clear_bit(nr, addr);		\
>  } while (0)
> 
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -278,7 +278,7 @@ static inline void get_bh(struct buffer_
> 
>  static inline void put_bh(struct buffer_head *bh)
>  {
> -        smp_mb__before_atomic_dec();
> +        smp_mb__before_atomic();
>          atomic_dec(&bh->b_count);
>  }
> 
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -649,7 +649,7 @@ static inline void hd_ref_init(struct hd
>  static inline void hd_struct_get(struct hd_struct *part)
>  {
>  	atomic_inc(&part->ref);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  static inline int hd_struct_try_get(struct hd_struct *part)
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -447,7 +447,7 @@ static inline int tasklet_trylock(struct
> 
>  static inline void tasklet_unlock(struct tasklet_struct *t)
>  {
> -	smp_mb__before_clear_bit(); 
> +	smp_mb__before_atomic();
>  	clear_bit(TASKLET_STATE_RUN, &(t)->state);
>  }
> 
> @@ -495,7 +495,7 @@ static inline void tasklet_hi_schedule_f
>  static inline void tasklet_disable_nosync(struct tasklet_struct *t)
>  {
>  	atomic_inc(&t->count);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  static inline void tasklet_disable(struct tasklet_struct *t)
> @@ -507,13 +507,13 @@ static inline void tasklet_disable(struc
> 
>  static inline void tasklet_enable(struct tasklet_struct *t)
>  {
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&t->count);
>  }
> 
>  static inline void tasklet_hi_enable(struct tasklet_struct *t)
>  {
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&t->count);
>  }
> 
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -500,7 +500,7 @@ static inline void napi_disable(struct n
>  static inline void napi_enable(struct napi_struct *n)
>  {
>  	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(NAPI_STATE_SCHED, &n->state);
>  }
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2737,10 +2737,8 @@ static inline bool __must_check current_
>  	/*
>  	 * Polling state must be visible before we test NEED_RESCHED,
>  	 * paired by resched_task()
> -	 *
> -	 * XXX: assumes set/clear bit are identical barrier wise.
>  	 */
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return unlikely(tif_need_resched());
>  }
> @@ -2758,7 +2756,7 @@ static inline bool __must_check current_
>  	 * Polling state must be visible before we test NEED_RESCHED,
>  	 * paired by resched_task()
>  	 */
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return unlikely(tif_need_resched());
>  }
> --- a/include/linux/sunrpc/sched.h
> +++ b/include/linux/sunrpc/sched.h
> @@ -142,18 +142,18 @@ struct rpc_task_setup {
>  				test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
>  #define rpc_clear_running(t)	\
>  	do { \
> -		smp_mb__before_clear_bit(); \
> +		smp_mb__before_atomic(); \
>  		clear_bit(RPC_TASK_RUNNING, &(t)->tk_runstate); \
> -		smp_mb__after_clear_bit(); \
> +		smp_mb__after_atomic(); \
>  	} while (0)
> 
>  #define RPC_IS_QUEUED(t)	test_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
>  #define rpc_set_queued(t)	set_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
>  #define rpc_clear_queued(t)	\
>  	do { \
> -		smp_mb__before_clear_bit(); \
> +		smp_mb__before_atomic(); \
>  		clear_bit(RPC_TASK_QUEUED, &(t)->tk_runstate); \
> -		smp_mb__after_clear_bit(); \
> +		smp_mb__after_atomic(); \
>  	} while (0)
> 
>  #define RPC_IS_ACTIVATED(t)	test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate)
> --- a/include/linux/sunrpc/xprt.h
> +++ b/include/linux/sunrpc/xprt.h
> @@ -368,9 +368,9 @@ static inline int xprt_test_and_clear_co
> 
>  static inline void xprt_clear_connecting(struct rpc_xprt *xprt)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(XPRT_CONNECTING, &xprt->state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static inline int xprt_connecting(struct rpc_xprt *xprt)
> @@ -400,9 +400,9 @@ static inline void xprt_clear_bound(stru
> 
>  static inline void xprt_clear_binding(struct rpc_xprt *xprt)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(XPRT_BINDING, &xprt->state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static inline int xprt_test_and_set_binding(struct rpc_xprt *xprt)
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -191,7 +191,7 @@ static inline void tracehook_notify_resu
>  	 * pairs with task_work_add()->set_notify_resume() after
>  	 * hlist_add_head(task->task_works);
>  	 */
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	if (unlikely(current->task_works))
>  		task_work_run();
>  }
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -1204,7 +1204,7 @@ static inline bool __ip_vs_conn_get(stru
>  /* put back the conn without restarting its timer */
>  static inline void __ip_vs_conn_put(struct ip_vs_conn *cp)
>  {
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&cp->refcnt);
>  }
>  void ip_vs_conn_put(struct ip_vs_conn *cp);
> @@ -1408,7 +1408,7 @@ static inline void ip_vs_dest_hold(struc
> 
>  static inline void ip_vs_dest_put(struct ip_vs_dest *dest)
>  {
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&dest->refcnt);
>  }
> 
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -526,7 +526,7 @@ static int kgdb_cpu_enter(struct kgdb_st
>  			kgdb_info[cpu].exception_state &=
>  				~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
>  			kgdb_info[cpu].enter_kgdb--;
> -			smp_mb__before_atomic_dec();
> +			smp_mb__before_atomic();
>  			atomic_dec(&slaves_in_kgdb);
>  			dbg_touch_watchdogs();
>  			local_irq_restore(flags);
> @@ -654,7 +654,7 @@ static int kgdb_cpu_enter(struct kgdb_st
>  	kgdb_info[cpu].exception_state &=
>  		~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
>  	kgdb_info[cpu].enter_kgdb--;
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&masters_in_kgdb);
>  	/* Free kgdb_active */
>  	atomic_set(&kgdb_active, -1);
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -250,7 +250,7 @@ static inline void futex_get_mm(union fu
>  	 * get_futex_key() implies a full barrier. This is relied upon
>  	 * as full barrier (B), see the ordering comment above.
>  	 */
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  static inline bool hb_waiters_pending(struct futex_hash_bucket *hb)
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -498,7 +498,7 @@ int __usermodehelper_disable(enum umh_di
>  static void helper_lock(void)
>  {
>  	atomic_inc(&running_helpers);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  }
> 
>  static void helper_unlock(void)
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -389,9 +389,9 @@ static void rcu_eqs_enter_common(struct
>  	}
>  	rcu_prepare_for_idle(smp_processor_id());
>  	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
> -	smp_mb__before_atomic_inc();  /* See above. */
> +	smp_mb__before_atomic();  /* See above. */
>  	atomic_inc(&rdtp->dynticks);
> -	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
> +	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
>  	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
> 
>  	/*
> @@ -509,10 +509,10 @@ void rcu_irq_exit(void)
>  static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
>  			       int user)
>  {
> -	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
> +	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
>  	atomic_inc(&rdtp->dynticks);
>  	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
> -	smp_mb__after_atomic_inc();  /* See above. */
> +	smp_mb__after_atomic();  /* See above. */
>  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
>  	rcu_cleanup_after_idle(smp_processor_id());
>  	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
> @@ -637,10 +637,10 @@ void rcu_nmi_enter(void)
>  	    (atomic_read(&rdtp->dynticks) & 0x1))
>  		return;
>  	rdtp->dynticks_nmi_nesting++;
> -	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
> +	smp_mb__before_atomic();  /* Force delay from prior write. */
>  	atomic_inc(&rdtp->dynticks);
>  	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
> -	smp_mb__after_atomic_inc();  /* See above. */
> +	smp_mb__after_atomic();  /* See above. */
>  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
>  }
> 
> @@ -659,9 +659,9 @@ void rcu_nmi_exit(void)
>  	    --rdtp->dynticks_nmi_nesting != 0)
>  		return;
>  	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
> -	smp_mb__before_atomic_inc();  /* See above. */
> +	smp_mb__before_atomic();  /* See above. */
>  	atomic_inc(&rdtp->dynticks);
> -	smp_mb__after_atomic_inc();  /* Force delay to next write. */
> +	smp_mb__after_atomic();  /* Force delay to next write. */
>  	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
>  }
> 
> @@ -2738,7 +2738,7 @@ void synchronize_sched_expedited(void)
>  		s = atomic_long_read(&rsp->expedited_done);
>  		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
>  			/* ensure test happens before caller kfree */
> -			smp_mb__before_atomic_inc(); /* ^^^ */
> +			smp_mb__before_atomic(); /* ^^^ */
>  			atomic_long_inc(&rsp->expedited_workdone1);
>  			return;
>  		}
> @@ -2756,7 +2756,7 @@ void synchronize_sched_expedited(void)
>  		s = atomic_long_read(&rsp->expedited_done);
>  		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
>  			/* ensure test happens before caller kfree */
> -			smp_mb__before_atomic_inc(); /* ^^^ */
> +			smp_mb__before_atomic(); /* ^^^ */
>  			atomic_long_inc(&rsp->expedited_workdone2);
>  			return;
>  		}
> @@ -2785,7 +2785,7 @@ void synchronize_sched_expedited(void)
>  		s = atomic_long_read(&rsp->expedited_done);
>  		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
>  			/* ensure test happens before caller kfree */
> -			smp_mb__before_atomic_inc(); /* ^^^ */
> +			smp_mb__before_atomic(); /* ^^^ */
>  			atomic_long_inc(&rsp->expedited_done_lost);
>  			break;
>  		}
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2514,9 +2514,9 @@ static void rcu_sysidle_enter(struct rcu
>  	/* Record start of fully idle period. */
>  	j = jiffies;
>  	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_inc(&rdtp->dynticks_idle);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
>  }
> 
> @@ -2581,9 +2581,9 @@ static void rcu_sysidle_exit(struct rcu_
>  	}
> 
>  	/* Record end of idle period. */
> -	smp_mb__before_atomic_inc();
> +	smp_mb__before_atomic();
>  	atomic_inc(&rdtp->dynticks_idle);
> -	smp_mb__after_atomic_inc();
> +	smp_mb__after_atomic();
>  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
> 
>  	/*
> --- a/kernel/sched/cpupri.c
> +++ b/kernel/sched/cpupri.c
> @@ -165,7 +165,7 @@ void cpupri_set(struct cpupri *cp, int c
>  		 * do a write memory barrier, and then update the count, to
>  		 * make sure the vector is visible when count is set.
>  		 */
> -		smp_mb__before_atomic_inc();
> +		smp_mb__before_atomic();
>  		atomic_inc(&(vec)->count);
>  		do_mb = 1;
>  	}
> @@ -185,14 +185,14 @@ void cpupri_set(struct cpupri *cp, int c
>  		 * the new priority vec.
>  		 */
>  		if (do_mb)
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
> 
>  		/*
>  		 * When removing from the vector, we decrement the counter first
>  		 * do a memory barrier and then clear the mask.
>  		 */
>  		atomic_dec(&(vec)->count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		cpumask_clear_cpu(cpu, vec->mask);
>  	}
> 
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -394,7 +394,7 @@ EXPORT_SYMBOL(__wake_up_bit);
>   *
>   * In order for this to function properly, as it uses waitqueue_active()
>   * internally, some kind of memory barrier must be done prior to calling
> - * this. Typically, this will be smp_mb__after_clear_bit(), but in some
> + * this. Typically, this will be smp_mb__after_atomic(), but in some
>   * cases where bitflags are manipulated non-atomically under a lock, one
>   * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
>   * because spin_unlock() does not guarantee a memory barrier.
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -549,7 +549,7 @@ void clear_bdi_congested(struct backing_
>  	bit = sync ? BDI_sync_congested : BDI_async_congested;
>  	if (test_and_clear_bit(bit, &bdi->state))
>  		atomic_dec(&nr_bdi_congested[sync]);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	if (waitqueue_active(wqh))
>  		wake_up(wqh);
>  }
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -609,7 +609,7 @@ void unlock_page(struct page *page)
>  {
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	clear_bit_unlock(PG_locked, &page->flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_page(page, PG_locked);
>  }
>  EXPORT_SYMBOL(unlock_page);
> @@ -626,7 +626,7 @@ void end_page_writeback(struct page *pag
>  	if (!test_clear_page_writeback(page))
>  		BUG();
> 
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	wake_up_page(page, PG_writeback);
>  }
>  EXPORT_SYMBOL(end_page_writeback);
> --- a/net/atm/pppoatm.c
> +++ b/net/atm/pppoatm.c
> @@ -252,7 +252,7 @@ static int pppoatm_may_send(struct pppoa
>  	 * we need to ensure there's a memory barrier after it. The bit
>  	 * *must* be set before we do the atomic_inc() on pvcc->inflight.
>  	 * There's no smp_mb__after_set_bit(), so it's this or abuse
> -	 * smp_mb__after_clear_bit().
> +	 * smp_mb__after_atomic().
>  	 */
>  	test_and_set_bit(BLOCKED, &pvcc->blocked);
> 
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -45,7 +45,7 @@ static void hci_cc_inquiry_cancel(struct
>  		return;
> 
>  	clear_bit(HCI_INQUIRY, &hdev->flags);
> -	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
> +	smp_mb__after_atomic(); /* wake_up_bit advises about this barrier */
>  	wake_up_bit(&hdev->flags, HCI_INQUIRY);
> 
>  	hci_conn_check_pending(hdev);
> @@ -1531,7 +1531,7 @@ static void hci_inquiry_complete_evt(str
>  	if (!test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
>  		return;
> 
> -	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
> +	smp_mb__after_atomic(); /* wake_up_bit advises about this barrier */
>  	wake_up_bit(&hdev->flags, HCI_INQUIRY);
> 
>  	if (!test_bit(HCI_MGMT, &hdev->dev_flags))
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1323,7 +1323,7 @@ static int __dev_close_many(struct list_
>  		 * dev->stop() will invoke napi_disable() on all of it's
>  		 * napi_struct instances on this device.
>  		 */
> -		smp_mb__after_clear_bit(); /* Commit netif_running(). */
> +		smp_mb__after_atomic(); /* Commit netif_running(). */
>  	}
> 
>  	dev_deactivate_many(head);
> @@ -3343,7 +3343,7 @@ static void net_tx_action(struct softirq
> 
>  			root_lock = qdisc_lock(q);
>  			if (spin_trylock(root_lock)) {
> -				smp_mb__before_clear_bit();
> +				smp_mb__before_atomic();
>  				clear_bit(__QDISC_STATE_SCHED,
>  					  &q->state);
>  				qdisc_run(q);
> @@ -3353,7 +3353,7 @@ static void net_tx_action(struct softirq
>  					      &q->state)) {
>  					__netif_reschedule(q);
>  				} else {
> -					smp_mb__before_clear_bit();
> +					smp_mb__before_atomic();
>  					clear_bit(__QDISC_STATE_SCHED,
>  						  &q->state);
>  				}
> @@ -4216,7 +4216,7 @@ void __napi_complete(struct napi_struct
>  	BUG_ON(n->gro_list);
> 
>  	list_del(&n->poll_list);
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(NAPI_STATE_SCHED, &n->state);
>  }
>  EXPORT_SYMBOL(__napi_complete);
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -147,7 +147,7 @@ static void linkwatch_do_dev(struct net_
>  	 * Make sure the above read is complete since it can be
>  	 * rewritten as soon as we clear the bit below.
>  	 */
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
> 
>  	/* We are about to handle this device,
>  	 * so new events can be accepted
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
>  void inet_putpeer(struct inet_peer *p)
>  {
>  	p->dtime = (__u32)jiffies;
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&p->refcnt);
>  }
>  EXPORT_SYMBOL_GPL(inet_putpeer);
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -751,7 +751,7 @@ void nf_conntrack_free(struct nf_conn *c
>  	nf_ct_ext_destroy(ct);
>  	nf_ct_ext_free(ct);
>  	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
> -	smp_mb__before_atomic_dec();
> +	smp_mb__before_atomic();
>  	atomic_dec(&net->ct.count);
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_free);
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -598,7 +598,7 @@ static void rds_ib_set_ack(struct rds_ib
>  {
>  	atomic64_set(&ic->i_ack_next, seq);
>  	if (ack_required) {
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
>  	}
>  }
> @@ -606,7 +606,7 @@ static void rds_ib_set_ack(struct rds_ib
>  static u64 rds_ib_get_ack(struct rds_ib_connection *ic)
>  {
>  	clear_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return atomic64_read(&ic->i_ack_next);
>  }
> --- a/net/rds/iw_recv.c
> +++ b/net/rds/iw_recv.c
> @@ -429,7 +429,7 @@ static void rds_iw_set_ack(struct rds_iw
>  {
>  	atomic64_set(&ic->i_ack_next, seq);
>  	if (ack_required) {
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
>  	}
>  }
> @@ -437,7 +437,7 @@ static void rds_iw_set_ack(struct rds_iw
>  static u64 rds_iw_get_ack(struct rds_iw_connection *ic)
>  {
>  	clear_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	return atomic64_read(&ic->i_ack_next);
>  }
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -107,7 +107,7 @@ static int acquire_in_xmit(struct rds_co
>  static void release_in_xmit(struct rds_connection *conn)
>  {
>  	clear_bit(RDS_IN_XMIT, &conn->c_flags);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	/*
>  	 * We don't use wait_on_bit()/wake_up_bit() because our waking is in a
>  	 * hot path and finding waiters is very rare.  We don't want to walk
> @@ -661,7 +661,7 @@ void rds_send_drop_acked(struct rds_conn
> 
>  	/* order flag updates with spin locks */
>  	if (!list_empty(&list))
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
> 
>  	spin_unlock_irqrestore(&conn->c_lock, flags);
> 
> @@ -691,7 +691,7 @@ void rds_send_drop_to(struct rds_sock *r
>  	}
> 
>  	/* order flag updates with the rs lock */
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	spin_unlock_irqrestore(&rs->rs_lock, flags);
> 
> --- a/net/rds/tcp_send.c
> +++ b/net/rds/tcp_send.c
> @@ -93,7 +93,7 @@ int rds_tcp_xmit(struct rds_connection *
>  		rm->m_ack_seq = tc->t_last_sent_nxt +
>  				sizeof(struct rds_header) +
>  				be32_to_cpu(rm->m_inc.i_hdr.h_len) - 1;
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		set_bit(RDS_MSG_HAS_ACK_SEQ, &rm->m_flags);
>  		tc->t_last_expected_una = rm->m_ack_seq + 1;
> 
> --- a/net/sunrpc/auth.c
> +++ b/net/sunrpc/auth.c
> @@ -296,7 +296,7 @@ static void
>  rpcauth_unhash_cred_locked(struct rpc_cred *cred)
>  {
>  	hlist_del_rcu(&cred->cr_hash);
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(RPCAUTH_CRED_HASHED, &cred->cr_flags);
>  }
> 
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -142,7 +142,7 @@ gss_cred_set_ctx(struct rpc_cred *cred,
>  	gss_get_ctx(ctx);
>  	rcu_assign_pointer(gss_cred->gc_ctx, ctx);
>  	set_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(RPCAUTH_CRED_NEW, &cred->cr_flags);
>  }
> 
> --- a/net/sunrpc/backchannel_rqst.c
> +++ b/net/sunrpc/backchannel_rqst.c
> @@ -257,10 +257,10 @@ void xprt_free_bc_request(struct rpc_rqs
> 
>  	dprintk("RPC:       free backchannel req=%p\n", req);
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	WARN_ON_ONCE(!test_bit(RPC_BC_PA_IN_USE, &req->rq_bc_pa_state));
>  	clear_bit(RPC_BC_PA_IN_USE, &req->rq_bc_pa_state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
> 
>  	if (!xprt_need_to_requeue(xprt)) {
>  		/*
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -230,9 +230,9 @@ static void xprt_clear_locked(struct rpc
>  {
>  	xprt->snd_task = NULL;
>  	if (!test_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(XPRT_LOCKED, &xprt->state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  	} else
>  		queue_work(rpciod_workqueue, &xprt->task_cleanup);
>  }
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -889,11 +889,11 @@ static void xs_close(struct rpc_xprt *xp
>  	xs_reset_transport(transport);
>  	xprt->reestablish_timeout = 0;
> 
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
>  	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
>  	clear_bit(XPRT_CLOSING, &xprt->state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	xprt_disconnect_done(xprt);
>  }
> 
> @@ -1500,12 +1500,12 @@ static void xs_tcp_cancel_linger_timeout
> 
>  static void xs_sock_reset_connection_flags(struct rpc_xprt *xprt)
>  {
> -	smp_mb__before_clear_bit();
> +	smp_mb__before_atomic();
>  	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
>  	clear_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
>  	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
>  	clear_bit(XPRT_CLOSING, &xprt->state);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  }
> 
>  static void xs_sock_mark_closed(struct rpc_xprt *xprt)
> @@ -1559,10 +1559,10 @@ static void xs_tcp_state_change(struct s
>  		xprt->connect_cookie++;
>  		xprt->reestablish_timeout = 0;
>  		set_bit(XPRT_CLOSING, &xprt->state);
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(XPRT_CONNECTED, &xprt->state);
>  		clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		xs_tcp_schedule_linger_timeout(xprt, xs_tcp_fin_timeout);
>  		break;
>  	case TCP_CLOSE_WAIT:
> @@ -1581,9 +1581,9 @@ static void xs_tcp_state_change(struct s
>  	case TCP_LAST_ACK:
>  		set_bit(XPRT_CLOSING, &xprt->state);
>  		xs_tcp_schedule_linger_timeout(xprt, xs_tcp_fin_timeout);
> -		smp_mb__before_clear_bit();
> +		smp_mb__before_atomic();
>  		clear_bit(XPRT_CONNECTED, &xprt->state);
> -		smp_mb__after_clear_bit();
> +		smp_mb__after_atomic();
>  		break;
>  	case TCP_CLOSE:
>  		xs_tcp_cancel_linger_timeout(xprt);
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1208,7 +1208,7 @@ static int unix_stream_connect(struct so
>  	sk->sk_state	= TCP_ESTABLISHED;
>  	sock_hold(newsk);
> 
> -	smp_mb__after_atomic_inc();	/* sock_hold() does an atomic_inc() */
> +	smp_mb__after_atomic();	/* sock_hold() does an atomic_inc() */
>  	unix_peer(sk)	= newsk;
> 
>  	unix_state_unlock(sk);
> --- a/sound/pci/bt87x.c
> +++ b/sound/pci/bt87x.c
> @@ -435,7 +435,7 @@ static int snd_bt87x_pcm_open(struct snd
> 
>  _error:
>  	clear_bit(0, &chip->opened);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	return err;
>  }
> 
> @@ -450,7 +450,7 @@ static int snd_bt87x_close(struct snd_pc
> 
>  	chip->substream = NULL;
>  	clear_bit(0, &chip->opened);
> -	smp_mb__after_clear_bit();
> +	smp_mb__after_atomic();
>  	return 0;
>  }
> 
> 
> 

