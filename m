Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaDWVmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaDWVml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:42:41 -0400
Message-ID: <535833AE.6010505@redhat.com>
Date: Wed, 23 Apr 2014 17:42:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, joern@logfs.org, peterz@infradead.org,
        akpm@linux-foundation.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
References: <20140423125352.704f9fb2@annuminas.surriel.com> <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 05:37 PM, Jiri Kosina wrote:
> On Wed, 23 Apr 2014, Rik van Riel wrote:
> 
>> Echoing values into /proc/sysrq-trigger seems to be a popular way to
>> get information out of the kernel. However, dumping information about
>> thousands of processes, or hundreds of CPUs to serial console can
>> result in IRQs being blocked for minutes, resulting in various kinds
>> of cascade failures.
>>
>> The most common failure is due to interrupts being blocked for a very
>> long time. This can lead to things like failed IO requests, and other
>> things the system cannot easily recover from.
>>
>> This problem is easily fixable by making __handle_sysrq use RCU
>> instead of spin_lock_irqsave.
>>
>> This leaves the warning that RCU grace periods have not elapsed for a
>> long time, but the system will come back from that automatically.
> 
> This, however, will make RCU stall detector to send NMI to all online CPUs 
> so that they can dump their stacks.

It already does that, since several of the longer-running
sysrq handlers already grab rcu_read_lock(), for example
show_state().

> IOW, this might actually make the whole sysrq dump last for much longer, 
> and have the log polluted with all-CPU dumps for no good reason.
> 
> I wonder whether explicitly setting rcu_cpu_stall_suppress during sysrq 
> handling might be a viable workaround for this.

I suppose that would do the trick.

-- 
All rights reversed
