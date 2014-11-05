Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaKEMLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:11:17 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbaKEMLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:11:13 -0500
Message-ID: <545A13DA.3090207@nod.at>
Date: Wed, 05 Nov 2014 13:11:06 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com> <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 11:41 schrieb Chen Hanxiao:
> We lack of pid hierarchy information, and this will lead to:
> a) we don't know pids' relationship, who is whose child:
>    /proc/PID/ns/pid only tell us whether two pids live in different ns
> b) bring trouble to nested lxc container check/restore/migration
> c) bring trouble to pid translation between containers;
> 
> This patch will show the hierarchy of pid namespace
> by pidns_hierarchy like:
> 
> [root@localhost ~]#cat /proc/pidns_hierarchy
> 18060 18102 1534
> 18060 18102 1600
> 1550

Hmm, what about printing the pid hierarchy in the same way as /proc/self/mountinfo
does with mount namespaces?
Your current approach is not bad but we should really try to be consistent with existing
sources of information.

> *Note: numbers represent the pid 1 in different ns
> 
> It shows the pid hierarchy below:
> 
>       init_pid_ns (not showed in /proc/pidns_hierarchy)
>               │
> ┌────────────┐
> ns1                      ns2
> │                        │
> 1550                    18060
>                           │
>                           │
>                          ns3
>                           │
>                         18102
>                           │
>                  ┌──────────┐
>                  ns4                   ns5
>                  │                    │
>                 1534                  1600
> 
> Every pid printed in pidns_hierarchy
> is the init pid of that pid ns level.
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
> v6: fix get_pid leaks and do some cleanups;
> v5: collect pid by find_ge_pid;
>     use local list inside nslist_proc_show;
>     use get_pid, remove mutex lock.
> v4: simplify pid collection and some performance optimizamtion
>     fix another race issue.
> v3: fix a race issue and memory leak issue
> v2: use a procfs text file instead of dirs under /proc
> 
>  fs/proc/Kconfig           |   6 ++
>  fs/proc/Makefile          |   1 +
>  fs/proc/pidns_hierarchy.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 234 insertions(+)
>  create mode 100644 fs/proc/pidns_hierarchy.c
> 
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 2183fcf..4bb111c 100644
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
> +	  Show pid namespace hierarchy information

Why does this depend on EXPERT?
Every Linux distro will enable this option.

> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index 7151ea4..33e384b 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -30,3 +30,4 @@ proc-$(CONFIG_PROC_KCORE)	+= kcore.o
>  proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
>  proc-$(CONFIG_PRINTK)	+= kmsg.o
>  proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
> +proc-$(CONFIG_PROC_PID_HIERARCHY)	+= pidns_hierarchy.o
> diff --git a/fs/proc/pidns_hierarchy.c b/fs/proc/pidns_hierarchy.c
> new file mode 100644
> index 0000000..aee359f
> --- /dev/null
> +++ b/fs/proc/pidns_hierarchy.c
> @@ -0,0 +1,227 @@
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/proc_fs.h>
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/seq_file.h>
> +
> +/*
> + *  /proc/pidns_hierarchy
> + *
> + *  show the hierarchy of pid namespace
> + */
> +
> +#define NS_HIERARCHY	"pidns_hierarchy"
> +
> +/* list for host pid collection */
> +struct pidns_list {
> +	struct list_head list;
> +	struct pid *pid;
> +};
> +
> +static void free_pidns_list(struct list_head *head)
> +{
> +	struct pidns_list *tmp, *pos;
> +
> +	list_for_each_entry_safe(pos, tmp, head, list) {
> +		list_del(&pos->list);
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
> +			rc = pidns_list_add(pos->pid, pidns_pid_tree);
> +			if (rc) {
> +				put_pid(pos->pid);
> +				goto out;
> +                        }
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

This function allocates memory per PID. If we have lots of PIDs, how does this scale?
I'd go so far and say this can be a DoS'able issue if the pidns_hierarchy file is opened multiple times...

Thanks,
//richard
