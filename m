Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3JaCok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 22:44:40 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:40934 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3JaCoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 22:44:39 -0400
MIME-Version: 1.0
Date: Thu, 31 Oct 2013 10:44:38 +0800
Message-ID: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
Subject: Got iperf regression while intel_iommu is on, how to cut the cost of
 cache flushing
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

     We got network I/O performance degradation with latest stable
kernel and the be2net driver as compared to old kernel 3.0.6.   later
we found even compared to
the same latest stable kernel but the INTEL_IOMMU set to 'n',  still
got very noticeable performance regression:

Kernel   : 3.11.x with  CONFIG_INTEL_IOMMU_DEFAULT_ON not set
Network driver    : be2net

Average Bandwidth for :
   1.tcp-unidirectional test    : 7908 Mbits/sec
   2.tcp-unidirectional-parallel: 9400 Mbits/sec
   3.tcp-bidirectonal test      : 5464 Mbits/sec

Kernel   : 3.11.x with CONFIG_INTEL_IOMMU_DEFAULT_ON set
Network driver    : be2net

 Average Bandwidth for :
1.tcp-unidirectional test    : 4380 Mbits/sec
2.tcp-unidirectional-parallel: 9400 Mbits/sec
3.tcp-bidirectonal test      : 2915 Mbits/sec

After did some profiling,  the main part of the cause points to the
cache flushing operation when Intel-IOMMU does mapping and un-mapping:

Notice the  clflush_cache_range while INTEL_IOMMU is on

     27.22%    iperf  [kernel.kallsyms]     [k] copy_user_generic_string
---> 5.86%    iperf  [kernel.kallsyms]     [k] clflush_cache_range
      3.99%    iperf  [kernel.kallsyms]     [k] put_page
      2.66%    iperf  [kernel.kallsyms]     [k] __ticket_spin_lock
      1.86%    iperf  [kernel.kallsyms]     [k] free_hot_cold_page
      1.68%    iperf  [kernel.kallsyms]     [k] skb_copy_datagram_iovec
      1.63%    iperf  [kernel.kallsyms]     [k] __domain_mapping
      1.57%    iperf  [kernel.kallsyms]     [k] rb_p

The ECAP_REG (extended capability register) of Intel IOMMU (vt-d) bit
0 shows it is not in "Coherency", OS must do cache flushing while
mapping and remapping etc.

The ECAP_REG bit 0 is configured by BIOS, I have some questions here :
1. Does the SandyBridge/Ivy Bridge platform  support coherent mode ?
So we could get rid of the  clflush_cache_range() cost by set the bit
0 to 1.

Searching Intel SDM didn't show up the answer, BWG neither.

2. Are there any other way to cut the cache flushing cost ?
Read some paper about it, so far , no good solution, right ?

Thanks,
Ethan
