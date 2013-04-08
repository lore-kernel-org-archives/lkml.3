Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935543Ab3DHWi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:38:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab3DHWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:38:26 -0400
Date: Mon, 8 Apr 2013 15:38:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: use list_for_each_entry for list traversing
Message-Id: <20130408153824.974e9307f83616f90c63e00b@linux-foundation.org>
In-Reply-To: <63a5135b37c9a45abad27eed9f78d69dd4deba76.1365168828.git.npajkovs@redhat.com>
References: <63a5135b37c9a45abad27eed9f78d69dd4deba76.1365168828.git.npajkovs@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Apr 2013 15:42:11 +0200 Nikola Pajkovsky <npajkovs@redhat.com> wrote:

> the ipc/msg.c code does all list operations by hand and it open-codes
> the accesses, instead of using for_each_entry.
> 
> ...
>
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -237,14 +237,9 @@ static inline void ss_del(struct msg_sender *mss)
>  
>  static void ss_wakeup(struct list_head *h, int kill)
>  {
> -	struct list_head *tmp;
> +	struct msg_sender *mss, *t;
>  
> -	tmp = h->next;
> -	while (tmp != h) {
> -		struct msg_sender *mss;
> -
> -		mss = list_entry(tmp, struct msg_sender, list);
> -		tmp = tmp->next;
> +	list_for_each_entry_safe(mss, t, h, list) {
>  		if (kill)
>  			mss->list.next = NULL;
>  		wake_up_process(mss->tsk);

urgh, that code is sick.  What's it doing poking around in the
list_head internals?

> @@ -253,14 +248,9 @@ static void ss_wakeup(struct list_head *h, int kill)
>  
>  static void expunge_all(struct msg_queue *msq, int res)
>  {
> -	struct list_head *tmp;
> -
> -	tmp = msq->q_receivers.next;
> -	while (tmp != &msq->q_receivers) {
> -		struct msg_receiver *msr;
> +	struct msg_receiver *msr, *t;
>  
> -		msr = list_entry(tmp, struct msg_receiver, r_list);
> -		tmp = tmp->next;
> +	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
>  		msr->r_msg = NULL;
>  		wake_up_process(msr->r_tsk);
>  		smp_mb();

I think list_for_each_entry() would suffice here.

> @@ -278,7 +268,7 @@ static void expunge_all(struct msg_queue *msq, int res)
>   */
>  static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>  {
> -	struct list_head *tmp;
> +	struct msg_msg *msg;
>  	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
>  
>  	expunge_all(msq, -EIDRM);
> @@ -286,11 +276,7 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>  	msg_rmid(ns, msq);
>  	msg_unlock(msq);
>  
> -	tmp = msq->q_messages.next;
> -	while (tmp != &msq->q_messages) {
> -		struct msg_msg *msg = list_entry(tmp, struct msg_msg, m_list);
> -
> -		tmp = tmp->next;
> +	list_for_each_entry(msg, &msq->q_messages, m_list) {
>  		atomic_dec(&ns->msg_hdrs);
>  		free_msg(msg);
>  	}

This is buggy isn't it?  list_for_each_entry() will use the
recently-freed `msg'.


