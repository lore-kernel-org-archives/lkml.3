Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3CaNkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:40:41 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:46797
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab3CaNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:40:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 31 Mar 2013 21:40:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Paul Walmsley <paul@pwsan.com>
CC: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>, <maciej.rutecki@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ingo Molnar <mingo@redhat.com>, Ben Chan <benchan@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Revert "lockdep: check that no locks held at freeze time"
Message-ID: <20130331134037.GB17773@S2101-09.ap.freescale.net>
References: <alpine.DEB.2.00.1303310000180.6436@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1303310000180.6436@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 12:04:40AM +0000, Paul Walmsley wrote:
> 
> This reverts commit 6aa9707099c4b25700940eb3d016f16c4434360d.
> 
> Commit 6aa970 causes problems with NFS root filesystems.  The failures
> were noticed on OMAP2 and 3 boards during kernel init:
> 
> [    5.508148] [ BUG: swapper/0/1 still has locks held! ]
> [    5.513610] 3.9.0-rc3-00344-ga937536 #1 Not tainted
> [    5.518798] -------------------------------------
> [    5.523773] 1 lock held by swapper/0/1:
> [    5.527893]  #0:  (&type->s_umount_key#13/1){+.+.+.}, at: [<c011e84c>] sget+0x248/0x574
> [    5.536437]
> [    5.536437] stack backtrace:
> [    5.541107] [<c001bba8>] (unwind_backtrace+0x0/0xf0) from [<c05304bc>] (rpc_wait_bit_killable+0x98/0xcc)
> [    5.551208] [<c05304bc>] (rpc_wait_bit_killable+0x98/0xcc) from [<c0551600>] (__wait_on_bit+0x74/0xb8)
> [    5.561096] [<c0551600>] (__wait_on_bit+0x74/0xb8) from [<c05516b0>] (out_of_line_wait_on_bit+0x6c/0x78)
> [    5.571166] [<c05516b0>] (out_of_line_wait_on_bit+0x6c/0x78) from [<c0530a0c>] (__rpc_execute+0xf0/0x360)
> [    5.581329] [<c0530a0c>] (__rpc_execute+0xf0/0x360) from [<c052a254>] (rpc_run_task+0x98/0xa4)
> [    5.590515] [<c052a254>] (rpc_run_task+0x98/0xa4) from [<c052a374>] (rpc_call_sync+0x48/0xb4)
> [    5.599578] [<c052a374>] (rpc_call_sync+0x48/0xb4) from [<c0234964>] (nfs_proc_get_root+0x48/0x124)
> [    5.609191] [<c0234964>] (nfs_proc_get_root+0x48/0x124) from [<c0227300>] (nfs_get_root+0x58/0x190)
> [    5.618804] [<c0227300>] (nfs_get_root+0x58/0x190) from [<c022abbc>] (nfs_fs_mount_common+0x98/0x158)
> [    5.628601] [<c022abbc>] (nfs_fs_mount_common+0x98/0x158) from [<c022b440>] (nfs_try_mount+0x144/0x214)
> [    5.638580] [<c022b440>] (nfs_try_mount+0x144/0x214) from [<c022c4e0>] (nfs_fs_mount+0x178/0x850)
> [    5.648010] [<c022c4e0>] (nfs_fs_mount+0x178/0x850) from [<c011f6e8>] (mount_fs+0x44/0x184)
> [    5.656860] [<c011f6e8>] (mount_fs+0x44/0x184) from [<c01384c4>] (vfs_kern_mount+0x4c/0xc0)
> [    5.665740] [<c01384c4>] (vfs_kern_mount+0x4c/0xc0) from [<c013a6d4>] (do_mount+0x6d0/0x858)
> [    5.674682] [<c013a6d4>] (do_mount+0x6d0/0x858) from [<c013a8e0>] (sys_mount+0x84/0xb8)
> [    5.683197] [<c013a8e0>] (sys_mount+0x84/0xb8) from [<c075faf0>] (do_mount_root+0x24/0xb0)
> [    5.691986] [<c075faf0>] (do_mount_root+0x24/0xb0) from [<c075fee4>] (mount_root+0x50/0xf8)
> [    5.700866] [<c075fee4>] (mount_root+0x50/0xf8) from [<c07600ec>] (prepare_namespace+0x160/0x1c4)
> [    5.710296] [<c07600ec>] (prepare_namespace+0x160/0x1c4) from [<c075f978>] (kernel_init_freeable+0x17c/0x1c4)
> [    5.720825] [<c075f978>] (kernel_init_freeable+0x17c/0x1c4) from [<c054b6c4>] (kernel_init+0x8/0xe4)
> [    5.730529] [<c054b6c4>] (kernel_init+0x8/0xe4) from [<c0013d90>] (ret_from_fork+0x14/0x24)
> 
> Although the rootfs mounts, the system is unstable.  Here's a transcript from
> a PM test:
> 
> http://www.pwsan.com/omap/testlogs/test_v3.9-rc3/20130317194234/pm/37xxevm/37xxevm_log.txt
> 
> Here's what the test log should look like:
> 
> http://www.pwsan.com/omap/testlogs/test_v3.8/20130218214403/pm/37xxevm/37xxevm_log.txt
> 
> Mailing list discussion is here:
> 
> http://lkml.org/lkml/2013/3/4/221
> 
> Deal with this for v3.9 by reverting the problem commit, until folks can 
> figure out the right long-term course of action.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
...
> Cc: Shawn Guo <shawn.guo@linaro.org>

The same BUG was observed on IMX/MXS systems, so

Acked-by: Shawn Guo <shawn.guo@linaro.org>

