Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3IFPGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:06:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37771 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801Ab3IFPG3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:06:29 -0400
Date: Fri, 6 Sep 2013 11:06:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu, lwn@lwn.net
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [RELEASE] Userspace RCU 0.8.0
Message-ID: <20130906150621.GA32439@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
data synchronization library provides read-side access which scales
linearly with the number of cores. It does so by allowing multiples
copies of a given data structure to live at the same time, and by
monitoring the data structure accesses to detect grace periods after
which memory reclamation is possible.

liburcu-cds provides efficient data structures based on RCU and
lock-free algorithms. Those structures include hash tables, queues,
stacks, and doubly-linked lists.


What's new in Userspace RCU 0.8 ?

* Introduce new wait-free concurrent queue API (urcu/wfcqueue.h),

* Introduce new lock-free stack (urcu/lfstack.h),

* Wait-free stack API (urcu/wfstack.h) is extended,

* The old queue API (wfqueue.h) is flagged as deprecated. It will be
  kept around for a while, but will emit a compiler warning such as:

  warning: ‘cds_wfq_dequeue_blocking’ is deprecated
  (declared at /usr/local/include/urcu/wfqueue.h:87) [-Wdeprecated-declarations]

  New code should use urcu/wfcqueue.h instead of urcu/wfqueue.h.

* The old RCU lock-free stack urcu/rculfstack.h is replaced by
  urcu/lfstack.h. The old API will be kept around for a while, but will
  emit a compiler warning. New code should use urcu/lfstack.h.

* Tests are now split into:
    tests/unit/ : unit tests
    tests/regression/ : regression tests
    tests/benchmark/ : benchmarks

* A doc/examples/ directory is added, including API usage examples.
  Those are installed into /usr/share/doc/userspace-rcu/examples/ (for
  instance, assuming configure had --prefix=/usr).

* Had to bump the library .so version from 1.0.0 to 2.0.0 to fix symbol
  namespace clash (see commit 1de4df4b770e5e90440008becc5e14a15c75c6e0:
  "Fix static linking: fix symbol name namespaces").

Project website: http://urcu.so
Download link: http://urcu.so/files/
Git repository: git://git.urcu.so/urcu.git


