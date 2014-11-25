Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaKYDks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 22:40:48 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47567 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaKYDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 22:40:45 -0500
Message-ID: <5473F99D.6090505@huawei.com>
Date: Tue, 25 Nov 2014 11:38:05 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
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
        Randy Dunlap <rdunlap@infradead.org>, <Charles.Garcia-Tobin@arm.com>,
        <Kangkang.Shen@huawei.com>, <linux-acpi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linaro-acpi@lists.linaro.org>,
        "Ashwin Chaugule" <ashwin.chaugule@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v5 02/18] ACPI / table: Add new function to get table
 entries
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <2764417.DLFalXXngC@vostro.rjw.lan> <5473109A.2070704@linaro.org> <1581499.U8906vqSiO@vostro.rjw.lan>
In-Reply-To: <1581499.U8906vqSiO@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/24 22:51, Rafael J. Wysocki wrote:
> On Monday, November 24, 2014 07:03:54 PM Hanjun Guo wrote:
>> On 2014-11-24 9:27, Rafael J. Wysocki wrote:
>>> On Friday, October 17, 2014 09:36:58 PM Hanjun Guo wrote:
>>>> From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
>>>>
>>>> The acpi_table_parse() function has a callback that
>>>> passes a pointer to a table_header. Add a new function
>>>> which takes this pointer and parses its entries. This
>>>> eliminates the need to re-traverse all the tables for
>>>> each call. e.g. as in acpi_table_parse_madt() which is
>>>> normally called after acpi_table_parse().
>>>>
>>>> Acked-by: Grant Likely <grant.likely@linaro.org>
>>>> Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
>>>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>> ---
>>>>  drivers/acpi/tables.c |   67 ++++++++++++++++++++++++++++++++++---------------
>>>>  include/linux/acpi.h  |    4 +++
>>>>  2 files changed, 51 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>>>> index 6d5a6cd..21ae521 100644
>>>> --- a/drivers/acpi/tables.c
>>>> +++ b/drivers/acpi/tables.c
>>>> @@ -192,17 +192,14 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>>>>  
>>>>  
>>>>  int __init
>>>> -acpi_table_parse_entries(char *id,
>>>> -			     unsigned long table_size,
>>>> -			     int entry_id,
>>>> -			     acpi_tbl_entry_handler handler,
>>>> -			     unsigned int max_entries)
>>>> +acpi_parse_entries(unsigned long table_size,
>>>> +		acpi_tbl_entry_handler handler,
>>>> +		struct acpi_table_header *table_header,
>>>> +		int entry_id, unsigned int max_entries)
>>>>  {
>>>> -	struct acpi_table_header *table_header = NULL;
>>>>  	struct acpi_subtable_header *entry;
>>>> -	unsigned int count = 0;
>>>> +	int count = 0;
>>>>  	unsigned long table_end;
>>>> -	acpi_size tbl_size;
>>>>  
>>>>  	if (acpi_disabled)
>>>>  		return -ENODEV;
>>>> @@ -210,13 +207,11 @@ acpi_table_parse_entries(char *id,
>>>>  	if (!handler)
>>>>  		return -EINVAL;
>>>>  
>>>> -	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
>>>> -		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
>>>> -	else
>>>> -		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
>>>> +	if (!table_size)
>>>> +		return -EINVAL;
>>>>  
>>>>  	if (!table_header) {
>>>> -		pr_warn("%4.4s not present\n", id);
>>>> +		pr_warn("Table header not present\n");
>>> The message doesn't make sense any more if the table signature is not printed.

For this message, since no table id is passed, and this message is printed in
acpi_table_parse_entries() before this function is called, I think we can check
the table_header before call this function and remove the printed message here.

>>>
>>>>  		return -ENODEV;
>>>>  	}
>>>>  
>>>> @@ -232,30 +227,62 @@ acpi_table_parse_entries(char *id,
>>>>  		if (entry->type == entry_id
>>>>  		    && (!max_entries || count++ < max_entries))
>>>>  			if (handler(entry, table_end))
>>>> -				goto err;
>>>> +				return -EINVAL;
>>>>  
>>>>  		/*
>>>>  		 * If entry->length is 0, break from this loop to avoid
>>>>  		 * infinite loop.
>>>>  		 */
>>>>  		if (entry->length == 0) {
>>>> -			pr_err("[%4.4s:0x%02x] Invalid zero length\n", id, entry_id);
>>>> -			goto err;
>>>> +			pr_err("[0x%02x] Invalid zero length\n", entry_id);

For this one, since the table_header is valid now, we can keep it with:

- pr_err("[%4.4s:0x%02x] Invalid zero length\n", id, entry_id);
+ pr_err("[%4.4s:0x%02x] Invalid zero length\n", table_header->signature, entry_id);

>>> Same here.
>> How about remove the message and return directly?
> We could do that, but for what reason?  Is the message not useful?

I agree with you, the message is useful I think, how about the comments above?

Thanks
Hanjun

