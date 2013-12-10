Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3LJPxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:53:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53122 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3LJPxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:53:02 -0500
Date: Tue, 10 Dec 2013 16:52:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] sched: Revert need_resched() to look at TIF_NEED_RESCHED
Message-ID: <20131210155246.GI12849@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
 <20130927153003.GF15690@laptop.programming.kicks-ass.net>
 <87y53ubk6a.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y53ubk6a.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 12:11:33PM +0530, Aneesh Kumar K.V wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > Subject: sched: Revert need_resched() to look at TIF_NEED_RESCHED
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri Sep 27 17:20:30 CEST 2013
> >
> > Yuanhan reported a serious throughput regression in his pigz
> > benchmark. Using the ftrace patch I found that several idle paths
> > need more TLC before we can switch the generic need_resched() over to
> > preempt_need_resched.
> >
> > The preemption paths benefit most from preempt_need_resched and do
> > indeed use it; all other need_resched() users don't really care that
> > much so reverting need_resched() back to tif_need_resched() is the
> > simple and safe solution.
> >
> > Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> 
> I guess we still need to fix should_resched() I am hitting the below
> with upstream
> 
> 
> BUG: soft lockup - CPU#0 stuck for 23s! [qemu-system-ppc:4394]
> Modules linked in:
> CPU: 0 PID: 4394 Comm: qemu-system-ppc Not tainted 3.13.0-rc3+ #98
> task: c0000001d0788400 ti: c0000001dca00000 task.ti: c0000001dca00000
> NIP: c00000000082dd80 LR: c000000000081ae0 CTR: c000000000062ba0
> REGS: c0000001dca02f70 TRAP: 0901   Not tainted  (3.13.0-rc3+)
> MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 24822024  XER: 00000000
> CFAR: c000000000081adc SOFTE: 1
> GPR00: c000000000081ae0 c0000001dca031f0 c000000000d67ab0 0000000000000001
> GPR04: 0000000071000002 0000000000000001 00000189a0d786b7 00000000018c0000
> GPR08: 0000000000000001 0000000000000000 0000000000000000 c000000000da0000
> GPR12: 0000000000000c00 c00000000fef0000
> NIP [c00000000082dd80] ._cond_resched+0x0/0x40
> LR [c000000000081ae0] .kvmppc_prepare_to_enter+0x2a0/0x2e0
> Call Trace:
> [c0000001dca031f0] [c000000000081ae0] .kvmppc_prepare_to_enter+0x2a0/0x2e0 (unreliable)
> [c0000001dca03290] [c00000000008f2cc] .kvmppc_handle_exit_pr+0xec/0xa40
> [c0000001dca03340] [c0000000000918c4] kvm_start_lightweight+0xac/0xbc
> [c0000001dca03510] [c00000000008efe0] .kvmppc_vcpu_run_pr+0x130/0x2a0
> [c0000001dca039e0] [c0000000000855bc] .kvmppc_vcpu_run+0x2c/0x40
> [c0000001dca03a50] [c000000000082c94] .kvm_arch_vcpu_ioctl_run+0x54/0x1b0
> [c0000001dca03ae0] [c00000000007d5f8] .kvm_vcpu_ioctl+0x478/0x740
> [c0000001dca03ca0] [c000000000218864] .do_vfs_ioctl+0x4a4/0x760
> [c0000001dca03d80] [c000000000218b78] .SyS_ioctl+0x58/0xb0
> [c0000001dca03e30] [c000000000009e58] syscall_exit+0x0/0x98
> Instruction dump:
> e92d0260 e94911c0 812a0004 5529f07e 5529103e 912a0004 38210080 e8010010
> ebc1fff0 ebe1fff8 7c0803a6 4e800020 <7c0802a6> 38600000 f8010010 f821ff91 
> 
> 
> The revert which Alexander tried had those
> 
> http://mid.gmane.org/20131128132641.GP10022@twins.programming.kicks-ass.net

-ENOPARSE..


