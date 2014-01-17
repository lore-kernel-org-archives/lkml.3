Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaAQA0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:26:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:44303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaAQA0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:26:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208,223";a="460171342"
Date: Fri, 17 Jan 2014 08:26:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [slub shrink] 0f6934bf16: +191.9% vmstat.system.cs
Message-ID: <20140117002601.GB1413@localhost>
References: <20140116030744.GA19349@localhost>
 <52D82F13.9070309@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <52D82F13.9070309@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 11:12:19AM -0800, Dave Hansen wrote:
> On 01/15/2014 07:07 PM, kernel test robot wrote:
> > 9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
> > ---------------  -------------------------  
> >    8235933 ~ 2%     +80.6%   14872911 ~ 3%  lkp-sbx04/micro/will-it-scale/read2
> >    8235933          +80.6%   14872911       TOTAL interrupts.RES
> > 
> > 9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
> > ---------------  -------------------------  
> >     161531 ~ 7%    +191.9%     471544 ~ 9%  lkp-sbx04/micro/will-it-scale/read2
> >     161531         +191.9%     471544       TOTAL vmstat.system.cs
> > 
> > 9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
> > ---------------  -------------------------  
> >      32943 ~ 1%     +71.8%      56599 ~ 3%  lkp-sbx04/micro/will-it-scale/read2
> >      32943          +71.8%      56599       TOTAL vmstat.system.in
> 
> I suspect that something is wrong with that system.  My 160-cpu system
> does about 40,000 interrupts/sec and ~4300 context switches/sec when
> running 160 read2_processes.  I wonder if you're hitting swap or the
> dirty limits or something.  Are you running it with way more threads
> than it has CPUs?

lkp-sbx04 has 64 CPU threads, and I'm running will-it-scale with
thread numbers 1 16 24 32 48 64 8 

> Also, are those will-it-scale tests the threaded or process versions?

Hansen, I'm running will-it-scale with parameters

./runtest.py read2 16 1 16 24 32 48 64 8

Which runs both threaded/process tests. The runtest.py is modified to
accept a custom list of threads to run. The patch is attached.

The list of duration and thread numbers for runtest.py are computed
and is different for machines with different number of CPUs. The goal
of the computation is so that the test wall time on different machines
will be equally ~5 minutes.

In a system with 120 CPUs, the numbers will be:

./runtest.py brk1 16 1 120 15 30 45 60 90

Thanks,
Fengguang

--T4sUOijqQbZv57TR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-accept-custom-list-of-threads-to-run.patch"

>From 882d7cdc4387912e1fe6a3c9e4c42cdb0ce78c23 Mon Sep 17 00:00:00 2001
From: Fengguang Wu <fengguang.wu@intel.com>
Date: Fri, 17 Jan 2014 08:11:52 +0800
Subject: [PATCH] accept custom list of threads to run

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 runtest.py |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/runtest.py b/runtest.py
index 14d2467..8d4a2cf 100755
--- a/runtest.py
+++ b/runtest.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/python
 
 import time
 import subprocess
@@ -48,12 +48,12 @@ class linux_stat():
 		return 1.0 * idle / (idle + busy)
 
 
-duration=5
-
-if len(sys.argv) != 2:
-	print >> sys.stderr, 'Usage: runtest.py <testcase>'
+if len(sys.argv) < 4:
+	print >> sys.stderr, 'Usage: runtest.py <testcase> <duration> <threads...>'
 	sys.exit(1)
 cmd = sys.argv[1]
+duration = int(sys.argv[2])
+threads  = sys.argv[3:]
 
 nr_cores=0
 r = re.compile('^processor')
@@ -87,7 +87,8 @@ if arch == 'ppc64':
 print 'tasks,processes,processes_idle,threads,threads_idle,linear'
 print '0,0,100,0,100,0'
 
-for i in range(1, nr_cores+1):
+for i in threads:
+	i = int(i)
 	c = './%s_processes -t %d -s %d' % (cmd, i, duration)
 	before = linux_stat()
 	pipe = subprocess.Popen(setarch + ' ' + c, shell=True, stdout=subprocess.PIPE).stdout
-- 
1.7.10.4


--T4sUOijqQbZv57TR--
