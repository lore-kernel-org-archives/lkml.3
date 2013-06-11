Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3FKWp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:45:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3FKWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:45:20 -0400
Date: Tue, 11 Jun 2013 15:45:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/pid.c: Masking the flag out to get the
 actual value.
Message-Id: <20130611154518.fda9262961c21e96a57cbd5e@linux-foundation.org>
In-Reply-To: <1370901398-8989-1-git-send-email-raphael.scarv@gmail.com>
References: <1370901398-8989-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013 18:56:38 -0300 "Raphael S. Carvalho" <raphael.scarv@gmail.com> wrote:

> This patch shouldn't be applied if those branches must only be taken when
> the pid_allocation(PIDNS_HASH_ADDING) flag was turned off.

Well yes - hopefully this is the case.  Otherwise we're missing some
rather important-looking wakeups.


> Otherwise, we must turn the PIDNS_HASH_ADDING flag (1U << 31) off
> before getting into the switch-cases.
> 
> ...
>
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -263,7 +263,10 @@ void free_pid(struct pid *pid)
>  		struct upid *upid = pid->numbers + i;
>  		struct pid_namespace *ns = upid->ns;
>  		hlist_del_rcu(&upid->pid_chain);
> -		switch(--ns->nr_hashed) {
> +
> +		/* We must turn the PIDNS_HASH_ADDING flag off to
> +		   get the actual value of nr_hashed */
> +		switch ((--ns->nr_hashed) & ~(PIDNS_HASH_ADDING)) {
>  		case 1:
>  			/* When all that is left in the pid namespace
>  			 * is the reaper wake up the reaper.  The reaper

Eric, can you please take a look?  Presumably and hopefully
PIDNS_HASH_ADDING cannot be set here, but what guarantees this?

Hopefully we can fix this one by adding the missing comment.
