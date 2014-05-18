Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaERGI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 02:08:27 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:35948 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaERGI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 02:08:26 -0400
Message-ID: <53784E56.4070801@colorfullife.com>
Date: Sun, 18 May 2014 08:08:22 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ipc,msg: document volatile r_msg
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com> <1400012857-11733-5-git-send-email-davidlohr@hp.com>
In-Reply-To: <1400012857-11733-5-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
> The need for volatile is not obvious, document it.
>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

In the long run, it would be great if the logic from sem.c would be 
moved to one central place.
- wake_up_sem_queue_prepare()
- wake_up_sem_queue_do()
- get_queue_result()
- the realtime compatible implementation that uses a completion instead 
of the busy loop in get_queue_result()

The code more or less just a reliable wait queue, nothing is specific to 
sysv:
- the woken up task knows if it was woken up due to a signal or due to 
wake_up_process()
- wake_up_process() out of line, after dropping all locks
- only two lock operation (one for: check that task must wait and go to 
sleep, one for: identify the task that must be woken up).

With a "normal" wait queue, there are three lock operation (notice that 
task was woken up, cleanup)


> ---
>   ipc/msg.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/ipc/msg.c b/ipc/msg.c
> index c2cdb5b..956cd65 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -42,9 +42,7 @@
>   #include <linux/uaccess.h>
>   #include "util.h"
>   
> -/*
> - * one msg_receiver structure for each sleeping receiver:
> - */
> +/* one msg_receiver structure for each sleeping receiver */
>   struct msg_receiver {
>   	struct list_head	r_list;
>   	struct task_struct	*r_tsk;
> @@ -54,6 +52,12 @@ struct msg_receiver {
>   	long			r_msgtype;
>   	long			r_maxsize;
>   
> +	/*
> +	 * Mark r_msg volatile so that the compiler
> +	 * does not try to get smart and optimize
> +	 * it. We rely on this for the lockless
> +	 * receive algorithm.
> +	 */
>   	struct msg_msg		*volatile r_msg;
>   };
>   

