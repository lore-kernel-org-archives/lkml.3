Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaCGR2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:28:53 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:58236 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753941AbaCGR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:28:51 -0500
MIME-Version: 1.0
In-Reply-To: <5319F272.1070101@redhat.com>
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
	<5319F272.1070101@redhat.com>
Date: Fri, 7 Mar 2014 09:28:50 -0800
Message-ID: <CALnjE+q=fejHPsjVj9+jnypJCUHfCDFc553U48WR48Tjcf3FZw@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace via
 Netlink to avoid guest stall
From: Pravin Shelar <pshelar@nicira.com>
To: Thomas Graf <tgraf@redhat.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 8:23 AM, Thomas Graf <tgraf@redhat.com> wrote:
> On 02/28/2014 08:16 PM, Zoltan Kiss wrote:
>>
>> The kernel datapath now switched to zerocopy Netlink messages, but that
>> also
>> means that the pages on frags array are sent straight to userspace. If
>> those
>> pages came outside the kernel, we have to swap them out with local copies.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> ---
>>   net/openvswitch/datapath.c |    6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index 36f8872..ffb563c 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -464,6 +464,12 @@ static int queue_userspace_packet(struct datapath
>> *dp, struct sk_buff *skb,
>>         }
>>         nla->nla_len = nla_attr_size(skb->len);
>>
>> +       if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC))) {
>> +               err = -ENOMEM;
>> +               skb_tx_error(skb);
>> +               goto out;
>> +       }
>> +
>>         skb_zerocopy(user_skb, skb, skb->len, hlen);
>>
>>         /* Pad OVS_PACKET_ATTR_PACKET if linear copy was performed */
>
>
> How about we move the call to skb_orphan_frags() into skb_zerocopy()
> itself and call it before we actually reference the frags?
>

Problem is mapping SKBTX_DEV_ZEROCOPY pages to userspace. skb_zerocopy
is not doing that.

Unless I missing something, Current netlink code can not handle
skb-frags with zero copy. So we have to copy skb anyways and no need
to orphan-frags here.
If you are planning on handling skb-frags without copying then
skb_orphan_frags should be done in netlink.
