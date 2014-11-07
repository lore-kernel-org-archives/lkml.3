Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaKGWNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:13:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56829 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbaKGWNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:13:30 -0500
Message-ID: <545D43BD.8030203@fb.com>
Date: Fri, 7 Nov 2014 14:12:13 -0800
From: Calvin Owens <calvinowens@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>,
        <lvs-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <agartrell@fb.com>, <kernel-team@fb.com>
Subject: Re: [PATCH] ipvs: Keep skb->sk when allocating headroom on tunnel
 xmit
References: <1415147860-11389-1-git-send-email-calvinowens@fb.com> <alpine.LFD.2.11.1411051048540.1631@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1411051048540.1631@ja.home.ssi.bg>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-07_08:2014-11-07,2014-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411070185
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 01:21 AM, Julian Anastasov wrote:
>
> 	Hello,
>
> On Tue, 4 Nov 2014, Calvin Owens wrote:
>
>> ip_vs_prepare_tunneled_skb() ignores ->sk when allocating a new
>> skb, either unconditionally setting ->sk to NULL or allowing
>> the uninitialized ->sk from a newly allocated skb to leak through
>> to the caller.
>>
>> This patch properly copies ->sk and increments its reference count.
>>
>> Signed-off-by: Calvin Owens <calvinowens@fb.com>
>
> 	Good catch. Please, extend your patch to
> fix also the second place that has such error,
> ip_vs_tunnel_xmit_v6. This call is missing from long time,
> it was not needed. But commits that allow skb->sk (local
> clients) already need it, eg.

I'm not sure where exactly you mean: ip_vs_tunnel_xmit_v6() calls
ip_vs_prepare_tunneled_skb() to do the allocation, so this patch covers 
that case.

In older versions of the kernel, ip_vs_tunnel_xmit_v6() does it 
directly, could that be what you're looking at?

> - f2428ed5e7bc89c7 ("ipvs: load balance ipv6 connections from a local
> process"), 2.6.28
> - 4856c84c1358b798 ("ipvs: load balance IPv4 connections from a local
> process"), 2.6.28
>
>> ---
>>   net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
>> index 437a366..bd90bf8 100644
>> --- a/net/netfilter/ipvs/ip_vs_xmit.c
>> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
>> @@ -846,6 +846,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
>>   		new_skb = skb_realloc_headroom(skb, max_headroom);
>>   		if (!new_skb)
>>   			goto error;
>> +		if (skb->sk)
>> +			skb_set_owner_w(new_skb, skb->sk);
>>   		consume_skb(skb);
>>   		skb = new_skb;
>>   	}
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
