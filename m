Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945911Ab3BHDzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:55:12 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:37273 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295Ab3BHDzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <kf1kul$699$2@ger.gmane.org>
References: <51140154.9040901@oracle.com> <kf1kul$699$2@ger.gmane.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 7 Feb 2013 22:54:48 -0500
Message-ID: <CA+1xoqeND5452=W0HLYoBzfou+0NM_x2d5GubivQX8mKOFExsg@mail.gmail.com>
Subject: Re: net: rcu warnings in ip6fl_get_first
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem <davem@davemloft.net>, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 8:38 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, 07 Feb 2013 at 19:32 GMT, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Hi guys,
>>
>> I got the following while fuzzing with trinity inside a KVM tools guest:
>>
>> [   51.680236] ===============================
>> [   51.681914] [ INFO: suspicious RCU usage. ]
>> [   51.683610] 3.8.0-rc6-next-20130206-sasha-00028-g83214f7-dirty #276 Tainted: G        W
>> [   51.686703] -------------------------------
>> [   51.688281] net/ipv6/ip6_flowlabel.c:671 suspicious rcu_dereference_check() usage!
>> [   51.691345]
>
> It should use rcu_dereference_bh()...
>
> diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
> index ea42bf4..c50080f 100644
> --- a/net/ipv6/ip6_flowlabel.c
> +++ b/net/ipv6/ip6_flowlabel.c
> @@ -65,13 +65,13 @@ static DEFINE_SPINLOCK(ip6_fl_lock);
>  static DEFINE_SPINLOCK(ip6_sk_fl_lock);
>
>  #define for_each_fl_rcu(hash, fl)                              \
> -       for (fl = rcu_dereference(fl_ht[(hash)]);               \
> +       for (fl = rcu_dereference_bh(fl_ht[(hash)]);            \
>              fl != NULL;                                        \
> -            fl = rcu_dereference(fl->next))
> +            fl = rcu_dereference_hb(fl->next))
>  #define for_each_fl_continue_rcu(fl)                           \
> -       for (fl = rcu_dereference(fl->next);                    \
> +       for (fl = rcu_dereference_bh(fl->next);                 \
>              fl != NULL;                                        \
> -            fl = rcu_dereference(fl->next))
> +            fl = rcu_dereference_bh(fl->next))
>
>  #define for_each_sk_fl_rcu(np, sfl)                            \
>         for (sfl = rcu_dereference_bh(np->ipv6_fl_list);        \

Yup, that's how I fixed it locally and it was running without warnings
for couple of hours now.


Thanks,
Sasha
