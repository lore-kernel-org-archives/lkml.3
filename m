Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaJHPQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaJHPQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:16:38 -0400
Date: Wed, 8 Oct 2014 17:13:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
Message-ID: <20141008151328.GB4835@redhat.com>
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if this was already discussed, I have to admit that I ignored
the previous discussion ;) And it is possible I misread this patch
completely.

On 10/08, Chen Hanxiao wrote:
>
> This patch will show the hierarchy of pid namespace
> by /proc/pidns_hierarchy like:
>
> [root@localhost ~]#cat /proc/pidns_hierarchy
> /proc/18060/ns/pid /proc/18102/ns/pid /proc/1534/ns/pid
> /proc/18060/ns/pid /proc/18102/ns/pid /proc/1600/ns/pid
> /proc/1550/ns/pid

Well, personally I too think that the filenames look a bit strange,
can't it just print the numbers?

And, iiuc what this patch does... perhaps in this case we should
simply add "struct list_head children" into struct pid_namespace?
In this case the patch will be really simple. I dunno.

> +pidns_list_add(struct pid *pid, struct list_head *list_head,
> +		struct pid_namespace *curr_ns)
> +{
> +	struct pidns_list *ent;
> +	struct pid_namespace *ns;
> +
> +	if (is_child_reaper(pid)) {
> +		ent = kmalloc(sizeof(*ent), GFP_KERNEL);

GFP_KERNEL under rcu_read_lock(). This is not safe without
CONFIG_PREEMPT_RCU.

> +		if (!ent)
> +			return -ENOMEM;
> +
> +		ent->pid = pid;
> +		ns = pid->numbers[pid->level].ns;
> +		if (curr_ns) {
> +			/* add pids who is the child of curr_ns */
> +			for (; ns != NULL; ns = ns->parent)
> +				if (ns == curr_ns)
> +					list_add_tail(&ent->list, list_head);

afaics, it doesn't make sense to continue after list_add() ?

> +static int proc_pidns_list_refresh(struct pid_namespace *curr_ns)
> +{
> +	struct pid *pid;
> +	struct task_struct *p;
> +	int rc;
> +
> +	/* collect pid in differet ns */
> +	for_each_process(p) {

Hmm. We only want the tasks from our namespace, yes? Perhaps find_ge_pid()
makes more sense?

> +		pid = task_pid(p);

Well, in theory you need barrier() here. Or perhaps we should add
ACCESS_ONCE() into task_pid()...

And imho it would be better to declare pidns_list/pidns_tree locally
in nslist_proc_show() and pass them to the callees.

Oleg.

