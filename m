Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaDAIDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:03:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaDAIDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:03:09 -0400
Date: Tue, 1 Apr 2014 10:02:58 +0200
From: Robin Hack <rhack@redhat.com>
To: Eunbong Song <eunb.song@samsung.com>
Cc: ak@linux.intel.com, sasha.levin@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tools/liblockdep: Build failure
Message-ID: <20140401080258.GA10429@bigoook.brq.redhat.com>
References: <22212997.138341396332274687.JavaMail.weblogic@epml01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22212997.138341396332274687.JavaMail.weblogic@epml01>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have same issue.

I investigated output of gcc -E and I found that asmlinkage macro isn't
expanded as is expected.

$ grep asmlinkage common.o
asmlinkage extern void lockdep_sys_exit(void);

On Tue, Apr 01, 2014 at 06:04:35AM +0000, Eunbong Song wrote:
> 
> There is tools/liblockdep build failure.
> I have been trying to find the cause and i found commit id 63f9a7fde715352e0769302527670542a664b981 is the casue.
> 
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Sat Feb 8 08:52:01 2014 +0100
> 
>     asmlinkage: Make lockdep_sys_exit asmlinkage
> 
>     lockdep_sys_exit can be called from assembler code, so make it
>     asmlinkage.
> 
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Ingo Molnar <mingo@kernel.org>
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>
>     Link: http://lkml.kernel.org/r/1391845930-28580-5-git-send-email-ak@linux.intel.com
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 92b1bfc..7df9aa6 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -265,7 +265,7 @@ extern void lockdep_info(void);
>  extern void lockdep_reset(void);
>  extern void lockdep_reset_lock(struct lockdep_map *lock);
>  extern void lockdep_free_key_range(void *start, unsigned long size);
> -extern void lockdep_sys_exit(void);
> +extern asmlinkage void lockdep_sys_exit(void);
> 
>  extern void lockdep_off(void);
>  extern void lockdep_on(void);
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index eb8a547..c8b6753 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -4191,7 +4191,7 @@ void debug_show_held_locks(struct task_struct *task)
>  }
>  EXPORT_SYMBOL_GPL(debug_show_held_locks);
> 
> -void lockdep_sys_exit(void)
> +asmlinkage void lockdep_sys_exit(void)
>  {
>         struct task_struct *curr = current;
