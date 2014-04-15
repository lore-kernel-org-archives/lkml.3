Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaDOHyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:54:00 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52472 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaDOHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:53:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al9gALzkTFN5LEcvPGdsb2JhbABYgwaDUIULoi2ZMoEfFwMBAQEBODWCZhwVDhgkNAUlAwcth3vMQRaOTR2DDoEUBJhhimaLIys
Date: Tue, 15 Apr 2014 17:53:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [regression, 3.15-rc1] vdso_gettimeofday hogs all my CPU
Message-ID: <20140415075335.GE31578@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I'm guessing that x86 vdso problems are in your area of expertise,
if not can you point me at the right person to bug?

I just spun up my XFS performance tests on 3.15-rc1, the first of
which runs a concurrent fsmark workload. fsmark uses gettimeofday to
do per-operation timing and performance is horrendous. 3.14.0 on this
workload does around 300,000 file creates per second. 3.15-rc1
does:

#  ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d  /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d  /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11  -d  /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14  -d  /mnt/scratch/15
#       Version 3.3, 16 thread(s) starting at Tue Apr 15 17:37:20 2014
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      70950.5        155219877
     0      3200000            0      71832.4        150138649
     0      4800000            0      71195.5        150935842
     0      6400000            0      71215.4        150906768
     0      8000000            0      63707.7        166569461
.....

about 70,000 files/sec, so it's way, way down on 3.14. The load has
pegged all 16 CPUs in the VM, and perf top tells me:

-  63.11%  [vdso]              [.] __vdso_gettimeofday
   - __vdso_gettimeofday
        44.24% stop
        28.18% do_run
        13.98% write_file
        13.60% setup_file_name

that it's the gettimeofday calls that are causing the excessive CPU
load.

I haven't changed anything in userspace for the past couple of
months, the only thing that has changed is the kernel. I haven't
looked at this any further and have no idea what to do to debug it
further, so let me know if you need more information....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
