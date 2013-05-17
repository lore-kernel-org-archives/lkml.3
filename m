Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3EQL4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:56:20 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:16900 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3EQL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:56:19 -0400
Message-ID: <51961AE6.1010106@hardwarefreak.com>
Date: Fri, 17 May 2013 06:56:22 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: David Oostdyk <daveo@ll.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: high-speed disk I/O is CPU-bound?
References: <518CFE7C.9080708@ll.mit.edu> <20130516005913.GE24635@dastard> <5194C4BB.9080406@hardwarefreak.com> <5194FCAC.1010300@ll.mit.edu> <20130516225656.GG24635@dastard>
In-Reply-To: <20130516225656.GG24635@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/2013 5:56 PM, Dave Chinner wrote:
> On Thu, May 16, 2013 at 11:35:08AM -0400, David Oostdyk wrote:
>> On 05/16/13 07:36, Stan Hoeppner wrote:
>>> On 5/15/2013 7:59 PM, Dave Chinner wrote:
>>>> [cc xfs list, seeing as that's where all the people who use XFS in
>>>> these sorts of configurations hang out. ]
>>>>
>>>> On Fri, May 10, 2013 at 10:04:44AM -0400, David Oostdyk wrote:
>>>>> As a basic benchmark, I have an application
>>>>> that simply writes the same buffer (say, 128MB) to disk repeatedly.
>>>>> Alternatively you could use the "dd" utility.  (For these
>>>>> benchmarks, I set /proc/sys/vm/dirty_bytes to 512M or lower, since
>>>>> these systems have a lot of RAM.)
>>>>>
>>>>> The basic observations are:
>>>>>
>>>>> 1.  "single-threaded" writes, either a file on the mounted
>>>>> filesystem or with a "dd" to the raw RAID device, seem to be limited
>>>>> to 1200-1400MB/sec.  These numbers vary slightly based on whether
>>>>> TurboBoost is affecting the writing process or not.  "top" will show
>>>>> this process running at 100% CPU.
>>>> Expected. You are using buffered IO. Write speed is limited by the
>>>> rate at which your user process can memcpy data into the page cache.
>>>>
>>>>> 2.  With two benchmarks running on the same device, I see aggregate
>>>>> write speeds of up to ~2.4GB/sec, which is closer to what I'd expect
>>>>> the drives of being able to deliver.  This can either be with two
>>>>> applications writing to separate files on the same mounted file
>>>>> system, or two separate "dd" applications writing to distinct
>>>>> locations on the raw device.
>>> 2.4GB/s is the interface limit of quad lane 6G SAS.  Coincidence?  If
>>> you've daisy chained the SAS expander backplanes within a server chassis
>>> (9266-8i/72405), or between external enclosures (9285-8e/71685), and
>>> have a single 4 lane cable (SFF-8087/8088/8643/8644) connected to your
>>> RAID card, this would fully explain the 2.4GB/s wall, regardless of how
>>> many parallel processes are writing, or any other software factor.
>>>
>>> But surely you already know this, and you're using more than one 4 lane
>>> cable.  Just covering all the bases here, due to seeing 2.4 GB/s as the
>>> stated wall.  This number is just too coincidental to ignore.
>>
>> We definitely have two 4-lane cables being used, but this is an
>> interesting coincidence.  I'd be surprised if anyone could really
>> achieve the theoretical throughput on one cable, though.  We have
>> one JBOD that only takes a single 4-lane cable, and we seem to cap
>> out at closer to 1450MB/sec on that unit.  (This is just a single
>> point of reference, and I don't have many tests where only one
>> 4-lane cable was in use.)
> 
> You can get pretty close to the theoretical limit on the back end
> SAS cables - just like you can with FC.

Yep.

> What I'd suggest you do is look at the RAID card configuration -
> often they default to active/passive failover configurations when
> there are multiple channels to the same storage. Then hey only use
> one of the cables for all traffic. Some RAID cards offer
> ative/active or "load balanced" options where all back end paths are
> used in redundant configurations rather than just one....

Also read the docs for your JBOD chassis.  Some have a single expander
module with 2 host ports while some have two such expanders for
redundancy and have 4 total host ports.  The latter requires dual ported
drives.  In this config you'd use one host port on each expander and
configure the RAID HBA for multipathing.  (It may be possible to use all
4 host ports in this setup but this requires a RAID HBA with 4 external
4 lane connectors.  I'm not aware of any at this time, nut only two port
models.  So you'd have to use two non-RAID HBAs each with two 4 lane
ports, SCSI multipath, and Linux md/RAID.)

Most JBODs that use the LSI 2x36 expander ASIC will give you full b/w
over two host ports in a single expander single chassis config.  Other
JBODs may direct wire one of the two host port to the expansion port so
you may only get full 8 lane host bandwidth with an expansion unit
attached.  There are likely other configurations I'm not aware of.

>> You guys hit the nail on the head!  With O_DIRECT I can use a single
>> writer thread and easily see the same throughput that I _ever_ saw
>> in the multiple-writer case (~2.4GB/sec), and "top" shows the writer
>> at 10% CPU usage.  I've modified my application to use O_DIRECT and
>> it makes a world of difference.
> 
> Be aware that O_DIRECT is not a magic bullet. It can make your IO
> go a lot slower on some worklaods and storage configs....
>
>> [It's interesting that you see performance benefits for O_DIRECT
>> even with a single SATA drive.  

The single SATA drive has little to do with it actually.  It's the
limited CPU/RAM bus b/w of the box.  The reason O_DIRECT shows a 78%
improvement in disk throughput is a direct result of dramatically
decreased memory pressure, allowing full speed DMA from RAM to the HBA
over the PCI bus.  The pressure caused by the mem-mem copying of
buffered IO causes every read in the CPU to be a cache miss, further
exacerbating the load on the CPU/RAM buses.  All the memory reads cause
extra CPU bus snooping to update the L2s.  The constant cache misses and
resulting waits on memory reads are what drive the CPU to 98% utilization.

>> The reason it took me so long to
>> test O_DIRECT in this case, is that I never saw any significant
>> benefit from using it in the past.  But that is when I didn't have
>> such fast storage, so I probably wasn't hitting the bottleneck with
>> buffered I/O?]
> 
> Right - for applications not designed to use direct IO from the
> ground up, this is typically the case - buffered IO is faster right
> up to the point where you run out of CPU....

Or memory bandwidth, which in turn runs you out of CPU.

-- 
Stan

