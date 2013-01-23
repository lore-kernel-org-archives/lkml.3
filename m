Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3AWIa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:30:26 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49004 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3AWIaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:30:24 -0500
Message-ID: <50FF9F92.60202@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 16:30:10 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net> <50FF7086.4020509@linux.vnet.ibm.com> <1358922520.5752.91.camel@marge.simpson.net> <50FF8CD8.4060105@linux.vnet.ibm.com> <1358929257.5752.109.camel@marge.simp!
 son.net>
In-Reply-To: <1358929257.5752.109.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012308-1618-0000-0000-0000033BD92E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 04:20 PM, Mike Galbraith wrote:
> On Wed, 2013-01-23 at 15:10 +0800, Michael Wang wrote: 
>> On 01/23/2013 02:28 PM, Mike Galbraith wrote:
> 
>>> Abbreviated test run:
>>> Tasks    jobs/min  jti  jobs/min/task      real       cpu
>>>   640   158044.01   81       246.9438     24.54    577.66   Wed Jan 23 07:14:33 2013
>>>  1280    50434.33   39        39.4018    153.80   5737.57   Wed Jan 23 07:17:07 2013
>>>  2560    47214.07   34        18.4430    328.58  12715.56   Wed Jan 23 07:22:36 2013
>>
>> So still not works... and not going to balance path while waking up will
>> fix it, looks like that's the only choice if no error on balance path
>> could be found...benchmark wins again, I'm feeling bad...
>>
>> I will conclude the info we collected and make a v3 later.
> 
> FWIW, I hacked virgin to do full balance if an idle CPU was not found,
> leaving the preference to wake cache affine intact though, turned on
> WAKE_BALANCE in all domains, and it did not collapse.  In fact, the high
> load end, where the idle search will frequently be a waste of cycles,
> actually improved a bit.  Things that make ya go hmmm.

Oh, does that means the old balance path is good while the new is really
broken, I mean, compared this with the previously results, could we say
that all the collapse was just caused by the change of balance path?

Regards,
Michael Wang

> 
> Tasks    jobs/min  jti  jobs/min/task      real       cpu
>     1      436.60  100       436.5994     13.88      3.80   Wed Jan 23 08:49:21 2013
>     1      437.23  100       437.2294     13.86      3.85   Wed Jan 23 08:49:45 2013
>     1      440.41  100       440.4070     13.76      3.76   Wed Jan 23 08:50:08 2013
>     5     2463.41   99       492.6829     12.30     10.90   Wed Jan 23 08:50:22 2013
>     5     2427.88   99       485.5769     12.48     11.90   Wed Jan 23 08:50:37 2013
>     5     2431.78   99       486.3563     12.46     11.74   Wed Jan 23 08:50:51 2013
>    10     4867.47   99       486.7470     12.45     23.30   Wed Jan 23 08:51:05 2013
>    10     4855.77   99       485.5769     12.48     23.35   Wed Jan 23 08:51:18 2013
>    10     4891.04   99       489.1041     12.39     22.71   Wed Jan 23 08:51:31 2013
>    20     9789.98   96       489.4992     12.38     36.18   Wed Jan 23 08:51:44 2013
>    20     9774.19   97       488.7097     12.40     39.58   Wed Jan 23 08:51:56 2013
>    20     9774.19   97       488.7097     12.40     37.99   Wed Jan 23 08:52:09 2013
>    40    19086.61   98       477.1654     12.70     89.56   Wed Jan 23 08:52:22 2013
>    40    19116.72   98       477.9180     12.68     92.69   Wed Jan 23 08:52:35 2013
>    40    19056.60   98       476.4151     12.72     90.19   Wed Jan 23 08:52:48 2013
>    80    37149.43   98       464.3678     13.05    114.19   Wed Jan 23 08:53:01 2013
>    80    37436.29   98       467.9537     12.95    111.54   Wed Jan 23 08:53:14 2013
>    80    37206.45   98       465.0806     13.03    111.49   Wed Jan 23 08:53:27 2013
>   160    69605.17   97       435.0323     13.93    152.35   Wed Jan 23 08:53:41 2013
>   160    69705.25   97       435.6578     13.91    152.05   Wed Jan 23 08:53:55 2013
>   160    69356.22   97       433.4764     13.98    154.56   Wed Jan 23 08:54:09 2013
>   320   112482.60   94       351.5081     17.24    285.52   Wed Jan 23 08:54:27 2013
>   320   112222.22   94       350.6944     17.28    287.80   Wed Jan 23 08:54:44 2013
>   320   109994.33   97       343.7323     17.63    302.40   Wed Jan 23 08:55:02 2013
>   640   152273.26   94       237.9270     25.47    614.95   Wed Jan 23 08:55:27 2013
>   640   153175.36   96       239.3365     25.32    608.48   Wed Jan 23 08:55:53 2013
>   640   152994.08   95       239.0533     25.35    609.33   Wed Jan 23 08:56:18 2013
>  1280   191101.26   95       149.2979     40.59   1218.71   Wed Jan 23 08:56:59 2013
>  1280   191667.90   94       149.7405     40.47   1215.06   Wed Jan 23 08:57:40 2013
>  1280   191289.77   94       149.4451     40.55   1217.35   Wed Jan 23 08:58:20 2013
>  2560   221654.52   94        86.5838     69.99   2392.78   Wed Jan 23 08:59:31 2013
>  2560   221117.45   91        86.3740     70.16   2399.01   Wed Jan 23 09:00:41 2013
>  2560   220394.94   93        86.0918     70.39   2409.10   Wed Jan 23 09:01:52 2013
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

