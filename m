Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaKFIOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:14:06 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaKFIOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:14:01 -0500
Message-ID: <545B2DC4.1090005@nod.at>
Date: Thu, 06 Nov 2014 09:13:56 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com> <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com> <545A13DA.3090207@nod.at> <20141105124111.GA19563@mail.hallyn.com> <545A1D53.3070507@nod.at> <5871495633F38949900D2BF2DC04883E61F2B2@G08CNEXMBPEKD02.g08.fujitsu.local>
In-Reply-To: <5871495633F38949900D2BF2DC04883E61F2B2@G08CNEXMBPEKD02.g08.fujitsu.local>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2014 um 06:48 schrieb Chen, Hanxiao:
> 
> 
>> -----Original Message-----
>> From: Richard Weinberger [mailto:richard@nod.at]
>> Sent: Wednesday, November 05, 2014 8:52 PM
>> To: Serge E. Hallyn
>> Cc: Chen, Hanxiao/³Â êÏÏö; Eric W. Biederman; Serge Hallyn; Oleg Nesterov;
>> containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Mateusz
>> Guzik; David Howells
>> Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
>>
>> Am 05.11.2014 um 13:41 schrieb Serge E. Hallyn:
>>> Quoting Richard Weinberger (richard@nod.at):
>>>> Am 05.11.2014 um 11:41 schrieb Chen Hanxiao:
>>>>> We lack of pid hierarchy information, and this will lead to:
>>>>> a) we don't know pids' relationship, who is whose child:
>>>>>    /proc/PID/ns/pid only tell us whether two pids live in different ns
>>>>> b) bring trouble to nested lxc container check/restore/migration
>>>>> c) bring trouble to pid translation between containers;
>>>>>
>>>>> This patch will show the hierarchy of pid namespace
>>>>> by pidns_hierarchy like:
>>>>>
>>>>> [root@localhost ~]#cat /proc/pidns_hierarchy
>>>>> 18060 18102 1534
>>>>> 18060 18102 1600
>>>>> 1550
>>>>
>>>> Hmm, what about printing the pid hierarchy in the same way as
>> /proc/self/mountinfo
>>>> does with mount namespaces?
>>>> Your current approach is not bad but we should really try to be consistent
>> with existing
>>>> sources of information.
>>>
>>> Good point.  How would you structure it to make it look mor elike mountinfo?
>>> Adding the pidns inode number (in place of a mount sequence number) might be
>>> useful, but it sounds like you have a more concrete idea?
>>
>> Just list <init_PID> <parent_of_init_PID>. This way we have exactly one
>> information record per line and always exactly two columns to parse.
>>
>> e.g.
>> [root@localhost ~]#cat /proc/pidns_hierarchy
>> 1550 1
>> 18060 1
>> 18102 18060
>> 1534 18102
>> 1600 18102
>>
> But this style lacks of *level* information:

It does not.

> Ex:
> 1->18060->18102->1600->1700
> If we want to check the 1700's level in pid ns
> Style 1:
> 18060 18102 1600 1700
> 
> Style 2:
> 18060 1
> 18102 18060
> 1600 18102
> 1700 1600
> 
> If we had a little more containers,
> Style 2 would not be clear enough.
> 1 line vs $(PID level) line

Any trivial program can find out the level of nesting.

> If there were no more related information to show,
> I think style 1 looks better.

It is not about looking better, it is about parsing and being consistent with existing
interfaces. /proc/pidns_hierarchy will be mostly read by *programs*, not humans.
/proc/ has already too many horrible to parse files, please don't add another one.
This is also why sysfs has the one-value-per-file rule.

If it makes you feel better you can add a third column to the output which indicates
the nesting level (or the distance to the initial pidns) . i.e.
Style 2:
18060 1 1
18102 18060 2
1600 18102 3
1700 1600 4

Thanks,
//richard
