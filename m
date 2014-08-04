Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaHDO6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:58:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:63880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaHDO6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:58:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,799,1400050800"; 
   d="scan'208";a="571476647"
Date: Mon, 4 Aug 2014 22:57:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Artem Fetishev <Artem_Fetishev@epam.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at
 ffff880012770000
Message-ID: <20140804145751.GA14134@localhost>
References: <20140730040739.GH16537@localhost>
 <1b77fad4898c4250a6cbea851ac5c6db@EPBYMINSA0001.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b77fad4898c4250a6cbea851ac5c6db@EPBYMINSA0001.epam.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Mon, Aug 04, 2014 at 12:20:45PM +0000, Artem Fetishev wrote:
> Are we talking about error in rapl_pmu_init()? I ran your script on v3.14 and the error (in rapl_pmu_init) did not appear. Once again, for 3.14-rc8 the error does show up. My patch was merged between v3.14-rc8 and v3.14. The purpose of the patch was fixing that GPF in rapl_pmu_init. So I doubt the bisect is correct.

> +-----------------------------------------------------------+------------+------------+---------------+
> |                                                           | d9060742fb | 825600c0f2 | next-20140723 |
> +-----------------------------------------------------------+------------+------------+---------------+
> | boot_successes                                            | 167        | 48         | 9             |
> | boot_failures                                             | 97         | 18         | 2             |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference      | 97         | 14         | 2             |
> | Oops                                                      | 97         | 3          | 2             |

> | RIP:rapl_pmu_init                                         | 97         |            |               |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 97         |            |               |
> | backtrace:rapl_pmu_init                                   | 97         |            |               |

The rapl_pmu_init bug is confirmed to be fixed judging from the above
3 lines.

> | backtrace:kernel_init_freeable                            | 97         | 3          |               |

However the below BUGs are new in commit 825600c0f2:

> | BUG:unable_to_handle_kernel_paging_request                | 0          | 17         | 2             |
> | BUG:unable_to_handle_kernel_NULL_pointer                  | 0          | 1          |               |
> | RIP:slob_page_alloc                                       | 0          | 3          |               |
> | backtrace:proc_create_data                                | 0          | 3          |               |
> | backtrace:init_timer_list_procfs                          | 0          | 3          |               |
> | BUG:unable_to_handle                                      | 0          | 1          |               |
> | BUG:unable_to_handl                                       | 0          | 1          |               |
> | BUG:unable_to_handle_ker                                  | 0          | 1          |               |
> | BUG:kernel_boot_hang                                      | 0          | 1          |               |
> | RIP:memset                                                | 0          | 0          | 2             |
> | RIP:__rmqueue                                             | 0          | 0          | 2             |
> | backtrace:cryptomgr_test                                  | 0          | 0          | 2             |
> | backtrace:do_fork                                         | 0          | 0          | 2             |
> +-----------------------------------------------------------+------------+------------+---------------+

BUT I find cryptomgr_test showing up in the dmesg, which is very good
at producing all kinds of bug messages. So please ignore this bug
report -- it has too strong noises and may not be correct.

> [    1.026545] cryptomgr_test (20) used greatest stack depth: 5632 bytes left
> [    1.030491] AVX version of gcm_enc/dec engaged.
> [    1.033812] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
> [    1.038806] BUG: unable to handle kernel paging request at ffff880012770000

Thanks,
Fengguang

> [    1.040058] IP: [<ffffffff8161d18f>] memset+0x1f/0xb0
> [    1.040058] PGD 4170067 PUD 4171067 PMD 13bee067 PTE 8000000012770060
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] BUG: unable to handle kernel paging request at ffff880012776440
> [    1.040058] IP: [<ffffffff810fb846>] match_held_lock+0x16/0x2f0
> [    1.040058] PGD 4170067 PUD 4171067 PMD 13bee067 PTE 8000000012776060
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 0000000000000072
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> [    1.040058] IP: [<ffffffff820d66f6>] no_context+0x34e/0x3f4
> [    1.040058] PGD 0 
> [    1.040058] BUG: unable to handle kernel NULL pointer dereference at 000000000000006a
> 
> git bisect start v3.14 v3.13 --
> git bisect good 494479038d97f1b9f76fc633a360a681acdf035c  # 20:32     66+     28  Merge tag 'pinctrl-v3.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
> git bisect good 751a03c3728ed393287374078b98c3094a0b3bd2  # 20:36     66+     67  Merge tag 'pm+acpi-3.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect good 18f2af2d68815e1c4d5c275ebd030e27ef627582  # 20:43     66+     55  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> git bisect good 708f04d2abf4e90abee61d9ffb1f165038017ecf  # 20:46     66+     58  block: free q->flush_rq in blk_init_allocated_queue error paths
> git bisect good 75c5a52da3fc2a06abb6c6192bdf5d680e56d37d  # 20:48     66+     31  vfs: Allocate anon_inode_inode in anon_inode_init()
> git bisect  bad 0f2776e6151a123552fd06b666fe755fa780a967  # 20:48      0-     18  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
> git bisect good 1fac1fa965a9fbdb38d8a4b945db3521f801c946  # 20:57     66+     26  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
> git bisect  bad bc53267e97e4942e7f22c31cd8cf87840796accb  # 21:01      1-      5  Merge branch 'akpm' (patches from Andrew Morton)
> git bisect good 2946369ee277fa9fcc3372aabddc9c15dfabf744  # 21:11     66+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> git bisect  bad 825600c0f20e595daaa7a6dd8970f84fa2a2ee57  # 21:30      0-      7  x86: fix boot on uniprocessor systems
> git bisect good d9060742fbf630fe31951dfc10b798deb2813f01  # 22:39     66+     29  ocfs2: check if cluster name exists before deref
> # first bad commit: [825600c0f20e595daaa7a6dd8970f84fa2a2ee57] x86: fix boot on uniprocessor systems
> git bisect good d9060742fbf630fe31951dfc10b798deb2813f01  # 22:49    198+     97  ocfs2: check if cluster name exists before deref
> git bisect  bad 5eb00b037d9bb650b18b8f331bb9fb7a66559b5f  # 22:51      0-      2  Add linux-next specific files for 20140723
> git bisect  bad 82e13c71bc655b6dc7110da4e164079dadb44892  # 23:12      0-     77  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux
> git bisect  bad 1a58d9909611972fd1c081bb04a9f7dc2571e612  # 23:23      2-      1  Add linux-next specific files for 20140724
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-enable-kvm
> 	-cpu Haswell,+smep,+smap
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 1
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=10
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang
