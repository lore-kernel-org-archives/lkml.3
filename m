Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3C0GYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:24:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59319 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3C0GYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:24:53 -0400
Date: Wed, 27 Mar 2013 15:23:44 +0900 (JST)
Message-Id: <20130327.152344.338429402.d.hatayama@jp.fujitsu.com>
To: jingbai.ma@hp.com
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: makedumpfile mmap() benchmark
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <515288E9.2070707@hp.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
	<515288E9.2070707@hp.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jingbai Ma <jingbai.ma@hp.com>
Subject: makedumpfile mmap() benchmark
Date: Wed, 27 Mar 2013 13:51:37 +0800

> Hi,
> 
> I have tested the makedumpfile mmap patch on a machine with 2TB
> memory, here is testing results:

Thanks for your benchmark. It's very helpful to see the benchmark on
different environments.

> Test environment:
> Machine: HP ProLiant DL980 G7 with 2TB RAM.
> CPU: Intel(R) Xeon(R) CPU E7- 2860  @ 2.27GHz (8 sockets, 10 cores)
> (Only 1 cpu was enabled the 2nd kernel)
> Kernel: 3.9.0-rc3+ with mmap kernel patch v3
> vmcore size: 2.0TB
> Dump file size: 3.6GB
> makedumpfile mmap branch with parameters: -c --message-level 23 -d 31
> --map-size <map-size>

To reduce the benchmark time, I recommend LZO or snappy compressions
rather than zlib. zlib is used when -c option is specified, and it's
too slow for use of crash dump.

To build makedumpfile with each compression format supports, do
USELZO=on or USESNAPPY=on after installing necessary libraries.

> All measured time from debug message of makedumpfile.
> 
> As a comparison, I also have tested with original kernel and original
> makedumpfile 1.5.1 and 1.5.3.
> I added all [Excluding unnecessary pages] and [Excluding free pages]
> time together as "Filter Pages", and [Copyying Data] as "Copy data"
> here.
> 
> makedumjpfile Kernel map-size (KB) Filter pages (s) Copy data (s)
> Total (s)
> 1.5.1	 3.7.0-0.36.el7.x86_64	N/A	940.28	1269.25	2209.53
> 1.5.3	 3.7.0-0.36.el7.x86_64	N/A	380.09	992.77	1372.86
> 1.5.3	v3.9-rc3	N/A	197.77	892.27	1090.04
> 1.5.3+mmap	v3.9-rc3+mmap	0	164.87	606.06	770.93
> 1.5.3+mmap	v3.9-rc3+mmap	4	88.62	576.07	664.69
> 1.5.3+mmap	v3.9-rc3+mmap	1024	83.66	477.23	560.89
> 1.5.3+mmap	v3.9-rc3+mmap	2048	83.44	477.21	560.65
> 1.5.3+mmap	v3.9-rc3+mmap	10240	83.84	476.56	560.4

Did you calculate "Filter pages" by adding two [Excluding unnecessary
pages] lines? The first one of the two line is displayed by
get_num_dumpable_cyclic() during the calculation of the total number
of dumpable pages, which is later used to print progress of writing
pages in percentage.

For example, here is the log, where the number of cycles is 3, and

mem_map (16399)
  mem_map    : ffffea0801e00000
  pfn_start  : 20078000
  pfn_end    : 20080000
read /proc/vmcore with mmap()
STEP [Excluding unnecessary pages] : 13.703842 seconds <-- this part is by get_num_dumpable_cyclic()
STEP [Excluding unnecessary pages] : 13.842656 seconds
STEP [Excluding unnecessary pages] : 6.857910 seconds
STEP [Excluding unnecessary pages] : 13.554281 seconds <-- this part is by the main filtering processing.
STEP [Excluding unnecessary pages] : 14.103593 seconds
STEP [Excluding unnecessary pages] : 7.114239 seconds
STEP [Copying data               ] : 138.442116 seconds
Writing erase info...
offset_eraseinfo: 1f4680e40, size_eraseinfo: 0

Original pages  : 0x000000001ffc28a4
<cut>

So, get_num_dumpable_cyclic() actually does filtering operation but it
should not be included here.

If so, I guess each measured time would be about 42 seconds, right?
Then, it's almost same as the result I posted today: 35 seconds.

Thanks.
HATAYAMA, Daisuke

