Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaDDC5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:57:31 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:1500 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaDDC50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:57:26 -0400
X-Greylist: delayed 134945 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 22:57:25 EDT
Message-ID: <533E1F8E.5040600@hp.com>
Date: Thu, 03 Apr 2014 22:57:18 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Marcos Matsunaga <Marcos.Matsunaga@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH v8 00/10] qspinlock: a 4-byte queue spinlock with PV support
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <20140402143201.GF12188@phenom.dumpdata.com> <533C7485.3030203@hp.com> <533CC309.3020607@hp.com> <20140403172333.GA3877@localhost.localdomain>
In-Reply-To: <20140403172333.GA3877@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 01:23 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 02, 2014 at 10:10:17PM -0400, Waiman Long wrote:
>> On 04/02/2014 04:35 PM, Waiman Long wrote:
>>> On 04/02/2014 10:32 AM, Konrad Rzeszutek Wilk wrote:
>>>> On Wed, Apr 02, 2014 at 09:27:29AM -0400, Waiman Long wrote:
>>>>> N.B. Sorry for the duplicate. This patch series were resent as the
>>>>>       original one was rejected by the vger.kernel.org list server
>>>>>       due to long header. There is no change in content.
>>>>>
>>>>> v7->v8:
>>>>>    - Remove one unneeded atomic operation from the slowpath, thus
>>>>>      improving performance.
>>>>>    - Simplify some of the codes and add more comments.
>>>>>    - Test for X86_FEATURE_HYPERVISOR CPU feature bit to enable/disable
>>>>>      unfair lock.
>>>>>    - Reduce unfair lock slowpath lock stealing frequency depending
>>>>>      on its distance from the queue head.
>>>>>    - Add performance data for IvyBridge-EX CPU.
>>>> FYI, your v7 patch with 32 VCPUs (on a 32 cpu socket machine) on an
>>>> HVM guest under Xen after a while stops working. The workload
>>>> is doing 'make -j32' on the Linux kernel.
>>>>
>>>> Completely unresponsive. Thoughts?
>>>>
>>> Thank for reporting that. I haven't done that much testing on Xen.
>>> My focus was in KVM. I will perform more test on Xen to see if I
>>> can reproduce the problem.
>>>
>> BTW, does the halting and sending IPI mechanism work in HVM? I saw
> Yes.
>> that in RHEL7, PV spinlock was explicitly disabled when in HVM mode.
>> However, this piece of code isn't in upstream code. So I wonder if
>> there is problem with that.
> The PV ticketlock fixed it for HVM. It was disabled before because
> the PV guests were using bytelocks while the HVM were using ticketlocks
> and you couldnt' swap in PV bytelocks for ticketlocks during startup.

The RHEL7 code has used PV ticketlock already. RHEL7 uses a single 
kernel for all configurations. So PV ticketlock as well as Xen and KVM 
support was compiled in. I think booting the kernel on bare metal will 
cause the Xen code to work in HVM mode thus activating the PV spinlock 
code which has a negative impact on performance. That may be why it was 
disabled so that the bare metal performance will not be impacted.

BTW, could you send me more information about the configuration of the 
machine, like the .config file that you used?

-Longman
