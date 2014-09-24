Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaIXQ1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:27:37 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48169 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaIXQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:27:35 -0400
Message-ID: <5422F0F4.6000709@6wind.com>
Date: Wed, 24 Sep 2014 18:27:32 +0200
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
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com> <CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
In-Reply-To: <CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/09/2014 18:01, Cong Wang a écrit :
> On Wed, Sep 24, 2014 at 2:23 AM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Le 23/09/2014 21:22, Cong Wang a écrit :
>>
>>> On Tue, Sep 23, 2014 at 6:20 AM, Nicolas Dichtel
>>> <nicolas.dichtel@6wind.com> wrote:
>>>>
>>>>
>>>> Here is a small screenshot to show how it can be used by userland:
>>>> $ ip netns add foo
>>>> $ ip netns del foo
>>>> $ ip netns
>>>> $ touch /var/run/netns/init_net
>>>> $ mount --bind /proc/1/ns/net /var/run/netns/init_net
>>>> $ ip netns add foo
>>>> $ ip netns
>>>> foo (id: 3)
>>>> init_net (id: 1)
>>>> $ ip netns exec foo ip netns
>>>> foo (id: 3)
>>>> init_net (id: 1)
>>>> $ ip netns exec foo ip link add ipip1 link-netnsid 1 type ipip remote
>>>> 10.16.0.121 local 10.16.0.249
>>>> $ ip netns exec foo ip l ls ipip1
>>>> 6: ipip1@NONE: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN mode
>>>> DEFAULT group default
>>>>       link/ipip 10.16.0.249 peer 10.16.0.121 link-netnsid 1
>>>>
>>>> The parameter link-netnsid shows us where the interface sends and
>>>> receives
>>>> packets (and thus we know where encapsulated addresses are set).
>>>>
>>>
>>> So ipip1 is shown in netns foo but functioning in netns init_net? Getting
>>> the
>>> id of init_net in foo depends on your mount namespace, /var/run/netns/ may
>>> not visible inside foo, in this case, link-netnsid is meaningless. It
>>> is not your
>>> fault, network namespace already heavily relies on mount namespace (sysfs
>>> needs to be remount otherwise you can not create device with the same
>>> name.)
>>>
>>> On the other hand, what's the problem you are trying to solve? AFAIK,
>>> the ifindex
>>> issue is purely in output, IOW, the device still functions correctly
>>> even through
>>> its link ifindex is not correct after moving to another namespace. If
>>> not, it is bug
>>> we need to fix.
>>>
>> The problem is explained here:
>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064
>> and here:
>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239
>>
>
> Please, summarize the discussion in your changelog, instead of pointing
> to a long thread.
The thread is long, but the mail in focus contains the information. Here is a 
copy and paste:
What I'm trying to solve is to have full info in netlink messages sent by the
kernel, thus beeing able to identify a peer netns (and this is close from what
audit guys are trying to have). Theorically, messages sent by the kernel can be
reused as is to have the same configuration. This is not the case with x-netns
devices. Here is an example, with ip tunnels:

$ ip netns add 1
$ ip link add ipip1 type ipip remote 10.16.0.121 local 10.16.0.249 dev eth0
$ ip -d link ls ipip1
8: ipip1 <at> eth0: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT
group default
      link/ipip 10.16.0.249 peer 10.16.0.121 promiscuity 0
      ipip remote 10.16.0.121 local 10.16.0.249 dev eth0 ttl inherit pmtudisc
$ ip link set ipip1 netns 1
$ ip netns exec 1 ip -d link ls ipip1
8: ipip1 <at> tunl0: <POINTOPOINT,NOARP,M-DOWN> mtu 1480 qdisc noop state DOWN mode
DEFAULT group default
      link/ipip 10.16.0.249 peer 10.16.0.121 promiscuity 0
      ipip remote 10.16.0.121 local 10.16.0.249 dev tunl0 ttl inherit pmtudisc

Now informations got with 'ip link' are wrong and incomplete:
   - the link dev is now tunl0 instead of eth0, because we only got an ifindex
     from the kernel without any netns informations.
   - the encapsulation addresses are not part of this netns but the user doesn't
     known that (still because netns info is missing). These IPv4 addresses may
     exist into this netns.
   - it's not possible to create the same netdevice with these infos.

Hope it's more clear now.

>
> And clearly you missed my question above: how do you get netns id
> without sharing /var/run/netns/ ?
>
You can get an id only if you already have a "pointer" to this netns.
