Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab3EGIr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:47:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53003 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab3EGIrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:47:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5188BFA6.5070606@jp.fujitsu.com>
Date: Tue, 07 May 2013 17:47:34 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        ebiederm@xmission.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, jingbai.ma@hp.com
Subject: Re: makedumpfile mmap() benchmark
References: <E1UYLNS-0003H3-NC@eag09.americas.sgi.com>
In-Reply-To: <E1UYLNS-0003H3-NC@eag09.americas.sgi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/04 4:10), Cliff Wickman wrote:
> 
>> Jingbai Ma wote on 27 Mar 2013:
>> I have tested the makedumpfile mmap patch on a machine with 2TB memory,
>> here is testing results:
>> Test environment:
>> Machine: HP ProLiant DL980 G7 with 2TB RAM.
>> CPU: Intel(R) Xeon(R) CPU E7- 2860  @ 2.27GHz (8 sockets, 10 cores)
>> (Only 1 cpu was enabled the 2nd kernel)
>> Kernel: 3.9.0-rc3+ with mmap kernel patch v3
>> vmcore size: 2.0TB
>> Dump file size: 3.6GB
>> makedumpfile mmap branch with parameters: -c --message-level 23 -d 31
>> --map-size <map-size>
>> All measured time from debug message of makedumpfile.
>>
>> As a comparison, I also have tested with original kernel and original
>> makedumpfile 1.5.1 and 1.5.3.
>> I added all [Excluding unnecessary pages] and [Excluding free pages]
>> time together as "Filter Pages", and [Copyying Data] as "Copy data" here.
>>
>> makedumjpfile	Kernel	map-size (KB)	Filter pages (s)	Copy data (s)	Total (s)
>> 1.5.1	 3.7.0-0.36.el7.x86_64	N/A	940.28	1269.25	2209.53
>> 1.5.3	 3.7.0-0.36.el7.x86_64	N/A	380.09	992.77	1372.86
>> 1.5.3	v3.9-rc3	N/A	197.77	892.27	1090.04
>> 1.5.3+mmap	v3.9-rc3+mmap	0	164.87	606.06	770.93
>> 1.5.3+mmap	v3.9-rc3+mmap	4	88.62	576.07	664.69
>> 1.5.3+mmap	v3.9-rc3+mmap	1024	83.66	477.23	560.89
>> 1.5.3+mmap	v3.9-rc3+mmap	2048	83.44	477.21	560.65
>> 1.5.3+mmap	v3.9-rc3+mmap	10240	83.84	476.56	560.4
> 
> I have also tested the makedumpfile mmap patch on a machine with 2TB memory,
> here are the results:
> Test environment:
> Machine: SGI UV1000 with 2TB RAM.
> CPU: Intel(R) Xeon(R) CPU E7- 8837  @ 2.67GHz
> (only 1 cpu was enabled in the 2nd kernel)
> Kernel: 3.0.13 with mmap kernel patch v3 (I had to tweak the patch a bit)
> vmcore size: 2.0TB
> Dump file size: 3.6GB
> makedumpfile mmap branch with parameters: -c --message-level 23 -d 31
>     --map-size <map-size>
> All measured times are actual clock times.
> All tests are noncyclic.   Crash kernel memory: crashkernel=512M
> 
> As did Jingbai Ma, I also tested with an unpatched kernel and
> makedumpfile 1.5.1 and 1.5.3.  But they do 2 filtering scans: unnecessary
> pages and free pages; here added together as filter pages time.
> 
>                                        Filter    Copy
> makedumpfile Kernel	 map-size(KB) pages(s)	data(s) Total(s)
> 1.5.1	     3.0.13	   N/A	      671   	511    1182
> 1.5.3	     3.0.13	   N/A	      294       535     829
> 1.5.3+mmap   3.0.13+mmap     0	       54    	506   	560
> 1.5.3+mmap   3.0.13+mmap  4096	       40    	416	456
> 1.5.3+mmap   3.0.13+mmap 10240	       37	424	461
> 
> Using mmap for the copy data as well as for filtering pages did little:
> 1.5.3+mmap   3.0.13+mmap  4096	       37    	414	451
> 
> My results are quite similar to Jingbai Ma's.
> The mmap patch to the kernel greatly speeds the filtering of pages, so
> we at SGI would very much like to see this patch in the 3.10 kernel.
>    http://marc.info/?l=linux-kernel&m=136627770125345&w=2
> 
> What puzzles me is that the patch greatly speeds the read's of /proc/vmcore
> (where map-size is 0) as well as providing the mmap ability.  I can now
> seek/read page structures almost as fast as mmap'ing and copying them.
> (versus Jingbai Ma's results where mmap almost doubled the speed of reads)
> I have put counters in to verify, and we are doing several million
> seek/read's vs. a few thousand mmap's.  Yet the performance is similar
> (54sec vs. 37sec, above). I can't rationalize that much improvement.

The change between 1.5.3+mmap between 1.5.3 that might be affecting the
result I guess is the below only.

commit ba1fd638ac024d01f70b5d7e16f0978cff978c22
Author: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date:   Wed Feb 20 20:13:07 2013 +0900

    [PATCH] Clean up readmem() by removing its recursive call.

In addition to your and Ma's results, my result also showed similar
result: 100 secs for read() and 70 secs for mmap() with 4KB map. See:
https://lkml.org/lkml/2013/3/26/914

So I think:

- the performance degradation not only had come from many
ioremap/iounmap calls but also from the way makedumpfile was implemented.

- The changes of makedumpfile that impacted performance gain are the
below two:
  - Implement 8-entry cache for readmem() by Petr Tesarik, and
  - The above clean up patch that removes unnecessary recursive call of
readmem().

- Even by these changes only, we can get enough performance gain.
Further, using mmap allows us to get the performance close to
kernel-side processing; this might be unnecessary in practice but might
be meaningful in kdump's design that uses user-space tools as a part of
framework.

-- 
Thanks.
HATAYAMA, Daisuke

