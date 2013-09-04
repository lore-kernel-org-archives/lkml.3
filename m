Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471Ab3IDT0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:26:54 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:39713 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3IDT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:26:52 -0400
Message-ID: <52278970.2080803@hp.com>
Date: Wed, 04 Sep 2013 15:26:40 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:05 PM, Waiman Long wrote:
> When running the AIM7's short workload, Linus' lockref patch eliminated
> most of the spinlock contention. However, there were still some left:
>
>       8.46%     reaim  [kernel.kallsyms]     [k] _raw_spin_lock
>                   |--42.21%-- d_path
>                   |          proc_pid_readlink
>                   |          SyS_readlinkat
>                   |          SyS_readlink
>                   |          system_call
>                   |          __GI___readlink
>                   |
>                   |--40.97%-- sys_getcwd
>                   |          system_call
>                   |          __getcwd
>
> The big one here is the rename_lock (seqlock) contention in d_path()
> and the getcwd system call. This patch will eliminate the need to take
> the rename_lock while translating dentries into the full pathnames.
>
> The need to take the rename_lock is to make sure that no rename
> operation can be ongoing while the translation is in progress. However,
> only one thread can take the rename_lock thus blocking all the other
> threads that need it even though the translation process won't make
> any change to the dentries.
>
> This patch will replace the writer's write_seqlock/write_sequnlock
> sequence of the rename_lock of the callers of the prepend_path() and
> __dentry_path() functions with the reader's read_seqbegin/read_seqretry
> sequence within these 2 functions. As a result, the code will have to
> retry if one or more rename operations had been performed. In addition,
> RCU read lock will be taken during the translation process to make
> sure that no dentries will go away.
>
> In addition, the dentry's d_lock is also not taken to further reduce
> spinlock contention. However, this means that the name pointer and
> other dentry fields may not be valid. As a result, the code was
> enhanced to handle the case that the parent pointer or the name
> pointer can be NULL.
>
> With this patch, the _raw_spin_lock will now account for only 1.2%
> of the total CPU cycles for the short workload. This patch also has
> the effect of reducing the effect of running perf on its profile
> since the perf command itself can be a heavy user of the d_path()
> function depending on the complexity of the workload.
>
> When taking the perf profile of the high-systime workload, the amount
> of spinlock contention contributed by running perf without this patch
> was about 16%. With this patch, the spinlock contention caused by
> the running of perf will go away and we will have a more accurate
> perf profile.
>
> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
In term of AIM7 performance, this patch has a performance boost of
about 6-7% on top of Linus' lockref patch on a 8-socket 80-core DL980.

User Range          |   10-100  | 200-10000 | 1100-2000 |
Mean JPM w/o patch  | 4,365,114 | 7,211,115 | 6,964,439 |
Mean JPM with patch | 3,872,850 | 7,655,958 | 7,422,598 |
% Change            |  -11.3%   |   +6.2%   |   +6.6%   |

I am not sure if it is too aggresive for not taking the d_lock before
prepend_name(). I can add back those locking instructions if necessary.

Regards,
Longman


