Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaKELyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbaKELys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:54:48 -0500
Date: Wed, 5 Nov 2014 12:54:23 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
Message-ID: <20141105115422.GA28654@mguzik>
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 06:41:54PM +0800, Chen Hanxiao wrote:
> +static void free_pidns_list(struct list_head *head)
> +{
> +	struct pidns_list *tmp, *pos;
> +
> +	list_for_each_entry_safe(pos, tmp, head, list) {
> +		list_del(&pos->list);

Any need for this one? stuff is freed anyway...

> +		put_pid(pos->pid);
> +		kfree(pos);
> +	}
> +}
> +
> +static int
> +pidns_list_add(struct pid *pid, struct list_head *list_head)
> +{
> +	struct pidns_list *ent;
> +
> +	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
> +	if (!ent)
> +		return -ENOMEM;
> +
> +	ent->pid = pid;
> +	list_add_tail(&ent->list, list_head);
> +
> +	return 0;
> +}
> +
> +static int
> +pidns_list_filter(struct list_head *pidns_pid_list,
> +		struct list_head *pidns_pid_tree)
> +{
> +	struct pidns_list *pos, *pos_t;
> +	struct pid_namespace *ns0, *ns1;
> +	struct pid *pid0, *pid1;
> +	int rc, flag = 0;
> +
> +	/*
> +	 * screen pids with relationship
> +	 * in pidns_pid_list, we may add pids like:
> +	 * ns0   ns1   ns2
> +	 * pid1->pid2->pid3
> +	 * we should screen pid1, pid2 and keep pid3
> +	 */
> +	list_for_each_entry(pos, pidns_pid_list, list) {
> +		list_for_each_entry(pos_t, pidns_pid_list, list) {
> +			flag = 0;
> +			pid0 = pos->pid;
> +			pid1 = pos_t->pid;
> +			ns0 = pid0->numbers[pid0->level].ns;
> +			ns1 = pid1->numbers[pid1->level].ns;
> +			if (pos->pid->level < pos_t->pid->level)
> +				for (; ns1 != NULL; ns1 = ns1->parent)
> +					if (ns0 == ns1) {
> +						flag = 1;
> +						break;
> +					}
> +			/* a redundant pid found */
> +			if (flag == 1)
> +				break;
> +		}
> +
> +		if (flag == 0) {
> +			rcu_read_lock();
> +			get_pid(pos->pid);
> +			rcu_read_unlock();

At this point you should have a valid reference for pid, so rcu should
not matter.


> +			rc = pidns_list_add(pos->pid, pidns_pid_tree);
> +			if (rc) {
> +				put_pid(pos->pid);
> +				goto out;
> +                        }

'}' is misindented. Also 'out' is not a good label if it used solely for
cleanup on error. 'out_err', 'fail' or something woud be better.

> +		}
> +	}
> +
> +	/*
> +	 * Now all usefull stuffs are in pidns_pid_tree,
> +	 * free pidns_pid_list
> +	 */
> +	free_pidns_list(pidns_pid_list);
> +
> +	return 0;
> +
> +out:
> +	free_pidns_list(pidns_pid_tree);
> +	return rc;
> +}
> +
> +/* 
> + * collect pids and stored in pidns_pid_list,
> + * then remove duplicated ones,
> + * add the rest to pidns_pid_tree
> + */
> +static int proc_pidns_list_refresh(struct pid_namespace *curr_ns,
> +		struct list_head *pidns_pid_list,
> +		struct list_head *pidns_pid_tree)
> +{
> +	struct pid *pid;
> +	int new_nr, nr = 0;
> +	int rc;
> +
> +	/* collect pids in current namespace */
> +	while (nr < PID_MAX_LIMIT) {
> +		rcu_read_lock();
> +		pid = find_ge_pid(nr, curr_ns);
> +		if (pid) {
> +			new_nr = pid_vnr(pid);
> +			if (!is_child_reaper(pid)) {
> +				nr = new_nr + 1;
> +				rcu_read_unlock();
> +				continue;
> +			}
> +			get_pid(pid);
> +			rcu_read_unlock();
> +			rc = pidns_list_add(pid, pidns_pid_list);
> +			if (rc) {
> +				put_pid(pid);
> +				goto out;
> +                        }
> +		} else {
> +			rcu_read_unlock();
> +			break;
> +		}
> +		nr = new_nr + 1;
> +	}
> +

Would be beneficial to reorganize this loop. Handle shorter case (!pid)
first.

I consulted Dr. Grep and it told me about delayed_put_pid, so I guess
pid itself is not going to be freed in the meantime, but this still
seems fishy. 

> +	/*
> +	 * Only one pid found as the child reaper,
> +	 * so current pid namespace do not have sub-namespace,
> +	 * return 0 directly.
> +	 */
> +	if (list_is_singular(pidns_pid_list)) {
> +		rc = 0;
> +		goto out;
> +	}
> +
> +	/*
> +	 * screen duplicate pids from pidns_pid_list
> +	 * and form a new list pidns_pid_tree.
> +	 */
> +	rc = pidns_list_filter(pidns_pid_list, pidns_pid_tree);
> +	if (rc)
> +		goto out;
> +
> +	return 0;
> +
> +out:
> +	free_pidns_list(pidns_pid_list);
> +	return rc;
> +}
> +
> +static int nslist_proc_show(struct seq_file *m, void *v)
> +{
> +	struct pidns_list *pos;
> +	struct pid_namespace *ns, *curr_ns;
> +	struct pid *pid;
> +	char pid_buf[16];
> +	int i, rc;
> +
> +	LIST_HEAD(pidns_pid_list);
> +	LIST_HEAD(pidns_pid_tree);
> +
> +	curr_ns = task_active_pid_ns(current);
> +
> +	rc = proc_pidns_list_refresh(curr_ns, &pidns_pid_list, &pidns_pid_tree);
> +	if (rc)
> +		return rc;
> +
> +	/* print pid namespace's hierarchy */
> +	list_for_each_entry(pos, &pidns_pid_tree, list) {
> +		pid = pos->pid;
> +		for (i = curr_ns->level + 1; i <= pid->level; i++) {
> +			ns = pid->numbers[i].ns;
> +			/* show PID '1' in specific pid ns */
> +			snprintf(pid_buf, 16, "%u",
> +				pid_vnr(find_pid_ns(1, ns)));
> +			seq_printf(m, "%s ", pid_buf);
> +		}
> +
> +		seq_putc(m, '\n');
> +	}
> +
> +	free_pidns_list(&pidns_pid_tree);
> +
> +	return 0;
> +}
> +
> +static int nslist_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, nslist_proc_show, NULL);
> +}
> +
> +static const struct file_operations proc_nspid_nslist_fops = {
> +	.open		= nslist_proc_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static int __init pidns_hierarchy_init(void)
> +{
> +	proc_create(NS_HIERARCHY, S_IWUGO,
> +		NULL, &proc_nspid_nslist_fops);
> +
> +	return 0;
> +}
> +fs_initcall(pidns_hierarchy_init);
> -- 
> 1.9.3
> 

-- 
Mateusz Guzik
