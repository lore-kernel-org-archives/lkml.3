Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab3HTL0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3HTL0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:26:40 -0400
Date: Tue, 20 Aug 2013 13:26:29 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bufferbloat-list <bloat@lists.bufferbloat.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Dave Taht <dave.taht@gmail.com>
Subject: ADSL/ATM linklayer tc shaping regression fix commits for stable
Message-ID: <20130820132629.51618797@redhat.com>
Organization: Red Hat Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg (and google search),

ADSL/ATM linklayer shaping were broken in kernel release from 3.8 to
3.10 by commit 56b765b79 ("htb: improved accuracy at high rates").

I can see that 3.9-stable is marked EOL, and 3.8-stable also seems
closed.  I guess it is up to Greg, how far the commits described below
can be backported.  Below is the commit needed for a 3.9 backport.

This was not the only regression introduced by the regression commit,
several fixes were required:

(Refactor/change commit for easy 3.9 backport step (in v3.10-rc1)):
 commit 6906f4ed6f8 (htb: add HTB_DIRECT_QLEN attribute)

The following commit fixes are in 3.10-rc5:
 commit 01cb71d2d47 (net_sched: restore "overhead xxx" handling)
 commit 5343a7f8be1 (net_sched: htb: do not mix 1ns and 64ns time units)

The following commit fixes are in 3.10-rc6:
 commit 40edeff6e1c (net_sched: qdisc_get_rtab() must check data[] array)
 (this fix goes further back, but needed for linklayer atm, see below[1])

Refactor improvements (v3.11-rc1):
 commit 130d3d68b52 (net_sched: psched_ratecfg_precompute() improvements)

The linklayer ATM/ADSL fix, reached 3.11-rc6:
 commit 8a8e3d84b17 (net_sched: restore "linklayer atm" handling)


[1] Eric Dumazet also found a general "linklayer atm" regression
(dating way-back), which could cause rate-tables to get wrongly shared
between the same rates with-and-without linklayer atm settings.
Addressed/fixed in (3.10-rc6:):
 - commit 40edeff6e1c (net_sched: qdisc_get_rtab() must check data[] array)
When configuring two completely equal rates, the kernel detects that
these two equal rates can share the same rate-table.  But the kernel
didn't check if the rate-table data had been modified, which is done
in the linklayer atm case.
In practice, this often isn't a problem, as overhead parameter is
usually combined with the linklayer parameter.


The regression commit 56b765b79 ("htb: improved accuracy at high
rates"), is not all bad, it did provided a significantly improved rate
shaping accuracy.  The old rate-table based system, which this commit
removed, would get inaccurate at rates above 100Mbit/s.

(ps. I'm the original author of http://www.adsl-optimizer.dk/ and
http://sourceforge.net/projects/adsl-optimizer/)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
