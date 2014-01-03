Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaACS0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:26:17 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52673 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaACS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:26:13 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-58-52c700c45039
Message-id: <52C700BC.1010200@samsung.com>
Date: Fri, 03 Jan 2014 11:26:04 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
 <20131230141511.GC2799@8bytes.org>
In-reply-to: <20131230141511.GC2799@8bytes.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX90jDMeDDNaulrOYs34Nm8XJZb+Z
	LTpnb2C3uLxrDpvF158ODqweTw7OY/LYOesuu8fiPS+ZPE7M+M3i8XmTXABrFJdNSmpOZllq
	kb5dAlfGrH7lgkahivb9UxgbGPfxdTFycEgImEhcnh7VxcgJZIpJXLi3nq2LkYtDSGAZo8TT
	6ZeYIZxeJokTaz9BORsZJWbMe80M0sIroCVxbMZrFhCbRUBV4mbzD7A4m4C6xOfXO9hBbCEB
	OYmmJavB4qICERKvzk5kgegVlPgx+R6YLSKgJHH9cysryAJmgSmMEu0N01lBEsICSRLT5s9n
	ghiUITG7aysjiM0poC9x5/wDsBpmAWuJlZO2MULY8hKb17xlhqhXlvhz+RQTxJuKEttXW01g
	FJmFZPUsJN2zkHQvYGRexShWWpxcUJyUnlphrFecmFtcmpeul5yfu4kREjE1OxjvfbU5xCjA
	wajEw5tx8liQEGtiWXFl7iFGCQ5mJRHewDdAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw5E7ia
	Vjzn+Kj6suzcRb/Ug/s7pJffrX978+aGNRpJUe53nZcFXXj/c+bcbaL7hGT0bTq3M6U/eDFp
	6V9rRQY247o9ckZL9ctDrdTSOUxCG1X+btfN6Ys7MvPLj4q6S1aLJ35+8fLzFJZP779cPnri
	TZh9rQfb8arn5wUC7kyyCn5xyccx7+hWJZbijERDLeai4kQAbuP+QHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 07:15 AM, Joerg Roedel wrote:
> On Wed, Nov 13, 2013 at 01:56:08PM -0700, Shuah Khan wrote:
>> dma-debug checks to verify if driver validated the address returned by
>> dma mapping routines when driver does unmap. If a driver doesn't call
>> unmap, failure to check mapping errors isn't detected and reported.
>>
>> Enhancing existing bus notifier_call dma_debug_device_change() to check
>> for mapping errors at the same time it detects leaked dma buffers for
>> BUS_NOTIFY_UNBOUND_DRIVER event. It scans for mapping errors and if any
>> found, prints one warning message that includes mapping error count.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   lib/dma-debug.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
>> index d87a17a..e34865e 100644
>> --- a/lib/dma-debug.c
>> +++ b/lib/dma-debug.c
>> @@ -717,6 +717,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
>>   	struct dma_debug_entry *entry;
>>   	unsigned long flags;
>>   	int count = 0, i;
>> +	int map_err_cnt = 0;
>>
>>   	local_irq_save(flags);
>>
>> @@ -724,6 +725,8 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
>>   		spin_lock(&dma_entry_hash[i].lock);
>>   		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
>>   			if (entry->dev == dev) {
>> +				if (entry->map_err_type == MAP_ERR_NOT_CHECKED)
>> +					map_err_cnt += 1;
>>   				count += 1;
>>   				*out_entry = entry;
>
> I think it is better to check for this in a seperate function and use
> err_printk instead of dev_warn in the end to print the errors.
> The new function can then be called in the dma_debug_device_change
> callback like device_dma_allocations is.
>

I did explore separate function option and backed off from it since the 
new routine will have to duplicate what device_dma_allocations() does 
except that it checks for entry->map_err_type.

I still have the patch that does that saved away. If you still prefer 
that approach, I can rework the patch and send it.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
