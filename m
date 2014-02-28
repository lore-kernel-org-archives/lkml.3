Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaB1BCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:02:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52184 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaB1BCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:02:20 -0500
Date: Thu, 27 Feb 2014 17:02:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140228010214.GA16768@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
 <20140224185341.GU8264@linux.vnet.ibm.com>
 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
 <1393515453.28840.9961.camel@triegel.csb>
 <20140227175021.GT8264@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227175021.GT8264@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022801-0928-0000-0000-0000000415ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 09:50:21AM -0800, Paul E. McKenney wrote:
> On Thu, Feb 27, 2014 at 04:37:33PM +0100, Torvald Riegel wrote:
> > xagsmtp2.20140227154925.3851@vmsdvm9.vnet.ibm.com
> > 
> > On Mon, 2014-02-24 at 11:54 -0800, Linus Torvalds wrote:
> > > On Mon, Feb 24, 2014 at 10:53 AM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > >
> > > > Good points.  How about the following replacements?
> > > >
> > > > 3.      Adding or subtracting an integer to/from a chained pointer
> > > >         results in another chained pointer in that same pointer chain.
> > > >         The results of addition and subtraction operations that cancel
> > > >         the chained pointer's value (for example, "p-(long)p" where "p"
> > > >         is a pointer to char) are implementation defined.
> > > >
> > > > 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
> > > >         applied to a chained pointer and an integer for the purposes
> > > >         of alignment and pointer translation results in another
> > > >         chained pointer in that same pointer chain.  Other uses
> > > >         of bitwise operators on chained pointers (for example,
> > > >         "p|~0") are implementation defined.
> > > 
> > > Quite frankly, I think all of this language that is about the actual
> > > operations is irrelevant and wrong.
> > > 
> > > It's not going to help compiler writers, and it sure isn't going to
> > > help users that read this.
> > > 
> > > Why not just talk about "value chains" and that any operations that
> > > restrict the value range severely end up breaking the chain. There is
> > > no point in listing the operations individually, because every single
> > > operation *can* restrict things. Listing individual operations and
> > > depdendencies is just fundamentally wrong.
> > 
> > [...]
> > 
> > > The *only* thing that matters for all of them is whether they are
> > > "value-preserving", or whether they drop so much information that the
> > > compiler might decide to use a control dependency instead. That's true
> > > for every single one of them.
> > > 
> > > Similarly, actual true control dependencies that limit the problem
> > > space sufficiently that the actual pointer value no longer has
> > > significant information in it (see the above example) are also things
> > > that remove information to the point that only a control dependency
> > > remains. Even when the value itself is not modified in any way at all.
> > 
> > I agree that just considering syntactic properties of the program seems
> > to be insufficient.  Making it instead depend on whether there is a
> > "semantic" dependency due to a value being "necessary" to compute a
> > result seems better.  However, whether a value is "necessary" might not
> > be obvious, and I understand Paul's argument that he does not want to
> > have to reason about all potential compiler optimizations.  Thus, I
> > believe we need to specify when a value is "necessary".
> > 
> > I have a suggestion for a somewhat different formulation of the feature
> > that you seem to have in mind, which I'll discuss below.  Excuse the
> > verbosity of the following, but I'd rather like to avoid
> > misunderstandings than save a few words.
> 
> Thank you very much for putting this forward!  I must confess that I was
> stuck, and my earlier attempt now enshrined in the C11 and C++11 standards
> is quite clearly way bogus.
> 
> One possible saving grace:  From discussions at the standards committee
> meeting a few weeks ago, there is a some chance that the committee will
> be willing to do a rip-and-replace on the current memory_order_consume
> wording, without provisions for backwards compatibility with the current
> bogosity.
> 
> > What we'd like to capture is that a value originating from a mo_consume
> > load is "necessary" for a computation (e.g., it "cannot" be replaced
> > with value predictions and/or control dependencies); if that's the case
> > in the program, we can reasonably assume that a compiler implementation
> > will transform this into a data dependency, which will then lead to
> > ordering guarantees by the HW.
> > 
> > However, we need to specify when a value is "necessary".  We could say
> > that this is implementation-defined, and use a set of litmus tests
> > (e.g., like those discussed in the thread) to roughly carve out what a
> > programmer could expect.  This may even be practical for a project like
> > the Linux kernel that follows strict project-internal rules and pays a
> > lot of attention to what the particular implementations of compilers
> > expected to compile the kernel are doing.  However, I think this
> > approach would be too vague for the standard and for many other
> > programs/projects.
> 
> I agree that a number of other projects would have more need for this than
> might the kernel.  Please understand that this is in no way denigrating
> the intelligence of other projects' members.  It is just that many of
> them have only recently started seriously thinking about concurrency.
> In contrast, the Linux kernel community has been doing concurrency since
> the mid-1990s.  Projects with less experience with concurrency will
> probably need more help, from the compiler and from elsewhere as well.
> 
> Your proposal looks quite promising at first glance.  But rather than
> try and comment on it immediately, I am going to take a number of uses of
> RCU from the Linux kernel and apply your proposal to them, then respond
> with the results

