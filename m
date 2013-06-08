Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3FHBHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:07:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3FHBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:07:24 -0400
Message-ID: <51B283C4.4070803@oracle.com>
Date: Sat, 08 Jun 2013 09:07:16 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        dan.magenheimer@oracle.com
Subject: Re: [PATCH] xen/tmem: Don't over-write tmem_frontswap_poolid after
 tmem_frontswap_init set it.
References: <1370633355-21201-1-git-send-email-konrad.wilk@oracle.com> <20130607194534.GB21543@phenom.dumpdata.com>
In-Reply-To: <20130607194534.GB21543@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 03:45 AM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 07, 2013 at 12:29:15PM -0700, Konrad Rzeszutek Wilk wrote:
> 
> CC-ing Bob.
> 
>> Commit 10a7a0771399a57a297fca9615450dbb3f88081a ("xen: tmem: enable Xen
>> tmem shim to be built/loaded as a module") allows the tmem module
>> to be loaded any time. For this work the frontswap API had to
>> be able to asynchronously to call tmem_frontswap_init before
>> or after the swap image had been set. That was added in git
>> commit 905cd0e1bf9ffe82d6906a01fd974ea0f70be97a
>> ("mm: frontswap: lazy initialization to allow tmem backends to build/run as modules").
>>
>> Which means we could do this (The common case):
>>
>>  modprobe tmem		[so calls frontswap_register_ops, no ->init]
>> 			 modifies tmem_frontswap_poolid = -1
>>  swapon /dev/xvda1	[__frontswap_init, calls -> init, tmem_frontswap_poolid is
>> 			 < 0 so tmem hypercall done]
>>
>> Or the failing one:
>>
>>  swapon /dev/xvda1	[calls __frontswap_init, sets the need_init bitmap]
>>  modprobe tmem		[calls frontswap_register_ops, -->init calls, finds out
>> 			tmem_frontswap_poolid is 0, does not make a hypercall.
>> 			Later in the module_init, sets tmem_frontswap_poolid=-1]
>>
>> Which meant that in the failing case we would not call the hypercall
>> to initialize the pool and never be able to make any frontswap
>> backend calls.
>>
>> Moving the frontswap_register_ops after setting the tmem_frontswap_poolid
>> fixes it.
>>
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Nice catch!
Reviewed-by: Bob Liu <bob.liu@oracle.com>

>> ---
>>  drivers/xen/tmem.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
>> index cc072c6..0f0493c 100644
>> --- a/drivers/xen/tmem.c
>> +++ b/drivers/xen/tmem.c
>> @@ -379,10 +379,10 @@ static int xen_tmem_init(void)
>>  #ifdef CONFIG_FRONTSWAP
>>  	if (tmem_enabled && frontswap) {
>>  		char *s = "";
>> -		struct frontswap_ops *old_ops =
>> -			frontswap_register_ops(&tmem_frontswap_ops);
>> +		struct frontswap_ops *old_ops;
>>  
>>  		tmem_frontswap_poolid = -1;
>> +		old_ops = frontswap_register_ops(&tmem_frontswap_ops);
>>  		if (IS_ERR(old_ops) || old_ops) {
>>  			if (IS_ERR(old_ops))
>>  				return PTR_ERR(old_ops);
>> -- 
>> 1.8.1.4
>>

-- 
Regards,
-Bob
