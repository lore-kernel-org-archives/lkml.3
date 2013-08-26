Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3HZUmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:42:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3HZUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:42:00 -0400
Date: Mon, 26 Aug 2013 13:41:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Svenning =?ISO-8859-1?Q?S=F8rensen?= <sss@secomea.dk>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] IPC: bugfix for msgrcv with msgtyp < 0
Message-Id: <20130826134159.d033956c339cbd0bb7cb6f7f@linux-foundation.org>
In-Reply-To: <52189CB1.9030806@secomea.dk>
References: <52189CB1.9030806@secomea.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Aug 2013 13:44:49 +0200 Svenning S__rensen <sss@secomea.dk> wrote:

> According to 'man msgrcv':
> "If msgtyp is less than 0, the first message of the lowest type that is less
> than or equal to the absolute value of msgtyp shall be received."
> 
> Bug: The kernel only returns a message if its type is 1; other messages with
> type < abs(msgtype) will never get returned.
> 
> Fix: After having traversed the list to find the first message with the
> lowest type, we need to actually return that message.
> 
> Signed-off-by: Svenning Soerensen <sss@secomea.dk>
> 
> diff --git a/ipc/msg.c b/ipc/msg.c
> index bd60d7e..9f29d9e 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -839,7 +839,7 @@ static inline void free_copy(struct msg_msg *copy)
>   
>   static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
>   {
> -	struct msg_msg *msg;
> +	struct msg_msg *msg, *found = NULL;
>   	long count = 0;
>   
>   	list_for_each_entry(msg, &msq->q_messages, m_list) {
> @@ -848,6 +848,7 @@ static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
>   					       *msgtyp, mode)) {
>   			if (mode == SEARCH_LESSEQUAL && msg->m_type != 1) {
>   				*msgtyp = msg->m_type - 1;
> +				found = msg;

Should we continue the search in this case, or should the code
immediately return this message?

>   			} else if (mode == SEARCH_NUMBER) {
>   				if (*msgtyp == count)
>   					return msg;
> @@ -857,7 +858,7 @@ static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
>   		}
>   	}
>   
> -	return ERR_PTR(-EAGAIN);
> +	return found ?: ERR_PTR(-EAGAIN);
>   }
>   
>   long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgflg,
