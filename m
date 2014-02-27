Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaB0CdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:33:15 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:56232 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaB0CdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:33:13 -0500
Message-ID: <530EA3E5.3010102@gmail.com>
Date: Wed, 26 Feb 2014 23:33:09 -0300
From: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Li Guang <lig.fnst@cn.fujitsu.com>,
        Kieran Clancy <clancy.kieran@gmail.com>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <530E9BEF.8080601@cn.fujitsu.com>
In-Reply-To: <530E9BEF.8080601@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> that's really nasty EC firmware!

Yes!
And this bug has been unsolved for about two years.

> 20 is enough?
> the query index is length of a byte.
>
According to our humble tests, 8 is the maximum number of
accumulated events. For instance, if the one plugs or unplugs the PSU
16 times, (or battery % changes 16 times) during S3 sleep, then the
EC returns no more than 8 events when polled by this patch or by
my userspace util.
And having reached 8 events, it won't produce its GPE until queried.

> the query index is length of a byte.

There is no query index, unless you refer to something else (I'm sorry if its
something that escapes me).
    For us, a query is just: send 0x84 through EC CMD port, and read status
from CMD port and event type from EC DATA port. This is done with
the usual ec.c functions that would handle a query after a GPE interrupt,
but using them instead to poll (not GPE initiated) at awake. The EC would
then return status without 0x20 mask and 'event type'==0 when no more left.

--
Juan Manuel Cabo <juanmanuel.cabo@gmail.com>



>>
>>   enum {
>>       EC_FLAGS_QUERY_PENDING,        /* Query is pending */
>> @@ -116,6 +118,7 @@ EXPORT_SYMBOL(first_ec);
>>   static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
>>   static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
>>   static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
>> +static int EC_FLAGS_CLEAR_ON_RESUME; /* EC should be polled on boot/resume */
>>    
>
> seems name is implicit, what about EC_FLAGS_QEVENT_CLR_ON_RESUME?
> seems too long :-)
>
>>
>>   /* --------------------------------------------------------------------------
>>                                Transaction Management
>> @@ -440,6 +443,26 @@ acpi_handle ec_get_handle(void)
>>
>>   EXPORT_SYMBOL(ec_get_handle);
>>
>> +static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
>> +
>> +/* run with locked ec mutex */
>> +static void acpi_ec_clear(struct acpi_ec *ec)
>> +{
>> +    int i, status;
>> +    u8 value = 0;
>> +
>> +    for (i = 0; i<  ACPI_EC_CLEAR_MAX; i++) {
>> +        status = acpi_ec_query_unlocked(ec,&value);
>> +        if (status || !value)
>> +            break;
>> +    }
>> +
>> +    if (i == ACPI_EC_CLEAR_MAX)
>> +        pr_warn("Warning: Maximum of %d stale EC events cleared\n", i);
>> +    else
>> +        pr_info("%d stale EC events cleared\n", i);
>> +}
>> +
>>   void acpi_ec_block_transactions(void)
>>   {
>>       struct acpi_ec *ec = first_ec;
>> @@ -463,6 +486,10 @@ void acpi_ec_unblock_transactions(void)
>>       mutex_lock(&ec->mutex);
>>       /* Allow transactions to be carried out again */
>>       clear_bit(EC_FLAGS_BLOCKED,&ec->flags);
>> +
>> +    if (EC_FLAGS_CLEAR_ON_RESUME)
>> +        acpi_ec_clear(ec);
>> +
>>       mutex_unlock(&ec->mutex);
>>   }
>>
>> @@ -821,6 +848,13 @@ static int acpi_ec_add(struct acpi_device *device)
>>
>>       /* EC is fully operational, allow queries */
>>       clear_bit(EC_FLAGS_QUERY_PENDING,&ec->flags);
>> +
>> +    /* Some hardware may need the EC to be cleared before use */
>>    
>
> description is implicit, should specify what we clear is Q event, not EC.
>
> Thanks!
> Li Guang
>
>> +    if (EC_FLAGS_CLEAR_ON_RESUME) {
>> +        mutex_lock(&ec->mutex);
>> +        acpi_ec_clear(ec);
>> +        mutex_unlock(&ec->mutex);
>> +    }
>>       return ret;
>>   }
>>
>> @@ -922,6 +956,30 @@ static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
>>       return 0;
>>   }
>>
>> +/*
>> + * On some hardware it is necessary to clear events accumulated by the EC during
>> + * sleep. These ECs stop reporting GPEs until they are manually polled, if too
>> + * many events are accumulated. (e.g. Samsung Series 5/9 notebooks)
>> + *
>> + * https://bugzilla.kernel.org/show_bug.cgi?id=44161
>> + *
>> + * Ideally, the EC should also be instructed not to accumulate events during
>> + * sleep (which Windows seems to do somehow), but the interface to control this
>> + * behaviour is not known at this time.
>> + *
>> + * Models known to be affected are Samsung 530Uxx/535Uxx/540Uxx/550Pxx/900Xxx,
>> + * however it is very likely that other Samsung models are affected.
>> + *
>> + * On systems which don't accumulate EC events during sleep, this extra check
>> + * should be harmless.
>> + */
>> +static int ec_clear_on_resume(const struct dmi_system_id *id)
>> +{
>> +    pr_debug("Detected system needing EC poll on resume.\n");
>> +    EC_FLAGS_CLEAR_ON_RESUME = 1;
>> +    return 0;
>> +}
>> +
>>   static struct dmi_system_id ec_dmi_table[] __initdata = {
>>       {
>>       ec_skip_dsdt_scan, "Compal JFL92", {
>> @@ -965,6 +1023,9 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
>>       ec_validate_ecdt, "ASUS hardware", {
>>       DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
>>       DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
>> +    {
>> +    ec_clear_on_resume, "Samsung hardware", {
>> +    DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
>>       {},
>>   };
>>
>>    
>
>

