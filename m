Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbbATVuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:50:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2849 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbbATVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:16 -0500
Message-ID: <54BECD89.7030404@fb.com>
Date: Tue, 20 Jan 2015 14:50:01 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@infradead.org>
CC: Tony Luck <tony.luck@gmail.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] block: Remove annoying "unknown partition table" message
References: <54AD5893.9040701@plexistor.com> <54AD59DC.4020703@plexistor.com> <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com> <54B99591.7080007@fb.com> <54BBB048.7010207@plexistor.com> <20150118151059.GA17263@infradead.org> <54BBD225.3080200@plexistor.com> <54BBD5D7.6000802@plexistor.com>
In-Reply-To: <54BBD5D7.6000802@plexistor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-20_06:2015-01-20,2015-01-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-17 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.182402046397986
 urlsuspect_oldscore=0.182402046397986 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501200210
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 08:48 AM, Boaz Harrosh wrote:
> On 01/18/2015 05:32 PM, Boaz Harrosh wrote:
>> From: Boaz Harrosh <boaz@plexistor.com>
>>
>> As Christoph put it best:
>>   Can we just get rid of the warnings?  It's fairly annoying as devices
>>   without partitions are perfectly fine and very useful.
>>
>> Me too I see this message every VM boot for ages on all my
>> devices. Would love to just remove it. For me a partition-table
>> is only needed for a booting BIOS, grub, and stuff.
>>
>> (NOT Yet Tested)
>>
>> CC: Christoph Hellwig <hch@infradead.org>
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>> ---
>>  block/partitions/check.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/block/partitions/check.c b/block/partitions/check.c
>> index 9ac1df7..e3a9077 100644
>> --- a/block/partitions/check.c
>> +++ b/block/partitions/check.c
>> @@ -184,9 +184,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
>>  	if (err)
>>  	/* The partition is unrecognized. So report I/O errors if there were any */
>>  		res = err;
>> -	if (!res)
>> -		strlcat(state->pp_buf, " unknown partition table\n", PAGE_SIZE);
>> -	else if (warn_no_part)
>> +	if (warn_no_part)
>>  		strlcat(state->pp_buf, " unable to read partition table\n", PAGE_SIZE);
>>  
>>  	printk(KERN_INFO "%s", state->pp_buf);
>>
> 
> Off course that was untested crap something like:
> ---
> diff --git a/block/partitions/check.c b/block/partitions/check.c
> index 9ac1df7..16118d1 100644
> --- a/block/partitions/check.c
> +++ b/block/partitions/check.c
> @@ -184,12 +184,12 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
>  	if (err)
>  	/* The partition is unrecognized. So report I/O errors if there were any */
>  		res = err;
> -	if (!res)
> -		strlcat(state->pp_buf, " unknown partition table\n", PAGE_SIZE);
> -	else if (warn_no_part)
> -		strlcat(state->pp_buf, " unable to read partition table\n", PAGE_SIZE);
> -
> -	printk(KERN_INFO "%s", state->pp_buf);
> +	if (res) {
> +		if (warn_no_part)
> +			strlcat(state->pp_buf,
> +				" unable to read partition table\n", PAGE_SIZE);
> +		printk(KERN_INFO "%s", state->pp_buf);
> +	}
>  
>  	free_page((unsigned long)state->pp_buf);
>  	free_partitions(state);
> ---
> Not-Signed-off-yet: Boaz Harrosh <boaz@plexistor.com>

Were you going to send a tested patch with the commit message?

-- 
Jens Axboe

