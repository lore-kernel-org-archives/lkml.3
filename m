Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3DQB3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:29:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41097 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab3DQB3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:29:42 -0400
Message-ID: <516DFAFC.1030101@huawei.com>
Date: Wed, 17 Apr 2013 09:29:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <bsingharora@gmail.com>, <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, <jpoimboe@redhat.com>,
        <berrange@redhat.com>, <lpoetter@redhat.com>,
        <workman-devel@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
References: <20130406012159.GA17159@mtj.dyndns.org> <516D333D.4040703@huawei.com> <20130416171056.GA2874@mtj.dyndns.org>
In-Reply-To: <20130416171056.GA2874@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/17 1:10, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Apr 16, 2013 at 07:17:17PM +0800, Li Zefan wrote:
> ...
>>> hot-unplug).  It currently transfers all its tasks to the nearest
>>> ancestor with executing resources, which is an irreversible process
>>> which would affect all other co-mounted controllers.  We probably want
>>> it to just take on the masks of the ancestor until its own executing
>>> resources become online again, and the new behavior should be gated
>>> behind a switch (Li, can you please look into this?).
>>>
>>
>> Sure, I'll be working on sane hierarchy behavior for cpuset.
> 
> Great, it'd be great if you can share how it's gonna be done once the
> basic design gets settled before full implementation.
> 

The basic idea is, when a cpuset becomes empty due to hotplug, we don't
move the tasks in it, but instead we update tasks' cpumask/nodemask using
the nearest non-empty acestor cpuset's cpus_allowed and mems_allowed.

- then it's allowed to move those tasks from the empty cpuset to another
cpuset

- when this acestor cpuset's cpumask/nodemask is changed (either by writing
cpuset.cpus/mems or hotplug), not only the tasks in it but also tasks in
the empty cpuset will be updated.

- it's allowed to move a task to an empty cpuset, and the task's cpumask/nodemask
will be updated according to the nearst non-empty acestor, no matter if this
empty cpuset is exclusive or not.

- if a previously offlined cpu becomes online again, the emtpy cpuset won't
get this cpu resource automatically, which is the current behavior.

How does this sound?

