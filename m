Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbaJaTPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:15:44 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58695 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaJaTPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:15:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
References: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
	<1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com>
	<871tpph03k.fsf@x220.int.ebiederm.org> <54535B00.5090708@6wind.com>
Date: Fri, 31 Oct 2014 12:14:40 -0700
In-Reply-To: <54535B00.5090708@6wind.com> (Nicolas Dichtel's message of "Fri,
	31 Oct 2014 10:48:48 +0100")
Message-ID: <87wq7g831b.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/onRlczmdwth9JJyHCm7WayX/l12kTQSM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;nicolas.dichtel@6wind.com
X-Spam-Relay-Country: 
X-Spam-Timing: total 412 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 4.8 (1.2%), b_tie_ro: 2.2 (0.5%), parse: 0.73 (0.2%),
	extract_message_metadata: 15 (3.6%), get_uri_detail_list: 2.3 (0.6%),
	tests_pri_-1000: 6 (1.4%), tests_pri_-950: 1.32 (0.3%), tests_pri_-900: 1.08
	(0.3%), tests_pri_-400: 26 (6.2%), check_bayes: 24 (5.9%), b_tokenize: 6
	(1.6%), b_tok_get_all: 8 (1.9%), b_comp_prob: 2.3 (0.6%), b_tok_touch_all:
	2.6 (0.6%), b_finish: 2.3 (0.6%), tests_pri_0: 328 (79.6%), tests_pri_500: 27
	(6.5%), poll_dns_idle: 20 (4.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH net-next v4 0/4] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> Le 30/10/2014 19:41, Eric W. Biederman a écrit :
>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>
>>> The goal of this serie is to be able to multicast netlink messages with an
>>> attribute that identify a peer netns.
>>> This is needed by the userland to interpret some informations contained in
>>> netlink messages (like IFLA_LINK value, but also some other attributes in case
>>> of x-netns netdevice (see also
>>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>>
>>> Ids of peer netns are set by userland via a new genl messages. These ids are
>>> stored per netns and are local (ie only valid in the netns where they are set).
>>> To avoid allocating an int for each peer netns, I use idr_for_each() to retrieve
>>> the id of a peer netns. Note that it will be possible to add a table (struct net
>>> -> id) later to optimize this lookup if needed.
>>>
>>> Patch 1/4 introduces the netlink API mechanism to set and get these ids.
>>> Patch 2/4 and 3/4 implements an example of how to use these ids in rtnetlink
>>> messages. And patch 4/4 shows that the netlink messages can be symetric between
>>> a GET and a SET.
>>>
>>> iproute2 patches are available, I can send them on demand.
>>
>> A quick reply.  I think this patchset is in the right general direction.
>> There are some oddball details that seem odd/awkward to me such as using
>> genetlink instead of rtnetlink to get and set the ids, and not having
>> ids if they are not set (that feels like a maintenance/usability challenge).
> No problem to use rtnetlink, in fact, I hesitated.
>
> For the second point, I'm not sure to follow you: how to have an id, which will
> not break migration, without asking the user to set it?

We have that situtation with ifindex already.  Basically the thought is
to allow an id to be set, but also allow an id to be auto-generated if
we use an namespace without an id being set.

My gut says if we can figure that out we will have an interface with
much more utility.

> Note that if the user does not provide an id, you still have a magic value to
> say "it's a peer netns but we don't know which one".

That is certainly an improvement in clarity over where we are today.

>> I would like to give your patches a deep review, but I won't be able to
>> do that for a couple of weeks.  I am deep in the process of moving,
>> and will be mostly offline until about the Nov 11th.
>
> No problem, I will wait.
> I would be great to get a final version for the 3.19 ;-)

Eric
