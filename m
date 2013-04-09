Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937358Ab3DIKET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:04:19 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:39381
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934845Ab3DIKEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:04:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dIc89bh542I1432I4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h941hd25hf0ah1269h1288h12a5h12a9h12bdh12e1h137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH v4] cpufreq: powerpc: Add cpufreq driver for Freescale
 e500mc SoCs
Thread-Topic: [PATCH v4] cpufreq: powerpc: Add cpufreq driver for Freescale
 e500mc SoCs
Thread-Index: AQHONQI7NwrNmkrAu0qLWr8UGqf5Z5jNpGWAgAAEf6A=
Date: Tue, 9 Apr 2013 10:04:11 +0000
Message-ID: <D07C73A334FF604B95B3CBD2A545D07B0B12831E@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365496365-28450-1-git-send-email-Yuantian.Tang@freescale.com>
 <CAKohpokVf0hCokDL62WeaUdYEBycf+Kh_cRgWxTR--_12xjEBA@mail.gmail.com>
In-Reply-To: <CAKohpokVf0hCokDL62WeaUdYEBycf+Kh_cRgWxTR--_12xjEBA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.128]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r39A4L1f002601

Thanks, you make my code look better each review.

Thanks,
Yuantian


> -----Original Message-----
> From: Viresh Kumar [mailto:viresh.kumar@linaro.org]
> Sent: 2013Äê4ÔÂ9ÈÕ 17:47
> To: Tang Yuantian-B29983
> Cc: rjw@sisk.pl; cpufreq@vger.kernel.org; linux-pm@vger.kernel.org;
> linux-kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Li Yang-
> R58472
> Subject: Re: [PATCH v4] cpufreq: powerpc: Add cpufreq driver for
> Freescale e500mc SoCs
> 
> Mostly good now, V5 should be the final one.
> 
> On 9 April 2013 14:02,  <Yuantian.Tang@freescale.com> wrote:
> > diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c
> > b/drivers/cpufreq/ppc-corenet-cpufreq.c
> 
> > +static int corenet_cpufreq_target(struct cpufreq_policy *policy,
> > +               unsigned int target_freq, unsigned int relation) {
> > +       struct cpufreq_freqs freqs;
> > +       unsigned int new;
> > +       struct clk *parent;
> > +       int ret;
> > +       struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
> > +
> > +       cpufreq_frequency_table_target(policy, data->table,
> > +                       target_freq, relation, &new);
> > +
> > +       if (policy->cur == data->table[new].frequency)
> > +               return 0;
> > +
> > +       freqs.old = policy->cur;
> > +       freqs.new = data->table[new].frequency;
> > +       freqs.cpu = policy->cpu;
> 
> You don't need to set freqs.cpu..
> 
> > +       mutex_lock(&cpufreq_lock);
> > +       cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> > +
> > +       parent = of_clk_get(data->parent, new);
> > +       ret = clk_set_parent(data->clk, parent);
> > +       if (ret) {
> > +               freqs.new = freqs.old;
> > +               cpufreq_notify_transition(policy, &freqs,
> CPUFREQ_POSTCHANGE);
> > +               mutex_unlock(&cpufreq_lock);
> > +               return ret;
> > +       }
> > +
> > +       cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> > +       mutex_unlock(&cpufreq_lock);
> 
> What about writing it as:
> 
> +       ret = clk_set_parent(data->clk, parent);
> +       if (ret)
> +               freqs.new = freqs.old;
> +
> +       cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> +       mutex_unlock(&cpufreq_lock);
> 
> return ret;
> 
> > +       return 0;
> > +}

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
