Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbaJ2Wtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:49:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56434 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039AbaJ2Wtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:49:49 -0400
Message-ID: <54516F05.8050204@fb.com>
Date: Wed, 29 Oct 2014 16:49:41 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "Jason B. Akers" <jason.b.akers@intel.com>, <linux-ide@vger.kernel.org>,
        <dan.j.williams@intel.com>, <kapil.karkra@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox> <20141029201417.GK16186@dastard> <545157DB.70304@fb.com> <20141029220905.GL16186@dastard>
In-Reply-To: <20141029220905.GL16186@dastard>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-29_07:2014-10-29,2014-10-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410290228
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 04:09 PM, Dave Chinner wrote:
> On Wed, Oct 29, 2014 at 03:10:51PM -0600, Jens Axboe wrote:
>> On 10/29/2014 02:14 PM, Dave Chinner wrote:
>>> On Wed, Oct 29, 2014 at 11:23:38AM -0700, Jason B. Akers wrote:
>>>> The following series enables the use of Solid State hybrid drives
>>>> ATA standard 3.2 defines the hybrid information feature, which provides a means for the host driver to provide hints to the SSHDs to guide what to place on the SSD/NAND portion and what to place on the magnetic media.
>>>>
>>>> This implementation allows user space applications to provide the cache hints to the kernel using the existing ionice syscall. 
>>>>
>>>> An application can pass a priority number coding up bits 11, 12, and 15 of the ionice command to form a 3 bit field that encodes the following priorities:
>>>> 	OPRIO_ADV_NONE,
>>>> 	IOPRIO_ADV_EVICT, /* actively discard cached data */
>>>> 	IOPRIO_ADV_DONTNEED, /* caching this data has little value */
>>>> 	IOPRIO_ADV_NORMAL, /* best-effort cache priority (default) */
>>>> 	IOPRIO_ADV_RESERVED1, /* reserved for future use */
>>>> 	IOPRIO_ADV_RESERVED2,
>>>> 	IOPRIO_ADV_RESERVED3,
>>>> 	IOPRIO_ADV_WILLNEED, /* high temporal locality */
>>>>
>>>> For example the following commands from the user space will make dd IOs to be generated with a hint of IOPRIO_ADV_DONTNEED assuming the SSHD is /dev/sdc.
>>>>
>>>> ionice -c2 -n4096 dd if=/dev/zero of=/dev/sdc bs=1M count=1024
>>>> ionice -c2 -n4096 dd if=/dev/sdc of=/dev/null bs=1M count=1024
>>>
>>> This looks to be the wrong way to implement per-IO priority
>>> information.
>>>
>>> How does a filesystem make use of this to make sure it's
>>> metadata ends up with IOPRIO_ADV_WILLNEED to store frequently
>>> accessed metadata in flash. Conversely, journal writes need to
>>> be issued with IOPRIO_ADV_DONTNEED so they don't unneceessarily
>>> consume flash space as they are never-read IOs...
>>
>> Not disagreeing that loading more into the io priority fields is a
>> bit... icky. I see why it's done, though, it requires the least amount
>> of plumbing.
> 
> Yeah, but we don't do things the easy way just because it's easy. We
> do things the right way. ;)

Still not disagreeing with you, merely stating that I can see why they
chose to do it this way. Still doesn't change the fact that it feels
like a hack, not a designed solution.

>> As for the fs accessing this, the io nice fields are readily exposed
>> through the ->bi_rw setting. So while the above example uses ionice to
>> set a task io priority (that a bio will then inherit), nothing prevents
>> you from passing it in directly from the kernel.
> 
> Right, but now the filesystem needs to provide that on a per-inode
> basis, not from the task structure as the task that is submitting
> the bio is not necesarily the task doing the read/write syscall.

Whomever submits the bio would need to provide it, yes. And with the
disconnect for async writes, that becomes... interesting.

> e.g. the write case above doesn't actually inherit the task priority
> at the bio level at all because the IO is being dispatched by a
> background flusher thread, not the ioniced task calling write(2). 

Oh yes, I realize that.

> IMO using ionice is a nice hack, but utimately it looks mostly useless
> from a user and application perspective as cache residency is a
> property of the data being read/written, not the task doing the IO.
> e.g. a database will want it's indexes in flash and bulk
> data in non-cached storage.
> 
> IOWs, to make effective use of this the task will need different
> cache hints for each different type of data needs to do IO on, and
> so overloading IO priorities just seems the wrong direction to be
> starting from.

Agree.

-- 
Jens Axboe

