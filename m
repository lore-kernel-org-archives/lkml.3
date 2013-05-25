Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab3EYRH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 13:07:59 -0400
Received: from svr129.fastwebhost.com ([67.227.167.43]:35640 "EHLO
	svr129.fastwebhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab3EYRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 13:07:57 -0400
X-Greylist: delayed 4017 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2013 13:07:57 EDT
From: Amit Kale <amitkale@geeksofpune.in>
Organization: GEEks of Pune
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: EnhanceIO(TM) caching driver features [1/3]
Date: Sat, 25 May 2013 21:30:27 +0530
User-Agent: KMail/1.13.6 (Linux/2.6.38-16-generic; KDE/4.6.5; i686; ; )
Cc: Amit Kale <akale@stec-inc.com>,
        OS Engineering <osengineering@stec-inc.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>, koverstreet@google.com,
        linux-bcache@vger.kernel.org, thornber@redhat.com, dm-devel@redhat.com
References: <A44CB407BBB85C498149811C52498A450872D9@MYMBX3.stec-inc.ad> <A44CB407BBB85C498149811C52498A45088559@MYMBX3.stec-inc.ad> <20130525062917.GW29680@kernel.dk>
In-Reply-To: <20130525062917.GW29680@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305252130.27645.amitkale@geeksofpune.in>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - svr129.fastwebhost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - geeksofpune.in
X-Get-Message-Sender-Via: svr129.fastwebhost.com: authenticated_id: amitkale@geeksofpune.in
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013, Jens Axboe wrote:
> Please don't top post!

Got to use a different email client for that. Note that I am writing this from 
my personal email address. This email and any future emails I write from this 
address are my personal views and sTec can't be held responsible for them.

> On Sat, May 25 2013, Amit Kale wrote:
> > Hi Jens,
> > 
> > I by mistake dropped the weblink to demartek study while composing my
> > email. The demartek study is published here:
> > http://www.demartek.com/Demartek_STEC_S1120_PCIe_Evaluation_2013-02.html.
> > It's an independent study. Here are a few numbers taken from this
> > report. In a database comparison using transactions per second
> > 
> > HDD baseline (40 disks) - 2570 tps
> > 240GB Cache - 9844 tps
> > 480GB cache - 19758 tps
> > RAID5 pure SSD - 32380 tps
> > RAID0 pure SSD - 40467 tps
> > 
> > There are two types of performance comparisons, application based and
> > IO pattern based. Application based tests measure efficiency of cache
> > replacement algorithms. These are time consuming. Above tests were
> > done by demartek over a period of time. I don't have performance
> > comparisons between EnhanceIO(TM) driver, bcache and dm-cache. I'll
> > try to get them done in-house.
> 
> Unless I'm badly mistaken, that study is only on enhanceio, it does not
> compare it to any other solutions. 

That's correct. I haven't seen any application level benchmark based 
comparisons between different caching solutions on any platform.

> Additionally, it's running on
> Windows?!

Yes. However as I have said above, application level testing is primarly a 
test of cache replacement algorithm. So the effect of a platform is less, 
although not zero.

> I don't think it's too much to ask to see results on the
> operating system for which you are submitting the changes.

Agreed that's a fair thing to ask.

> 
> > IO pattern based tests can be done quickly. However since IO pattern
> > is fixed prior to the test, output tends to depend on whether the IO
> > pattern suits the caching algorithm. These are relatively easy. I can
> > definitely post this comparison.
> 
> It's fairly trivial to do some synthetic cache testing with fio, using
> eg the zipf distribution. That'll get you data reuse, for both reads and
> writes (if you want), in the selected distribution.

While the running a test is trivial deciding what IO patterns to run is a 
difficult problem. The bottom line for sequential, random, zipf and pareto is 
the same - they all test a fixed IO pattern, which at best is very unlike an 
application pattern. Cache behavior affects IO addresses that an application 
issues. The block list of IOs requested by an application is different when 
running on HDD, SSD and cache. Memory usage by cache is one significant factor 
in this effect. IO latency (more and less) also affects when multiple threads 
are processing transactions.

Regardless of which IO pattern is used following characteristics to a large 
extent measure efficiency of a cache engine minus cache replacement algorithm.
Hit rate - Can be varied between 0 to 100%. 90% and above are of interest for 
caching.
Read versus Write mix - Can be varied from 0/100, 10/90, ...., 10/90, 0/100.
IO block size - Fixed equal to or a multiple of cache block size. Variable 
complicates analysis of results.

Does following comparison sound interesting? I welcome others to propose 
modifications or other ways.

Cache block size 4kB.
HDD size = 500GB
SSD size = 100GB and 500GB. 
HDD equal to SSD is only to study cache behavior so all of the tests below 
need not be performed.

For read-only cache mode 
This works best for write intensive loads R/W mix - 10/90 and 30/70
Write intensive loads are usually long writes Block size - 64kB
Cache hit ratio 0%, 90%, 95%, 100%.

For write-through cache mode
This works best for read intensive loads R/W mix 100/0, 90/10
Block size - 4kB, 16kB, 128kB.
Cache hit ratio 90%, 95%, 100%

For write-back cache mode
This works best for fluctuating loads R/W mix 90/10
Block size - 4kB
Cache hit ratio 95%.

Thanks.
-Amit
