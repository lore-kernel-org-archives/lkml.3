Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3G3CNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:13:06 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:10377 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3G3CNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:13:04 -0400
Message-ID: <51F720E4.2080505@huawei.com>
Date: Tue, 30 Jul 2013 10:11:48 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <akpm@linux-foundation.org>,
        <gaofeng@cn.fujitsu.com>, <libo.chen@huawei.com>
Subject: Re: [PATCH 0/9] Add namespace support for syslog v2
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <87wqo9urao.fsf@xmission.com>
In-Reply-To: <87wqo9urao.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric,

Thanks for your attention.


On 2013/7/30 2:58, Eric W. Biederman wrote:
> Rui Xiang <rui.xiang@huawei.com> writes:
> 
>> This patchset introduces a system log namespace.
> 
> The largest outstanding question is not answered.  Can't we just fix
> iptables to log somehwere better than dmesg, and would that not entirely
> remove the need for this work?
> 
I don't think there is any question. In this patchset, patch(1-8) implement
a mechanism for syslog_ns. And iptables is an actual scene to use ns. So we
can treat patch9 as a instance for syslog_ns.

Sorry for my negligence, I will add some detailed logs in next version.


Thanks.

> That question needs to be answered before we proceed down this path.
> 
> Eric
> 
>> It is the 2nd version. The link of the 1st version is 
>> http://lwn.net/Articles/525728/. In that version, syslog_
>> namespace was added into nsproxy and created through a new
>> clone flag CLONE_SYSLOG when cloning a process. 
>>
>> There were some discussion in last November about the 1st 
>> version. This version used these important advice, and 
>> referred to Serge's patch(http://lwn.net/Articles/525629/).
>>
>> Unlike the 1st version, in this patchset, syslog namespace 
>> is tied to a user namespace. Add we must create a new user 
>> ns before create a new syslog ns, because that will make 
>> users have full capabilities in this new userns after 
>> cloning a new user ns. The syslog namespace can be created 
>> through a new command(11) to __NR_syslog syscall. That owe 
>> to a new syslog flag SYSLOG_ACTION_NEW_NS.
>>
>> In syslog_namespace, some necessary identifiers for handling 
>> syslog buf are containerized. When one container creates a
>> new syslog ns, individual buf will be allocated to store log
>> ownned this container. 
>>
>> A new interface ns_printk is added to print the logs which 
>> we want to see in the container. Through ns_printk, we can 
>> get more logs related to a specific net ns, for instance, 
>> iptables. Here we use it to report iptable logs per 
>> contianer.
>>
>> Then default printk targeted at the init_syslog_ns will 
>> continue to print out most kernel log to host.
>>
>> One task in a new syslog ns could affect only current 
>> container through "dmesg", "dmesg -c" and /dev/kmsg 
>> actions. The read/write interface such as /dev/kmsg, 
>> /pro/kmsg and syslog syscall continue to be useful for 
>> container users.
>>
>> This patchset is based on linus' linux tree.
>>
>> Rui Xiang (9):
>>   syslog_ns: add syslog_namespace and put/get_syslog_ns
>>   syslog_ns: add syslog_ns into user_namespace
>>   syslog_ns: add init syslog_ns for global syslog
>>   syslog_ns: make syslog handling per namespace
>>   syslog_ns: make permisiion check per user namespace
>>   syslog_ns: use init syslog_ns for console action
>>   syslog_ns: implement function for creating syslog ns
>>   syslog_ns: implement ns_printk for specific syslog_ns
>>   netfilter: use ns_printk in iptable context
>>
>>  fs/proc/kmsg.c                 |  17 +-
>>  include/linux/printk.h         |   5 +-
>>  include/linux/syslog.h         |  79 ++++-
>>  include/linux/user_namespace.h |   2 +
>>  include/net/netfilter/xt_log.h |   6 +-
>>  kernel/printk.c                | 642 ++++++++++++++++++++++++-----------------
>>  kernel/sysctl.c                |   3 +-
>>  kernel/user.c                  |   3 +
>>  kernel/user_namespace.c        |   4 +
>>  net/netfilter/xt_LOG.c         |   4 +-
>>  10 files changed, 493 insertions(+), 272 deletions(-)
> 
> .
> 


