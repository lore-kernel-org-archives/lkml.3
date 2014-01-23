Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaAWCPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:15:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaAWCPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:15:35 -0500
Message-ID: <52E07B31.8070104@oracle.com>
Date: Wed, 22 Jan 2014 21:15:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: khlebnikov@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG: Bad rss-counter state
References: <52E06B6F.90808@oracle.com> <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 08:39 PM, David Rientjes wrote:
> On Wed, 22 Jan 2014, Sasha Levin wrote:
>
>> Hi all,
>>
>> While fuzzing with trinity running inside a KVM tools guest using latest -next
>> kernel,
>> I've stumbled on a "mm: BUG: Bad rss-counter state" error which was pretty
>> non-obvious
>> in the mix of the kernel spew (why?).
>>
>
> It's not a fatal condition and there's only a few possible stack traces
> that could be emitted during the exit() path.  I don't see how we could
> make it more visible other than its log-level which is already KERN_ALERT.

Would it make sense to add a VM_BUG_ON() to make it more obvious when we have
CONFIG_VM_DEBUG enabled? Many of the VM_BUG_ON test cases are non-fatal either,
and it would make it easier spotting this issue.

>> I've added a small BUG() after the printk() in check_mm(), and here's the full
>> output:
>>
>
> Worst place to add it :)  At line 562 of kernel/fork.c in linux-next
> you're going to hit BUG() when there may be other counters that are also
> bad and they don't get printed.

I gave the condition before curly braces :)

                 if (unlikely(x)) {
                         printk(KERN_ALERT "BUG: Bad rss-counter state "
                                           "mm:%p idx:%d val:%ld\n", mm, i, x);
                         BUG();
                 }

>> [  318.334905] BUG: Bad rss-counter state mm:ffff8801e6dec000 idx:0 val:1
>
> So our mm has a non-zero MM_FILEPAGES count, but there's nothing that was
> cited that would tell us what that is so there's not much to go on, unless
> someone already recognizes this as another issue.  Is this reproducible on
> 3.13 or only on linux-next?

Yup, I see it in v3.13 too, which is odd.


Thanks,
Sasha
