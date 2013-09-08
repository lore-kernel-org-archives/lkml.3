Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078Ab3IHSCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 14:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab3IHSCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 14:02:11 -0400
Date: Sun, 8 Sep 2013 19:56:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW][PATCH] pidns: Fix hang in zap_pid_ns_processes by
	sending a potentially extra wakeup
Message-ID: <20130908175602.GA3172@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com> <20130830144232.GA18281@mail.hallyn.com> <87hae6vh0w.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hae6vh0w.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, vacation.

On 08/30, Eric W. Biederman wrote:
>
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -265,6 +265,7 @@ void free_pid(struct pid *pid)
>  		struct pid_namespace *ns = upid->ns;
>  		hlist_del_rcu(&upid->pid_chain);
>  		switch(--ns->nr_hashed) {
> +		case 2:
>  		case 1:
>  			/* When all that is left in the pid namespace
>  			 * is the reaper wake up the reaper.  The reaper

I think the patch is fine, and this matches "init_pids" in
zap_pid_ns_processes().

But, Eric, if this patch was not applied yet, any chance you can
add a comment ? Just a little note about the potential zombie
leader can help to understand this code. I won't insist of course,
but this "case 2" doesn't look obvious.

Off topic. What if the first alloc_pid() succeeds and then later
copy_process() fails. In this case free_pid() is called but
PIDNS_HASH_ADDING was not cleared, we miss kern_unmount(), no?

Oleg.

