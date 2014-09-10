Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaIJQXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:23:18 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:45330
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaIJQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:23:16 -0400
Date: Wed, 10 Sep 2014 18:23:15 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
Message-ID: <20140910162315.GB7748@mail.hallyn.com>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1409740200-26461-3-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409740200-26461-3-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> This patch will show the hierarchy of pid namespace
> under /proc/pidns like:
> /proc/pidns
> ├── hierarchy
> │   ├── pidns4026532399
> │   │   ├── pidns -> /proc/2863/ns/pid
> │   │   └── pidns4026532515
> │   │       └── pidns -> /proc/10611/ns/pid
> │   └── pidns4026532504
> │       └── pidns -> /proc/4450/ns/pid
> └── refresh
> 
> a) hierarchy dir:
>   use to show hierarchy infomation using dir and symlinks.
>   dirs are named as pidns($inum)
>   a symlink is created under pidns($inum), and linked to
>   that pid namespace.
> 
> b) refresh
>   trigger key.
>   We need to write sth to /proc/nspid/refresh,
>   then we could get hierarchy info
>   under /proc/pidns/hierarchy.

Ouch.  There may not be a better way, but it sure would be nice if
we could simply have the list update in real-time.

If we have to 'echo 1 > /proc/pidns/refresh' to update the fs tree under
/proc/pidns/ to reflect new pidns activity, then why not just make this
a text file?  I suppose if it were a textfile you'd be encouraging ppl
to 'cat pidlist | while read line; do grep line /proc/pidns; done',
which would cause a refresh of that file for every grep?

My concern with this approach is that it is unlike any other pseudo-fs
that I know of, and people may simply expect the fs contents to be
uptodate rather than a snapshot.

> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
>  fs/proc/Kconfig           |   6 ++
>  fs/proc/Makefile          |   1 +
>  fs/proc/pidns_hierarchy.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 168 insertions(+)
>  create mode 100644 fs/proc/pidns_hierarchy.c
> 
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 2183fcf..e2e2292 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -71,3 +71,9 @@ config PROC_PAGE_MONITOR
>  	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
>  	  /proc/kpagecount, and /proc/kpageflags. Disabling these
>            interfaces will reduce the size of the kernel by approximately 4kb.
> +
> +config PROC_PID_HIERARCHY
> +	bool "Enable /proc/pidns_hierarchy support" if EXPERT
> +	depends on PROC_FS
> +	help
> +	  Show pid namespace hierarchy infomation
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index 239493e..733599b 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -29,3 +29,4 @@ proc-$(CONFIG_PROC_KCORE)	+= kcore.o
>  proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
>  proc-$(CONFIG_PRINTK)	+= kmsg.o
>  proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
> +proc-$(CONFIG_PROC_PID_HIERARCHY)	+= pidns_hierarchy.o
> diff --git a/fs/proc/pidns_hierarchy.c b/fs/proc/pidns_hierarchy.c
> new file mode 100644
> index 0000000..d35340f
> --- /dev/null
> +++ b/fs/proc/pidns_hierarchy.c
> @@ -0,0 +1,161 @@
> +/*
> + * proc_pidns_hierarchy.c -- handles pidns hierarchy
> + *
> + * Copyright 2014
> + */
> +
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/proc_fs.h>
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/pid_namespace.h>
> +
> +/*
> + * The /proc/pidns directory
> + */
> +
> +#define BASE_DIR	"pidns"			/* Subdir in /proc */
> +#define HIERARCHY_DIR	"pidns/hierarchy"	/* hierarchy dir */
> +#define REFRESH_KEY	"pidns/refresh"		/* refresh key */
> +#define NAME		"pidns_hierarchy"	/* Module name */
> +
> +static LIST_HEAD(pidns_list);
> +static DEFINE_RWLOCK(pidns_lock);
> +static struct proc_dir_entry *proc_root;
> +
> +struct ns_pid_list {
> +	struct pid *pid;
> +	struct list_head list;
> +};
> +
> +static void free_pidns_list(struct list_head *head)
> +{
> +	struct ns_pid_list *tmp, *pos;
> +
> +	list_for_each_entry_safe(pos, tmp, head, list) {
> +		list_del(&pos->list);
> +		kfree(pos);
> +	}
> +}
> +
> +/*
> + * Only add pids with different ns
> + */
> +static int
> +ns_pid_list_really_add(struct pid *pid)
> +{
> +	struct ns_pid_list *tmp, *pos;
> +
> +	list_for_each_entry_safe(pos, tmp, &pidns_list, list)
> +		if (ns_of_pid(pid) == ns_of_pid(pos->pid))
> +			return 0;
> +
> +	return 1;
> +}
> +
> +static int
> +ns_pid_list_add(struct pid *pid)
> +{
> +	struct ns_pid_list *ent;
> +
> +	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
> +	if (!ent)
> +		return -ENOMEM;
> +	ent->pid = pid;
> +	if (ns_pid_list_really_add(pid))
> +		list_add_tail(&ent->list, &pidns_list);
> +
> +	return 0;
> +}
> +
> +static void print_list(void)
> +{
> +	struct ns_pid_list *tmp, *pos;
> +	struct proc_dir_entry *parent, *parent_new;
> +	struct pid_namespace *ns, *curr_ns;
> +	struct pid *pid;
> +	char name_buf[16], pid_buf[32];
> +	int i, k;
> +
> +	curr_ns = task_active_pid_ns(current);
> +
> +	list_for_each_entry_safe(pos, tmp, &pidns_list, list) {
> +		pid = pos->pid;
> +		k = -1;
> +		ns = pid->numbers[pid->level].ns;
> +		/* Check whether pid has relationship with current ns */
> +		for (; ns != NULL; ns = ns->parent)
> +			if (ns == curr_ns)
> +				k = curr_ns->level;
> +		if (k == -1)
> +			continue;
> +		parent = proc_root;
> +		for (i = k + 1; i <= pid->level; i++) {
> +			ns = pid->numbers[i].ns;
> +			snprintf(name_buf, 16, "pidns%u",
> +				pid->numbers[i].ns->proc_inum);
> +			snprintf(pid_buf, 32, "/proc/%u/ns/pid",
> +				pid->numbers[0].nr);
> +			/* don't duplicate ns dirs */
> +			parent_new = proc_uniq_dir(parent, name_buf);
> +			if (!parent_new) {
> +				parent_new = proc_mkdir(name_buf, parent);
> +				proc_symlink("pidns", parent_new, pid_buf);
> +			}
> +		parent = parent_new;
> +		}
> +	}
> +}
> +
> +void proc_pidns_list(void)
> +{
> +	struct pid *pid;
> +	struct task_struct *task = &init_task;
> +
> +	remove_proc_subtree(HIERARCHY_DIR, NULL);
> +	proc_root = proc_mkdir(HIERARCHY_DIR, NULL);
> +	free_pidns_list(&pidns_list);
> +
> +	do {
> +		pid = task_pid(task);
> +		if (pid) {
> +			if (pid->level > 0)
> +				ns_pid_list_add(pid);
> +		}
> +	} while ((task = next_task(task)) != &init_task);
> +
> +	print_list();
> +	printk(KERN_INFO "refresh finished\n");
> +}
> +
> +ssize_t proc_pidns_refresh_switch(struct file *file, const char __user *buf,
> +		size_t size, loff_t *ppos)
> +{
> +	write_lock(&pidns_lock);
> +	proc_pidns_list();
> +	write_unlock(&pidns_lock);
> +	return 1;
> +}
> +
> +static const struct file_operations proc_pidns_refresh_fops = {
> +	.write = proc_pidns_refresh_switch,
> +};
> +
> +static int __init pidns_hierarchy_init(void)
> +{
> +
> +	if (!proc_mkdir(BASE_DIR, NULL))
> +		return -ENOMEM;
> +	proc_root = proc_mkdir(HIERARCHY_DIR, NULL);
> +	if (!proc_root)
> +		return -ENOMEM;
> +
> +	proc_create(REFRESH_KEY, S_IWUGO,
> +		NULL, &proc_pidns_refresh_fops);
> +	printk(KERN_INFO "%s: loaded successfully\n", NAME);
> +
> +	return 0;
> +}
> +fs_initcall(pidns_hierarchy_init);
> -- 
> 1.9.0
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
