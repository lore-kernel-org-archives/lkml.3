Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaB0DbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:31:09 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:56031 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaB0DbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:31:06 -0500
Message-ID: <530EB176.1050402@gmail.com>
Date: Thu, 27 Feb 2014 00:31:02 -0300
From: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Li Guang <lig.fnst@cn.fujitsu.com>
CC: Kieran Clancy <clancy.kieran@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <530E9BEF.8080601@cn.fujitsu.com> <530EA3E5.3010102@gmail.com> <530EAD92.6020807@cn.fujitsu.com>
In-Reply-To: <530EAD92.6020807@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 12:14 AM, Li Guang wrote:
> oh, sorry, I'm referring internal EC firmware code
> for Q event queuing, not ACPI SPEC, ;-)
> for machine you tested, 8 is the queue size,
> but for some unknown also nasty EC firmwares(let's suppose it exists),
> it may queue more Q events.
> and I saw several firmwares queued 32 events by default,
> then, let's say, they be used for some samsung products,
> and also they also forgot to deal with sleep/resume state,
> then, we'll also leave stale Q event there.
>
> Thanks!
>

We tested each on our different samsung models (intel, amd), and it
was 8 across. But you're right, there might be more in the future.

     I even saw a bug report in ubuntu's launchpad of an HP with a similar
sounding problem, ( https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/89860 )
which I have no idea if it was caused by the same issue, but if in the future,
the flag ec_clear_on_resume is used to match other DMI's, it might
be a good idea to make the max iteration count bigger.

      The only reason that there is a max iteration count, was to prevent
an unexpected case in which an unknown EC never returns 0 after
queue emptied. So far it hasn't been the case. Can we count on it?.
The loop currently does finish early when there are no more events.

I guess changing it 255 or 1000 would be enough, right?

Cheers!
-- 
Juan Manuel Cabo<juanmanuel.cabo@gmail.com>



>>      For us, a query is just: send 0x84 through EC CMD port, and read status
>> from CMD port and event type from EC DATA port. This is done with
>> the usual ec.c functions that would handle a query after a GPE interrupt,
>> but using them instead to poll (not GPE initiated) at awake. The EC would
>> then return status without 0x20 mask and 'event type'==0 when no more left.
>>
>> -- 
>> Juan Manuel Cabo<juanmanuel.cabo@gmail.com>
>>
>>
>>
>>   
>>>>    enum {
>>>>        EC_FLAGS_QUERY_PENDING,        /* Query is pending */
>>>> @@ -116,6 +118,7 @@ EXPORT_SYMBOL(first_ec);
>>>>    static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
>>>>    static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
>>>>    static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
>>>> +static int EC_FLAGS_CLEAR_ON_RESUME; /* EC should be polled on boot/resume */
>>>>
>>>>        
>>> seems name is implicit, what about EC_FLAGS_QEVENT_CLR_ON_RESUME?
>>> seems too long :-)
>>>
>>>     
>>>>    /* --------------------------------------------------------------------------
>>>>                                 Transaction Management
>>>> @@ -440,6 +443,26 @@ acpi_handle ec_get_handle(void)
>>>>
>>>>    EXPORT_SYMBOL(ec_get_handle);
>>>>
>>>> +static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
>>>> +
>>>> +/* run with locked ec mutex */
>>>> +static void acpi_ec_clear(struct acpi_ec *ec)
>>>> +{
>>>> +    int i, status;
>>>> +    u8 value = 0;
>>>> +
>>>> +    for (i = 0; i<   ACPI_EC_CLEAR_MAX; i++) {
>>>> +        status = acpi_ec_query_unlocked(ec,&value);
>>>> +        if (status || !value)
>>>> +            break;
>>>> +    }
>>>> +
>>>> +    if (i == ACPI_EC_CLEAR_MAX)
>>>> +        pr_warn("Warning: Maximum of %d stale EC events cleared\n", i);
>>>> +    else
>>>> +        pr_info("%d stale EC events cleared\n", i);
>>>> +}
>>>> +
>>>>    void acpi_ec_block_transactions(void)
>>>>    {
>>>>        struct acpi_ec *ec = first_ec;
>>>> @@ -463,6 +486,10 @@ void acpi_ec_unblock_transactions(void)
>>>>        mutex_lock(&ec->mutex);
>>>>        /* Allow transactions to be carried out again */
>>>>        clear_bit(EC_FLAGS_BLOCKED,&ec->flags);
>>>> +
>>>> +    if (EC_FLAGS_CLEAR_ON_RESUME)
>>>> +        acpi_ec_clear(ec);
>>>> +
>>>>        mutex_unlock(&ec->mutex);
>>>>    }
>>>>
>>>> @@ -821,6 +848,13 @@ static int acpi_ec_add(struct acpi_device *device)
>>>>
>>>>        /* EC is fully operational, allow queries */
>>>>        clear_bit(EC_FLAGS_QUERY_PENDING,&ec->flags);
>>>> +
>>>> +    /* Some hardware may need the EC to be cleared before use */
>>>>
>>>>        
>>> description is implicit, should specify what we clear is Q event, not EC.
>>>
>>> Thanks!
>>> Li Guang
>>>
>>>     
>>>> +    if (EC_FLAGS_CLEAR_ON_RESUME) {
>>>> +        mutex_lock(&ec->mutex);
>>>> +        acpi_ec_clear(ec);
>>>> +        mutex_unlock(&ec->mutex);
>>>> +    }
>>>>        return ret;
>>>>    }
>>>>
>>>> @@ -922,6 +956,30 @@ static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
>>>>        return 0;
>>>>    }
>>>>
>>>> +/*
>>>> + * On some hardware it is necessary to clear events accumulated by the EC during
>>>> + * sleep. These ECs stop reporting GPEs until they are manually polled, if too
>>>> + * many events are accumulated. (e.g. Samsung Series 5/9 notebooks)
>>>> + *
>>>> + * https://bugzilla.kernel.org/show_bug.cgi?id=44161
>>>> + *
>>>> + * Ideally, the EC should also be instructed not to accumulate events during
>>>> + * sleep (which Windows seems to do somehow), but the interface to control this
>>>> + * behaviour is not known at this time.
>>>> + *
>>>> + * Models known to be affected are Samsung 530Uxx/535Uxx/540Uxx/550Pxx/900Xxx,
>>>> + * however it is very likely that other Samsung models are affected.
>>>> + *
>>>> + * On systems which don't accumulate EC events during sleep, this extra check
>>>> + * should be harmless.
>>>> + */
>>>> +static int ec_clear_on_resume(const struct dmi_system_id *id)
>>>> +{
>>>> +    pr_debug("Detected system needing EC poll on resume.\n");
>>>> +    EC_FLAGS_CLEAR_ON_RESUME = 1;
>>>> +    return 0;
>>>> +}
>>>> +
>>>>    static struct dmi_system_id ec_dmi_table[] __initdata = {
>>>>        {
>>>>        ec_skip_dsdt_scan, "Compal JFL92", {
>>>> @@ -965,6 +1023,9 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
>>>>        ec_validate_ecdt, "ASUS hardware", {
>>>>        DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
>>>>        DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
>>>> +    {
>>>> +    ec_clear_on_resume, "Samsung hardware", {
>>>> +    DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
>>>>        {},
>>>>    };
>>>>
>>>>
>>>>        
>>>
>>>      
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>    
>
>

