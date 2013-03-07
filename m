Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3CGRfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:35:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3CGRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:35:50 -0500
Message-ID: <5138D001.8000409@oracle.com>
Date: Thu, 07 Mar 2013 12:36:01 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: ebiederm@xmission.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com> <513860E8.4080807@huawei.com> <876213wmwt.fsf@xmission.com>
In-Reply-To: <876213wmwt.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 04:59 AM, ebiederm@xmission.com wrote:
> Li Zefan <lizefan@huawei.com> writes:
> 
>> Cc: sasha.levin@oracle.com
>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: container
>>
>> This is a second report... and the same address: 0xfffffffffffffff0 
> 
> Actually this is the third report I have seen with that address, and the
> others were on x86_64.
> 
> The obvious answer is that there is something subtlely wrong with:
> 
> commit b67bfe0d42cac56c512dd5da4b1b347a23f4b70a
> Author: Sasha Levin <sasha.levin@oracle.com>
> Date:   Wed Feb 27 17:06:00 2013 -0800
> 
>     hlist: drop the node parameter from iterators
> 
> 
> This is the only change the pid namespace that I am aware of in 3.9-rc1.
> 
> If you can reproduce this somewhat readily can you please revert the
> hlist change and see if this continues to happen.  Right now there are
> no other code changes that I can see.  And the address
> 0xfffffffffffffff0 is consistent with a bug in hlist_for_each_entry_rcu.

Looks like the hlist change is probably the issue, though it specifically
uses:

	#define hlist_entry_safe(ptr, type, member) \
        	(ptr) ? hlist_entry(ptr, type, member) : NULL

I'm still looking at the code in question and it's assembly, but I can't
figure out what's going wrong. I was also trying to see what's so special
about this loop in find_pid_ns as opposed to the rest of the kernel code
that uses hlist_for_each_entry_rcu() but couldn't find out why.

Is it somehow possible that if we rcu_dereference_raw() the same thing twice
inside the same rcu_read_lock() section we'll get different results? That's
really the only reason for this crash that comes to mind at the moment, very
unlikely - but that's all I have right now.

Is this bug reproducible easily on your setup? I've managed to reproduce it
exactly 3 times in the past month or so, twice when I reported it and only
once since then - at some point I thought that it was a freak compiler issue
that went away when the code changed but since you're reporting it again
I guess that it isn't the case.


Paul, any chance you can give hlist_for_each_entry_rcu() a second look please?
I know you've already acked it before, but is it possible I missed a subtle
detail with RCU that causes this?


Thanks,
Sasha
