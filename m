Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaKLLPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:15:22 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaKLLPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:15:16 -0500
Message-ID: <5463413E.6000800@nod.at>
Date: Wed, 12 Nov 2014 12:15:10 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCH v7 1/2] procfs: show hierarchy of pid namespace
References: <1415786899-13392-1-git-send-email-chenhanxiao@cn.fujitsu.com> <1415786899-13392-2-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1415786899-13392-2-git-send-email-chenhanxiao@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.11.2014 um 11:08 schrieb Chen Hanxiao:
> We lack of pid hierarchy information, and this will lead to:
> a) we don't know pids' relationship, who is whose child:
>    /proc/PID/ns/pid only tell us whether two pids live in different ns
> b) bring trouble to nested lxc container check/restore/migration
> c) bring trouble to pid translation between containers;
> 
> This patch will show the hierarchy of pid namespace
> by pidns_hierarchy like:
> 
> <init_PID> <parent_of_init_PID> <relative PID level>
> 
> Ex:
> [root@localhost ~]#cat /proc/pidns_hierarchy
> 18060 1 1
> 18102 18060 2
> 1534  18102 3
> 1600  18102 3
> 1550  1 1
> *Note: numbers represent the pid 1 in different ns
> 
> It shows the pid hierarchy below:
> 
>       init_pid_ns 1
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
> v7: change stype to be consistent with current interface like
>     <init_PID> <parent_of_init_PID> <relative PID level>
>     remove EXPERT dependent in Kconfig
> v6: fix a get_pid leak and do some cleanups;
> v5: collect pid by find_ge_pid;
>     use local list inside nslist_proc_show;
>     use get_pid, remove mutex lock.
> v4: simplify pid collection and some performance optimizamtion
>     fix another race issue.
> v3: fix a race issue and memory leak issue
> v2: use a procfs text file instead of dirs under /proc
> 
>  fs/proc/Kconfig           |   6 +
>  fs/proc/Makefile          |   1 +
>  fs/proc/pidns_hierarchy.c | 280 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 287 insertions(+)
>  create mode 100644 fs/proc/pidns_hierarchy.c
> 
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 2183fcf..82dda55 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -71,3 +71,9 @@ config PROC_PAGE_MONITOR
>  	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
>  	  /proc/kpagecount, and /proc/kpageflags. Disabling these
>            interfaces will reduce the size of the kernel by approximately 4kb.
> +
> +config PROC_PID_HIERARCHY
> +	bool "Enable /proc/pidns_hierarchy support"
> +	depends on PROC_FS
> +	help
> +	  Show pid namespace hierarchy information
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
> index 0000000..4629bfd
> --- /dev/null
> +++ b/fs/proc/pidns_hierarchy.c
> @@ -0,0 +1,280 @@
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
> + *  show the hierarchy of pid namespace in:
> + *  <init_PID>  <parent_of_init_PID> <relative PID level>
> + *
> + *  init_PID: child reaper in ns
> + *  parent_of_init_PID: init_PID's parent, also child reaper
> + *  relative PID level: pid level relative to caller's ns
> + */
> +
> +#define NS_HIERARCHY	"pidns_hierarchy"
> +#define MAX(a, b) ((a) > (b) ? (a) : (b))

Please use max() from kernel.h, there is no need to reinvent the wheel.

> +
> +/* list for host pid collection */
> +struct pidns_list {
> +	struct list_head list;
> +	struct pid *pid;
> +	int show_level;

s/show_level/level, to keep it easy. :-)

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
> +pidns_list_add(struct pid *pid, struct list_head *list_head,
> +		int show_level)
> +{
> +	struct pidns_list *ent;
> +
> +	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
> +	if (!ent)
> +		return -ENOMEM;
> +
> +	ent->pid = pid;
> +	ent->show_level = show_level;
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
> +			get_pid(pos->pid);
> +			rc = pidns_list_add(pos->pid, pidns_pid_tree, 0);
> +			if (rc) {
> +				put_pid(pos->pid);
> +				goto cleanup;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 *  Now all useful stuffs are in pidns_pid_tree,
> +	 *  free pidns_pid_list
> +	 */
> +	free_pidns_list(pidns_pid_list);
> +
> +	return 0;
> +
> +cleanup:
> +	free_pidns_list(pidns_pid_tree);
> +	return rc;
> +}
> +
> +static void
> +pidns_list_set_show_level(struct list_head *pidns_list_in,
> +		struct pid_namespace *curr_ns)
> +{
> +	struct pidns_list *pos, *pos_t;
> +	struct pid *pid0, *pid1;
> +	int i;
> +
> +	/*
> +	 * From the pid hierarchy point of view,
> +	 * we already had a list of pids who are not
> +	 * the subset of each other.
> +	 * But part of them may be same.
> +	 * We need to set the show_level of each pids:
> +	 * pid0:         A->B->C   pid1:       A->B->D
> +	 * show_level       2                  0
> +	 * We use show_level to identify
> +	 * the public part of each pids.
> +	 */
> +	list_for_each_entry(pos, pidns_list_in, list) {
> +		list_for_each_entry(pos_t, pidns_list_in, list) {
> +			pid0 = pos->pid;
> +			pid1 = pos_t->pid;
> +			if (pid0 == pid1)
> +				continue;
> +			if (pos_t->show_level > 0)
> +				continue;
> +			for (i = curr_ns->level + 1; i <= pid0->level; i++) {
> +				/* skip the public parts */
> +				if (pid0->numbers[i].ns ==
> +						pid1->numbers[i].ns)
> +					continue;
> +				else
> +					break;
> +			}
> +			pos->show_level = i - 1;
> +		}
> +	}
> +}
> +
> +/*
> + * collect pids and stored in pidns_pid_list,

s/stored/store

> + * then remove duplicated ones,
> + * add the rest to pidns_pid_tree
> + */

This comment is a bit confusing.

What about "proc_pidns_list_refresh - Finds all init pids, places them into pidns_pid_list
and then stores the hirarchy into pidns_pid_tree."?

Beside of my minor comments I like the patch. :-)
Thanks a lot for doing this work!

Thanks,
//richard
