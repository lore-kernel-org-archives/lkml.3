Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbaGYI1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:27:39 -0400
Received: from numascale.com ([213.162.240.84]:33770 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958AbaGYI1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:27:35 -0400
X-Greylist: delayed 2231 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2014 04:27:34 EDT
Message-ID: <53D20C2E.3070902@numascale.com>
Date: Fri, 25 Jul 2014 15:50:06 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Hillf Danton <dhillf@gmail.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [3.14] core onlining/hotplug regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas et al,

On a larger x86 system with 1728 cores, 3.15(.6) asserts on 
smpboot_thread_fn's td->cpu != smp_processor_id() consistently after 
~1500 cores are online.

Reverting the only directly related changes I could find [1,2] doesn't 
help. Debugging indicates there is a race where the created thread is 
quickly migrated to core 0 when this occurs, since smp_processor_id 
returns 0 in these cases. Thomas introduced a thread parked state to fix 
related issues a year back. Linux 3.14(.13) boots just nice.

Full boot output is at:
https://resources.numascale.com/linux-315-thread-mig.txt

Any theories so far? I'll start bisecting when I have full access to the 
system again in a week and I'll do some more debugging with intermittent 
access before then.

Thanks,
   Daniel

-- [1]

commit 81c98869faa5f3a9457c93efef908ef476326b31
Author: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Date:   Thu Apr 3 14:46:25 2014 -0700
kthread: ensure locality of task_struct allocations

-- [2]

commit 89f898c1e195fa6235c869bb457e500b7b3ac49d
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Thu Jun 5 15:42:43 2014 +0200

     x86: Fix list/memory corruption on CPU hotplug
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