And here is an initial set of six selected randomly from the Linux kernel
(assuming you trust awk's random-number generator).  This is of course a
tiny subset of what is in the kernel, but should be a good set to start
with.  Looks like a reasonable start to me, though I would not expect the
kernel to convert over wholesale any time soon.  Which is OK, there are
userspace projects using RCU.

Thoughts?  Am I understanding your proposal at all?  ;-)

							Thanx, Paul

------------------------------------------------------------------------

value_dep_preserving usage examples.

/* The following is approximate -- need sparse and maybe other checking. */
#define rcu_dereference(x) atomic_load_explicit(&(x), memory_order_consume)

1.	mm/vmalloc.c __purge_vmap_area_lazy()

	This requires only two small changes.  I am not sure that the
	second change is necessary.  My guess is that it is, on the theory
	that passing a non-value_dep_preserving variable in through a
	value_dep_preserving argument is guaranteed OK, give or take
	unnecessary suppression of optimizations, but that passing a
	value_dep_preserving in through a non-value_dep_preserving could
	be a serious bug.

	That said, the Linux kernel convention is that once you leave
	the outermost rcu_read_lock(), there is no more value dependency
	preservation.  Implementing this convention would remove the
	need for the cast, for whatever that is worth.

	static void __purge_vmap_area_lazy(...)
	{
		static DEFINE_SPINLOCK(purge_lock);
		LIST_HEAD(valist);
		struct vmap_area value_dep_preserving *va; /* CHANGE */
		struct vmap_area *n_va;
		int nr = 0;

		...

		rcu_read_lock();
		list_for_each_entry_rcu(va, &vmap_area_list, list) {
			if (va->flags & VM_LAZY_FREE) {
				if (va->va_start < *start)
					*start = va->va_start;
				if (va->va_end > *end)
					*end = va->va_end;
				nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
				list_add_tail(&va->purge_list, &valist);
				va->flags |= VM_LAZY_FREEING;
				va->flags &= ~VM_LAZY_FREE;
			}
		}
		rcu_read_unlock();

		...

		if (nr) {
			spin_lock(&vmap_area_lock);
			list_for_each_entry_safe(va, n_va, &valist, purge_list)
				__free_vmap_area((struct vmap_area *)va); /* CHANGE */
			spin_unlock(&vmap_area_lock);
		}
		...
	}

2.	net/core/sock.c sock_def_wakeup()

	static void sock_def_wakeup(struct sock *sk)
	{
		struct socket_wq value_dep_preserving *wq; /* CHANGE */

		rcu_read_lock();
		wq = rcu_dereference(sk->sk_wq);
		if (wq_has_sleeper(wq))
			wake_up_interruptible_all(&((struct socket_wq *)wq->wait)); /* CHANGE */
		rcu_read_unlock();
	}

	This calls wq_has_sleeper():

	static inline bool
	wq_has_sleeper(struct socket_wq value_dep_preserving *wq) /* CHANGE */
	{
		/* We need to be sure we are in sync with the
		 * add_wait_queue modifications to the wait queue.
		 *
		 * This memory barrier is paired in the sock_poll_wait.
		 */
		smp_mb();
		return wq && waitqueue_active(&wq->wait);
	}

	Although wq_has_sleeper() has a full memory barrier and therefore
	does not need value_dep_preserving, it seems to be called from
	within a lot of RCU read-side critical sections, so it is likely
	a bit nicer to decorate its argument than to apply casts to all
	calls.

	Is "&wq->wait" also value_dep_preserving?  The call to
	wake_up_interruptible_all() doesn't need it to be because it
	acquires a spinlock within the structure, and the ensuing barriers
	and atomic instructions enforce all the ordering that is required.

	The call waitqueue_active() is preceded by a full barrier, so
	it too has all the ordering it needs.

	So this example is slightly nicer if, given a value_dep_preserving
	pointer "p", "&p->f" is non-value_dep_preserving.  But there
	will likely be other examples that strongly prefer otherwise,
	and the pair of casts required here are not that horrible.
	Plus this approach matches our discussion earlier in this thread.

	Might be nice to have an intrinsic that takes a value_dep_preserving
	pointer and returns a non-value_dep_preserving pointer with the
	same value.

