Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339Ab3E2JSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:18:04 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:60566 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965261Ab3E2JSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:18:00 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51A5C7C0.5040304@yandex-team.ru>
Date: Wed, 29 May 2013 13:17:52 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jesper Dangaard Brouer <brouer@redhat.com>, paulmck@linux.vnet.ibm.com,
        Dipankar Sarma <dipankar@in.ibm.com>, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
References: <519B8908.9080007@yandex-team.ru>   <1369150693.3301.233.camel@edumazet-glaptop>   <519BB90B.6080706@yandex-team.ru>   <1369188080.3301.268.camel@edumazet-glaptop>   <1369201765.3301.299.camel@edumazet-glaptop> <519CB2D8.103@yandex-team.ru>   <1369225837.3301.324.camel@edumazet-glaptop>   <519CC2FB.2010006@yandex-team.ru>   <20130522174532.GC3431@linux.vnet.ibm.com> <519D19DA.50400@yandex-team.ru>   <20130525113715.GA3795@linux.vnet.ibm.com>   <51A39E11.5020405@yandex-team.ru>  <1369699930.3301.494.camel@edumazet-glaptop>  <51A47496.6000100@yandex-team.ru> <1369787693.3301.586.camel@edumazet-glaptop>
In-Reply-To: <1369787693.3301.586.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.05.2013 04:34, Eric Dumazet wrote:
> On Tue, 2013-05-28 at 13:10 +0400, Roman Gushchin wrote:
>> On 28.05.2013 04:12, Eric Dumazet wrote:
>
>>> Adding a barrier() is probably what we want.
>>
>> I agree, inserting barrier() is also a correct and working fix.
>
> Yeah, but I can not find a clean way to put it inside the "for (;;)"

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 2ae1371..74d5065 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -107,7 +107,7 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
   *
   */
  #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)                        \
-       for (pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));            \
+       for (({barrier();}), pos = rcu_dereference_raw(hlist_nulls_first_rcu(head)); \
                 (!is_a_nulls(pos)) &&                                           \
                 ({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
                 pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))



