Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3CDUQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:16:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49717 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3CDUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:16:23 -0500
Message-ID: <51350112.6090208@wwwdotorg.org>
Date: Mon, 04 Mar 2013 13:16:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: viro@zeniv.linux.org.uk, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 resend] procfs: Improve Scaling in proc
References: <1360961274-24652-1-git-send-email-nzimmer@sgi.com>
In-Reply-To: <1360961274-24652-1-git-send-email-nzimmer@sgi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 01:47 PM, Nathan Zimmer wrote:
> I am currently tracking a hotlock reported by a customer on a large system,
> 512 cores.  I am currently running 3.8-rc7 but the issue looks like it has been
> this way for a very long time.
> The offending lock is proc_dir_entry->pde_unload_lock.
> 
> This patch converts the replaces the lock with the rcu. However the pde_openers
> list still is controlled by a spin lock. I tested on a 4096 machine and the lock
> doesn't seem hot at least according to perf.

Nathan,

This patch causes RCU errors on my ARM systems (which have 2 or 4 CPUs)
during boot; see the log below. Reverting it fixes the problem. Let me
know if you need any more information to diagnose the problem. Thanks.

> [ 3.652115] VFS: Mounted root (ext3 filesystem) on device 179:1.
> [ 3.664856] devtmpfs: mounted
> [ 3.668877] Freeing init memory: 212K
...
> [ 25.765891] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=2102 jiffies, g=4294967050, c=4294967049, q=5749)
> [ 25.777786] INFO: Stall ended before state dump start
> [ 88.815886] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=8407 jiffies, g=4294967050, c=4294967049, q=5818)
> [ 88.827777] INFO: Stall ended before state dump start
> [ 151.865886] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=14712 jiffies, g=4294967050, c=4294967049, q=5869)
> [ 151.877863] INFO: Stall ended before state dump start
> [ 214.915885] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=21017 jiffies, g=4294967050, c=4294967049, q=5869)
> [ 214.927857] INFO: Stall ended before state dump start
> [ 240.525981] INFO: task mountall:71 blocked for more than 120 seconds.
> [ 240.532435] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 240.541452] INFO: task init:150 blocked for more than 120 seconds.
> [ 240.547687] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 240.556352] INFO: task udevd:151 blocked for more than 120 seconds.
> [ 240.562623] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 240.571262] INFO: task ata_id:197 blocked for more than 120 seconds.
> [ 240.577662] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 277.965881] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=27322 jiffies, g=4294967050, c=4294967049, q=5869)
> [ 277.977860] INFO: Stall ended before state dump start 

