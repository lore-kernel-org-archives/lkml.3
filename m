Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3LRJ1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:27:11 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:28950 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3LRJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:27:06 -0500
Message-ID: <52B166ED.7020508@huawei.com>
Date: Wed, 18 Dec 2013 17:12:13 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <kaber@trash.net>, <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, <ebiederm@xmission.com>,
        <herbert@gondor.apana.org.au>
CC: <edumazet@google.com>, <fbl@redhat.com>, <ebiederm@xmission.com>,
        <jeff@garzik.org>, <peterz@infradead.org>, <honkiko@gmail.com>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "Huang Qiang" <h.huangqiang@huawei.com>,
        Wengmeiling <wengmeiling.weng@huawei.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <daniel.wagner@bmw-carit.de>, <nhorman@tuxdriver.com>
Subject: Re: cgroup filter on physics interface can't control container
References: <52A52BBF.6030105@huawei.com> <52A9A97F.20902@huawei.com>
In-Reply-To: <52A9A97F.20902@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello guys,

I said before "we can save sk_classid before skb_scrub_packet and
restore it after that"  since skb->sk had been freed in
skb_scrub_packet(), so it is not reasonable. yes?

I have another idea.
commit:f84517253(cls_cgroup: Store classid in struct sock) introduces
sk_classid and put it in skb->sk pointer.  can we put sk_classid form
struct sock to struct sk_buff? then sk_classid will not be affected
by dev_forward_skb()->skb_scrub_packet() ?

any comment are welcome!


thanks,
Libo


On 2013/12/12 20:18, Libo Chen wrote:
> ping...
> 
> On 2013/12/9 10:32, Libo Chen wrote:
>> hello network hackers,
>>
>> 	A linux container was builded with veth pair(veth0 inside container, veth1 outside container),
>>
>> the config as below:
>>
>>   lxc.network.type = veth
>>   lxc.network.flags = up
>>   lxc.network.link = br0  // base on eth0
>>   lxc.network.name = eth0
>>   lxc.network.ipv4 = 128.5.130.26/24
>>
>> then I use tc command with cgroup filter on veth0, it works well. But when setting on eth0, it doesn`t work.
>>
>> The reason is dev_forward_skb() in veth_xmit will call skb_scrub_packet and clean all information including skb->sk
>> in the skb, so if cls_cgroup_classify is working in serving softirq state, it will return failer, see below:
>>
>> 	if (in_serving_softirq()) {
>> 		/* If there is an sk_classid we'll use that. */
>> 		if (!skb->sk)
>> 			return -1;
>> 		classid = skb->sk->sk_classid;
>> 	}
>>
>>
>> Qdisc with cgroup filter on physics interface can not control a container network, it is disappointed.
>>
>> we can save sk_classid before skb_scrub_packet and restore it after that. Is it reasonable?  or any way to achieve this?
>>
>> thanks,
>> Libo
>>
> 


