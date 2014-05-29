Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaE2Jlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:41:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:46383 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaE2Jlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:41:50 -0400
Message-ID: <538700B5.5070601@parallels.com>
Date: Thu, 29 May 2014 13:41:09 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Vasily Kulikov <segoon@openwall.com>,
        <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com> <5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot> <53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot> <5386F8EA.8050501@parallels.com> <5386FC0C.9000307@nod.at>
In-Reply-To: <5386FC0C.9000307@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.36.87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 01:21 PM, Richard Weinberger wrote:
> Am 29.05.2014 11:07, schrieb Pavel Emelyanov:
>> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
>>> On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
>>>> On 05/28/2014 10:28 PM, Vasily Kulikov wrote:
>>>>> On Wed, May 28, 2014 at 16:44 +0400, Pavel Emelyanov wrote:
>>>>> It will be simplier
>>>>> to parse the file -- if 'ns_ids' file contains some ID then this ID for
>>>>> every ns can be obtained regardless of the specific ID name (SID, PID,
>>>>> PGID, etc.).
>>>>
>>>> True, but given a task PID how to determine which pid namespaces it lives in
>>>> to get the idea of how PIDs map to each other? Maybe we need some explicit
>>>> API for converting (ID, NS1, NS2) into (ID)?
>>>
>>> AFAIU the idea of the patch is to add a new debugging information which
>>> can be trivially obtained via 'cat /proc/...':
>>
>> I agree, but this ability will be very useful by checkpoint-restore project
>> too and I'd really appreciate if the API we have for that would be scalable
>> enough. Per-task proc file works for me, but how about sid-s and pgid-s?
> 
> What kind of information does CRIU need?

We need to know what pid namespaces a task lives in and how pid, sid and
pgid look in all of them. A short example with pids only

Task t1 with pid 2, lives in init pid ns calls clone(CLONE_NEWPID), creates
ns1 with task t2 having pid (3, 1), then t2 calls clone(CLONE_NEWPID) again
and creates ns2 with task t3 having pid (4, 5, 1). I.e. the trees look like 
this:

    init_pid_ns    ns1         ns2
t1  2
t2   `- 3          1 
t3       `- 4      `- 5        1

Also note, that /proc/pid/ns will show us that t1 lives in init_pid_ns,
t2 lives in ns1 and t3 lives in ns2.

Now if we come from init pid ns with criu and try to dump task with pid 3
(i.e. the t2), the existing kernel API can tell us that:

a) t2 lives in ns1 != init_pid_ns (via /proc/pid/ns link)
b) t3 lives in ns2 != init_pid_ns
c) t2 has pid 3 (via init's /proc) in init ns and pid 1 in its ns (via t2's /proc)
d) t3 has pid 4 in init ns and pid 1 in its ns

what we also need to know and don't yet have an API for is

e) ns2 is the child of ns1
f) t3 has pid 5 in ns1

Thanks,
Pavel
