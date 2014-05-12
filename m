Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbaELPIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:08:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42866 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758432AbaELPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:08:18 -0400
Message-ID: <5370E3E0.4050109@fb.com>
Date: Mon, 12 May 2014 09:08:16 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Avoid always dirtying mapping->flags on O_DIRECT
References: <20140509213907.GA20698@kernel.dk> <x49r43z837o.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49r43z837o.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-12_01:2014-05-12,2014-05-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.997696947966296 urlsuspect_oldscore=0.997696947966296
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997696947966296 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405120200
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 08:46 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@fb.com> writes:
> 
>> Hi,
>>
>> In some testing I ran today, we end up spending 40% of the time in
>> filemap_check_errors(). That smells fishy. Looking further, this is
>> basically what happens:
>>
>> blkdev_aio_read()
>>     generic_file_aio_read()
>>         filemap_write_and_wait_range()
>>             if (!mapping->nr_pages)
>>                 filemap_check_errors()
>>
>> and filemap_check_errors() always attempts two test_and_clear_bit() on
>> the mapping flags, thus dirtying it for every single invocation. The
>> patch below tests each of these bits before clearing them, avoiding this
>> issue. In my test case (4-socket box), performance went from 1.7M IOPS
>> to 4.0M IOPS.
> 
> It might help to use the word cacheline somewhere in here.  ;-) Out of

I thought that was self-evident, but yes, I could add that :-)

> curiosity, what workload were you running?

Nothing fancy, just some fio jobs that spread over two nodes.


