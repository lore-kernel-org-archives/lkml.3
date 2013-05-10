Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3EJOEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:04:50 -0400
Received: from MX2.LL.MIT.EDU ([129.55.12.46]:53779 "EHLO mx2.ll.mit.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3EJOEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:04:48 -0400
Message-ID: <518CFE7C.9080708@ll.mit.edu>
Date: Fri, 10 May 2013 10:04:44 -0400
From: David Oostdyk <daveo@ll.mit.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130412 Thunderbird/17.0.5
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: high-speed disk I/O is CPU-bound?
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-05-10_02:2013-05-10,2013-05-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=4 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1305100107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a few relatively high-end systems with hardware RAIDs which are 
being used for recording systems, and I'm trying to get a better 
understanding of contiguous write performance.

The hardware that I've tested with includes two high-end Intel E5-2600 
and E5-4600 (~3GHz) series systems, as well as a slightly older Xeon 
5600 system.  The JBODs include a 45x3.5" JBOD, a 28x3.5" JBOD (with 
either 7200RPM or 10kRPM SAS drives), and a 24x2.5" JBOD with 10kRPM 
drives.  I've tried LSI controllers (9285-8e, 9266-8i, as well as the 
integrated Intel LSI controllers) as well as Adaptec Series 7 RAID 
controllers (72405 and 71685).

Normally I'll setup the RAIDs as RAID60 and format them as XFS, but the 
exact RAID level, filesystem type, and even RAID hardware don't seem to 
matter very much from my observations (but I'm willing to try any 
suggestions).  As a basic benchmark, I have an application that simply 
writes the same buffer (say, 128MB) to disk repeatedly. Alternatively 
you could use the "dd" utility.  (For these benchmarks, I set 
/proc/sys/vm/dirty_bytes to 512M or lower, since these systems have a 
lot of RAM.)

The basic observations are:

1.  "single-threaded" writes, either a file on the mounted filesystem or 
with a "dd" to the raw RAID device, seem to be limited to 
1200-1400MB/sec.  These numbers vary slightly based on whether 
TurboBoost is affecting the writing process or not.  "top" will show 
this process running at 100% CPU.

2.  With two benchmarks running on the same device, I see aggregate 
write speeds of up to ~2.4GB/sec, which is closer to what I'd expect the 
drives of being able to deliver.  This can either be with two 
applications writing to separate files on the same mounted file system, 
or two separate "dd" applications writing to distinct locations on the 
raw device.  (Increasing the number of writers beyond two does not seem 
to increase aggregate performance; "top" will show both processes 
running at perhaps 80% CPU).

3.  I haven't been able to find any tricks (lio_listio, multiple threads 
writing to distinct file offsets, etc) that seem to deliver higher write 
speeds when writing to a single file.  (This might be xfs-specific, though)

4.  Cheap tricks like making a software RAID0 of two hardware RAID 
devices does not deliver any improved performance for single-threaded 
writes.  (Have not thoroughly tested this configuration fully with 
multiple writers, though.)

5.  Similar hardware on Windows seems to be able to deliver >3GB/sec 
write speeds on a single-threaded writes, and the trick of making a 
software RAID0 of two hardware RAIDs does deliver increased write 
speeds.  (I only point this out to say that I think the hardware is not 
necessarily the bottleneck.)

The question is, is it possible that high-speed I/O to these hardware 
RAIDs could actually be CPU-bound above ~1400MB/sec?

It seems to be the only explanation of the benchmarks that I've been 
seeing, but I don't know where to start looking to really determine the 
bottleneck.  I'm certainly open to suggestions to running different 
configurations or benchmarks.

Thanks for any help/advice!
Dave O.

