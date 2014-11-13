Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742AbaKMXMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:12:07 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52302 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920AbaKMXMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:12:03 -0500
Message-ID: <54653ABF.3080400@gmail.com>
Date: Thu, 13 Nov 2014 15:11:59 -0800
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>,
        Alexander Duyck <alexander.h.duyck@redhat.com>
CC: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikey@neuling.org, tony.luck@intel.com,
        mathieu.desnoyers@polymtl.ca, donald.c.skidmore@intel.com,
        peterz@infradead.org, benh@kernel.crashing.org,
        heiko.carstens@de.ibm.com, oleg@redhat.com, will.deacon@arm.com,
        davem@davemloft.net, michael@ellerman.id.au, matthew.vick@intel.com,
        nic_swsd@realtek.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, linux@arm.linux.org.uk,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        mingo@kernel.org
Subject: Re: [PATCH 2/3] r8169: Use load_acquire() and store_release() to
 reduce memory barrier overhead
References: <20141113191250.12579.19694.stgit@ahduyck-server> <20141113192735.12579.22892.stgit@ahduyck-server> <20141113213049.GA12297@electric-eye.fr.zoreil.com>
In-Reply-To: <20141113213049.GA12297@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 01:30 PM, Francois Romieu wrote:
> Alexander Duyck <alexander.h.duyck@redhat.com> :
> [...]
>> In addition the r8169 uses a rmb() however I believe it is placed incorrectly
>> as I assume it supposed to be ordering descriptor reads after the check for
>> ownership.
> Not exactly. It's a barrier against compiler optimization from 2004.
> It should not matter.

Okay.  Do you recall the kind of problem it was you were seeing?

The origin of the rmb() for the Intel drivers was a PowerPC issue in
which it was fetching the length of a buffer before it checked the DD
bit (equivalent of DescOwn).  I'm wondering if the issue you were seeing
was something similar where it had reordered reads in the descriptor to
cause that type of result.

> However I disagree with the change below:
>
>> @@ -7284,11 +7280,11 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
>>  		struct RxDesc *desc = tp->RxDescArray + entry;
>>  		u32 status;
>>  
>> -		rmb();
>> -		status = le32_to_cpu(desc->opts1) & tp->opts1_mask;
>> -
>> +		status = cpu_to_le32(load_acquire(&desc->opts1));
>>  		if (status & DescOwn)
>>  			break;
>> +
>> +		status &= tp->opts1_mask;
> -> tp->opts1_mask is not __le32 tainted.

Sorry I just noticed I got my byte ordering messed up on that.  It
should have been le32_to_cpu.  desc->opts is le32, and status should be
CPU ordered.  I will have that updated for v2.

> Btw, should I consider the sketch above as a skeleton in my r8169 closet ?
>
>            NIC                      CPU0                      CPU1
> | CPU | NIC | CPU | CPU | 
>
>                           | CPU | NIC | CPU | CPU |
>                                          ^ tx_dirty
>
>                                 [start_xmit...
>
> | CPU | CPU | CPU | CPU |
>    (NIC did it's job)
>                                                            [rtl_tx...
>                           | ... | ... | NIC | NIC |
>                                   (ring update)
>                               (tx_dirty increases)
>
>                                                      | CPU | CPU | ??? | ??? |
>                                                            tx_dirty ?
>                                                      reaping about-to-be-sent
>                                                      buffers on some platforms ?
>                                 ...start_xmit]

Actually it looks like that could be due to the placement of tp->cur_tx
update and the txd->opts1 being updated in the same spot in start_xmit
with no barrier to separate them.  As such the compiler is free to
update tp->cur_tx first, and then update the desc->opts to set the
DescOwn bit.

I will move the update of tp->cur_tx down a few lines past where the
second wmb is/was.  That should provide enough buffer to guarantee that
cur_tx update is only visible after the descriptors have been updated so
the reaping should only occur if the CPU has written back.

Thanks,

Alex

