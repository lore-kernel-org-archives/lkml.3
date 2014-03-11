Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaCKTlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:41:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33566 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaCKTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:41:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,632,1389744000"; 
   d="scan'208";a="108900544"
Message-ID: <531F66D0.1050000@citrix.com>
Date: Tue, 11 Mar 2014 19:41:04 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@redhat.com>, Pravin Shelar <pshelar@nicira.com>
CC: Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        <xen-devel@lists.xenproject.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace
 via Netlink to avoid guest stall
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>	<5319F272.1070101@redhat.com> <CALnjE+q=fejHPsjVj9+jnypJCUHfCDFc553U48WR48Tjcf3FZw@mail.gmail.com> <531A0911.4040304@redhat.com>
In-Reply-To: <531A0911.4040304@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/14 17:59, Thomas Graf wrote:
> On 03/07/2014 06:28 PM, Pravin Shelar wrote:
>> Problem is mapping SKBTX_DEV_ZEROCOPY pages to userspace. skb_zerocopy
>> is not doing that.
>>
>> Unless I missing something, Current netlink code can not handle
>> skb-frags with zero copy. So we have to copy skb anyways and no need
>> to orphan-frags here.
>> If you are planning on handling skb-frags without copying then
>> skb_orphan_frags should be done in netlink.
>
> If you look at the second part of skb_zerocopy() this is exactly what
> it is doing unless the target skb has sufficient linear space
> preallocated. At least unless mmap is enabled in which case we would
> have to copy again until we have implemented a way to pass page refs
> via the nl ring buffer.
>
> So I think Zoltan is correct in orphaning frags that come from f.e.
> a tun device via zerocopy_sg_from_iovec().

Now as I'm checking how Netlink works, I might be wrong at some parts :) 
skb_zerocopy correctly add the frags to the user_skb we are sending 
upwards, however when the userspace receive it in netlink_recvmsg(), it 
gets copied to the supplied buffer anyway. Is that correct? In which 
case we don't need to worry that userspace will sit on that page 
indefinitely. However we have to worry about userspace not calling recv 
on that Netlink socket, so in the end we still need skb_orphan_frags, 
just for a different reason :)
We can put skb_orphan_frags into skb_zerocopy, skb_clone also do that.

However with Netlink mmapped IO, we should take a different approach, 
and instead of calling skb_orphan_frags we should make sure user_skb can 
hold any skb we get from the kernel, and copy the frags there. Even if 
we would be able to pass page refs to userspace through the ring buffer 
(AFAIK currently we can't), it would be fragile to just pass kernel 
pages directly to userspace, even if they came without the 
SKBTX_DEV_ZEROCOPY flag. And I think it would be quite rare that we need 
that copy anyway, because the flow setup usually happens with small 
packets without frags.
If we choose the above approach with Netlink mmap, we don't need 
skb_orphan_frags, in fact

Regards,

Zoli
