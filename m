Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbaD3TLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:11:54 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54990 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3TLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:11:52 -0400
Message-ID: <53614AF4.7010107@gmail.com>
Date: Wed, 30 Apr 2014 15:11:48 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] bridge: preserve random init MAC address
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com> <1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com> <20140318201056.7b876394@nehalam.linuxnetplumber.net> <20140320020540.GF28801@wotan.suse.de> <CAB=NE6WKyQbh9Eih05szW6708fVTNPgTe62SU5tC2dQkqwJApg@mail.gmail.com>
In-Reply-To: <CAB=NE6WKyQbh9Eih05szW6708fVTNPgTe62SU5tC2dQkqwJApg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 03:41 PM, Luis R. Rodriguez wrote:
> On Wed, Mar 19, 2014 at 7:05 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> On Tue, Mar 18, 2014 at 08:10:56PM -0700, Stephen Hemminger wrote:
>>> On Wed, 12 Mar 2014 20:15:25 -0700
>>> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>>>
>>>> As it is now if you add create a bridge it gets started
>>>> with a random MAC address and if you then add a net_device
>>>> as a slave but later kick it out you end up with a zero
>>>> MAC address. Instead preserve the original random MAC
>>>> address and use it.
>>>
>>> What is supposed to happen is that the recalculate chooses
>>> the lowest MAC address of the slaves. If there are no slaves
>>> it might as well just calculate a new random value. There is
>>> not great merit in preserving the original defunct address.
>>>
>>> Or something like this
>>> --- a/net/bridge/br_stp_if.c  2014-02-12 08:21:56.733857356 -0800
>>> +++ b/net/bridge/br_stp_if.c  2014-03-18 20:09:09.334388826 -0700
>>> @@ -235,6 +235,9 @@ bool br_stp_recalculate_bridge_id(struct
>>>                       addr = p->dev->dev_addr;
>>>
>>>       }
>>> +
>>> +     if (addr == br_mac_zero)
>>> +             return false;  /* keep original address */
>>>
>>>       if (ether_addr_equal(br->bridge_id.addr, addr))
>>>               return false;   /* no change */
>>>
>>> that just keeps the old value.
>>
>> The old value could be a port which got root blocked, I think
>> it can be confusing to see that happen. Either way feel free to
>> make the call, I'll provide more details below on perhaps one reason
>> to keep the original MAC address.
> 
> Stephen, I'd like to respin this series to address all pending
> feedback, I'd still like your feedback / call / judgement on this
> part. I'm fine either way, just wanted to ensure I highlight the
> reasoning of why I kept the original random MAC address. Please keep
> in mind that at this point I'm convinced bridging is the *wrong*
> solution to networking with guests but it is being used in a lot of
> current topologies, this would just help with smoothing out corner
> cases.
> 

Hi Luis

I took at this series again, I think it might make to generate
a new random address instead of storing the original.
There is not much point in storing the original since it's been
gone, and most likely not advertised anywhere anyway.

As for virtualization configuration you described, a lot of times
there is a single port in the down state that remains.  At least
that's how libvirt manages it's bridged networks.

Thanks
-vlad

>>> The bridge is in a meaningless state when there are no ports,
>>
>> Some virtualization topologies may want a backend with no link (or
>> perhaps one which is dynamic, with the option to have none) to the
>> internet but just a bridge so guests sharing the bridge can talk to
>> each other. In this case bridging can be used only to link the
>> batch of guests.
>>
>> In this case the bridge simply acts as a switch, but also can be used as the
>> interface for DHCP, for example. In such a case the guests will be doing
>> ARP to get to the DHCP server. There's a flurry of ways one can try to get
>> all this meshed together including enablign an ARP proxy but I'm looking
>> at ways to optimize this further -- but I'd like to address the current
>> usage cases first.
>>
>>> and when the first port is added back it will be used as the
>>> new bridge id.
>>
>> Sure. Let me know how you think we should proceed with this patch based
>> on the above.
> 
> Thanks in advance.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

