Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKFJgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:36:42 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:27812 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751472AbaKFJgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:36:36 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="42953615"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Mateusz Guzik <mguzik@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        "Richard Weinberger" <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: RE: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
Thread-Index: AQHP+O9Lg3z+Noh97kKDgxnQdIZD5ZxTN0FA
Date: Thu, 6 Nov 2014 09:36:32 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E61F8D3@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20141105115422.GA28654@mguzik>
In-Reply-To: <20141105115422.GA28654@mguzik>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA69akJI001738



> -----Original Message-----
> From: Mateusz Guzik [mailto:mguzik@redhat.com]
> Sent: Wednesday, November 05, 2014 7:54 PM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„
> Cc: Eric W. Biederman; Serge Hallyn; Oleg Nesterov;
> containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; David
> Howells; Richard Weinberger; Pavel Emelyanov; Vasiliy Kulikov
> Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
> 
> On Wed, Nov 05, 2014 at 06:41:54PM +0800, Chen Hanxiao wrote:
> > +static void free_pidns_list(struct list_head *head)
> > +{
> > +	struct pidns_list *tmp, *pos;
> > +
> > +	list_for_each_entry_safe(pos, tmp, head, list) {
> > +		list_del(&pos->list);
> 
> Any need for this one? stuff is freed anyway...
> 
Yes, they're all freed.
But is that ok to leave a list full of freed stuffs..

[snip]
> > +
> > +		if (flag == 0) {
> > +			rcu_read_lock();
> > +			get_pid(pos->pid);
> > +			rcu_read_unlock();
> 
> At this point you should have a valid reference for pid, so rcu should
> not matter.
> 
Right.

> 
> > +			rc = pidns_list_add(pos->pid, pidns_pid_tree);
> > +			if (rc) {
> > +				put_pid(pos->pid);
> > +				goto out;
> > +                        }
> 
> '}' is misindented. Also 'out' is not a good label if it used solely for
> cleanup on error. 'out_err', 'fail' or something woud be better.

something wrong with my vimrc...
'out' is definitely not a good label.
I think 'cleanup' is a better one.

> 
[snip]
> > +static int proc_pidns_list_refresh(struct pid_namespace *curr_ns,
> > +		struct list_head *pidns_pid_list,
> > +		struct list_head *pidns_pid_tree)
> > +{
> > +	struct pid *pid;
> > +	int new_nr, nr = 0;
> > +	int rc;
> > +
> > +	/* collect pids in current namespace */
> > +	while (nr < PID_MAX_LIMIT) {
> > +		rcu_read_lock();
> > +		pid = find_ge_pid(nr, curr_ns);
> > +		if (pid) {
> > +			new_nr = pid_vnr(pid);
> > +			if (!is_child_reaper(pid)) {
> > +				nr = new_nr + 1;
> > +				rcu_read_unlock();
> > +				continue;
> > +			}
> > +			get_pid(pid);
> > +			rcu_read_unlock();
> > +			rc = pidns_list_add(pid, pidns_pid_list);
> > +			if (rc) {
> > +				put_pid(pid);
> > +				goto out;
> > +                        }
> > +		} else {
> > +			rcu_read_unlock();
> > +			break;
> > +		}
> > +		nr = new_nr + 1;
> > +	}
> > +
> 
> Would be beneficial to reorganize this loop. Handle shorter case (!pid)
> first.

OK.

> 
> I consulted Dr. Grep and it told me about delayed_put_pid, so I guess
> pid itself is not going to be freed in the meantime, but this still
> seems fishy.

I found 
call_rcu(&pid->rcu, delayed_put_pid) in free_pid


Thanks,
- Chen

> 
> > +	/*
> > +	 * Only one pid found as the child reaper,
> > +	 * so current pid namespace do not have sub-namespace,
> > +	 * return 0 directly.
> > +	 */
> > +	if (list_is_singular(pidns_pid_list)) {
> > +		rc = 0;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * screen duplicate pids from pidns_pid_list
> > +	 * and form a new list pidns_pid_tree.
> > +	 */
> > +	rc = pidns_list_filter(pidns_pid_list, pidns_pid_tree);
> > +	if (rc)
> > +		goto out;
> > +
> > +	return 0;
> > +
> > +out:
> > +	free_pidns_list(pidns_pid_list);
> > +	return rc;
> > +}
> > +
> > +static int nslist_proc_show(struct seq_file *m, void *v)
> > +{
> > +	struct pidns_list *pos;
> > +	struct pid_namespace *ns, *curr_ns;
> > +	struct pid *pid;
> > +	char pid_buf[16];
> > +	int i, rc;
> > +
> > +	LIST_HEAD(pidns_pid_list);
> > +	LIST_HEAD(pidns_pid_tree);
> > +
> > +	curr_ns = task_active_pid_ns(current);
> > +
> > +	rc = proc_pidns_list_refresh(curr_ns, &pidns_pid_list, &pidns_pid_tree);
> > +	if (rc)
> > +		return rc;
> > +
> > +	/* print pid namespace's hierarchy */
> > +	list_for_each_entry(pos, &pidns_pid_tree, list) {
> > +		pid = pos->pid;
> > +		for (i = curr_ns->level + 1; i <= pid->level; i++) {
> > +			ns = pid->numbers[i].ns;
> > +			/* show PID '1' in specific pid ns */
> > +			snprintf(pid_buf, 16, "%u",
> > +				pid_vnr(find_pid_ns(1, ns)));
> > +			seq_printf(m, "%s ", pid_buf);
> > +		}
> > +
> > +		seq_putc(m, '\n');
> > +	}
> > +
> > +	free_pidns_list(&pidns_pid_tree);
> > +
> > +	return 0;
> > +}
> > +
> > +static int nslist_proc_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, nslist_proc_show, NULL);
> > +}
> > +
> > +static const struct file_operations proc_nspid_nslist_fops = {
> > +	.open		= nslist_proc_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= single_release,
> > +};
> > +
> > +static int __init pidns_hierarchy_init(void)
> > +{
> > +	proc_create(NS_HIERARCHY, S_IWUGO,
> > +		NULL, &proc_nspid_nslist_fops);
> > +
> > +	return 0;
> > +}
> > +fs_initcall(pidns_hierarchy_init);
> > --
> > 1.9.3
> >
> 
> --
> Mateusz Guzik
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
