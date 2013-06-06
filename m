Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3FFUz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:55:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3FFUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:55:57 -0400
Date: Thu, 6 Jun 2013 13:55:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Guy Streeter <streeter@redhat.com>,
        Eric Paris <eparis@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] audit: cleanup audit_log_start/wait_for_auditd
 mess
Message-Id: <20130606135555.15e649bccc02d8c738e71fa9@linux-foundation.org>
In-Reply-To: <20130603204620.GB21574@redhat.com>
References: <20130603204559.GA21574@redhat.com>
	<20130603204620.GB21574@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013 22:46:20 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> audit_log_start() tries to obfusticate the code/logic and
> reimplements wait_event_timeout() in a very confusing way.
> 
> Just change wait_for_auditd() to use wait_event_timeout()
> and return bool.
> 
> Also remove the unnecessary "ab = NULL" initialization.

I would prefer that this be nicely tested - for a cosmetic thing I
don't think it's worth the risk as-is.

> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1051,20 +1051,19 @@ static inline void audit_get_stamp(struct audit_context *ctx,
>  }
>  
>  /*
> - * Wait for auditd to drain the queue a little
> + * Wait for auditd to drain audit_skb_queue if it is full
>   */
> -static void wait_for_auditd(unsigned long sleep_time)
> +static bool wait_for_auditd(gfp_t gfp_mask)
>  {
> -	DECLARE_WAITQUEUE(wait, current);
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> -	add_wait_queue(&audit_backlog_wait, &wait);
> -
> -	if (audit_backlog_limit &&
> -	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
> -		schedule_timeout(sleep_time);
> -
> -	__set_current_state(TASK_RUNNING);
> -	remove_wait_queue(&audit_backlog_wait, &wait);
> +	/* Atomic callers use can 5 more entries over the limit */

"can use"

> +	if (!(gfp_mask & __GFP_WAIT))
> +		return skb_queue_len(&audit_skb_queue) <=
> +					audit_backlog_limit + 5;
> +
> +	return wait_event_timeout(audit_backlog_wait,
> +		!audit_backlog_limit ||
> +			skb_queue_len(&audit_skb_queue) <= audit_backlog_limit,
> +		audit_backlog_wait_time);
>  }
>
> ...
>
