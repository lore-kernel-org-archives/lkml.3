Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3EXUQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:16:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab3EXUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:16:54 -0400
Date: Fri, 24 May 2013 13:16:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] ipc: move locking out of ipcctl_pre_down_nolock
Message-Id: <20130524131652.e21bff6b6c6a214b19b299a9@linux-foundation.org>
In-Reply-To: <1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
	<1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 18:08:03 -0700 Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:

> This function currently acquires both the rw_mutex and the rcu lock on
> successful lookups, leaving the callers to explicitly unlock them, creating
> another two level locking situation.
> 
> Make the callers (including those that still use ipcctl_pre_down()) explicitly
> lock and unlock the rwsem and rcu lock.
> 
> ...
>
> @@ -409,31 +409,38 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
>  			return -EFAULT;
>  	}
>  
> +	down_write(&msg_ids(ns).rw_mutex);
> +	rcu_read_lock();
> +
>  	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
>  			       &msqid64.msg_perm, msqid64.msg_qbytes);
> -	if (IS_ERR(ipcp))
> -		return PTR_ERR(ipcp);
> +	if (IS_ERR(ipcp)) {
> +		err = PTR_ERR(ipcp);
> +		/* the ipc lock is not held upon failure */

Terms like "the ipc lock" are unnecessarily vague.  It's better to
identify the lock by name, eg msg_queue.q_perm.lock.

Where should readers go to understand the overall locking scheme?  A
description of the overall object hierarchy and the role which the
various locks play?

Have you done any performance testing of this patchset?  Just from
squinting at it, I'd expect the effects to be small...

