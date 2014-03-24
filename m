Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaCXLTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:19:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:50609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCXLTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:19:22 -0400
Message-ID: <533014B1.4030307@biereigel-wb.de>
Date: Mon, 24 Mar 2014 12:19:13 +0100
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Stefan Biereigel <stefan@biereigel.de>,
        lenb@kernel.org, rjw@rjwysocki.net,
        Lan Tianyu <lantianyu1986@gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after
 suspend to RAM.
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com>
In-Reply-To: <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:56o5c55FAWoiZ1hqnBuhbXwNQb56dpwrlmgL2iQBjKo
 TbZ36xQj8ETxUrGU4/iB2GUlZtPXa0h9/NlgJn49Lw+F76Wq4n
 Uhz4lrsxPEeFY66wh0qA3j0gGjzbTuCW1ljmBIzEloOWlmUCIn
 sQwBYY5cPGI6pos3r4UOCs7dCsfegoFIC4Yd7YAM18QrPUkGWO
 94FhWudshqwCsdqW8iS9WGIfMC+3dDtggYHSCwZ46o8Ki1BPk7
 duyvcpydsxFC94kM5LmYkf5/GQXOiVKxOsxpBgTmn4aHOVXn3C
 EedBW24yVrAfhw3yoBKkQtiJ+FAcm4AFliw72wqT+2ykY8iTJ3
 qRUhqxqpRBdVhhDYGCllAdck41GRQ12iTj9s5rB1V
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
thank you for the suggestion. The patch resolves the issue on my N150
when applied to a clean 3.14-rc7. Anyways I'm wondering if similar
problems to mine now exist on the Samsung Series 7/9 notebooks?

Is any further action from my part required?

Regards,
Stefan

Am 24.03.2014 10:30, schrieb Lan Tianyu:
> Please try the following patch.
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index d7d32c2..9239527 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -1027,8 +1027,13 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
>         DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
>         DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
>         {
> -       ec_clear_on_resume, "Samsung hardware", {
> -       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
> +       ec_clear_on_resume, "Samsung NP530U3B", {
> +       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +       DMI_MATCH(DMI_PRODUCT_NAME, "530U3BI/530U4BI/530U4BH"),}, NULL},
> +       {
> +       ec_clear_on_resume, "Samsung NP530U3C", {
> +       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +       DMI_MATCH(DMI_PRODUCT_NAME, "530U3C/530U4C/532U3C"),}, NULL},
>         {},
>  };
> 
> 
> 
> 
> 2014-03-24 15:50 GMT+08:00 Stefan Biereigel <security@biereigel-wb.de>:
>> Hi,
>>
>> starting with 3.14-rc6, the lid on my Samsung N150 behaves weird: My
>> system is set up, so that it should suspend to RAM as soon as the lid is
>> closed. Beginning with 3.14-rc6, the lid goes from "open" to "closed"
>> correctly the first time (and the system suspends), but after resuming
>> from standby (by opening the lid), the lid does not change to "open" again.
>> Of course, closing the lid again does not induce suspend to RAM then.
>> Opening the lid now (while not sleeping), makes ACPI notify the opening,
>> so I guess ACPI "misses" or discards the lid open event from the EC when
>> coming from sleep.
>> Now, closing the lid again does induce suspend to RAM. This behaviour is
>> reproducible: every other time, suspending works.
>>
>> This behaviour seems to be introduced by commit ad332c8a: ACPI / EC:
>> Clear stale EC events on Samsung systems.
>> Which was introduced after 3.14-rc5.
>>
>> When opening the lid to resume from standby, i see in dmesg:
>> Mar 23 22:12:04 little1 kernel: [ 7630.932074] ACPI : EC: 1 stale EC
>> events cleared
>> (which comes from drivers/acpi/ec.c)
>>
>> Seems to me, that the "open" event is cleared from the EC, but also
>> discarded instead of passed on. Shouldn't the correct behaviour be to
>> report all the pending events, read from the EC, as ACPI events? Can you
>> point me in a direction for fixing the issue cleanly, then I will try to
>> find a solution and prepare a patch for this issue.
>>
>> Best regards,
>> Stefan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
