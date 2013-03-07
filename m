Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab3CGSFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:05:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60862 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3CGSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:05:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>
	<513860E8.4080807@huawei.com> <876213wmwt.fsf@xmission.com>
	<5138D001.8000409@oracle.com>
	<1362678371.15793.218.camel@edumazet-glaptop>
	<5138D377.6040406@oracle.com>
Date: Thu, 07 Mar 2013 10:05:34 -0800
In-Reply-To: <5138D377.6040406@oracle.com> (Sasha Levin's message of "Thu, 07
	Mar 2013 12:50:47 -0500")
Message-ID: <87boavrspd.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ma9GBqZu/W9wnNgURNowNN49HUUQjAys=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sasha.levin@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> On 03/07/2013 12:46 PM, Eric Dumazet wrote:
>> On Thu, 2013-03-07 at 12:36 -0500, Sasha Levin wrote:
>> 
>>> Looks like the hlist change is probably the issue, though it specifically
>>> uses:
>>>
>>> 	#define hlist_entry_safe(ptr, type, member) \
>>>         	(ptr) ? hlist_entry(ptr, type, member) : NULL
>>>
>>> I'm still looking at the code in question and it's assembly, but I can't
>>> figure out what's going wrong. I was also trying to see what's so special
>>> about this loop in find_pid_ns as opposed to the rest of the kernel code
>>> that uses hlist_for_each_entry_rcu() but couldn't find out why.
>>>
>>> Is it somehow possible that if we rcu_dereference_raw() the same thing twice
>>> inside the same rcu_read_lock() section we'll get different results? That's
>>> really the only reason for this crash that comes to mind at the moment, very
>>> unlikely - but that's all I have right now.
>>>
>> 
>> Yep
>> 
>> #define hlist_entry_safe(ptr, type, member) \
>> 	(ptr) ? hlist_entry(ptr, type, member) : NULL
>> 
>> Is not safe, as ptr can be evaluated twice, and thats not good at all...
>
> ptr is being evaluated twice, but in this case this is an
> rcu_dereference_raw() value within the same rcu_read_lock() section.
>
> Is it still problematic?

Definitely.

Head in this instance the expression: &pid_hash[pid_hashfn(nr, ns)]

And the crash clearly shows that when hilst_entry is being evaluated the
HEAD is NULL.

Perhaps this shows up in proc because the hash chains are short and
frequently NULL?

Eric
