Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaJIKCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:02:50 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751261AbaJIKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:02:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,683,1406563200"; 
   d="scan'208";a="37007997"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: RE: [PATCHv4] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCHv4] procfs: show hierarchy of pid namespace
Thread-Index: AQHP4wrZ2MSxvdApvkG5f6ztnzmOcJwne5xQ
Date: Thu, 9 Oct 2014 10:02:37 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5E1649@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20141008151328.GB4835@redhat.com>
In-Reply-To: <20141008151328.GB4835@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s99A2tYg029667



> -----Original Message-----
> From: Oleg Nesterov [mailto:oleg@redhat.com]
> Sent: Wednesday, October 08, 2014 11:13 PM
> To: Chen, Hanxiao/³Â êÏÏö
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Serge
> Hallyn; Eric W. Biederman; David Howells; Richard Weinberger; Pavel Emelyanov;
> Vasiliy Kulikov; Mateusz Guzik
> Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
> 
> Sorry if this was already discussed, I have to admit that I ignored
> the previous discussion ;) And it is possible I misread this patch
> completely.
> 
> On 10/08, Chen Hanxiao wrote:
> >
> > This patch will show the hierarchy of pid namespace
> > by /proc/pidns_hierarchy like:
> >
> > [root@localhost ~]#cat /proc/pidns_hierarchy
> > /proc/18060/ns/pid /proc/18102/ns/pid /proc/1534/ns/pid
> > /proc/18060/ns/pid /proc/18102/ns/pid /proc/1600/ns/pid
> > /proc/1550/ns/pid
> 
> Well, personally I too think that the filenames look a bit strange,
> can't it just print the numbers?

Yes, let's print PID numbers only.
> 
> And, iiuc what this patch does... perhaps in this case we should
> simply add "struct list_head children" into struct pid_namespace?
> In this case the patch will be really simple. I dunno.
> 

If we had a children list in pid_namespace,
all we had to do is a iteration from pid 1 of current ns.
That would be nice.

> > +pidns_list_add(struct pid *pid, struct list_head *list_head,
> > +		struct pid_namespace *curr_ns)
> > +{
> > +	struct pidns_list *ent;
> > +	struct pid_namespace *ns;
> > +
> > +	if (is_child_reaper(pid)) {
> > +		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
> 
> GFP_KERNEL under rcu_read_lock(). This is not safe without
> CONFIG_PREEMPT_RCU.

It should be GFP_ATOMIC, Matesuz have already pointed out
and I'v changed it in v3.
Sorry for that mistake.

> 
> > +		if (!ent)
> > +			return -ENOMEM;
> > +
> > +		ent->pid = pid;
> > +		ns = pid->numbers[pid->level].ns;
> > +		if (curr_ns) {
> > +			/* add pids who is the child of curr_ns */
> > +			for (; ns != NULL; ns = ns->parent)
> > +				if (ns == curr_ns)
> > +					list_add_tail(&ent->list, list_head);
> 
> afaics, it doesn't make sense to continue after list_add() ?

Oops, we need a break here.

> 
> > +static int proc_pidns_list_refresh(struct pid_namespace *curr_ns)
> > +{
> > +	struct pid *pid;
> > +	struct task_struct *p;
> > +	int rc;
> > +
> > +	/* collect pid in differet ns */
> > +	for_each_process(p) {
> 
> Hmm. We only want the tasks from our namespace, yes? Perhaps find_ge_pid()
> makes more sense?

Only tasks from our ns is valid.
But how could find_ge_pid() do that?

nr = 1;
while (nr < PID_MAX_LIMIT) {
	find_ge_pid(nr, curr_ns);
	list_add();
	nr++;
}
Perhaps that's not a good way.

> 
> > +		pid = task_pid(p);
> 
> Well, in theory you need barrier() here. Or perhaps we should add
> ACCESS_ONCE() into task_pid()...

You mean modify task_pid as:
return ACCESS_ONCE(task->pids[PIDTYPE_PID].pid;);

> 
> And imho it would be better to declare pidns_list/pidns_tree locally
> in nslist_proc_show() and pass them to the callees.

That's a good idea.
Will changed in the next version.

Thanks,
- Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