git diff --stat from v0.7.4:

 .gitignore                                         |  186 +++--
 ChangeLog                                          |  211 ++++++
 CodingStyle                                        |    2 +-
 LICENSE                                            |   45 +-
 Makefile.am                                        |   19 +-
 README                                             |  123 +++-
 compat_arch_x86.c                                  |    4 +-
 config/ax_tls.m4                                   |   13 +-
 configure.ac                                       |  122 ++-
 doc/Makefile.am                                    |    2 +
 doc/cds-api.txt                                    |   35 +-
 doc/examples/Makefile.am                           |  142 ++++
 doc/examples/Makefile.examples.template            |   29 +
 doc/examples/dist-files/Makefile                   |   33 +
 doc/examples/hlist/Makefile                        |   25 +
 doc/examples/hlist/Makefile.cds_hlist_add_head_rcu |   21 +
 doc/examples/hlist/Makefile.cds_hlist_del_rcu      |   21 +
 .../hlist/Makefile.cds_hlist_for_each_entry_rcu    |   21 +
 doc/examples/hlist/Makefile.cds_hlist_for_each_rcu |   21 +
 doc/examples/hlist/cds_hlist_add_head_rcu.c        |   64 ++
 doc/examples/hlist/cds_hlist_del_rcu.c             |   90 +++
 doc/examples/hlist/cds_hlist_for_each_entry_rcu.c  |   84 +++
 doc/examples/hlist/cds_hlist_for_each_rcu.c        |   91 +++
 doc/examples/lfstack/Makefile                      |   23 +
 .../lfstack/Makefile.cds_lfs_pop_all_blocking      |   21 +
 doc/examples/lfstack/Makefile.cds_lfs_pop_blocking |   21 +
 doc/examples/lfstack/Makefile.cds_lfs_push         |   21 +
 doc/examples/lfstack/cds_lfs_pop_all_blocking.c    |   79 ++
 doc/examples/lfstack/cds_lfs_pop_blocking.c        |   75 ++
 doc/examples/lfstack/cds_lfs_push.c                |   72 ++
 doc/examples/list/Makefile                         |   29 +
 doc/examples/list/Makefile.cds_list_add_rcu        |   21 +
 doc/examples/list/Makefile.cds_list_add_tail_rcu   |   21 +
 doc/examples/list/Makefile.cds_list_del_rcu        |   21 +
 .../list/Makefile.cds_list_for_each_entry_rcu      |   21 +
 doc/examples/list/Makefile.cds_list_for_each_rcu   |   21 +
 doc/examples/list/Makefile.cds_list_replace_rcu    |   21 +
 doc/examples/list/cds_list_add_rcu.c               |   64 ++
 doc/examples/list/cds_list_add_tail_rcu.c          |   64 ++
 doc/examples/list/cds_list_del_rcu.c               |   90 +++
 doc/examples/list/cds_list_for_each_entry_rcu.c    |   84 +++
 doc/examples/list/cds_list_for_each_rcu.c          |   90 +++
 doc/examples/list/cds_list_replace_rcu.c           |   94 +++
 doc/examples/rculfhash/Makefile                    |   31 +
 doc/examples/rculfhash/Makefile.cds_lfht_add       |   22 +
 .../rculfhash/Makefile.cds_lfht_add_replace        |   22 +
 .../rculfhash/Makefile.cds_lfht_add_unique         |   22 +
 doc/examples/rculfhash/Makefile.cds_lfht_del       |   22 +
 doc/examples/rculfhash/Makefile.cds_lfht_destroy   |   22 +
 .../Makefile.cds_lfht_for_each_entry_duplicate     |   22 +
 doc/examples/rculfhash/Makefile.cds_lfht_lookup    |   22 +
 doc/examples/rculfhash/cds_lfht_add.c              |  106 +++
 doc/examples/rculfhash/cds_lfht_add_replace.c      |  147 ++++
 doc/examples/rculfhash/cds_lfht_add_unique.c       |  144 ++++
 doc/examples/rculfhash/cds_lfht_del.c              |  168 +++++
 doc/examples/rculfhash/cds_lfht_destroy.c          |  149 ++++
 .../rculfhash/cds_lfht_for_each_entry_duplicate.c  |  143 ++++
 doc/examples/rculfhash/cds_lfht_lookup.c           |  147 ++++
 doc/examples/rculfhash/jhash.h                     |  256 +++++++
 doc/examples/rculfqueue/Makefile                   |   21 +
 doc/examples/rculfqueue/Makefile.cds_lfq_dequeue   |   21 +
 doc/examples/rculfqueue/Makefile.cds_lfq_enqueue   |   21 +
 doc/examples/rculfqueue/cds_lfq_dequeue.c          |  115 +++
 doc/examples/rculfqueue/cds_lfq_enqueue.c          |   73 ++
 doc/examples/urcu-flavors/Makefile                 |   27 +
 doc/examples/urcu-flavors/Makefile.bp              |   21 +
 doc/examples/urcu-flavors/Makefile.mb              |   21 +
 doc/examples/urcu-flavors/Makefile.membarrier      |   21 +
 doc/examples/urcu-flavors/Makefile.qsbr            |   21 +
 doc/examples/urcu-flavors/Makefile.signal          |   21 +
 doc/examples/urcu-flavors/bp.c                     |  115 +++
 doc/examples/urcu-flavors/mb.c                     |  141 ++++
 doc/examples/urcu-flavors/membarrier.c             |  140 ++++
 doc/examples/urcu-flavors/qsbr.c                   |  149 ++++
 doc/examples/urcu-flavors/signal.c                 |  140 ++++
 doc/examples/wfcqueue/Makefile                     |   23 +
 doc/examples/wfcqueue/Makefile.cds_wfcq_dequeue    |   21 +
 doc/examples/wfcqueue/Makefile.cds_wfcq_enqueue    |   21 +
 doc/examples/wfcqueue/Makefile.cds_wfcq_splice     |   21 +
 doc/examples/wfcqueue/cds_wfcq_dequeue.c           |   79 ++
 doc/examples/wfcqueue/cds_wfcq_enqueue.c           |   72 ++
 doc/examples/wfcqueue/cds_wfcq_splice.c            |  109 +++
 doc/examples/wfstack/Makefile                      |   23 +
 doc/examples/wfstack/Makefile.cds_wfs_pop          |   21 +
 .../wfstack/Makefile.cds_wfs_pop_all_blocking      |   21 +
 doc/examples/wfstack/Makefile.cds_wfs_push         |   21 +
 doc/examples/wfstack/cds_wfs_pop.c                 |   75 ++
 doc/examples/wfstack/cds_wfs_pop_all_blocking.c    |   79 ++
 doc/examples/wfstack/cds_wfs_push.c                |   72 ++
 doc/rcu-api.txt                                    |   24 +-
 lfstack.c                                          |   81 ++
 rculfhash.c                                        |  106 ++-
 rculfstack.c                                       |    3 +
 scripts/urcu-api-list.sh                           |  233 ++++++
 tests/Makefile.am                                  |  199 +----
 tests/api.h                                        |  316 --------
 tests/benchmark/Makefile.am                        |  186 +++++
 tests/benchmark/common.sh                          |   12 +
 tests/benchmark/runall.sh                          |  104 +++
 tests/benchmark/runhash.sh                         |  136 ++++
 tests/benchmark/runpaul-phase1.sh                  |   44 ++
 tests/benchmark/runpaul-phase2.sh                  |   47 ++
 tests/benchmark/runpaul-phase3.sh                  |   50 ++
 tests/benchmark/runpaul-phase4.sh                  |   40 +
 tests/benchmark/runpaul-phase5.sh                  |   11 +
 tests/benchmark/runpaul-phase6.sh                  |    7 +
 tests/benchmark/runpaul-phase7.sh                  |   41 ++
 tests/benchmark/runtests-batch.sh                  |   19 +
 tests/benchmark/runtests.sh                        |   21 +
 tests/benchmark/subphase4.sh                       |  101 +++
 tests/benchmark/test_cycles_per_loop.c             |   44 ++
 tests/benchmark/test_looplen.c                     |   74 ++
 tests/benchmark/test_mutex.c                       |  399 ++++++++++
 tests/benchmark/test_perthreadlock.c               |  410 +++++++++++
 tests/benchmark/test_perthreadlock_timing.c        |  198 +++++
 tests/benchmark/test_rwlock.c                      |  391 ++++++++++
 tests/benchmark/test_rwlock_timing.c               |  183 +++++
 tests/benchmark/test_urcu.c                        |  404 ++++++++++
 tests/benchmark/test_urcu_assign.c                 |  439 +++++++++++
 tests/benchmark/test_urcu_bp.c                     |  399 ++++++++++
 tests/benchmark/test_urcu_defer.c                  |  426 +++++++++++
 tests/benchmark/test_urcu_gc.c                     |  470 ++++++++++++
 tests/benchmark/test_urcu_hash.c                   |  774 ++++++++++++++++++++
 tests/benchmark/test_urcu_hash.h                   |  390 ++++++++++
 tests/benchmark/test_urcu_hash_rw.c                |  284 +++++++
 tests/benchmark/test_urcu_hash_unique.c            |  279 +++++++
 tests/benchmark/test_urcu_lfq.c                    |  436 +++++++++++
 tests/benchmark/test_urcu_lfs.c                    |  518 +++++++++++++
 tests/benchmark/test_urcu_lfs_rcu.c                |  435 +++++++++++
 tests/benchmark/test_urcu_qsbr.c                   |  410 +++++++++++
 tests/benchmark/test_urcu_qsbr_gc.c                |  470 ++++++++++++
 tests/benchmark/test_urcu_qsbr_timing.c            |  225 ++++++
 tests/benchmark/test_urcu_timing.c                 |  224 ++++++
 tests/benchmark/test_urcu_wfcq.c                   |  581 +++++++++++++++
 tests/benchmark/test_urcu_wfq.c                    |  401 ++++++++++
 tests/benchmark/test_urcu_wfs.c                    |  565 ++++++++++++++
 tests/common/Makefile.am                           |    3 +
 tests/common/api.h                                 |  311 ++++++++
 tests/common/cpuset.h                              |   45 ++
 tests/common/thread-id.h                           |   55 ++
 tests/rcutorture.h                                 |  503 -------------
 tests/regression/Makefile.am                       |   75 ++
 tests/regression/rcutorture.h                      |  503 +++++++++++++
 tests/regression/test_urcu_fork.c                  |  147 ++++
 tests/regression/urcutorture.c                     |   30 +
 tests/runall.sh                                    |  104 ---
 tests/runhash.sh                                   |  136 ----
 tests/runpaul-phase1.sh                            |   44 --
 tests/runpaul-phase2.sh                            |   47 --
 tests/runpaul-phase3.sh                            |   50 --
 tests/runpaul-phase4.sh                            |   40 -
 tests/runpaul-phase5.sh                            |   11 -
 tests/runpaul-phase6.sh                            |    7 -
 tests/runpaul-phase7.sh                            |   41 --
 tests/runtests-batch.sh                            |    8 -
 tests/runtests.sh                                  |   10 -
 tests/subphase4.sh                                 |  101 ---
 tests/test_cycles_per_loop.c                       |   44 --
 tests/test_looplen.c                               |   93 ---
 tests/test_mutex.c                                 |  420 -----------
 tests/test_perthreadlock.c                         |  431 -----------
 tests/test_perthreadlock_timing.c                  |  215 ------
 tests/test_rwlock.c                                |  412 -----------
 tests/test_rwlock_timing.c                         |  200 -----
 tests/test_uatomic.c                               |   87 ---
 tests/test_urcu.c                                  |  463 ------------
 tests/test_urcu_assign.c                           |  460 ------------
 tests/test_urcu_bp.c                               |  459 ------------
 tests/test_urcu_defer.c                            |  447 -----------
 tests/test_urcu_gc.c                               |  491 -------------
 tests/test_urcu_hash.c                             |  682 -----------------
 tests/test_urcu_hash.h                             |  419 -----------
 tests/test_urcu_hash_rw.c                          |  275 -------
 tests/test_urcu_hash_unique.c                      |  271 -------
 tests/test_urcu_lfq.c                              |  462 ------------
 tests/test_urcu_lfs.c                              |  458 ------------
 tests/test_urcu_qsbr.c                             |  466 ------------
 tests/test_urcu_qsbr_gc.c                          |  491 -------------
 tests/test_urcu_qsbr_timing.c                      |  243 ------
 tests/test_urcu_timing.c                           |  241 ------
 tests/test_urcu_wfq.c                              |  416 -----------
 tests/test_urcu_wfs.c                              |  416 -----------
 tests/unit/Makefile.am                             |   61 ++
 tests/unit/test_uatomic.c                          |   91 +++
 tests/unit/test_urcu_multiflavor-bp.c              |   39 +
 tests/unit/test_urcu_multiflavor-mb.c              |   39 +
 tests/unit/test_urcu_multiflavor-memb.c            |   38 +
 tests/unit/test_urcu_multiflavor-qsbr.c            |   38 +
 tests/unit/test_urcu_multiflavor-signal.c          |   39 +
 tests/unit/test_urcu_multiflavor.c                 |   50 ++
 tests/unit/test_urcu_multiflavor.h                 |   29 +
 tests/unit/urcu-asm.c                              |   37 +
 tests/urcu-asm.c                                   |   37 -
 tests/urcutorture.c                                |   30 -
 urcu-bp.c                                          |  117 +--
 urcu-bp.h                                          |    2 +
 urcu-call-rcu-impl.h                               |  276 +++++--
 urcu-call-rcu.h                                    |   16 +-
 urcu-defer-impl.h                                  |    4 +-
 urcu-flavor.h                                      |    5 +
 urcu-pointer.h                                     |    6 +-
 urcu-qsbr.c                                        |  223 ++++--
 urcu-qsbr.h                                        |    2 +
 urcu-wait.h                                        |  185 +++++
 urcu.c                                             |  212 ++++--
 urcu.h                                             |    4 +
 urcu/cds.h                                         |    2 +
 urcu/compiler.h                                    |   12 +
 urcu/config.h.in                                   |    2 +-
 urcu/futex.h                                       |    2 +-
 urcu/hlist.h                                       |   93 ++-
 urcu/lfstack.h                                     |  226 ++++++
 urcu/list.h                                        |  179 ++---
 urcu/map/urcu-bp.h                                 |   13 +-
 urcu/map/urcu-qsbr.h                               |   13 +-
 urcu/map/urcu.h                                    |   67 +-
 urcu/rcuhlist.h                                    |   48 +-
 urcu/rculfhash.h                                   |   19 +-
 urcu/rculfstack.h                                  |   47 +-
 urcu/rculist.h                                     |   48 +-
 urcu/static/lfstack.h                              |  285 +++++++
 urcu/static/urcu-bp.h                              |  147 ++--
 urcu/static/urcu-pointer.h                         |   24 +-
 urcu/static/urcu-qsbr.h                            |  156 +++-
 urcu/static/urcu.h                                 |  194 ++---
 urcu/static/wfcqueue.h                             |  634 ++++++++++++++++
 urcu/static/wfstack.h                              |  370 +++++++++-
 urcu/system.h                                      |   10 +-
 urcu/tls-compat.h                                  |   17 +-
 urcu/uatomic/generic.h                             |    6 +-
 urcu/wfcqueue.h                                    |  417 +++++++++++
 urcu/wfqueue.h                                     |   58 +-
 urcu/wfstack.h                                     |  279 ++++++-
 wfcqueue.c                                         |  172 +++++
 wfqueue.c                                          |    3 +
 wfstack.c                                          |   72 +-
 236 files changed, 22036 insertions(+), 11630 deletions(-)


