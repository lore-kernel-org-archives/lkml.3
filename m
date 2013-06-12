Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3FLLlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:41:16 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:49332 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756322Ab3FLLlN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:41:13 -0400
X-ASG-Debug-ID: 1371037269-053ea947e81cdea0001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
To: Amit Kale <amitkale@geeksofpune.in>
CC: "koverstreet@google.com" <koverstreet@google.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "thornber@redhat.com" <thornber@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Padmini Balasubramaniyan <padminib@stec-inc.com>,
        "Amit Phansalkar" <aphansalkar@stec-inc.com>
Subject: RE: Performance Comparison among EnhanceIO, bcache and dm-cache.
Thread-Topic: Performance Comparison among EnhanceIO, bcache and dm-cache.
X-ASG-Orig-Subj: RE: Performance Comparison among EnhanceIO, bcache and dm-cache.
Thread-Index: AQHOZyk53ZDPNgozIE2Qnh8POgAh+Jkx6J/A
Date: Wed, 12 Jun 2013 11:39:30 +0000
Message-ID: <D399C715A2AD7F4F891A75871FC3117507B9E6@MYMBX3.stec-inc.ad>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
 <201306121028.03278.amitkale@geeksofpune.in>
In-Reply-To: <201306121028.03278.amitkale@geeksofpune.in>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.20.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1371037269
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.133691
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Amit Kale [mailto:amitkale@geeksofpune.in]
> Sent: Wednesday, June 12, 2013 10:28 AM
> To: OS Engineering
> Cc: koverstreet@google.com; linux-bcache@vger.kernel.org;
> thornber@redhat.com; dm-devel@redhat.com; LKML; Jens Axboe; Padmini
> Balasubramaniyan; Amit Phansalkar
> Subject: Re: Performance Comparison among EnhanceIO, bcache and dm-
> cache.
> 
> On Tuesday 11 Jun 2013, OS Engineering wrote:
> > Hi Jens,
> >
> > In continuation with our previous communication, we have carried out
> > performance comparison among EnhanceIO, bcache and dm-cache.
> >
> > We found that EnhanceIO provides better throughput on zipf workload
> > (with
> > theta=1.2) in comparison to bcache and dm-cache for write through caches.
> > However, for write back caches, we found that dm-cache had best
> > throughput followed by EnhanceIO and then bcache. Dm-cache commits
> > on-disk metadata every time a REQ_SYNC or REQ_FUA bio is written. If
> > no such requests are made then it commits metadata once every second.
> > If power is lost, it may lose some recent writes. However, EnhanceIO
> > and bcache do not acknowledge IO completion until both IO and metadata
> > hits the SSD. Hence, EnhanceIO and bcache provide higher data integrity at
> a cost of performance.
> 
> So it won't be fair to compare them with dm-cache in write-back mode since
> guarantees are different. I am sure if similar (SYNC/FUA enforcement for
> persistence) guarantees are implemented in bcache/EnhanceIO, they'll offer
> a much better performance.
> 
> >
> > The fio config and setup information follows:
> > HDD              : 100GB
> > SSD              :  20GB
> > Mode             : write through / write back
> > Cache block_size : 4KB for bcache, EnhanceIO and 256KB for dm-cache
> >
> > The other options have been left to their default values.
> >
> > Note:
> > 1) In case of dm-cache, we used 2 partitions of same SSD with 1GB partition
> > as metadata and 20GB partition as caching device. This has been done so as
> > to ensure a fair comparison as EnhanceIO and bcache do not have a
> separate
> > metadata device.
> >
> > 2) In order to ensure proper cache warm up, We have turned off
> sequential
> > bypass in bcache. This does not impact our performance results as they are
> > taken for random workload.
> >
> > For each test, we first performed a warm up run using the following fio
> > options: fio --direct=1 --size=90% --filesize=20G --blocksize=4k
> > --ioengine=libaio --rw=rw --rwmixread=100 --rwmixwrite=0 --iodepth=8 ...
> >
> > Then, we performed our actual run with the following fio options:
> > fio --direct=1 --size=100% --filesize=20G --blocksize=4k --ioengine=libaio
> > --rw=randrw --rwmixread=90 --rwmixwrite=10 --iodepth=8 --numjobs=4
> > --random_distribution=zipf:1.2 ...
> 
> Did you experiment a little with varying iodepth and numjobs? Is this the
> best
> combination you found out? The numbers below appear low considering a
> 90% hit
> ratio for EnhanceIO. SSD baseline performance shown below appears low.
> However
> it should not affect this comparison. All caching solutions are being subjected
> to the same ratio of HDD/SSD performance.

We have chosen a representative workload for our tests, we could do more experiments  
that tests SSD to its performance limits.  


> >
> > ============================= Write Through ===============================
> > Type      Read Latency(ms)   Write Latency(ms)    Read(MB/s)    Write(MB/s)
> > ========================================================================
> > EnhanceIO      1.58                             16.53                           32.91               3.65
> > bcache             0.58                             31.05                           27.17                3.02
> > dm-cache       0.24                             27.45                           31.05                3.44
> 
> EnhanceIO shows much higher read latency here. Is that because of
> READFILLs ?
> Write latency, read-write throughputs are good.
> 

Yes, READFILL's (SSD writes at the time of read of an uncached block) is the reason for higher read latency in EnhanceIO. 


> >
> > ============================= Write Back ==================================
> > Type      Read Latency(ms)    Write Latency(ms)    Read(MB/s)   Write(MB/s)
> >
>>==========================================================================
> > EnhanceIO      0.34                         4.98                                 138.72                15.40
> > bcache             0.95                          1.76                                 106.82                11.85
> > dm-cache       0.58                          0.55                                 193.76                21.52
> 
> Here EnhanceIO's read latency is better compared the other two. Write
> latency
> is larger than the other two.
> 
> -Amit
 
EnhanceIO has higher write latencies as it acknowledges IO completion only when both data and metadata has
hit the SSD.

> >
> > ============================ Base Line ====================================
> > Type      Read Latency(ms)    Write Latency(ms)    Read(MB/s)   Write(MB/s)
>> ==========================================================================
> > HDD            6.22                              27.23                               13.51                1.49
> > SSD             0.47                                0.42                             235.87              26.21
> >
> > We have written scripts that aid in cache creation, deletion and
> > performance run for all these caching solutions. These scripts can be
> > found at:
> > https://github.com/stec-inc/EnhanceIO/tree/master/performance_test
> >
> > Thanks and Regards,
> > sTec Team
