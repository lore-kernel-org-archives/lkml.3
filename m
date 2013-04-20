Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410Ab3DTBGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 21:06:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62597 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157Ab3DTBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 21:06:50 -0400
Message-ID: <5171EA24.3070001@huawei.com>
Date: Sat, 20 Apr 2013 09:06:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask
 in an empty cpuset
References: <517137A7.4020605@huawei.com> <51713819.8050708@huawei.com> <20130419183618.GC13811@mtj.dyndns.org>
In-Reply-To: <20130419183618.GC13811@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/20 2:36, Tejun Heo wrote:
> Hello, Li.
> 
> On Fri, Apr 19, 2013 at 08:27:05PM +0800, Li Zefan wrote:
>> I think this was introduced unintentionally when cpuset hotplug was
>> made asynchronous. Fortunately it does no harm, as updating tasks'
>> cpumask will just return failure and there's a guarantee_online_mems()
>> when updating nodemask, and then the tasks will be moved to an ancestor
>> cpuset.
> 
> Yeah, which will update the masks to the proper values anyway, so it
> was intentionally written that way as it didn't really matter either
> way.  I suppose this helps future changes?  Maybe update the
> description a bit?
> 

I was trying to fix a bug: before moving tasks out of empty cpusets,
update_tasks_nodemask() is called, which calls do_migrate_pages(xx, from, to)
finally, from == node_to_be_offlined, to == empty_nodeamsk, so I guess
no pages will be migrated.

Then when those tasks are moving to an ancestor, do_migrate_pages(xx, from, to)
is called again, from == empty_nodemask, to == ancestor's nodemask,
so I guess again no pages will be migrated.

This bug exists even before your changes.

