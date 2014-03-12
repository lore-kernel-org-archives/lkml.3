Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaCLHW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:22:28 -0400
Received: from smtp03.stone-is.org ([87.238.162.6]:50267 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbaCLHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:22:26 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53200B2E.4060805@acm.org>
Date: Wed, 12 Mar 2014 08:22:22 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
References: <531DC851.5060400@acm.org> <20140311135137.GA22995@dhcp-26-207.brq.redhat.com> <531F518A.1070808@acm.org> <20140311204826.GA30105@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140311204826.GA30105@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 21:48, Alexander Gordeev wrote:
> On Tue, Mar 11, 2014 at 07:10:18PM +0100, Bart Van Assche wrote:
>>> I assume the BUG() above hits? If so, I am failing to understand how
>>> the code gets here. Mind elaborate?
>>
>> You are correct, the BUG() mentioned in the call stack in the
>> description of this patch does indeed correspond with the BUG()
>> statement in the above code. That BUG() was encountered while testing
>> the scsi-mq patch series with a workload with a large queue depth. I
>> think the fact that I hit that BUG() statement means that my workload
>> was queueing requests faster than these were processed by the SCSI LLD
>> and hence that percpu_ida_alloc() ran out of tags.
> 
> Function steal_tags() is entered with disabled interrupts and
> pool->lock taken. Then the 'for' cycle enters/loops while 'cpus_have_tags'
> is not zero. Which means we can not end up with no set bits at all -
> and that is the reason why BUG() is (legitimately) placed there.

Sorry but the above reasoning is wrong. Even if interrupts are disabled
on one CPU, even if that CPU holds pool->lock, and even if
cpus_have_tags has at least one bit set at the time steal_tags() starts,
it is still possible that another CPU obtains "remote->lock" before
steal_tags() can obtain that lock and that that other CPU causes
remote->nr_free to drop to zero. I am aware the percpu_ida code is not
easy to read due to such complex interactions between CPU cores.
However, my understanding is that the goal of the percpu_ida allocator
was not that its code would be easy to read but that its performance
would be optimal.

Is this sufficient to make you have another look at my patch ?

Thanks,

Bart.

