Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3G2Mh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:37:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57734 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3G2Mhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:37:55 -0400
Message-ID: <51F66206.1010504@huawei.com>
Date: Mon, 29 Jul 2013 20:37:26 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <libo.chen@huawei.com>
Subject: Re: [PATCH 9/9] netfilter: use ns_printk in iptable context
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-10-git-send-email-rui.xiang@huawei.com> <51F63A88.4090405@cn.fujitsu.com>
In-Reply-To: <51F63A88.4090405@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/29 17:48, Gao feng wrote:
> On 07/29/2013 10:31 AM, Rui Xiang wrote:
>> To containerise iptables log, use ns_printk
>> to report individual logs to container as
>> getting syslog_ns from skb->dev->nd_net->user_ns.
>>
>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>> ---
>>  include/net/netfilter/xt_log.h | 6 +++++-
>>  net/netfilter/xt_LOG.c         | 4 ++--
>>  2 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
>> index 9d9756c..5222cba 100644
>> --- a/include/net/netfilter/xt_log.h
>> +++ b/include/net/netfilter/xt_log.h
>> @@ -39,10 +39,14 @@ static struct sbuff *sb_open(void)
>>  	return m;
>>  }
>>  
>> -static void sb_close(struct sbuff *m)
>> +static void sb_close(struct sbuff *m, struct sk_buff *skb)
>>  {
>>  	m->buf[m->count] = 0;
>> +#ifdef CONFIG_NET_NS
>> +	ns_printk(skb->dev->nd_net->user_ns->syslog_ns, "%s\n", m->buf);
>> +#else
>>  	printk("%s\n", m->buf);
>> +#endif
>>  
>>  	if (likely(m != &emergency))
>>  		kfree(m);
>> diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
>> index 5ab2484..f2cd2fa3 100644
>> --- a/net/netfilter/xt_LOG.c
>> +++ b/net/netfilter/xt_LOG.c
>> @@ -493,7 +493,7 @@ ipt_log_packet(struct net *net,
>>  
>>  	dump_ipv4_packet(m, loginfo, skb, 0);
>>  
>> -	sb_close(m);
>> +	sb_close(m, skb);
> 
> 
> why don't you pass net directly to sb_close here?
> 
> un init net namespace will not trigger any system log through ipt_LOG/ip6t_LOG.
> You can check the FIXME in ipt_log_packet.
> 
> BTW,for this patch,you should cc netfilter-devel@vger.kernel.org too.
> 
Hi Gao,

Thanks for your attention.

Yes, you are right. In the 1st version, there was no net parameter in ipt_log_packet
function. Here I didn't do any amendment. And I will alter it in next version.



Thanks.


