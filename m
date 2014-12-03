Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaLCT3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:29:25 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46792 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaLCT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:29:24 -0500
Date: Wed, 3 Dec 2014 11:29:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        rgb@redhat.com, eparis@redhat.com
Cc: fweisbec@gmail.com
Subject: Re: audit: rcu_read_lock() used illegally while idle
Message-ID: <20141203192919.GP25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141203181922.GA26916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203181922.GA26916@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120319-0005-0000-0000-000006D55799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 01:19:22PM -0500, Dave Jones wrote:
> I'm not sure why this only just started complaining, because this code
> hasn't changed in years, but I don't recall seeing this before.
> This gets spewed during bootup since I put 3.18-rc7 on my firewall.
> Previously it was running rc4 where I didn't see this.

That is quite strange.  I wonder if NO_HZ_FULL has told RCU that the
CPU is idle before the sysret_audit hook is called.

Adding Frederic for his thoughts on this.

> Did something in RCU change recently ?

Not since -rc1, as far as I know, anyway.

							Thanx, Paul

> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.18.0-rc7+ #93 Not tainted
> -------------------------------
> include/linux/rcupdate.h:883 rcu_read_lock() used illegally while idle!
> 
> other info that might help us debug this:
> 
> 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> RCU used illegally from extended quiescent state!
> 1 lock held by systemd-sysctl/557:
>  #0:  (rcu_read_lock){......}, at: [<ffffffff890f1320>] audit_filter_type+0x0/0x240
> 
> stack backtrace:
> CPU: 0 PID: 557 Comm: systemd-sysctl Not tainted 3.18.0-rc7+ #93
>  0000000000000000 0000000063c50efc ffff88021f51fd28 ffffffff895abec3
>  0000000000000000 ffff880234758000 ffff88021f51fd58 ffffffff890a5280
>  ffff880221d9c548 00007fd651f320d0 0000000000000514 00000000ffff9012
> Call Trace:
>  [<ffffffff895abec3>] dump_stack+0x4e/0x68
>  [<ffffffff890a5280>] lockdep_rcu_suspicious+0xf0/0x110
>  [<ffffffff890f150e>] audit_filter_type+0x1ee/0x240
>  [<ffffffff890f1320>] ? audit_filter_user+0x340/0x340
>  [<ffffffff890ecd39>] audit_log_start+0x49/0x4a0
>  [<ffffffff8908f4f5>] ? local_clock+0x25/0x30
>  [<ffffffff890a397f>] ? lock_release_holdtime.part.30+0xf/0x190
>  [<ffffffff890f1973>] audit_log_exit+0x53/0xcf0
>  [<ffffffff8908f4f5>] ? local_clock+0x25/0x30
>  [<ffffffff890a397f>] ? lock_release_holdtime.part.30+0xf/0x190
>  [<ffffffff895b4f0c>] ? sysret_signal+0x5/0x43
>  [<ffffffff890f4a65>] __audit_syscall_exit+0x245/0x2a0
>  [<ffffffff895b4f61>] sysret_audit+0x17/0x21
> 

