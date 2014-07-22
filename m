Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaGVWJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:09:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:26886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbaGVWJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,712,1400050800"; 
   d="scan'208";a="547426881"
Subject: [PATCH v5 0/7] crypto: SHA1 multibuffer implementation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jul 2014 15:09:25 -0700
Message-ID: <1406066965.2970.802.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

I've updated my implementation from v4 to have the multi-buffer daemon
flush the jobs if there're no other jobs running on the cpu.  The flusher
logic is reorganized so it is contained in mcryptd per Peter's feedback.
The multi-buffer crypto daemon now directly takes advantage of the cpu
if there're no other jobs running on cpu.  The flush routine was moved
out of the notifier path to crypto daemon.  To check that there're
no other jobs running, I've added the single_task_running function to
obtain the information.

Please note also that a separate bug fix to the crypto scatter gather list walk
for the null string needs to be incorporated, which I encountered during
my testing: http://marc.info/?l=linux-crypto-vger&m=140503429412699&w=2

In this patch series, we introduce the multi-buffer crypto algorithm on
x86_64 and apply it to SHA1 hash computation.  The multi-buffer technique
takes advantage of the 8 data lanes in the AVX2 registers and allows
computation to be performed on data from multiple jobs in parallel.
This allows us to parallelize computations when data inter-dependency in
a single crypto job prevents us to fully parallelize our computations.
The algorithm can be extended to other hashing and encryption schemes
in the future.

On multi-buffer SHA1 computation with AVX2, we saw throughput increase
up to 2.2x over the existing x86_64 single buffer AVX2 algorithm.

The multi-buffer crypto algorithm is described in the following paper:
Processing Multiple Buffers in Parallel to Increase Performance on
Intel® Architecture Processors
http://www.intel.com/content/www/us/en/communications/communications-ia-multi-buffer-paper.html

The outline of the algorithm is sketched below:
Any driver requesting the crypto service will place an async crypto
request on the workqueue.  The multi-buffer crypto daemon will pull
request from work queue and put each request in an empty data lane for
multi-buffer crypto computation.  When all the empty lanes are filled,
computation will commence on the jobs in parallel and the job with the
shortest remaining buffer will get completed and be returned.  To prevent
prolonged stall when there is no new jobs arriving, we will flush a
crypto job if it has not been completed after a maximum allowable delay,
or when cpu becomes idle and cpu cycles become available.

The multi-buffer algorithm necessitates mapping multiple scatter gather
buffers to linear addresses simultaneously. The crypto daemon may need
to sleep and yield the cpu to work on something else from time to time.
We made a change to not use kmap_atomic to do scatter-gather buffer
mapping and take advantage of the fact that we can directly translate
address the buffer's address to its linear address with x86_64.
To accommodate the fragmented nature of scatter-gather, we will keep
submitting the next scatter-buffer fragment for a job for multi-buffer
computation until a job is completed and no more buffer fragments remain.
At that time we will pull a new job to fill the now empty data slot.
We call a get_completed_job function to check whether there are other
jobs that have been completed when we job when we have no new job arrival
to prevent extraneous delay in returning any completed jobs.

The multi-buffer algorithm should be used for cases where crypto jobs
submissions are at a reasonable high rate.  For low crypto job submission
rate, this algorithm will not be beneficial. The reason is at low rate,
we do not fill out the data lanes before flushing the jobs instead of
processing them with all the data lanes full.  We will miss the benefit
of parallel computation, and adding delay to the processing of the crypto
job at the same time.  Some tuning of the maximum latency parameter may
be needed to get the best performance.

Note that the tcrypt SHA1 speed test, we wait for a previous job to
be completed before submitting a new job.  Hence this is not a valid
test for multi-buffer algorithm as it requires multiple outstanding jobs
submitted to fill the all data lanes to be effective (i.e. 8 outstanding
jobs for the AVX2 case).

Feedbacks and testings will be most welcomed.

Tim Chen

Change log:

v5.
1. Flush the job from the crypto daemon if the crypto daemon has no
other jobs to process and no other tasks are running on the cpu.
2. Change implementation of the idle flush so we do not hook into
the idle notifier. 

v4
1. Move the early flush of jobs when cpu becomes idle to crypto thread.
2. Move shash_ahash_mcryptd_digest to mcryptd.c 
http://www.gossamer-threads.com/lists/linux/kernel/1964734

v3
1. Add notifier to multi-buffer algorithm to flush job when the cpu
goes to idle to take advantage of available cpu cycles. 
2. Clean up of error messages.
http://marc.info/?l=linux-crypto-vger&m=140252063401632&w=2

v2
1. Change the sha1 crypto walk to use the new crypto_ahash_walk
interface for proper kmap.
2. Drop the hack that map buffer in crypto_hash_walk without kmap_atomic
as the new crypto_ahash_walk interface is merged.
3. Reorganize some
of the mcryptd hash interface code from ahash.c to mcryptd.c
http://marc.info/?l=linux-crypto-vger&m=140088627927559&w=2

v1
refer to: http://www.spinics.net/lists/linux-crypto/msg10993.html

Tim Chen (7):
  sched: Add function single_task_running to let a task check if it is
    the only task running on a cpu
  crypto: SHA1 multibuffer crypto hash infrastructure
  crypto: SHA1 multibuffer crypto opportunistic flush
  crypto: SHA1 multibuffer algorithm data structures
  crypto: SHA1 multibuffer submit and flush routines for AVX2
  crypto: SHA1 multibuffer crypto computation (x8 AVX2)
  crypto: SHA1 multibuffer scheduler

 arch/x86/crypto/Makefile                         |   2 +
 arch/x86/crypto/sha-mb/Makefile                  |  11 +
 arch/x86/crypto/sha-mb/sha1_mb.c                 | 935 +++++++++++++++++++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S  | 287 +++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S  | 327 ++++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c   |  64 ++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S | 228 ++++++
 arch/x86/crypto/sha-mb/sha1_x8_avx2.S            | 472 ++++++++++++
 arch/x86/crypto/sha-mb/sha_mb_ctx.h              | 136 ++++
 arch/x86/crypto/sha-mb/sha_mb_mgr.h              | 110 +++
 crypto/Kconfig                                   |  30 +
 crypto/Makefile                                  |   1 +
 crypto/mcryptd.c                                 | 705 +++++++++++++++++
 include/crypto/internal/hash.h                   |   9 +
 include/crypto/mcryptd.h                         | 112 +++
 include/linux/sched.h                            |   1 +
 kernel/sched/core.c                              |  12 +
 17 files changed, 3442 insertions(+)
 create mode 100644 arch/x86/crypto/sha-mb/Makefile
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb.c
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_x8_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha_mb_ctx.h
 create mode 100644 arch/x86/crypto/sha-mb/sha_mb_mgr.h
 create mode 100644 crypto/mcryptd.c
 create mode 100644 include/crypto/mcryptd.h

-- 
1.7.11.7


