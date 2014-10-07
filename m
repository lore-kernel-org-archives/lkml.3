Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaJGKaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:30:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63369 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaJGKaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:30:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f5-b7f776d000003e54-e7-5433c0a569bf
Content-transfer-encoding: 8BIT
Message-id: <5433C0A3.1020302@samsung.com>
Date: Tue, 07 Oct 2014 12:29:55 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
To: Michal Nazarewicz <mina86@mina86.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        k.opasiak@samsung.com
Subject: Re: [PATCH v2] usb: gadget: f_fs: add "zombie" mode
References: <1412668742-14831-1-git-send-email-r.baldyga@samsung.com>
 <xa1t61fwyyz6.fsf@mina86.com>
In-reply-to: <xa1t61fwyyz6.fsf@mina86.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xK7pLDxiHGFz5r2gx62U7i8XB+/UW
	zYvXs1ncnjiNzeLyrjlsFouWtTJbLDjewurA7rF/7hp2j3V/XjF59G1Zxehx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mj7MucdW8E+0ov/TJ6YGxrcCXYycHBICJhKPm3cwQdhiEhfurWfr
	YuTiEBJYyihxseMCG0iCV0BQ4sfkeyxdjBwczALyEkcuZUOY6hJTpuRClH9klLjQ/owJJM4r
	oCVx5JUbSCeLgKrE4i+3GUFsNgEdiS3fJ4DZogIREifv7mEHsUUEzCVO/F3BAjKHWaCdUWJx
	SwMzSEJYwEbizYY2MFtIIFXixqKHrCA2J9D8joVLmScwCsxCct0shOtmIVy3gJF5FaNoamly
	QXFSeq6RXnFibnFpXrpecn7uJkZIcH/dwbj0mNUhRgEORiUe3hVaxiFCrIllxZW5hxglOJiV
	RHhX7AcK8aYkVlalFuXHF5XmpBYfYmTi4JRqYPTiVMh6sdlBc+r2Yu6T1yViDy1V0rowKXyO
	xfNvK7i0vOcuvOPyfcKmNwdvMvrd7TtT7LfrvnxF8L1duptEjC0nbj4ukiBWe2bu5se9T7bd
	3SH4441O9Kf3LJ+WB19ZF1i6ZPsqfhbz/UsvyDJVG06/Guc9M/+/3e/fNdP+Wf63brN4lDZ5
	hSC3EktxRqKhFnNRcSIACO9/SEwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 12:07 PM, Michal Nazarewicz wrote:
> On Tue, Oct 07 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
>> @@ -1411,8 +1425,17 @@ static void ffs_data_closed(struct ffs_data *ffs)
>>  	ENTER();
>>  
>>  	if (atomic_dec_and_test(&ffs->opened)) {
>> -		ffs->state = FFS_CLOSING;
>> -		ffs_data_reset(ffs);
>> +		if (ffs->zombie_mode) {
>> +			ffs->state = FFS_ZOMBIE;
>> +			if (ffs->epfiles)
>> +				ffs_epfiles_delete(ffs->epfiles,
>> +						   ffs->eps_count);
> 
> This looks suspicious.  Why isn't it:
> 
> +			if (ffs->epfiles) {
> +				ffs_epfiles_destroy(ffs->epfiles,
> +						   ffs->eps_count);
> +				ffs->epfiles = NULL;
> +			}
> 
> If ffs->epfiles is not NULLed, call to ffs_data_reset in ffs_data_open
> will call ffs_epfiles_destroy which we don't want, do we?
> 

We do. When epfile->dentry == NULL, ffs_epfiles_destroy() will do only
kfree(epfiles). We want to do it.

We don't want to have ffs->epfiles being equal NULL before calling
ffs_func_eps_disable(), which iterates on this table.

Hmm, we could also change ffs_func_eps_disable() to not touch
ffs->epfiles if it's NULL. It seems to be better solution.

>> +			if (ffs->setup_state == FFS_SETUP_PENDING)
>> +				__ffs_ep0_stall(ffs);
>> +		} else {
>> +			ffs->state = FFS_CLOSING;
>> +			ffs_data_reset(ffs);
>> +		}
>>  	}
>>  
>>  	ffs_data_put(ffs);
> 
>> @@ -93,6 +93,26 @@ enum ffs_state {
>>  	FFS_ACTIVE,
>>  
>>  	/*
>> +	 * Function is visible to host, but it's not functional. All
>> +	 * setup requests are stalled and another transfers are refused.
> 
> “and transfers on other endpoints are refused.”
> 
>> +	 * All epfiles, excepting ep0, are deleted so there is no way
> 
> s/excepting/except/
> 
>> +	 * to perform any operations on them.
>> +	 *
>> +	 * This state is set after closing all functionfs files, when
>> +	 * mount parameter "zombie=1" has been set. Function will remain
>> +	 * in zombie state until filesystem will be umounted or ep0 will
> 
> s/will be umounted/is unmounted/
> s/ep0 will be/ep0 is/
> 
>> +	 * be opened again. In the second case functionfs state will be
>> +	 * reseted, and it will be ready for descriptors and strings
> 
> s/reseted/reset/
> 
>> +	 * writing.
>> +	 *
>> +	 * This is useful only when functionfs is composed to gadget
>> +	 * with another function which can perform some critical
>> +	 * operations, and it's strongly desired to have this operations
>> +	 * completed, even after functionfs files closure.
>> +	 */
>> +	FFS_ZOMBIE,
>> +
>> +	/*
>>  	 * All endpoints have been closed.  This state is also set if
>>  	 * we encounter an unrecoverable error.  The only
>>  	 * unrecoverable error is situation when after reading strings
> 

Thanks,
Robert Baldyga
