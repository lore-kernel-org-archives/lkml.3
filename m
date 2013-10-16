Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014Ab3JPIsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:48:45 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37910 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933953Ab3JPIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:48:38 -0400
Message-ID: <525E52E2.5050109@6wind.com>
Date: Wed, 16 Oct 2013 10:48:34 +0200
From: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Guillaume Gaudonville <gaudonville@6wind.com>,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com
Subject: Re: [RFC PATCH linux-next] ns: do not allocate a new nsproxy at each
 call
References: <1381858522-21341-1-git-send-email-guillaume.gaudonville@6wind.com> <87y55u1ip2.fsf@xmission.com>
In-Reply-To: <87y55u1ip2.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:40 PM, Eric W. Biederman wrote:
> "Guillaume Gaudonville" <gaudonville@6wind.com> writes:
>
>> Currently, at each call of setns system call a new nsproxy is allocated,
>> the old nsproxy namespaces are copied into the new one and the old nsproxy
>> is freed if the task was the only one to use it.
>>
>> It can creates large delays on hardware with large number of cpus since
>> to free a nsproxy a synchronize_rcu() call is done.
>>
>> When a task is the only one to use a nsproxy, only the task can do an action
>> that will make this nsproxy to be shared by another task or thread (fork,...).
>> So when the refcount of the nsproxy is equal to 1, we can simply update the
>> current nsproxy field without allocating a new one and freeing the old one.
>>
>> The install operations of each kind of namespace cannot fails, so there's no
>> need to check for an error and calling ops->install().
>>
>> Tested on TileGX (36 cores) and Intel (32 cores).
> This may be worth doing (I am a little scared of a design that has setns
> on a fast path) but right now this isn't safe.
>
> Currently pidns_install ends with:
>
> 	put_pid_ns(nsproxy->pid_ns_for_children);
> 	nsproxy->pid_ns_for_children = get_pid_ns(new);
> 	return 0;
>
>
> And netns_install ends with:
>
> 	put_net(nsproxy->net_ns);
> 	nsproxy->net_ns = get_net(net);
> 	return 0;
>
> The put before the set is not atomic and is not safe unless
> the nsproxy is private.  I think this is fixable but it requires a more
> indepth look at the code than you have done.
My expectation was that nobody else but the task itself could increase the
nsproxy refcount (ie. use it), if the refcount was equal to 1. So there
was no possible races while playing with nsproxy in that case.
Do you mean that someone else than the task itself could play with the 
nsproxy,
even if its refcount is equal to 1?

>
> Mind if I ask where this comes up?
The issue has been seen on a daemon that is performing monitoring and
configuration tasks in different netns.
>
>
>> Reported-by: Chris Metcalf <cmetcalf@tilera.com>
>> Signed-off-by: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
>> ---
>>   kernel/nsproxy.c |   12 ++++++++++++
>>   1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
>> index afc0456..afc04ac 100644
>> --- a/kernel/nsproxy.c
>> +++ b/kernel/nsproxy.c
>> @@ -255,6 +255,18 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
>>   	if (nstype && (ops->type != nstype))
>>   		goto out;
>>   
>> +	/*
>> +	 * If count == 1, only the current task can increment it,
>> +	 * by doing a fork for example so we can safely update the
>> +	 * current nsproxy pointers without allocate a new one,
>> +	 * update it and destroy the old one
>> +	 */
>> +	if (atomic_read(&tsk->nsproxy->count) == 1) {
>> +		err = ops->install(tsk->nsproxy, ei->ns);
>> +		fput(file);
>> +		return err;
>> +	}
> As a minor nit, but to match the rest of the code in this function that
> should read:
>
>> +	if (atomic_read(&tsk->nsproxy->count) == 1) {
>> +		err = ops->install(tsk->nsproxy, ei->ns);
>> +		goto out;
>> +	}
> There is no need to add an additional exit point to reason about.
>
>> +
>>   	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
>>   	if (IS_ERR(new_nsproxy)) {
>>   		err = PTR_ERR(new_nsproxy);


-- 
Guillaume Gaudonville
6WIND
Software Engineer

Tel: +33 1 39 30 92 53
Mob: +33 6 47 85 34 33
Fax: +33 1 39 30 92 11
guillaume.gaudonville@6wind.com
www.6wind.com
Join the Multicore Packet Processing Forum: www.multicorepacketprocessing.com

Ce courriel ainsi que toutes les pièces jointes, est uniquement destiné à son ou ses destinataires. Il contient des informations confidentielles qui sont la propriété de 6WIND. Toute révélation, distribution ou copie des informations qu'il contient est strictement interdite. Si vous avez reçu ce message par erreur, veuillez immédiatement le signaler à l'émetteur et détruire toutes les données reçues

This e-mail message, including any attachments, is for the sole use of the intended recipient(s) and contains information that is confidential and proprietary to 6WIND. All unauthorized review, use, disclosure or distribution is prohibited. If you are not the intended recipient, please contact the sender by reply e-mail and destroy all copies of the original message.

