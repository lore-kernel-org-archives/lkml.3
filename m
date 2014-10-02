Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaJBTsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:48:38 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46663 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJBTsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <877g0il0gd.fsf@x220.int.ebiederm.org>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
 <87ppei45ig.fsf@x220.int.ebiederm.org> <CALCETrX5e0cp4QFCv1eAqR1hjoROU9Rh=cRos9U35DaR-py3Eg@mail.gmail.com>
 <87y4t61a6v.fsf@x220.int.ebiederm.org> <54294B4E.70501@6wind.com>
 <87y4t2gtd0.fsf@x220.int.ebiederm.org> <542D5726.8070308@6wind.com>
 <8761g2nurx.fsf@x220.int.ebiederm.org> <CALCETrWxqzUF1x+TmW5G4kuHPP+sUtiRaT6dpZ0mQTJ217QB5w@mail.gmail.com>
 <877g0il0gd.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 2 Oct 2014 12:48:14 -0700
Message-ID: <CALCETrWLhfQpT+f=DPTsB4w5Oy+OeiygBrQosf25HDJQaOnPWg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <cwang@twopensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 12:45 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Thu, Oct 2, 2014 at 12:20 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>
>>>> Le 29/09/2014 20:43, Eric W. Biederman a écrit :
>>>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>>>
>>>>>> Le 26/09/2014 20:57, Eric W. Biederman a écrit :
>>>>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>>>>
>>>>>>>> On Fri, Sep 26, 2014 at 11:10 AM, Eric W. Biederman
>>>>>>>> <ebiederm@xmission.com> wrote:
>>>>>>>>> I see two ways to go with this.
>>>>>>>>>
>>>>>>>>> - A per network namespace table to that you can store ids for ``peer''
>>>>>>>>>     network namespaces.  The table would need to be populated manually by
>>>>>>>>>     the likes of ip netns add.
>>>>>>>>>
>>>>>>>>>     That flips the order of assignment and makes this idea solid.
>>>>>> I have a preference for this solution, because it allows to have a full
>>>>>> broadcast messages. When you have a lot of network interfaces (> 10k),
>>>>>> it saves a lot of time to avoid another request to get all informations.
>>>>>
>>>>> My practical question is how often does it happen that we care?
>>>> In fact, I don't think that scenarii with a lot of netns have a full mesh of
>>>> x-netns interfaces. It will be more one "link" netns with the physical
>>>> interface and all other with one interface with the link part in this "link"
>>>> netns. Hence, only one nsid is needing in each netns.
>>>
>>> I will buy that a full mesh is unlikely.
>>>
>>> For people doing simulations anything physical has a limited number of
>>> links.
>>>
>>> For people wanting all to all connectivity setting up an internal
>>> macvlan (or the equivalent) is likely much simpler and more efficient
>>> that a full mesh.
>>>
>>> So the question in my mind is how do we create these identifiers at need
>>> (when we create the cross network namespace links) instead of at network
>>> namespace creation time.  I don't see an answer to that in your patches,
>>> and perhaps it obvious.
>>>
>>
>> I wonder whether part of the problem is that we're thinking about
>> scoping wrong.  What if we made the hierarchy more explicit?
>>
>> For example, we could give each netns an admin-assigned identifier
>> (e.g. a 64-bit number, maybe required to be unique, maybe not)
>> relative to its containing userns.  Then we could come up with a way
>> to identify user namespaces (i.e. inode number relative to containing
>> user ns, if that's well-defined).
>
> If as suggested we only assign ids when a tunnel (or equivalent) is
> created between two network namespaces the space cost is a non-issue.
> The ids become at worst a constant factor addition to the cost of the
> tunnel.
>
> To keep things simple we may want to assign a free id (if one does not
> exist) when we connect a tunnel to a network namespace.
>
>> From user code's perspective, netnses that are in the requester's
>> userns or its descendents are identified by a path through a (possibly
>> zero-length) sequence of userns ids followed by a netns id.  Netnses
>> outside the requester's userns hierarchy cannot be named at all.
>>
>> Would this make sense?
>
> Nope.  What happens if I migrate 2 of the 4 network namespaces in a user
> namespace?  The migration potentially fails.  Application migration does
> not require user namespace migration.

Hmm.  I guess that, as long as those network namespaces aren't
connected to anything else, migrating like that makes sense and ought
to work.  Fair enough.

--Andy
