Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568Ab3JPTmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:42:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43737 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3JPTml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:42:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
Cc: Guillaume Gaudonville <gaudonville@6wind.com>,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com
References: <1381858522-21341-1-git-send-email-guillaume.gaudonville@6wind.com>
	<87y55u1ip2.fsf@xmission.com> <525E52E2.5050109@6wind.com>
Date: Wed, 16 Oct 2013 12:42:33 -0700
In-Reply-To: <525E52E2.5050109@6wind.com> (Guillaume Gaudonville's message of
	"Wed, 16 Oct 2013 10:48:34 +0200")
Message-ID: <8738o1ovdi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19U5mOEniaVX932PRNM9hg3L4Sx0uCabCc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1945]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH linux-next] ns: do not allocate a new nsproxy at each call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Gaudonville <guillaume.gaudonville@6wind.com> writes:

> On 10/15/2013 08:40 PM, Eric W. Biederman wrote:
>> "Guillaume Gaudonville" <gaudonville@6wind.com> writes:
>>
>>> Currently, at each call of setns system call a new nsproxy is allocated,
>>> the old nsproxy namespaces are copied into the new one and the old nsproxy
>>> is freed if the task was the only one to use it.
>>>
>>> It can creates large delays on hardware with large number of cpus since
>>> to free a nsproxy a synchronize_rcu() call is done.
>>>
>>> When a task is the only one to use a nsproxy, only the task can do an action
>>> that will make this nsproxy to be shared by another task or thread (fork,...).
>>> So when the refcount of the nsproxy is equal to 1, we can simply update the
>>> current nsproxy field without allocating a new one and freeing the old one.
>>>
>>> The install operations of each kind of namespace cannot fails, so there's no
>>> need to check for an error and calling ops->install().
>>>
>>> Tested on TileGX (36 cores) and Intel (32 cores).
>> This may be worth doing (I am a little scared of a design that has setns
>> on a fast path) but right now this isn't safe.
>>
>> Currently pidns_install ends with:
>>
>> 	put_pid_ns(nsproxy->pid_ns_for_children);
>> 	nsproxy->pid_ns_for_children = get_pid_ns(new);
>> 	return 0;
>>
>>
>> And netns_install ends with:
>>
>> 	put_net(nsproxy->net_ns);
>> 	nsproxy->net_ns = get_net(net);
>> 	return 0;
>>
>> The put before the set is not atomic and is not safe unless
>> the nsproxy is private.  I think this is fixable but it requires a more
>> indepth look at the code than you have done.

> My expectation was that nobody else but the task itself could increase the
> nsproxy refcount (ie. use it), if the refcount was equal to 1. So there
> was no possible races while playing with nsproxy in that case.
> Do you mean that someone else than the task itself could play with the
> nsproxy,
> even if its refcount is equal to 1?

It is not required to increase the nsproxy refcount to use nsproxy.  It
is possible to find a living task and look at it's nsproxy using just
rcu protection.  get_net_ns_by_pid is one example of a place where we do
that.

If the refcount was all that was protecting nsproxy the problematic
synchronize_rcu call would be unnecessary.

Look for task_nsproxy if you want to find other readers of the nsproxy
that don't increase the reference count.

>> Mind if I ask where this comes up?
> The issue has been seen on a daemon that is performing monitoring and
> configuration tasks in different netns.

Interesting...  In practice I would think that daemon by opening a few
choice netlink sockets would not need to change network namespaces at
all frequently, and you can also see the net information in /proc and
/sys without changing your default net.  So I am wondering about the
daemon.

That said if we can optimize things without getting ourselves into a
maintenance nightmare I am happy to see a patch optimizing things.

Eric
