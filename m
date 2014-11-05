Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaKEMvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:51:38 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaKEMvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:51:35 -0500
Message-ID: <545A1D53.3070507@nod.at>
Date: Wed, 05 Nov 2014 13:51:31 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Mateusz Guzik <mguzik@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/2v6] procfs: show hierarchy of pid namespace
References: <1415184115-12022-1-git-send-email-chenhanxiao@cn.fujitsu.com> <1415184115-12022-2-git-send-email-chenhanxiao@cn.fujitsu.com> <545A13DA.3090207@nod.at> <20141105124111.GA19563@mail.hallyn.com>
In-Reply-To: <20141105124111.GA19563@mail.hallyn.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 13:41 schrieb Serge E. Hallyn:
> Quoting Richard Weinberger (richard@nod.at):
>> Am 05.11.2014 um 11:41 schrieb Chen Hanxiao:
>>> We lack of pid hierarchy information, and this will lead to:
>>> a) we don't know pids' relationship, who is whose child:
>>>    /proc/PID/ns/pid only tell us whether two pids live in different ns
>>> b) bring trouble to nested lxc container check/restore/migration
>>> c) bring trouble to pid translation between containers;
>>>
>>> This patch will show the hierarchy of pid namespace
>>> by pidns_hierarchy like:
>>>
>>> [root@localhost ~]#cat /proc/pidns_hierarchy
>>> 18060 18102 1534
>>> 18060 18102 1600
>>> 1550
>>
>> Hmm, what about printing the pid hierarchy in the same way as /proc/self/mountinfo
>> does with mount namespaces?
>> Your current approach is not bad but we should really try to be consistent with existing
>> sources of information.
> 
> Good point.  How would you structure it to make it look mor elike mountinfo?
> Adding the pidns inode number (in place of a mount sequence number) might be
> useful, but it sounds like you have a more concrete idea?

Just list <init_PID> <parent_of_init_PID>. This way we have exactly one
information record per line and always exactly two columns to parse.

e.g.
[root@localhost ~]#cat /proc/pidns_hierarchy
1550 1
18060 1
18102 18060
1534 18102
1600 18102

>> This function allocates memory per PID. If we have lots of PIDs, how does this scale?
>> I'd go so far and say this can be a DoS'able issue if the pidns_hierarchy file is opened multiple times...
> 
> It's not per pid, but per init-pid.  For non-reaper pids he bails and continue
> through the loop a few lines above.  This still may be DOS-able if users don't
> have kmem restrictions to prevent a ton of pid namespaces, but then the
> namespaces themselves will take a lot more memory than the representation here.

Ah, I've overlooked that fact. If it is per init-pid it is not that bad. :-)

Thanks,
//richard
