Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbaIZUpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:45:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48452 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaIZUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:45:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Ahern <lxhacker68@gmail.com>
Cc: nicolas.dichtel@6wind.com, Cong Wang <cwang@twopensource.com>,
        netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
	<5422F0F4.6000709@6wind.com>
	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>
	<5423D80B.9060500@6wind.com>
	<CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>
	<54256CCB.4000709@6wind.com> <5425BB3E.10700@gmail.com>
	<87mw9myy4n.fsf@x220.int.ebiederm.org> <5425C22F.7050301@gmail.com>
Date: Fri, 26 Sep 2014 13:45:25 -0700
In-Reply-To: <5425C22F.7050301@gmail.com> (David Ahern's message of "Fri, 26
	Sep 2014 13:44:47 -0600")
Message-ID: <87tx3uun4q.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ZqnkeraSn+XvzisRepnFUM/lpuruvNnk=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4956]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Ahern <lxhacker68@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <lxhacker68@gmail.com> writes:

> On 9/26/14, 1:34 PM, Eric W. Biederman wrote:
>> When I wrote the "ip netns" support I never expected that all
>> applications would want to run in a specific network namespace.  All
>> that is needed is one socket per network namespace.
>
> Sure that is another option. But for a process to create a socket or
> thread in a second namespace it has to run as root -- CAP_SYS_ADMIN is
> needed for setns (or perhaps there is another way to create the socket
> or thread in the namespace).

To do anything other than simply listen on a netlink socket you also
have to be root.  So this is most cases that I am aware of this is a
don't care.  Especially for routing daemons.

If it becomes a common pain in writing network namespace aware
applications that the you have to be root just to open your listening
socket then that probably would be sufficient justification for the
socketat system call that I have I prototyped and then never did
anything with because at the time it was insufficiently interesting.

> Second, it still does not address the scalability problem. For example
> a single daemon providing service across 2k namespaces means it needs
> 2k listen sockets. From there a system could have 20, 30 or 50
> services running. Certainly lighter than a process per namespace, but
> not even close to ideal when talking about something like VRFs.

Ah.  You are talking about a system with 2k namespaces and 20-50
services providing services in all 2k namespaces. Something completely
different than the case of quagga you mentioned earlier.

I expect quagga would need one netlink control socket and one socket
listening to netlink events, and a tcp connection or two to remote bgp
servers in each network namespace.  In that case I don't see anything
except a small constant difference in ways it can be handled.

For your new example of a crazy number of servers running on a box each
of which is had one listening socket in each network namespace maybe
they will be idle most of the time in most network namespaces and the
overhead will be significant.  Shrug those applications don't appear to
exist so I can't say what would make a good design.

If someone writes them and describes what is going on we can see if the
current set of interfaces is ideal or problematics.  If there are
signifcantly better interfaces that can be provided in a maintainable
way I imagine the patches would be easily accepted.

But again this has nothing do with the peer netns work.  So if you have
something practical to contribute please start a new thread.

Eric
