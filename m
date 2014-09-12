Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaILUkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:40:19 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:35169 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaILUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140912190238.GJ4775@linux.vnet.ibm.com>
References: <20140901084403.GA18808@localhost> <20140912190238.GJ4775@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 12 Sep 2014 16:39:45 -0400
Message-ID: <CAJhHMCCevxQVctMtM83+_TN1PbcsQ9H_VaPOigv_OvZP32puYw@mail.gmail.com>
Subject: Re: [rcu] BUG: unable to handle kernel NULL pointer dereference at 000000da
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Shan Wei <davidshan@tencent.com>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 3:02 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Sep 01, 2014 at 04:44:04PM +0800, Fengguang Wu wrote:
>> Greetings,
>>
>> 0day kernel testing robot got the below dmesg and the first bad commit is
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> commit d860d40327dde251d508a234fa00bd0d90fbb656
>> Author:     Shan Wei <davidshan@tencent.com>
>> AuthorDate: Thu Jun 19 14:12:44 2014 -0700
>> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> CommitDate: Wed Jul 9 09:15:21 2014 -0700
>
> Hearing nothing from Shan or Pranith...
>
> So, I am not seeing this failure in my testing, but my best guess is
> that the problem is due to the fact that force_quiescent_state() is
> sometimes invoked with preemption enabled, which breaks __this_cpu_read()
> though perhaps with very low probability.  The common-case call (from
> __call_rcu_core()) -does- have preemption disabled, in fact, it has
> interrupts disabled.
>> So unless I hear otherwise, I will simply revert this commit.

I missed this report as I was not CC'ed and this is the first time I
am seeing this. As Christoph said later in the thread, it really is
not clear how this change is triggering the bug.

The tracer testing triggers this bug which is a corrupt stack and we
see no force_quiescent_state() in the back trace. So may be this is
exposing a bug somewhere else? Not really sure how to look at this.

> [    0.420978] Testing tracer branch:
> [    0.421701] BUG: unable to handle kernel NULL pointer dereference at 000000da
> [    0.422857] IP: [<c1061074>] update_curr+0x1a3/0x2c3
> [    0.423639] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
> [    0.424000] Thread overran stack, or stack corrupted
