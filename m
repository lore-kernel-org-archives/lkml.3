Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935379Ab3DKNey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:34:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45589 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab3DKNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:34:52 -0400
Message-ID: <5166BBFB.5030200@console-pimps.org>
Date: Thu, 11 Apr 2013 14:34:51 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Tony Luck <tony.luck@intel.com>, Mike Waychison <mikew@google.com>
Subject: Re: [PATCH 3/6] efivars: efivar_entry API
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <1365077935-6859-4-git-send-email-matt@console-pimps.org> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8CFEE@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8CFEE@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 16:25, Seiji Aguchi wrote:
>> +	if (efi_guidcmp(entry->var.VendorGuid, vendor))
>> +		return 0;
>> +
>> +	for (i = 0; i < DUMP_NAME_LEN; i++)
>> +		name[i] = entry->var.VariableName[i];
>> +
>> +	if (sscanf(name, "dump-type%u-%u-%d-%lu",
>> +		   cb_data->type, &part, &cnt, &time) == 4) {
>> +		*cb_data->id = part;
>> +		*cb_data->count = cnt;
>> +		cb_data->timespec->tv_sec = time;
>> +		cb_data->timespec->tv_nsec = 0;
>> +	} else if (sscanf(name, "dump-type%u-%u-%lu",
>> +			  cb_data->type, &part, &time) == 3) {
>> +		/*
>> +		 * Check if an old format,
>> +		 * which doesn't support holding
>> +		 * multiple logs, remains.
>> +		 */
>> +		*cb_data->id = part;
>> +		*cb_data->count = 0;
>> +		cb_data->timespec->tv_sec = time;
>> +		cb_data->timespec->tv_nsec = 0;
>> +	} else
>> +		return 0;
>> +
>> +	efivar_entry_size(entry, &size);
> 
> Deadlocking will happen in this efivar_entry_size() because __efivars->lock is already hold 
> in efivar_entry_iter_begin().

Good catch, thanks.

>> @@ -1419,81 +1229,90 @@ static int efi_pstore_write(enum pstore_type_id type,
>>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>>  		efi_name[i] = name[i];
>>
>> -	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
>> -				   size, psi->buf);
>> +	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
>> +				    !pstore_cannot_block_path(reason),
>> +				    size, psi->buf);
>>
>> -	spin_unlock_irqrestore(&efivars->lock, flags);
>> -
>> -	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
>> +	if (size && !ret && reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
> 
> Why do you add (size && !ret) checking?
> If the purpose of this patch is just adding new API, we don't need to modify the logic.

That looks like a bug that slipped in. I'll fix it. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
