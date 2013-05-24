Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab3EXJUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:20:20 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:55824 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755873Ab3EXJUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:20:17 -0400
X-ASG-Debug-ID: 1369387214-053ea947e8b85e0001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
To: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
CC: Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: EnhanceIO(TM) caching driver features [1/3]
Thread-Topic: EnhanceIO(TM) caching driver features [1/3]
X-ASG-Orig-Subj: EnhanceIO(TM) caching driver features [1/3]
Thread-Index: Ac5YX7JuBwqZqug8TSO0+2mX9HFy+Q==
Date: Fri, 24 May 2013 09:18:50 +0000
Message-ID: <A44CB407BBB85C498149811C52498A450872D9@MYMBX3.stec-inc.ad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1369387214
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.131874
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens and Kernel Gurus,

We are submitting EnhanceIO(TM) caching driver for an inclusion in Linux kernel. It's an enterprise grade caching solution having been validated extensively in-house, in a large number of enterprise installations. It features this distinct property not found in dm-cache or bcache. EnhanceIO(TM) caching solution has been reported to offer a substantial performance over a RAID source device in various types of applications - file servers, relational and object databases, replication engines, web hosting, messaging and more. EnhanceIO(TM) caching solution has been proven in independent testing, such as testing by Demartek.

We believe that EnhanceIO(TM) driver will add a substantial value to Linux kernel by letting customers exploit SSDs to their full potential. We would like you to consider it for an inclusion in the kernel.

Thanks.
--
Amit Kale

Features and capabilities are described below. Patch is being submitted in another email.

1. User interface

There are commands for creation and deletion of caches and editing of cache parameters.

2. Software interface

This kernel driver uses block device interface to receive IOs submitted by upper layers like filesystems or applications and submit IOs to HDD and SSDs. There is full transparency from upper layers' viewpoint.

3. Availability
Caches can be created and deleted while applications are online. So absolutely no downtime. Crash recovery is in milliseconds. Error recovery times depend on the kind of errors. Caches continue working without a downtime for intermittent errors.

4. Security
Cache operations require root privilege. IO operations are done at block layer, which is implicitly protected using device node level access control.


5. Portability
It works with all any HDD or SSD that supports Linux block layer interface. So it's device agnostic. We have tested Linux x86 32 and 64 bit configurations. We have compiled it for big-endian machines, although haven't tested in that configuration.

6. Persistence of cache configuration
Cache configuration can be made persistent through startup scripts.

7. Persistence of cached data
Cached data can be made persistent. There is an option to make it volatile only for abrupt shutdowns or reboots. This is to prevent the HDD and the SSD for a cache going out of sync, say in enterprise environments. There a large number of HDDs and SSDs may be accessed by a number of servers through a switch.

8. SSD life
An administrator has an option to choose a cache mode appropriate for desired SSD life. SSD life depends on the number of writes. These are defined by a cache mode: read-only (R1, W0), write-through (R1, W1), write-back (R1, W1 + MD writes).

9. Performance
EnhanceIO(TM) driver through put is equal to SSD throughput for 100% cache hits. No difference is measurable within the error margins of throughput measurement. Throughput generally depends on cache hit rate and is between HDD and SSD through put. Interestingly throughput can also be higher than SSD for a few test cases.


10. ACID properties

EnhanceIO(TM) metadata layout does not contain a journal or a shadow-page update capability, which are typical mechanisms to ensure atomicity. Write-back feature instead has been developed on the basis of safe sequence of SSD operations. A safe sequence is explained as follows - A cache operation may involve multiple block writes. A sequence of block writes is safe when executing only first few of them does not result in inconsistencies. If the sequence involves two block writes, if only one of them is written, it does not cause an inconsistency. An example of this is dirty block write - dirty data is first written; after that updated metadata is written. If an abnormal shutdown occurs after the dirty data is written, it will not cause inconsistency. This dirty block will be ignored as it's metadata is yet to be written. Since application wasn't returned IO completion status before the shutdown, it'll assume that the IO never made it to HDD.

EnhanceIO(TM) driver offers atomicity guarantee at a SSD internal flash block size level. In the case of an abnormal shutdown, for all IO requests each block in the IO request persists either in full or none. In no event does an incomplete block be found when cache is enabled later. For example for an SSD having an internal flash block size of 4kB - if an IO of 8kB was requested at offset 0, the end result could be either first 4kB being written, or the last 4kB being written, or none being written. If an IO of 4KB was requested at offset 2KB, the end result could be either the first 2kB (contained in first cache block) being written, or the last 2kB (contained in the second cache block) being written, or none of them being written.
If an SSD internal flash block size is smaller than cache block size, a torn-page problem could occur, where a cache block may contain garbage in the case of an abrupt power failure or an OS crash. This is an extremely rare condition. At present none of the recently manufactured SSDs are known to have less than 4kB of internal flash block size.
Block devices are required to offer an atomicity guarantee at a sector level (512bytes) at a minimum. EnhanceIO(TM) driver write-back conforms to this requirement.
If upper layers such as filesystems or databases are not prepared to handle sector level atomicity, they may fail in the case of an abnormal shutdown with EnhanceIO(TM) driver as well has HDD. So HDD guarantees in this context are not diluted.
If upper layers require a sequential write guarantee in addition to atomicity, they will work for HDD, however may fail with EnhanceIO(TM) driver in the case of an abnormal shutdown. Such layers will not work with RAID also. A sequential write guarantee is that a device will write blocks strictly in a sequential order. With this guarantee, if a block in an IO range is persistent, it implies that all blocks prior to it are also persistent. Enterprise software packages do not make this assumption, so will not have a problem with EnhanceIO(TM) driver. So EnhanceIO(TM) offers the same level of guarantees as RAID in this context.

EnhanceIO(TM) caches should offer the same guarantee of end result as is offered by a HDD in case of Parallel IOs. Parallel IOs do not result in stale or inconsistent cache data. This is not a requirement from filesystems as filesystems use page cache and do not issue simultaneous IO requests with overlapping IO ranges. However some applications may require this guarantee.

EnhanceIO(TM) write-back has been implemented to ensure that data is not be lost once a success status is returned for an application requested IO. This includes OS crashes, abrupt power failures, planned reboot and planned power-offs.

11. Error conditions - Handling power failures, intermittent and permanent device failures. These are being described in another email.
