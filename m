Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaIYIxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:53:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58345 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaIYIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:53:34 -0400
Message-ID: <5423D80B.9060500@6wind.com>
Date: Thu, 25 Sep 2014 10:53:31 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
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
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<5422F0F4.6000709@6wind.com> <CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>
In-Reply-To: <CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/09/2014 18:45, Cong Wang a écrit :
> On Wed, Sep 24, 2014 at 9:27 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Now informations got with 'ip link' are wrong and incomplete:
>>    - the link dev is now tunl0 instead of eth0, because we only got an
>> ifindex
>>      from the kernel without any netns informations.
>
> This is not new, macvlan has the same problem. This is why I said
> it is mostly a display problem, maybe just mark the ifindex as -1 or
> something when it is not in this netns. At least I don't expect the inner
> netns know anything outside, and I don't think I am the only one using
> netns in this way.
I understand your point but there is several use of netns. Netns can be used
also to instantiate virtual routers. In this case, administrators or daemons
need to be able to monitor and dump the configuration on all netns
(particularly beeing able to identify fully x-netns interfaces). We start to
discuss this in one of the two thread pointed in my cover letter and get the
conclusion that checking user ns is a good way to know if an id should be
disclosed or not for a peer netns.
Can you describe your use case?

>
>>    - the encapsulation addresses are not part of this netns but the user
>> doesn't
>>      known that (still because netns info is missing). These IPv4 addresses
>> may
>>      exist into this netns.
>
> I don't remember your x-netns code, but we have two choices:
>
> 1) Lookup the route of the netns which it is in
>
> If the address is not available in this netns, it will fail, this is expected
> since tunnel device is not a pure L2 device. Or maybe just fail
> early when we move it.
>
> 2) Lookup the route of the netns where it was created
>
> Transparent for upper layer, but as you said, the outer address is not
> available in this netns therefore hard to display. Just hiding this information
> doesn't seem wrong to me.
Your assumption here is that all dameons were started before the tunnel was
created. But this is not true, a daemon may be started later. Another case is
when a daemon crash: we need to be able to restart it and it should be able to
recover all needed information.

>
>
>>    - it's not possible to create the same netdevice with these infos.
>>
>
> This is expected, because after all you are already in a different netns.
>
A different netns only means a different network stack, not a different user ns
or mount ns or PID ns, ...
If you only play with netns, you may want to monitor all activies in all netns
(this is already possible) and beeing able to link information between netns
(this is what I'm trying to solve).