Changelog:

2013-09-06 Userspace RCU 0.8.0
	* Fix: hash table growth (for small tables) should be limited
	* Fix: doc/examples cross-build
	* Introduce URCU_INLINE_SMALL_FUNCTIONS
	* Add missing tests/common/Makefile.am
	* README: document make check/regtest/bench
	* tests: split in check, regtest and bench targets
	* Cleanup: doc/examples makefile
	* Fix: doc/examples VPATH build
	* doc/examples: Move the LIBS after the OBJECTS in the Makefile
	* Document build work-around on MacOS X
	* Fix tests: use of uninitialized variables
	* test_urcu_hash*: initialize TLS seeds
	* doc/examples: cds_lfht_for_each_entry_duplicate
	* doc/examples: cds_lfht_lookup
	* doc/examples: cds_lfht_destroy
	* doc/examples: cds_lfht_add_replace
	* doc/examples: cds_lfht_add_unique
	* doc/examples: cds_lfht_add/cds_lfht_del
	* doc/examples: add rculfqueue example
	* doc/examples: add synchronize_rcu()
	* doc/examples: add bp flavor
	* doc/examples: add dist toplevel makefile
	* doc/examples: add membarrier flavor
	* doc/examples: document call_rcu()
	* doc/examples: update qsbr example
	* urcu signal: remove assertion on exit
	* doc/examples: signal flavor
	* doc/examples: add mb flavor
	* doc/examples: update qsbr
	* doc/examples: introduce urcu-flavors examples directory
	* doc/examples: enhance rcu-flavor-qsbr example
	* doc/examples: rename qsbr-minimal to rcu-flavor-qsbr
	* doc/examples: automake stop on error
	* doc/examples: hlist
	* hlist/rcuhlist update
	* doc/examples: fix typo in list example
	* rcuhlist: make pointer stores atomic
	* hlist, rcuhlist: cleanup coding style
	* doc/examples: lfstack
	* doc/examples: update cds_wfs_pop_all_blocking
	* doc/examples: cds_wfs_pop_all_blocking
	* doc/examples: cds_wfs_pop
	* doc/examples: add missing Makefile
	* doc/examples: cds_wfs_push
	* doc/wfcqueue: cds_wfcq_splice
	* doc/examples: add cds_wfcq_dequeue
	* doc/examples: wfcq needs to link against urcu-common
	* doc/examples: update queue comment
	* doc/examples: fix make clean
	* gitignore: add qsbr-minimal
	* doc/examples: cds_wfcq_enqueue
	* doc/examples: Move LIBS to each makefile
	* doc/examples: cds_list_for_each_rcu
	* doc/examples: cds_list_for_each_entry_rcu
	* doc/examples: cds_list_replace_rcu
	* doc/examples: cds_list_add_tail_rcu
	* doc/examples: cds_list_del_rcu
	* doc/examples: cds_list_add_rcu
	* rculist: ensure atomic updates of next pointers
	* rculist: implement cds_list_add_tail_rcu
	* rculist.h and list.h style cleanup
	* example makefile: add missing cd ..
	* Update gitignore
	* Fix: examples Makefile on FreeBSD
	* hash table test: don't redefine CACHE_LINE_SIZE
	* tests: use thread-id.h wrapper
	* Implement thread-id.h wrapper
	* tests: add missing unsigned long casts to pthread_self()
	* Fix: don't build examples in static builds
	* Add QSBR minimal example
	* compiler.h: implement CAA_ARRAY_SIZE()
	* document rcu barrier
	* rcu barrier: handle OOM die urcu_die
	* Implement rcu_barrier()
	* rculfhash: document destroy context limitations
	* Add MIPS to README
	* Update README
	* Update README testing info about FreeBSD
	* test: fix api.h missing if brackets
	* tests: fix incorrect counter
	* Fix: membarrier fallback symbol conflict
	* Fix: Use a filled signal mask to disable all signals
	* urcu-bp: introduce struct urcu_gp
	* Fix: struct urcu_gp broke multiflavor
	* Cleanup test usage printout
	* wfstack tests: use pop "last" state info
	* wfstack: return whether pop is popping the last element
	* wfcqueue tests: use dequeue empty state
	* wfcqueue: return whether dequeue is dequeuing last element
	* urcu: avoid false sharing for rcu_gp_ctr
	* urcu: make the code of urcu-qsbr as normal urcu
	* rculfhash: detect if resize/destroy are called within RCU read-side C.S.
	* Documentation: rculfhash: cds_lfht_resize not within read-side C.S.
	* fix: rculfhash don't change qsbr online state
	* Add rcu_read_ongoing() API to each urcu flavor
	* Add "sparc" host cpu to configure.ac
	* futex: include syscall.h instead of sys/syscall.h
	* Add tab to output in order to allow easy nesting of tables.
	* Remove urcu-api-list.sh from dist tarball
	* Add urcu-api-list.sh script
	* list: implement cds_list_for_each_safe()
	* Fix: tests/api.h use cpuset.h
	* Fix hurd-i386: move cpuset tests outside of sched_setaffinity conditional
	* Fix tests: finer-grained use of CPU_SET, CPU_ZERO and cpu_set_t
	* Test for CPU_SET
	* Fix build on architectures with HAVE_SCHED_GETCPU but without HAVE_SYSCONF
	* README: document that Clang 3.0 (based on LLVM 3.0) is supported
	* clang: silence "unused expression result" warning
	* rculfhash: add assertions on node alignment
	* Spelling cleanups within comments and documentation
	* Fix configure checks for Tile
	* uatomic: style fix
	* doc/cds-api.txt: expand documentation
	* README: document each API file
	* README: reorganize
	* Add compilation support for the TileGX architecture
	* wfstack: add nonblocking to _LGPL_SOURCE API
	* Discourage use of pthread_atfork() for call_rcu handlers
	* Fix call_rcu fork handling
	* test: fork handling
	* rculfhash: add cds_lfht_replace to the write operations in the comments
	* urcu: fix comments for cds_list_for_each_prev()
	* documentation: fix rcu-api.txt duplicates
	* test wfcq: remove unneeded urcu.h include
	* test wfs: remove unneeded urcu.h include
	* urcu: declare test_urcu_multiflavor functions
	* urcu: remove the wrong comma
	* wfstack: implement nonblocking pop and next
	* wfcqueue: document first/next return values
	* wfstack: update comments about cds_wfs_empty/first being wait-free
	* wfstack API: rename cds_wfs_first_blocking to cds_wfs_first
	* wfstack test: test if number of push to empty vs pop_all match
	* wfstack: document first/next return values
	* test wfstack: enforce external mutex if needed by default
	* test wfcqueue: enforce external mutex if needed by default
	* urcu-mb/signal/membarrier: batch concurrent synchronize_rcu()
	* urcu-wait: move queue management code into urcu-wait.h
	* urcu-wait: move wait code into separate file
	* urcu-qsbr: batch concurrent synchronize_rcu()
	* tests: use standard malloc/free for synchronize_rcu()
	* urcu-bp: move quiescent threads to separate list
	* urcu-mb/signal/membarrier: move quiescent threads to separate list
	* urcu-qsbr: move offline threads to separate list
	* urcu-bp: improve 2-phase wait scheme
	* urcu-mb/signal/membarrier: improve 2-phase wait scheme
	* urcu-qsbr: improve 2-phase wait scheme
	* wfcqueue: implement mutex-free splice
	* wfcqueue: document empty criterion
	* urcu-call-rcu: use wait-free splice return value
	* test wfcqueue: add tests for queue state return value
	* wfcqueue: enqueue and splice return queue state
	* Fix: wfcqueue nonblocking dequeue
	* wfcqueue: Fix lock and unlock functions
	* runtests: Make path of time binary configurable
	* urcu-qsbr: skip Q.S. reporting if already reported
	* Fix TLS detection: test with linker, add --disable-compiler-tls
	* Cleanup: cast pthread_self() return value to unsigned long
	* Fallback mechanism not working on platform where TLS is unsupported
	* Revert "Fix: cross-build: configure.ac should use --target, not --host"
	* Fix: cross-build: configure.ac should use --target, not --host
	* test_urcu_wfcq: add splice and nosync tests
	* test_urcu_wfs: cleanup
	* test_urcu_lfs: cleanup
	* Fix static linking: add missing static for _defer_rcu
	* tests: report error value for make check
	* Add multiflavor test program
	* Fix static linking: fix symbol name namespaces
	* Fix static linking: add missing static to thr_defer
	* Fix static linking: add missing static
	* deprecation: fix build with gcc < 4.5
	* wfstack.c: update copyright notice
	* Update wfstack copyright notice
	* Comment fix: update associated LGPL header name
	* Update cds-api.txt following API deprecations
	* Deprecate wfqueue
	* Deprecate rculfstack
	* wfcqueue: introduce nonblocking API
	* lfstack: test pop_all and pop
	* lfstack: implement empty, pop_all and iterators, document API
	* lfstack: implement test
	* lfstack: implement lock-free stack
	* wfstack: implement pop_all and iteration tests
	* wfstack: implement cds_wfs_pop_all and iterators, document API
	* rculfhash test: fix trivial memleak and return node leak and errors
	* rculfhash: add missing extern
	* Cleanup: fix cppcheck errors
	* wfcqueue: remove ancient comment
	* test_urcu_lfq: remove rcu_defer_register_thread() from test_urcu_lfq
	* test_urcu_lfq: test for the proper pointer
	* test_urcu_lfs: remove rcu_defer_register_thread() from test_urcu_lfs
	* test_urcu_lfs: test for the proper pointer
	* wfcqueue: clarify locking usage
	* Document APIs in README
	* Test cleanup: replace "l" parameter by "loops"
	* Add wfcqueue header to cds.h
	* Fix: urcu-bp, urcu, urcu-qsbr should include wfcqueue
	* Fix: call_rcu list corruption on teardown (documentation)
	* call_rcu: remove head field alignement, explain wfcqueue motivation
	* wfcqueue: update credits in patch documentation
	* wfcqueue documentation: hint at for_each iterators
	* Fix urcu-call-rcu-impl.h: false-sharing
	* call_rcu: use wfcqueue, eliminate false-sharing
	* wfcqueue test
	* wfcqueue: implement concurrency-efficient queue
	* Ensure that read-side functions meet 10-line LGPL criterion
	* tls-compat.h: document sigaltstack(2) limitation
	* urcu: add notice to URCU_TLS() for it is not strictly async-signal-safe
	* Document sigaltstack(2) limitation
	* Documentation: update LICENSE file

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
