Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3AWJYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:24:35 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:46233 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3AWJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:24:33 -0500
Message-ID: <50FFAC4F.6010602@monom.org>
Date: Wed, 23 Jan 2013 10:24:31 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: John Fastabend <john.fastabend@gmail.com>
CC: Li Zefan <lizefan@huawei.com>, John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [BUG] Bug in netprio_cgroup and netcls_cgroup ?
References: <50FCDB5C.4050608@huawei.com> <50FD0144.1000401@monom.org> <50FD0402.6060400@huawei.com> <50FD09FD.4010804@monom.org> <50FD1113.6010402@huawei.com> <50FD786E.4050108@gmail.com> <20130122100938.GA26820@candlejack.bmw-carit.intra> <50FF287C.70906@gmail.com>
In-Reply-To: <50FF287C.70906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2013 01:02, John Fastabend wrote:
> [...]
>
>>>
>>> OK, I guess we should do something similar in the netprio, netcls
>>> cgroups and
>>> yes document it as you noted in your last comment.
>>
>> Here is my attempt to add such a check. I really don't know if this is
>> the
>> correct way to do so. To test this I have written a test program, which
>> seems to test the right thing. Please have a look and let me know if
>> it is correct: http://www.monom.org/misc/scm_rights.c
>>
>> And here a dirty first version of the patch:
>>
>>
>>  From 49a78d907eaf31c16673025e7e3b4844e419e416 Mon Sep 17 00:00:00 2001
>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>> Date: Tue, 22 Jan 2013 11:08:22 +0100
>> Subject: [PATCH] net: net_prio: Block attach if a socket is shared
>>
>> ---
>>   net/core/netprio_cgroup.c | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
>> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
>> index 847c02b..de4e6c5 100644
>> --- a/net/core/netprio_cgroup.c
>> +++ b/net/core/netprio_cgroup.c
>> @@ -274,9 +274,39 @@ static struct cftype ss_files[] = {
>>       { }    /* terminate */
>>   };
>>
>> +static int check_cnt(const void *v, struct file *file, unsigned n)
>> +{
>> +    unsigned *flag = (unsigned *)v;
>> +    int err;
>> +
>> +    struct socket *sock = sock_from_file(file, &err);
>> +    if (sock && file_count(file) > 1)
>> +        *flag = 1;
>> +
>
> I think this check will catch a lot of cases that are not necessarily
> sharing a socket across tasks though. For example iscsid passes a file
> descriptor to the kernel which does a sockfd_lookup() incrementing
> f_count. Similarly look at dup/clone/etc.

Yep, I expected that this patch was too simple.

> In many of these cases I believe it should be OK to move the task
> around when the sockets are not shared between multiple tasks.

Do you know of a different way to identify the shared sockets?

thanks,
daniel

