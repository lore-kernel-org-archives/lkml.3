Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaEMDfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:35:24 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49381 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaEMDfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:35:22 -0400
Message-ID: <537192D3.5030907@linux.vnet.ibm.com>
Date: Tue, 13 May 2014 11:34:43 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Paul Turner <pjt@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051303-1618-0000-0000-000000365059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During our testing, we found that the cpu.shares doesn't work as
expected, the testing is:

X86 HOST:
	12 CPU
GUEST(KVM):
	6 VCPU

We create 3 GUEST, each with 1024 shares, the workload inside them is:

GUEST_1:
	dbench 6
GUEST_2:
	stress -c 6
GUEST_3:
	stress -c 6

So by theory, each GUEST will got (1024 / (3 * 1024)) * 1200% == 400%
according to the group share (3 groups are created by virtual manager on
same level, and they are the only groups heavily running in system).

Now if only GUEST_1 running, it got 300% CPU, which is 1/4 of the whole
CPU resource.

So when all 3 GUEST running concurrently, we expect:

		GUEST_1		GUEST_2		GUEST_3
CPU%		300%		450%		450%

That is the GUEST_1 got the 300% it required, and the unused 100% was
shared by the rest group.

But the result is:

		GUEST_1		GUEST_2		GUEST_3
CPU%		40%		580%		580%

GUEST_1 failed to gain the CPU it required, and the dbench inside it
dropped a lot on performance.

So is this results expected (I really do not think so...)?

Or that imply the cpu-cgroup got some issue to be fixed?

Any comments are welcomed :)

Regards,
Michael Wang

