Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3A0KcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:32:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50709 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab3A0KcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:32:22 -0500
Date: Sun, 27 Jan 2013 11:35:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
Message-ID: <20130127103508.GB8894@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
	torvalds@linux-foundation.org, mingo@redhat.com,
	peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
	arjan@linux.intel.com, pjt@google.com, namhyung@kernel.org,
	vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
	preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
	linux-kernel@vger.kernel.org
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <20130124094439.GB13463@pd.tnic>
 <51014E34.60309@intel.com>
 <510493E4.8060602@intel.com>
 <1359261385.5803.46.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359261385.5803.46.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 05:36:25AM +0100, Mike Galbraith wrote:
> With aim7 compute on 4 node 40 core box, I see stable throughput
> improvement at tasks = nr_cores and below w. balance and powersaving. 
> 
>          3.8.0-performance                                  3.8.0-balance                                      3.8.0-powersaving
> Tasks    jobs/min  jti  jobs/min/task      real       cpu   jobs/min  jti  jobs/min/task      real       cpu   jobs/min  jti  jobs/min/task      real       cpu
>     1      432.86  100       432.8571     14.00      3.99     433.48  100       433.4764     13.98      3.97     433.17  100       433.1665     13.99      3.98
>     1      437.23  100       437.2294     13.86      3.85     436.60  100       436.5994     13.88      3.86     435.66  100       435.6578     13.91      3.90
>     1      434.10  100       434.0974     13.96      3.95     436.29  100       436.2851     13.89      3.89     436.29  100       436.2851     13.89      3.87
>     5     2400.95   99       480.1902     12.62     12.49    2554.81   98       510.9612     11.86      7.55    2487.68   98       497.5369     12.18      8.22
>     5     2341.58   99       468.3153     12.94     13.95    2578.72   99       515.7447     11.75      7.25    2527.11   99       505.4212     11.99      7.90
>     5     2350.66   99       470.1319     12.89     13.66    2600.86   99       520.1717     11.65      7.09    2508.28   98       501.6556     12.08      8.24
>    10     4291.78   99       429.1785     14.12     40.14    5334.51   99       533.4507     11.36     11.13    5183.92   98       518.3918     11.69     12.15
>    10     4334.76   99       433.4764     13.98     38.70    5311.13   99       531.1131     11.41     11.23    5215.15   99       521.5146     11.62     12.53
>    10     4273.62   99       427.3625     14.18     40.29    5287.96   99       528.7958     11.46     11.46    5144.31   98       514.4312     11.78     12.32
>    20     8487.39   94       424.3697     14.28     63.14   10594.41   99       529.7203     11.44     23.72   10575.92   99       528.7958     11.46     22.08
>    20     8387.54   97       419.3772     14.45     77.01   10575.92   98       528.7958     11.46     23.41   10520.83   99       526.0417     11.52     21.88
>    20     8713.16   95       435.6578     13.91     55.10   10659.63   99       532.9815     11.37     24.17   10539.13   99       526.9565     11.50     22.13
>    40    16786.70   99       419.6676     14.44    170.08   19469.88   98       486.7470     12.45     60.78   19967.05   98       499.1763     12.14     51.40
>    40    16728.78   99       418.2195     14.49    172.96   19627.53   98       490.6883     12.35     65.26   20386.88   98       509.6720     11.89     46.91
>    40    16763.49   99       419.0871     14.46    171.42   20033.06   98       500.8264     12.10     51.44   20682.59   98       517.0648     11.72     42.45

Ok, this is sick. How is balance and powersaving better than perf? Both
have much more jobs per minute than perf; is that because we do pack
much more tasks per cpu with balance and powersaving?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
