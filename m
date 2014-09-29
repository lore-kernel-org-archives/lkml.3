Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaI2SoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:44:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50028 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaI2SoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:44:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: nicolas.dichtel@6wind.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <cwang@twopensource.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<87ppei45ig.fsf@x220.int.ebiederm.org>
	<CALCETrX5e0cp4QFCv1eAqR1hjoROU9Rh=cRos9U35DaR-py3Eg@mail.gmail.com>
	<87y4t61a6v.fsf@x220.int.ebiederm.org> <54294B4E.70501@6wind.com>
Date: Mon, 29 Sep 2014 11:43:39 -0700
In-Reply-To: <54294B4E.70501@6wind.com> (Nicolas Dichtel's message of "Mon, 29
	Sep 2014 14:06:38 +0200")
Message-ID: <87y4t2gtd0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+2XYLLFbm8FNaofvaq41ftqjZrLr6cYTE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XMNoSubject No subject header
	*  1.8 MISSING_SUBJECT Missing Subject: header
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;nicolas.dichtel@6wind.com
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> Le 26/09/2014 20:57, Eric W. Biederman a écrit :
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Fri, Sep 26, 2014 at 11:10 AM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>>
>>>>> The goal of this serie is to be able to multicast netlink messages with an
>>>>> attribute that identify a peer netns.
>>>>> This is needed by the userland to interpret some informations contained in
>>>>> netlink messages (like IFLA_LINK value, but also some other attributes in case
>>>>> of x-netns netdevice (see also
>>>>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>>>>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>>>
>>>> I want say that the problem addressed by patch 3/5 of this series is a
>>>> fundamentally valid problem.  We have network objects spanning network
>>>> namespaces and it would be very nice to be able to talk about them in
>>>> netlink, and file descriptors are too local and argubably too heavy
>>>> weight for netlink quires and especially for netlink broadcast messages.
>>>>
>>>> Furthermore the concept of ineternal concept of peernet2id seems valid.
>>>>
>>>> However what you do not address is a way for CRIU (aka process
>>>> migration) to be able to restore these ids after process migration.
>>>> Going farther it looks like you are actively breaking process migration
>>>> at this time, making this set of patches a no-go.
> Ok, I will look more deeply into CRIU.
>
>>>>
>>>> When adding a new form of namespace id CRIU patches are just about
>>>> as necessary as iproute patches.
> Noted.



>>>> That does not describe what you have actually implemented in the
>>>> patches.
>>>>
>>>> I see two ways to go with this.
>>>>
>>>> - A per network namespace table to that you can store ids for ``peer''
>>>>    network namespaces.  The table would need to be populated manually by
>>>>    the likes of ip netns add.
>>>>
>>>>    That flips the order of assignment and makes this idea solid.
> I have a preference for this solution, because it allows to have a full
> broadcast messages. When you have a lot of network interfaces (> 10k),
> it saves a lot of time to avoid another request to get all informations.

My practical question is how often does it happen that we care?

>>>>    Unfortunately in the case of a fully referencing mesh of N network
>>>>    namespaces such a mesh winds up taking O(N^2) space, which seems
>>>>    undesirable.
> Memory consumption vs performances ;-)
> In fact, when you have a lot of netns, you already should have some memory
> available (at least N lo interfaces + N interfaces (veth or a x-netns
> interface)). I'm not convinced that this is really an obstacle.

I would have to see how it all fits together. O(N^2) grows a lot faster
that N.  So after a point it isn't in the same ballpark of memory
consumption.

>> broadcast message business, and only care about the remote namespace for
>> unicast messages.  Putting the work in an infrequently used slow path
>> instead of a comparitively common path gives us much more freedom in
>> the implementation.
> I think it's better to have a full netlink messages, instead a partial one.
> There is already a lot of attributes added for each rtnl interface messages to
> be sure to describe all parameters of these interfaces.
> And if the user don't care about ids (user has not set any id with iproute2),
> we can just add the same attribute with id 0 (let's say it's a reserved id) to
> indicate that the link part of this interface is in another netns.

I imagine an id like that is something we would want ip netns add to
set, and probably set in all existing network namespaces as well.

> The great benefit of your first proposal is that the ids are set by the
> userspace and thus it allows a high flexibility.
>
> Would you accept a patch that implements this first solution?

I would not fundamentally reject it.  I would really like to make
certain we think through how it will be used and what the practical
benefits are.  Depending on how it is used the data structure could
be a killer or it could be a case where we see how to manage it and
simply don't care.

Eric

