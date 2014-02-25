Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaBYBrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:47:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55104 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaBYBrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:47:21 -0500
X-IronPort-AV: E=Sophos;i="4.97,538,1389715200"; 
   d="scan'208";a="9596607"
Message-ID: <530BF6B4.3040206@cn.fujitsu.com>
Date: Tue, 25 Feb 2014 09:49:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
References: <20140207140536.943daf965008b9428cdcb468@linux-foundation.org>	<201402081055.BGJ73403.tQMLFVOJSOOFFH@I-love.SAKURA.ne.jp>	<20140207180647.5944fe3d.akpm@linux-foundation.org>	<201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>	<201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp> <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
In-Reply-To: <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/25 09:44:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/25 09:45:00,
	Serialize complete at 2014/02/25 09:45:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC scheduler people.

I can't figure out what we get with this patch.

On 02/17/2014 07:27 PM, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
>> This is a draft patch which changes task_struct->comm to use RCU.
> 
> Changes from previous draft version:
> 
>   Changed "struct rcu_comm" to use copy-on-write approach. Those multi-thread
>   or multi-process applications which do not change comm name will consume
>   memory for only one "struct rcu_comm".
> 
>   Changed do_commset() not to sleep.
> 
>   Changed to tolerate loss of consistency when memory allocation failed.
> 
>   Fixed race condition in copy_process().
> 
> Regards.
> ----------
>>From ada6c4d94f5afda36c7c21869d38b7111a6fe9bc Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 17 Feb 2014 14:32:11 +0900
> Subject: [PATCH] Change task_struct->comm to use RCU.
> 
> This patch changes task_struct->comm to be updated using RCU
> (unless memory allocation fails).
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/exec.c                 |  145 +++++++++++++++++++++++++++++++++++++++------
>  include/linux/init_task.h |    4 +-
>  include/linux/sched.h     |   37 ++++++++++--
>  kernel/fork.c             |    9 +++
>  kernel/kthread.c          |    4 +-
>  kernel/sched/core.c       |    2 +-
>  6 files changed, 173 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a781dec..8a68ab3 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -263,6 +263,11 @@ extern char ___assert_task_state[1 - 2*!!(
>  
>  /* Task command name length */
>  #define TASK_COMM_LEN 16
> +struct rcu_comm {
> +	char name[TASK_COMM_LEN];
> +	atomic_t usage;
> +	struct rcu_head rcu;
> +};
>  


I think the name "rcu_comm" is not good, I suggest that s/rcu_comm/task_comm/g.