3.	net/ipv4/tcp_cong.c tcp_init_congestion_control()

	This example requires only one change.	I am assuming
	that if "p" is value_dep_preserving, then "p->a" is -not-
	value_dep_preserving unless the struct field "a" has been
	declared value_dep_preserving.	This means that there is no
	need to change the "try_module_get(ca->owner)", which is a nice
	improvement over the current memory_order_consume work.

	I believe that this approach will do much to trim what would
	otherwise be over-large value_dep_preserving regions.

	void tcp_init_congestion_control(struct sock *sk)
	{
		struct inet_connection_sock *icsk = inet_csk(sk);
		struct tcp_congestion_ops value_dep_preserving *ca; /* CHANGE */

		if (icsk->icsk_ca_ops == &tcp_init_congestion_ops) {
			rcu_read_lock();
			list_for_each_entry_rcu(ca, &tcp_cong_list, list) {
				if (try_module_get(ca->owner)) {
					icsk->icsk_ca_ops = ca;
					break;
				}

				/* fallback to next available */
			}
			rcu_read_unlock();
		}

		if (icsk->icsk_ca_ops->init)
			icsk->icsk_ca_ops->init(sk);
	}

4.	drivers/target/tcm_fc/tfc_sess.c ft_sess_get()

	This one brings up an interesting point.  I am guessing that
	the value_dep_preserving should be silently stripped when the
	value is passed in through __VA_ARGS__, as in pr_debug() below.
	
	Thoughts?

	static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
	{
		struct ft_tport value_dep_preserving *tport; /* CHANGE */
		struct hlist_head *head;
		struct ft_sess value_dep_preserving *sess; /* CHANGE */

		rcu_read_lock();
		tport = rcu_dereference(lport->prov[FC_TYPE_FCP]);
		if (!tport)
			goto out;

		head = &tport->hash[ft_sess_hash(port_id)];
		hlist_for_each_entry_rcu(sess, head, hash) {
			if (sess->port_id == port_id) {
				kref_get((struct kref *)&sess->kref); /* CHANGE */
				rcu_read_unlock();
				pr_debug("port_id %x found %p\n", port_id, sess);
				return sess;
			}
		}
	out:
		rcu_read_unlock();
		pr_debug("port_id %x not found\n", port_id);
		return NULL;
	}

5.	net/netlabel/netlabel_unlabeled.c netlbl_unlhsh_search_iface()

	This one is interesting -- you have to go up a function-call
	level to find the rcu_read_lock.

	netlbl_unlhsh_add() calls netlbl_unlhsh_search_iface().

	There is no need for value_dep_preserving to flow into
	netlbl_unlhsh_search_iface(), but its return value appears
	to need to be netlbl_unlhsh_search_iface.

	static struct netlbl_unlhsh_iface value_dep_preserving *
	netlbl_unlhsh_search_iface(int ifindex) /* CHANGE */
	{
		u32 bkt;
		struct list_head *bkt_list;
		struct netlbl_unlhsh_iface value_dep_preserving *iter; /* CHANGE */

		bkt = netlbl_unlhsh_hash(ifindex);
		bkt_list = &netlbl_unlhsh_rcu_deref(netlbl_unlhsh)->tbl[bkt];
		list_for_each_entry_rcu(iter, bkt_list, list)
			if (iter->valid && iter->ifindex == ifindex)
				return iter;

		return NULL;
	}

6.	drivers/md/linear.c linear_congested()

	It is possible that this code relies on dependencies flowing into
	bdev_get_queue(), but to keep this effort finite in duration, I
	am relying on the __rcu markers -- and some of the structures
	in this subsystem do have __rcu.  The ->rdev and ->bdev fields
	don't, so this one is pretty straightforward.

	static int linear_congested(void *data, int bits)
	{
		struct mddev *mddev = data;
		struct linear_conf value_dep_preserving *conf; /* CHANGE */
		int i, ret = 0;

		if (mddev_congested(mddev, bits))
			return 1;

		rcu_read_lock();
		conf = rcu_dereference(mddev->private);

		for (i = 0; i < mddev->raid_disks && !ret ; i++) {
			struct request_queue *q = bdev_get_queue(conf->disks[i].rdev->bdev);
			ret |= bdi_congested(&q->backing_dev_info, bits);
		}

		rcu_read_unlock();
		return ret;
	}

