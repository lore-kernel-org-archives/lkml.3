Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3GXDT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3GXDT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:19:56 -0400
Message-ID: <51EF47BC.4090107@redhat.com>
Date: Wed, 24 Jul 2013 11:19:24 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Basil Gor <basil.gor@gmail.com>
Subject: Re: [PATCH net-next] tuntap: hardware vlan tx support
References: <1374563748-38821-1-git-send-email-jasowang@redhat.com> <51EE7341.4060404@cogentembedded.com>
In-Reply-To: <51EE7341.4060404@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:12 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 23-07-2013 11:15, Jason Wang wrote:
>
>> Inspired by commit f09e2249c4f5c7c13261ec73f5a7807076af0c8e (macvtap:
>> restore
>> vlan header on user read). This patch adds hardware vlan tx support for
>> tuntap. This is done by copying vlan header directly into userspace in
>> tun_put_user() instead of doing it through __vlan_put_tag() in
>> dev_hard_start_xmit(). This eliminates one unnecessary memove in
>
>    s/memove/memmove/?
>

Yes.
>> vlan_insert_tag() for 802.1ad and 802.1q traffic.
>
>> pktgen test shows about 20% improvement for 802.1q traffic:
>
>> Before:
>>    662149pps 317Mb/sec (317831520bps) errors: 0
>> After:
>>    801033pps 384Mb/sec (384495840bps) errors: 0
>
>> Cc: Basil Gor <basil.gor@gmail.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/net/tun.c |   39 +++++++++++++++++++++++++++++++++++----
>>   1 files changed, 35 insertions(+), 4 deletions(-)
>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index a72d141..66e265d 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
> [...]
>> @@ -1328,11 +1330,39 @@ static ssize_t tun_put_user(struct tun_struct
>> *tun,
>>           total += tun->vnet_hdr_sz;
>>       }
>>
>> -    len = min_t(int, skb->len, len);
>> +    if (!vlan_tx_tag_present(skb))
>> +        len = min_t(int, skb->len, len);
>> +    else {
>
>    According to Documentation/CodingStyle chapter 3, both arms of an
> *if* statement should have {} if one arm has it.
>

Right.
>> +        int copy, ret;
>> +        struct {
>> +            __be16 h_vlan_proto;
>> +            __be16 h_vlan_TCI;
>> +        } veth;
>
>    Empty line wouldn't hurt here, after declarations...
>

Ok
>> +        veth.h_vlan_proto = skb->vlan_proto;
>> +        veth.h_vlan_TCI = htons(vlan_tx_tag_get(skb));
> [...]
>
> WBR, Sergei
>

Thanks, will correct them.
> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

