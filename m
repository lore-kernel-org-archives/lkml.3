Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3CGRui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:50:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab3CGRuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:50:37 -0500
Message-ID: <5138D377.6040406@oracle.com>
Date: Thu, 07 Mar 2013 12:50:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: ebiederm@xmission.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>  <513860E8.4080807@huawei.com> <876213wmwt.fsf@xmission.com>  <5138D001.8000409@oracle.com> <1362678371.15793.218.camel@edumazet-glaptop>
In-Reply-To: <1362678371.15793.218.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 12:46 PM, Eric Dumazet wrote:
> On Thu, 2013-03-07 at 12:36 -0500, Sasha Levin wrote:
> 
>> Looks like the hlist change is probably the issue, though it specifically
>> uses:
>>
>> 	#define hlist_entry_safe(ptr, type, member) \
>>         	(ptr) ? hlist_entry(ptr, type, member) : NULL
>>
>> I'm still looking at the code in question and it's assembly, but I can't
>> figure out what's going wrong. I was also trying to see what's so special
>> about this loop in find_pid_ns as opposed to the rest of the kernel code
>> that uses hlist_for_each_entry_rcu() but couldn't find out why.
>>
>> Is it somehow possible that if we rcu_dereference_raw() the same thing twice
>> inside the same rcu_read_lock() section we'll get different results? That's
>> really the only reason for this crash that comes to mind at the moment, very
>> unlikely - but that's all I have right now.
>>
> 
> Yep
> 
> #define hlist_entry_safe(ptr, type, member) \
> 	(ptr) ? hlist_entry(ptr, type, member) : NULL
> 
> Is not safe, as ptr can be evaluated twice, and thats not good at all...

ptr is being evaluated twice, but in this case this is an
rcu_dereference_raw() value within the same rcu_read_lock() section.

Is it still problematic?


Thanks,
Sasha

