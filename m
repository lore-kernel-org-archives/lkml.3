Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbbAVVMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:12:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41651 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbbAVVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:12:38 -0500
Message-ID: <54C167D1.8080502@fb.com>
Date: Thu, 22 Jan 2015 14:12:49 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [block] 34b48db66e0: +3291.6% iostat.sde.wrqm/s
References: <1421889689.6126.45.camel@intel.com> <54C08CA6.8050101@fb.com>	<x49zj9a9073.fsf@segfault.boston.devel.redhat.com>	<54C1494D.5050507@fb.com>	<x49fvb28rrm.fsf@segfault.boston.devel.redhat.com>	<54C1647A.3090804@fb.com> <x497fwe8qwo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497fwe8qwo.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_08:2015-01-22,2015-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501220194
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 02:08 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@fb.com> writes:
> 
>> On 01/22/2015 01:49 PM, Jeff Moyer wrote:
>>> Jens Axboe <axboe@fb.com> writes:
>>>
>>>>> Agreed on all above, but are the actual benchmark numbers included
>>>>> somewhere in all this mess?  I'd like to see if the benchmark numbers
>>>>> improved first, before digging into the guts of which functions are
>>>>> called more or which stats changed.
>>>>
>>>> I deleted the original email, but the latter tables had drive throughput
>>>> rates and it looked higher for the ones I checked on the newer kernel.
>>>> Which the above math would indicate as well, multiplying reqs-per-sec
>>>> and req-size.
>>>
>>> Looking back at the original[1], I think I see the throughput numbers for
>>> iozone.  The part that confused me was that each table mixes different
>>> types of data.  I'd much prefer if different data were put in different
>>> tables, along with column headers that stated what was being reported
>>> and the units for the measurements.
>>>
>>> Anyway, I find the increased service time troubling, especially this
>>> one:
>>>
>>> testbox/testcase/testparams: ivb44/fsmark/performance-1x-1t-1HDD-xfs-4M-60G-NoSync
>>>
>>>        544 ?  0%   +1268.9%       7460 ?  0%  iostat.sda.w_await
>>>        544 ?  0%   +1268.5%       7457 ?  0%  iostat.sda.await
>>>
>>> I'll add this to my queue of things to look into.
>>
>> From that same table:
>>
>>       1009 ±  0%   +1255.7%      13682 ±  0%  iostat.sda.avgrq-sz
>>
>> the average request size has gone up equally. This is clearly a streamed
>> oriented benchmark, if the IOs get that big.
> 
> Hmm, ok, I'll buy that.  However, I am surprised that the relationship
> between i/o size and service time is 1:1 here...

Should be pretty close to 1:1, given that the smaller requests are still
sequential. And we're obviously doing a well enough job not to service
them out of sequence.

My original worry on bumping max_sectors was that we'd introduce slower
bubbles in the pipeline, for eg interleaved IO patterns where one does
large streamed IO and the other small non sequential. So it'd be
interesting to see a test for something like that.

-- 
Jens Axboe

