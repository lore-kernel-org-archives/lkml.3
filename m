Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbaGaK13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:27:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2431 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbaGaK11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,771,1400050800"; 
   d="scan'208";a="569888418"
Date: Thu, 31 Jul 2014 18:27:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [delayed_fput] BUG: unable to handle kernel paging request at
 ffff8800122a0ad0
Message-ID: <20140731102721.GA9455@localhost>
References: <20140730035541.GD16537@localhost>
 <20140730111521.GB759@infradead.org>
 <alpine.DEB.2.02.1407301550140.26018@chino.kir.corp.google.com>
 <CAADnVQ+OwgG-RJQ7QwfW2qrvpV9XYySckTbNmcacW7K0KxQqvA@mail.gmail.com>
 <20140731024014.GA10184@localhost>
 <CAADnVQL+O0ZFmF99+Ba4Ua2bwLnaO2KDJM1o86aUvG24xS08gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQL+O0ZFmF99+Ba4Ua2bwLnaO2KDJM1o86aUvG24xS08gg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 07:53:15PM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 30, 2014 at 7:40 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Wed, Jul 30, 2014 at 04:00:58PM -0700, Alexei Starovoitov wrote:
> >> On Wed, Jul 30, 2014 at 3:51 PM, David Rientjes <rientjes@google.com> wrote:
> >> > On Wed, 30 Jul 2014, Christoph Hellwig wrote:
> >> >
> >> >> On Wed, Jul 30, 2014 at 11:55:41AM +0800, Fengguang Wu wrote:
> >> >> > Greetings,
> >> >> >
> >> >> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >> >>
> >> >> How does this manage to trip over a 2 year old commit now?
> >>
> >> may be because all kernels are built with gcc 4.8.2 ?
> >> Fengguang, did you recently switch to new compiler?
> >> I think all older builds were with 4.6.3
> >
> > Alexei, I've been using gcc 4.8.2 for 4 months.
> >
> > Maybe it's because I test new randconfigs every day. And the problem
> > may only show up with very specific kernel config?
> 
> It seems a lot of odd crashes suddenly showed up and I'm guessing it
> may be related to compiler...
> See commit 2062afb4f8 ("Fix gcc-4.9.0 miscompilation of load_balance()
>  in scheduler")
> it's a nasty gcc bug that affects 4.9 and 4.8.
> I think it makes sense to apply that workaround before debugging much with 4.8
> just to eliminate the possibility of miscompiled code.

I tried boot testing 2062afb4f8~ and 2062afb4f8 with the same kernel
config. It looks make no much difference, at least for the problem in
this thread.

+-------------------------------------------------------------------------+------------+------------+
|                                                                         | 8bdd638091 | 2062afb4f8 |
+-------------------------------------------------------------------------+------------+------------+
| boot_successes                                                          | 253        | 252        |
| boot_failures                                                           | 47         | 48         |
| BUG:kernel_boot_hang                                                    | 12         | 3          |
| BUG:unable_to_handle_kernel_paging_request                              | 10         | 15         |
| Oops                                                                    | 12         | 17         |
| RIP:__fsnotify_update_child_dentry_flags                                | 2          |            |
| Kernel_panic-not_syncing:Fatal_exception                                | 21         | 26         |
| backtrace:fsnotify_add_mark_locked                                      | 3          | 1          |
| backtrace:SyS_inotify_add_watch                                         | 3          | 1          |
| BUG:Bad_page_state_in_process                                           | 10         | 17         |
| backtrace:cryptd_alloc_ablkcipher                                       | 4          | 5          |
| backtrace:ablk_init_common                                              | 4          | 5          |
| backtrace:ablk_init                                                     | 4          | 5          |
| backtrace:cryptomgr_test                                                | 21         | 30         |
| BUG:spinlock_bad_magic_on_CPU                                           | 3          | 4          |
| RIP:__d_lookup_rcu                                                      | 2          |            |
| backtrace:do_sys_open                                                   | 1          |            |
| backtrace:SyS_open                                                      | 1          |            |
| backtrace:smpboot_thread_fn                                             | 4          | 3          |
| general_protection_fault                                                | 9          | 9          |
| RIP:crypto_ahash_setkey                                                 | 10         | 10         |
| RIP:kzfree                                                              | 6          | 13         |
| backtrace:vfs_stat                                                      | 2          |            |
| backtrace:SyS_newstat                                                   | 2          |            |
| WARNING:CPU:PID:at_kernel/sched/core.c:wake_up_process()                | 1          |            |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                    | 2          | 2          |
| backtrace:iterate_dir                                                   | 1          | 3          |
| backtrace:SyS_getdents                                                  | 1          | 3          |
| RIP:worker_thread                                                       | 1          |            |
| Kernel_panic-not_syncing:VFS:Unable_to_mount_root_fs_on_unknown-block() | 1          |            |
| backtrace:prepare_namespace                                             | 1          |            |
| backtrace:kernel_init_freeable                                          | 1          | 2          |
| RIP:slob_page_alloc                                                     | 0          | 1          |
| backtrace:do_fork                                                       | 0          | 1          |
| backtrace:SyS_clone                                                     | 0          | 1          |
| backtrace:crypto_register_algs                                          | 0          | 2          |
| backtrace:crypto_null_mod_init                                          | 0          | 1          |
| backtrace:twofish_init                                                  | 0          | 1          |
| RIP:spin_dump                                                           | 0          | 1          |
| RIP:process_one_work                                                    | 0          | 1          |
+-------------------------------------------------------------------------+------------+------------+

Thanks,
Fengguang

