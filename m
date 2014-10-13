Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaJMKNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:13:51 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbaJMKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:13:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,709,1406563200"; 
   d="scan'208";a="37200017"
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
Thread-Index: AQHP5Ak2YqxcNV1GVkakC4FH3JNNB5wtsu1A
Date: Mon, 13 Oct 2014 10:13:50 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5E864C@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20141008151328.GB4835@redhat.com>
 <5871495633F38949900D2BF2DC04883E5E1649@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20141009213414.GA10705@redhat.com>
In-Reply-To: <20141009213414.GA10705@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9DADtIu018339



> -----Original Message-----
> From: Oleg Nesterov [mailto:oleg@redhat.com]
> Sent: Friday, October 10, 2014 5:34 AM
> To: Chen, Hanxiao/³Â êÏÏö
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Serge
> Hallyn; Eric W. Biederman; David Howells; Richard Weinberger; Pavel Emelyanov;
> Vasiliy Kulikov; Mateusz Guzik
> Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
> 
> On 10/09, Chen, Hanxiao wrote:
> >
> > > From: Oleg Nesterov [mailto:oleg@redhat.com]
> > >
> > > Hmm. We only want the tasks from our namespace, yes? Perhaps find_ge_pid()
> > > makes more sense?
> >
> > Only tasks from our ns is valid.
> > But how could find_ge_pid() do that?
> >
> > nr = 1;
> > while (nr < PID_MAX_LIMIT) {
> > 	find_ge_pid(nr, curr_ns);
> > 	list_add();
> > 	nr++;
> > }
> 
> something like this, except list_add() should obviously depend on
> is_child_reaper() check.
> 
> This can be more optimal in sub-namespaces, you do not need to abuse
> the global process list.
> 
> And if you change this code to use get_pid/put_pid, then you do not
> need to hold rcu_read_lock() throughout, you only need it around
> find_ge_pid + get_pid.
> 
> At the same time, for_each_process() in the global namespace can be
> faster if there are a lot of sub-threads.
> 
> > Perhaps that's not a good way.
> 
> OK, I won't insist.
> 
> although it would be nice to know why do you think this is bad.
> 
I worried about it may slower in global namespace.
But it will provide a great convenient way when query pid hierarchy
when not in init_pid_ns.


> > > > +		pid = task_pid(p);
> > >
> > > Well, in theory you need barrier() here. Or perhaps we should add
> > > ACCESS_ONCE() into task_pid()...
> >
> > You mean modify task_pid as:
> > return ACCESS_ONCE(task->pids[PIDTYPE_PID].pid;);
> 
> Yes. But not now an not in this patch of course. I'd suggest to add
> barrier() just in case.
> 
We can get rid of task_pid when we use find_ge_pid.
> 
> > > And imho it would be better to declare pidns_list/pidns_tree locally
> > > in nslist_proc_show() and pass them to the callees.
> >
> > That's a good idea.
> > Will changed in the next version.
> 
> Good. And I forgot to mention, in this case you do not need pidns_list_lock
> at all afaics.

Thanks for your comments.
I'll post a new patch using find_ge_pid + get_pid 

Thanks,
- Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
