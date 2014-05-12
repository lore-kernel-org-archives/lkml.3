Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaELUBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:01:40 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:43192 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaELUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:01:39 -0400
Date: Mon, 12 May 2014 16:01:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140512200135.GL1421@htj.dyndns.org>
References: <537119EF.2060102@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537119EF.2060102@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:58:55PM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [ 1297.886670] WARNING: CPU: 0 PID: 190 at kernel/workqueue.c:2176 process_one_work+0xb5/0x6f0()
> [ 1297.889216] Modules linked in:
> [ 1297.890306] CPU: 0 PID: 190 Comm: kworker/3:0 Not tainted 3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
> [ 1297.893258]  0000000000000009 ffff88010c5d7ce8 ffffffffb153e1ec 0000000000000002
> [ 1297.893258]  0000000000000000 ffff88010c5d7d28 ffffffffae15fd6c ffff88010cdd6c98
> [ 1297.893258]  ffff8806285d4000 ffffffffb3cd09e0 ffff88010cdde000 0000000000000000
> [ 1297.893258] Call Trace:
> [ 1297.893258] dump_stack (lib/dump_stack.c:52)
> [ 1297.893258] warn_slowpath_common (kernel/panic.c:430)
> [ 1297.893258] warn_slowpath_null (kernel/panic.c:465)
> [ 1297.893258] process_one_work (kernel/workqueue.c:2174 (discriminator 38))
> [ 1297.893258] worker_thread (kernel/workqueue.c:2354)
> [ 1297.893258] kthread (kernel/kthread.c:210)
> [ 1297.893258] ret_from_fork (arch/x86/kernel/entry_64.S:553)

Hmm, this is "percpu worker on the wrong CPU while the current
workqueue state indicates it should be on the CPU it's bound to"
warning.  We had a similar and more reproducible report a couple
months back.

  http://lkml.kernel.org/g/52F4F01C.1070800@linux.vnet.ibm.com

We added some debug code back then and it looked like the worker was
setting the right cpus_allowed mask and the cpu was up but still
ending up on the wrong CPU.  Peter was looking into it and, ooh, I
missed his last message and it fell through the crack.  We probably
should follow up on that thread.

Thanks.

-- 
tejun
