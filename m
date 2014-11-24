Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaKXIec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:34:32 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32997 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaKXIeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:34:31 -0500
Message-ID: <5472ED90.5010803@linaro.org>
Date: Mon, 24 Nov 2014 09:34:24 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        Kangkang.Shen@huawei.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v5 03/18] ACPI / table: Count matched and successfully
 parsed entries without specifying max entries
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-4-git-send-email-hanjun.guo@linaro.org> <6619034.gHDuQJ1A7y@vostro.rjw.lan>
In-Reply-To: <6619034.gHDuQJ1A7y@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.11.2014 02:45, Rafael J. Wysocki wrote:
> On Friday, October 17, 2014 09:36:59 PM Hanjun Guo wrote:
>> From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>
>> It is very useful to traverse all available table entries without max
>> number of expected entries type. Current acpi_parse_entries()
>> implementation gives that feature but it does not count those entries,
>> it returns 0 instead, so fix it to count matched and successfully
>> entries and return it.
>
> Hmm.  I guess that the goal is for count to only be incremented when the
> condition is satisfied entirely, while without the patch it may be incremented
> even if that isn't the case.

That would be our goal if patch would look like:
-		    && (!max_entries || count++ < max_entries))
+		    && (!max_entries && count++ < max_entries)) {
but then we can not walk through all available entries (with max_entries==0)

>
> I'm not sure how that is related to the above paragraph, however.
>

Previous changelog is not clear, let me rewrite it:

acpi_parse_entries() allows to traverse all available table entries (aka 
subtables) by passing max_entries parameter equal to 0. But for that use 
case acpi_parse_entries() does not inform caller how many entries were 
matched and for how many entries handler was run against. That patch is 
going to fix it.

Regards,
Tomasz

>> NOTE: This change has no impact to x86 and ia64 archs since existing code
>> checks for error occurrence only (acpi_parse_entries(...,0) < 0).
>>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   drivers/acpi/tables.c |    5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>> index 21ae521..b18e45e 100644
>> --- a/drivers/acpi/tables.c
>> +++ b/drivers/acpi/tables.c
>> @@ -225,10 +225,13 @@ acpi_parse_entries(unsigned long table_size,
>>   	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
>>   	       table_end) {
>>   		if (entry->type == entry_id
>> -		    && (!max_entries || count++ < max_entries))
>> +		    && (!max_entries || count < max_entries)) {
>>   			if (handler(entry, table_end))
>>   				return -EINVAL;
>>
>> +			count++;
>> +		}
>> +
>>   		/*
>>   		 * If entry->length is 0, break from this loop to avoid
>>   		 * infinite loop.
>>
>
