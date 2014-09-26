Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaIZNkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:40:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36501 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaIZNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:40:29 -0400
Message-ID: <54256CCB.4000709@6wind.com>
Date: Fri, 26 Sep 2014 15:40:27 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Cong Wang <cwang@twopensource.com>
CC: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<5422F0F4.6000709@6wind.com>	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>	<5423D80B.9060500@6wind.com> <CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>
In-Reply-To: <CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/09/2014 04:09, Cong Wang a écrit :
> On Thu, Sep 25, 2014 at 1:53 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Le 24/09/2014 18:45, Cong Wang a écrit :
>>>
>>> On Wed, Sep 24, 2014 at 9:27 AM, Nicolas Dichtel
>>> <nicolas.dichtel@6wind.com> wrote:
>>>>
>>>> Now informations got with 'ip link' are wrong and incomplete:
>>>>     - the link dev is now tunl0 instead of eth0, because we only got an
>>>> ifindex
>>>>       from the kernel without any netns informations.
>>>
>>>
>>> This is not new, macvlan has the same problem. This is why I said
>>> it is mostly a display problem, maybe just mark the ifindex as -1 or
>>> something when it is not in this netns. At least I don't expect the inner
>>> netns know anything outside, and I don't think I am the only one using
>>> netns in this way.
>>
>> I understand your point but there is several use of netns. Netns can be used
>> also to instantiate virtual routers. In this case, administrators or daemons
>> need to be able to monitor and dump the configuration on all netns
>> (particularly beeing able to identify fully x-netns interfaces). We start to
>> discuss this in one of the two thread pointed in my cover letter and get the
>> conclusion that checking user ns is a good way to know if an id should be
>> disclosed or not for a peer netns.
>
> Then you are leaking information, this breaks isolation.
>
>> Can you describe your use case?
>
> Yes, too simple: isolation networking, different netns's don't see each other
> (including anything inside) and only communicate via veth.
If you are a privileged user and you are able to access a peer netns (move an
interface into this peer netns, move an interface from this peer netns to your
own netns), I don't see any reason to not beeing able to get information about
this peer netns (you are already a privileged user in both netns).
If you want to isolate this peer netns (I think you call it "inner netns"), you
have to create a new user ns for this netns, hence a privileged user into this
peer netns will not be able to act in your own netns. And with this scenario and
my patches, this privileged user will not be able to get an id. Isolation is
preserved.
How do you preserved it in your scenario?

>
>
>> If you only play with netns, you may want to monitor all activies in all
>> netns
>> (this is already possible) and beeing able to link information between netns
>> (this is what I'm trying to solve).
>
>
> No, I don't want to monitor anything. Even if I wanted, I would just start one
> daemon in each netns instead of one for all.
Ok you don't want, but some other people (not only me) want it! And having one
daemon per netns does not scale: there are scenarii with thousand netns which
are dynamically created and deleted.

>
> On the other hand, why not exchange the configuration via veth
> between different netns? There are many ways to do so with TCP HTTP etc.
> This doesn't have to be solved in kernel.
>
The standard way with linux to monitor network configuration is netlink.
