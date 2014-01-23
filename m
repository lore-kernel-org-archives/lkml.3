Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaAWVSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaAWVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:18:33 -0500
Message-ID: <52E18720.4060008@redhat.com>
Date: Thu, 23 Jan 2014 22:18:24 +0100
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: Use do_div to divide 64 bit numbers
References: <1390502838-21581-1-git-send-email-zoltan.kiss@citrix.com> <52E17F40.4040004@redhat.com>
In-Reply-To: <52E17F40.4040004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 09:44 PM, Nikolay Aleksandrov wrote:
> On 01/23/2014 07:47 PM, Zoltan Kiss wrote:
>> Nikolay Aleksandrov's recent bonding option API changes (25a9b54a and e4994612)
>> introduced u64 as the type of downdelay and updelay. On 32 bit the division and
>> modulo operations cause compile errors:
>>
>> ERROR: "__udivdi3" [drivers/net/bonding/bonding.ko] undefined!
>> ERROR: "__umoddi3" [drivers/net/bonding/bonding.ko] undefined!
>>
>> This patch use the do_div macro, which guaranteed to do the right thing.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> ---
>>  drivers/net/bonding/bond_options.c |   19 +++++++++++--------
>>  1 file changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>> index 4cee04a..4f94907 100644
>> --- a/drivers/net/bonding/bond_options.c
>> +++ b/drivers/net/bonding/bond_options.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/rcupdate.h>
>>  #include <linux/ctype.h>
>>  #include <linux/inet.h>
>> +#include <asm/div64.h>
>>  #include "bonding.h"
>>  
>>  static struct bond_opt_value bond_mode_tbl[] = {
>> @@ -727,19 +728,20 @@ int bond_option_miimon_set(struct bonding *bond, struct bond_opt_value *newval)
>>  
>>  int bond_option_updelay_set(struct bonding *bond, struct bond_opt_value *newval)
>>  {
>> +	u64 quotient = newval->value;
>> +	u64 remainder = do_div(quotient, bond->params.miimon);
> Hi Zoltan,
> Thanks for fixing this, a few comments though:
> bond->params.miimon can be 0 here that's why there's a check afterwards,
> also please separate the local variable definitions from the body with a
> new line.
> The same applies for downdelay.
> 
> Nik
In fact since we don't need the u64 and newval->value is limited to
INT_MAX, can't we simply cast it to (int) and avoid the do_div entirely ?

>>  	if (!bond->params.miimon) {
>>  		pr_err("%s: Unable to set up delay as MII monitoring is disabled\n",
>>  		       bond->dev->name);
>>  		return -EPERM;
>>  	}
>> -	if ((newval->value % bond->params.miimon) != 0) {
>> +	if (remainder != 0) {
>>  		pr_warn("%s: Warning: up delay (%llu) is not a multiple of miimon (%d), updelay rounded to %llu ms\n",
>>  			bond->dev->name, newval->value,
>>  			bond->params.miimon,
>> -			(newval->value / bond->params.miimon) *
>> -			bond->params.miimon);
>> +			quotient * bond->params.miimon);
>>  	}
>> -	bond->params.updelay = newval->value / bond->params.miimon;
>> +	bond->params.updelay = quotient;
>>  	pr_info("%s: Setting up delay to %d.\n",
>>  		bond->dev->name,
>>  		bond->params.updelay * bond->params.miimon);
>> @@ -750,19 +752,20 @@ int bond_option_updelay_set(struct bonding *bond, struct bond_opt_value *newval)
>>  int bond_option_downdelay_set(struct bonding *bond,
>>  			      struct bond_opt_value *newval)
>>  {
>> +	u64 quotient = newval->value;
>> +	u64 remainder = do_div(quotient, bond->params.miimon);
>>  	if (!bond->params.miimon) {
>>  		pr_err("%s: Unable to set down delay as MII monitoring is disabled\n",
>>  		       bond->dev->name);
>>  		return -EPERM;
>>  	}
>> -	if ((newval->value % bond->params.miimon) != 0) {
>> +	if (remainder != 0) {
>>  		pr_warn("%s: Warning: down delay (%llu) is not a multiple of miimon (%d), delay rounded to %llu ms\n",
>>  			bond->dev->name, newval->value,
>>  			bond->params.miimon,
>> -			(newval->value / bond->params.miimon) *
>> -			bond->params.miimon);
>> +			quotient * bond->params.miimon);
>>  	}
>> -	bond->params.downdelay = newval->value / bond->params.miimon;
>> +	bond->params.downdelay = quotient;
>>  	pr_info("%s: Setting down delay to %d.\n",
>>  		bond->dev->name,
>>  		bond->params.downdelay * bond->params.miimon);
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

