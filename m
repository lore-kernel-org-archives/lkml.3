Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaJSE6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 00:58:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46518 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJSE6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 00:58:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-7-git-send-email-adityakali@google.com>
Date: Sat, 18 Oct 2014 21:57:30 -0700
In-Reply-To: <1413235430-22944-7-git-send-email-adityakali@google.com> (Aditya
	Kali's message of "Mon, 13 Oct 2014 14:23:48 -0700")
Message-ID: <8761fgpsg5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+F78Y5dF4aHSDZjIpaF4xwqLJKpWX9hSc=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4988]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Aditya Kali <adityakali@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 582 ms - load_scoreonly_sql: 0.08 (0.0%),
	signal_user_changed: 4.8 (0.8%), b_tie_ro: 3.3 (0.6%), parse: 1.18 (0.2%),
	extract_message_metadata: 5 (0.9%), get_uri_detail_list: 3.3 (0.6%),
	tests_pri_-1000: 3.3 (0.6%), tests_pri_-950: 1.22 (0.2%), tests_pri_-900:
	0.98 (0.2%), tests_pri_-400: 29 (4.9%), check_bayes: 28 (4.7%), b_tokenize:
	13 (2.2%), b_tok_get_all: 8 (1.4%), b_comp_prob: 2.0 (0.3%), b_tok_touch_all:
	2.7 (0.5%), b_finish: 0.68 (0.1%), tests_pri_0: 522 (89.6%), tests_pri_500:
	3.5 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv1 6/8] cgroup: restrict cgroup operations within task's cgroupns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aditya Kali <adityakali@google.com> writes:

> Restrict following operations within the calling tasks:
> * cgroup_mkdir & cgroup_rmdir
> * cgroup_attach_task
> * writes to cgroup files outside of task's cgroupns-root
>
> Also, read of /proc/<pid>/cgroup file is now restricted only
> to tasks under same cgroupns-root. If a task tries to look
> at cgroup of another task outside of its cgroupns-root, then
> it won't be able to see anything for the default hierarchy.
> This is same as if the cgroups are not mounted.

So I think this patch is out of order.  

We should add the namespace infrastructre and the restrictions before
we allow creation of the namespace.  Otherwise there is a bisection
point where cgroup namespaces are broken or at the very least have a
security hole.  Since we can anticipate this let's see if we can figure
out how to avoid it.

Eric


> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
>  kernel/cgroup.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f8099b4..2fc0dfa 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2318,6 +2318,12 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
>  	struct task_struct *task;
>  	int ret;
>  
> +	/* Only allow changing cgroups accessible within task's cgroup
> +	 * namespace. i.e. 'dst_cgrp' should be a descendant of task's
> +	 * cgroupns->root_cgrp. */
> +	if (!cgroup_is_descendant(dst_cgrp, task_cgroupns_root(leader)))
> +		return -EPERM;
> +
>  	/* look up all src csets */
>  	down_read(&css_set_rwsem);
>  	rcu_read_lock();
> @@ -2882,6 +2888,10 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
>  	struct cgroup_subsys_state *css;
>  	int ret;
>  
> +	/* Reject writes to cgroup files outside of task's cgroupns-root. */
> +	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current)))
> +		return -EINVAL;
> +
>  	if (cft->write)
>  		return cft->write(of, buf, nbytes, off);
>  
> @@ -4560,6 +4570,13 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
>  	parent = cgroup_kn_lock_live(parent_kn);
>  	if (!parent)
>  		return -ENODEV;
> +
> +	/* Allow mkdir only within process's cgroup namespace root. */
> +	if (!cgroup_is_descendant(parent, task_cgroupns_root(current))) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +
>  	root = parent->root;
>  
>  	/* allocate the cgroup and its ID, 0 is reserved for the root */
> @@ -4822,6 +4839,13 @@ static int cgroup_rmdir(struct kernfs_node *kn)
>  	if (!cgrp)
>  		return 0;
>  
> +	/* Allow rmdir only within process's cgroup namespace root.
> +	 * The process can't delete its own root anyways. */
> +	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current))) {
> +		cgroup_kn_unlock(kn);
> +		return -EPERM;
> +	}
> +
>  	ret = cgroup_destroy_locked(cgrp);
>  
>  	cgroup_kn_unlock(kn);
> @@ -5051,6 +5075,15 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
>  		if (root == &cgrp_dfl_root && !cgrp_dfl_root_visible)
>  			continue;
>  
> +		cgrp = task_cgroup_from_root(tsk, root);
> +
> +		/* The cgroup path on default hierarchy is shown only if it
> +		 * falls under current task's cgroupns-root.
> +		 */
> +		if (root == &cgrp_dfl_root &&
> +		    !cgroup_is_descendant(cgrp, task_cgroupns_root(current)))
> +			continue;
> +
>  		seq_printf(m, "%d:", root->hierarchy_id);
>  		for_each_subsys(ss, ssid)
>  			if (root->subsys_mask & (1 << ssid))
> @@ -5059,7 +5092,6 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
>  			seq_printf(m, "%sname=%s", count ? "," : "",
>  				   root->name);
>  		seq_putc(m, ':');
> -		cgrp = task_cgroup_from_root(tsk, root);
>  		path = cgroup_path(cgrp, buf, PATH_MAX);
>  		if (!path) {
>  			retval = -ENAMETOOLONG;
