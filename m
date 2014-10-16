Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaJPQ5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:57:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:32761 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaJPQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:57:39 -0400
To: schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, oleg@redhat.com
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the sub_info structure
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20141016160042.7f898871@mschwide>
In-Reply-To: <20141016160042.7f898871@mschwide>
Message-Id: <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 17 Oct 2014 01:57:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> Found this in the message log on a s390 system:
> 
> BUG kmalloc-192 (Not tainted): Poison overwritten

The use-after-free location you are suspecting is

----------
        retval = do_execve(getname_kernel(sub_info->path),
                           (const char __user *const __user *)sub_info->argv,
                           (const char __user *const __user *)sub_info->envp);
        if (!retval)
                return 0;

        /* Exec failed? */
fail:
        sub_info->retval = retval;
        do_exit(0);
}
----------

, isn't it?

I could not interpret the

> For UMH_NO_WAIT __call_usermodehelper() frees the sub_info structure
> directly, for UMH_WAIT_EXEC the call to umh_complete() allows
> call_usermodehelper_exec() to continue which then frees sub_info.

lines.

For both UMH_NO_WAIT and UMH_WAIT_EXEC cases,

  kernel_thread(call_helper, sub_info, CLONE_VFORK | SIGCHLD)

in __call_usermodehelper() waits for do_execve() to succeed or do_exit(),
doesn't it? What is wrong with assigning sub_info->retval in
____call_usermodehelper() when do_execve() did not succeed?
Which function/thread can free sub_info before assigning sub_info->retval?

Regards.
