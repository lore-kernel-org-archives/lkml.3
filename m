Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaCYILQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:11:16 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52782 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaCYILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:11:12 -0400
Date: Tue, 25 Mar 2014 09:11:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] mm: FAULT_AROUND_ORDER patchset performance data for
 powerpc
Message-ID: <20140325081107.GA28377@gmail.com>
References: <1395730215-11604-1-git-send-email-maddy@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395730215-11604-1-git-send-email-maddy@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Madhavan Srinivasan <maddy@linux.vnet.ibm.com> wrote:

> Performance data for different FAULT_AROUND_ORDER values from 4 socket
> Power7 system (128 Threads and 128GB memory) is below.  Fault around order (FAO)
> value of 3 looks more advantageous.
> 
> FAULT_AROUND_ORDER      Baseline        1               3               4		5               7
> 
> Linux build (make -j64)
> minor-faults		7184385		5874015		4567289		4318518		4193815		4159193
> times in seconds	61.433776136	60.865935292	59.245368038	60.630675011	60.56587624	59.828271924

Hm, I have one general observation: it's hard to tell how 
(statistically) significant the time differences are, without standard 
deviation numbers.

You can get stddev very easily via 'perf stat --null --repeat N'.

You can use --pre <script> and --post <script> for pre/post 
measurement cleanup hooks (such as 'make clean'). So for example:

  perf stat --null --repeat 3 --pre 'make defconfig; make clean >/dev/null 2>&1' make -j64 kernel/

Which run the workload 3 times and it will output something like:

       9.013717158 seconds time elapsed                                          ( +-  0.99% )

Where the +- column shows the stddev in relative percentage units.

The --null option ensures that only time measurement is done with no 
overhead for the workload, no other performance metrics are taken.

The overhead of the --pre stage is not added to the measured time.

Thus you can also add really expensive steps to the --pre stage, such 
as a vm_drop_caches clearing of all caches, to measure cache-cold 
results.

The stddev value shows that the result is significant to about the 
first fractional digit.

Thanks,

	Ingo
