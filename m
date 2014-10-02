Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaJBNqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:46:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35436 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaJBNqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:46:18 -0400
Message-ID: <542D5726.8070308@6wind.com>
Date: Thu, 02 Oct 2014 15:46:14 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <cwang@twopensource.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<87ppei45ig.fsf@x220.int.ebiederm.org>	<CALCETrX5e0cp4QFCv1eAqR1hjoROU9Rh=cRos9U35DaR-py3Eg@mail.gmail.com>	<87y4t61a6v.fsf@x220.int.ebiederm.org> <54294B4E.70501@6wind.com> <87y4t2gtd0.fsf@x220.int.ebiederm.org>
In-Reply-To: <87y4t2gtd0.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/09/2014 20:43, Eric W. Biederman a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>
>> Le 26/09/2014 20:57, Eric W. Biederman a écrit :
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>
>>>> On Fri, Sep 26, 2014 at 11:10 AM, Eric W. Biederman
>>>> <ebiederm@xmission.com> wrote:
>>>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>>>
>>>>>> The goal of this serie is to be able to multicast netlink messages with an
>>>>>> attribute that identify a peer netns.
>>>>>> This is needed by the userland to interpret some informations contained in
>>>>>> netlink messages (like IFLA_LINK value, but also some other attributes in case
>>>>>> of x-netns netdevice (see also
>>>>>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>>>>>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>>>>
>>>>> I want say that the problem addressed by patch 3/5 of this series is a
>>>>> fundamentally valid problem.  We have network objects spanning network
>>>>> namespaces and it would be very nice to be able to talk about them in
>>>>> netlink, and file descriptors are too local and argubably too heavy
>>>>> weight for netlink quires and especially for netlink broadcast messages.
>>>>>
>>>>> Furthermore the concept of ineternal concept of peernet2id seems valid.
>>>>>
>>>>> However what you do not address is a way for CRIU (aka process
>>>>> migration) to be able to restore these ids after process migration.
>>>>> Going farther it looks like you are actively breaking process migration
>>>>> at this time, making this set of patches a no-go.
>> Ok, I will look more deeply into CRIU.
>>
>>>>>
>>>>> When adding a new form of namespace id CRIU patches are just about
>>>>> as necessary as iproute patches.
>> Noted.
>
>
>
>>>>> That does not describe what you have actually implemented in the
>>>>> patches.
>>>>>
>>>>> I see two ways to go with this.
>>>>>
>>>>> - A per network namespace table to that you can store ids for ``peer''
>>>>>     network namespaces.  The table would need to be populated manually by
>>>>>     the likes of ip netns add.
>>>>>
>>>>>     That flips the order of assignment and makes this idea solid.
>> I have a preference for this solution, because it allows to have a full
>> broadcast messages. When you have a lot of network interfaces (> 10k),
>> it saves a lot of time to avoid another request to get all informations.
>
> My practical question is how often does it happen that we care?
In fact, I don't think that scenarii with a lot of netns have a full mesh of
x-netns interfaces. It will be more one "link" netns with the physical
interface and all other with one interface with the link part in this "link"
netns. Hence, only one nsid is needing in each netns.

>
>>>>>     Unfortunately in the case of a fully referencing mesh of N network
>>>>>     namespaces such a mesh winds up taking O(N^2) space, which seems
>>>>>     undesirable.
>> Memory consumption vs performances ;-)
>> In fact, when you have a lot of netns, you already should have some memory
>> available (at least N lo interfaces + N interfaces (veth or a x-netns
>> interface)). I'm not convinced that this is really an obstacle.
>
> I would have to see how it all fits together. O(N^2) grows a lot faster
> that N.  So after a point it isn't in the same ballpark of memory
> consumption.
>
>>> broadcast message business, and only care about the remote namespace for
>>> unicast messages.  Putting the work in an infrequently used slow path
>>> instead of a comparitively common path gives us much more freedom in
>>> the implementation.
>> I think it's better to have a full netlink messages, instead a partial one.
>> There is already a lot of attributes added for each rtnl interface messages to
>> be sure to describe all parameters of these interfaces.
>> And if the user don't care about ids (user has not set any id with iproute2),
>> we can just add the same attribute with id 0 (let's say it's a reserved id) to
>> indicate that the link part of this interface is in another netns.
>
> I imagine an id like that is something we would want ip netns add to
> set, and probably set in all existing network namespaces as well.
>
>> The great benefit of your first proposal is that the ids are set by the
>> userspace and thus it allows a high flexibility.
>>
>> Would you accept a patch that implements this first solution?
>
> I would not fundamentally reject it.  I would really like to make
> certain we think through how it will be used and what the practical
> benefits are.  Depending on how it is used the data structure could
> be a killer or it could be a case where we see how to manage it and
> simply don't care.
I will send a v3, so we can talk about it.


Thank you,
Nicolas
