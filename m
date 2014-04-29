Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012AbaD2Toh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:44:37 -0400
Received: from fujitsu24.fnanic.fujitsu.com ([192.240.6.14]:41761 "EHLO
	fujitsu24.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932491AbaD2Tof convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:44:35 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "sandeen@redhat.com" <sandeen@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "mpatlasov@parallels.com" <mpatlasov@parallels.com>
Date: Tue, 29 Apr 2014 12:43:54 -0700
Subject: RE: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
Thread-Topic: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
Thread-Index: Ac9j4ALT4O1+nPD9RjeKUHfRkIP4nQAAz2qQ
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E31D4C5C3BB@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <20140429151910.53f740ef@annuminas.surriel.com>
In-Reply-To: <20140429151910.53f740ef@annuminas.surriel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-29_05:2014-04-29,2014-04-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rik van Riel [mailto:riel@redhat.com]
> Sent: Tuesday, April 29, 2014 3:19 PM
> To: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org; sandeen@redhat.com; akpm@linux-foundation.org; jweiner@redhat.com; Motohiro Kosaki JP;
> mhocko@suse.cz; fengguang.wu@intel.com; mpatlasov@parallels.com
> Subject: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
> 
> It is possible for "limit - setpoint + 1" to equal zero, leading to a divide by zero error. Blindly adding 1 to "limit - setpoint" is not working,
> so we need to actually test the divisor before calling div64.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Cc: stable@vger.kernel.org

Fairly obvious fix.

Acked-by: KOSAKI Motohiro <Kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/page-writeback.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c index ef41349..2682516 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
>  					  unsigned long dirty,
>  					  unsigned long limit)
>  {
> +	unsigned int divisor;
>  	long long pos_ratio;
>  	long x;
> 
> +	divisor = limit - setpoint;
> +	if (!divisor)
> +		divisor = 1;
> +
>  	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
> -		    limit - setpoint + 1);
> +		    divisor);
>  	pos_ratio = x;
>  	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
>  	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
