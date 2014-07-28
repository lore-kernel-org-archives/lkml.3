Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaG1Vwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:52:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:32773 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaG1Vws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,751,1400050800"; 
   d="scan'208";a="580306627"
Subject: [Regression 3.16-rc kernel] -55% reduction in throughput for OLTP
 benchmark
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: suruchi <suruchi.a.kadu@intel.com>, ak <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jul 2014 14:51:39 -0700
Message-ID: <1406584299.2970.924.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

We saw a large regression (-55%) in a standard OLTP benchmark
between 3.15 kernel and 3.16-rc4 kernel.

One issue was caused by the changes in async direct IO in the 
direct IO patch series between commit f6c0a192 and 62a8067a 
for the 3.16-rc kernel.  The kernel before this series at 
commit 38583f09 has no such regression.

After some investigations and instrumentation, we saw that the
problem was caused by a lot of io_wait issued from 
do_blockdev_direct_IO for async direct IO writes, which
did not happen for 3.15 kernel.  The benchmark
used to run at 97% cpu utilization now has only
35% cpu utilization with plenty of idle time.

At the end of do_blockdev_direct_IO, 

        if (dio->is_async && retval == 0 && dio->result &&
            ((rw == READ) || (dio->result == sdio.size)))
                retval = -EIOCBQUEUED;

        if (retval != -EIOCBQUEUED)
                dio_await_completion(dio);

we saw for async writes, the check
for (dio->result == sdio.size) failed. The retval was not
set to -EIOCBQUEUED, causing dio_await_completion to be issued
and hence the io_waits.

It is possible that the problem was introduced when dio->result
computation was moved into do_direct_IO in commit 3320c60b.
However, we cannot compile and test this commit separately as 
it is dependent on some later patches in the direct IO patch series
so we have to test the patch series as a whole.

This is quite a large regression for us and we hope that
it can be fixed before 3.16 kernel is released.

Thanks.

Tim

