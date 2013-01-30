Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3A3CcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:32:09 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:20663
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab3A3CcI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:32:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bh1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h1889i1155h)
Message-ID: <51088619.5060102@freescale.com>
Date: Wed, 30 Jan 2013 10:31:53 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Florian Fainelli <ffainelli@freebox.fr>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>, <matthieu.castet@parrot.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: fix the wrong timeo for panic_nand_wait()
References: <CAMiH66HWn5PtjX20=WT7GMMV=J72rg3jx64iACSBiExjoD+X7A@mail.gmail.com> <1358818230-27037-1-git-send-email-b32955@freescale.com> <201301292200.14622.ffainelli@freebox.fr>
In-Reply-To: <201301292200.14622.ffainelli@freebox.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月30日 05:00, Florian Fainelli 写道:
> Hello Huang,
>
> Le mardi 22 janvier 2013 02:30:30, Huang Shijie a écrit :
>> In nand_wait(), the timeo for panic_nand_wait() is assigned with
>> wrong value(jiffies + some delay). The timeo should be set like the
>> panic_nand_write() does.
>>
>> This patch fixes it, and also uses the msecs_to_jiffies() to make the
>> code more readable.
> You are not exactly explaining what is the issue with the current code, and
> how you are fixing it. If someone needs to backport this patch for whatever
> reason, it must be clear as to what it fixes.
ok, i can add more comments.
thanks for your review.

Best Regards
Huang Shijie

>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>> ---
>> fix the compiler error in version 1, and add some commits.
>>
>> ---
>>   drivers/mtd/nand/nand_base.c |    8 ++------
>>   1 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>> index 8323ac9..a8c1fb4 100644
>> --- a/drivers/mtd/nand/nand_base.c
>> +++ b/drivers/mtd/nand/nand_base.c
>> @@ -825,13 +825,8 @@ static void panic_nand_wait(struct mtd_info *mtd,
>> struct nand_chip *chip, static int nand_wait(struct mtd_info *mtd, struct
>> nand_chip *chip) {
>>
>> -	unsigned long timeo = jiffies;
>>   	int status, state = chip->state;
>> -
>> -	if (state == FL_ERASING)
>> -		timeo += (HZ * 400) / 1000;
>> -	else
>> -		timeo += (HZ * 20) / 1000;
>> +	unsigned long timeo = (state == FL_ERASING ? 400 : 20);
>>
>>   	led_trigger_event(nand_led_trigger, LED_FULL);
>>
>> @@ -849,6 +844,7 @@ static int nand_wait(struct mtd_info *mtd, struct
>> nand_chip *chip) if (in_interrupt() || oops_in_progress)
>>   		panic_nand_wait(mtd, chip, timeo);
>>   	else {
>> +		timeo = jiffies + msecs_to_jiffies(timeo);
>>   		while (time_before(jiffies, timeo)) {
>>   			if (chip->dev_ready) {
>>   				if (chip->dev_ready(mtd))


