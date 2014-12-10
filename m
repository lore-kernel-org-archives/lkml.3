Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaLJDOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:14:06 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57688 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaLJDOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:14:04 -0500
Message-ID: <5487BA75.4010604@roeck-us.net>
Date: Tue, 09 Dec 2014 19:13:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Cernekee <cernekee@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] hexagon: Fix build failures in linux-next
References: <1418163705-1816-1-git-send-email-linux@roeck-us.net> <20141210002523.GA17946@codeaurora.org>
In-Reply-To: <20141210002523.GA17946@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010204.5487BA7A.031E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 04:25 PM, rkuo wrote:
> On Tue, Dec 09, 2014 at 02:21:45PM -0800, Guenter Roeck wrote:
>> hexagon:defconfig fails to build in linux-next since commit 332fd7c4fef5
>> ("genirq: Generic chip: Change irq_reg_{readl,writel} arguments").
>>
>> The primary build failure is
>>
>> arch/hexagon/include/asm/cacheflush.h: In function 'copy_to_user_page':
>> arch/hexagon/include/asm/cacheflush.h:89:22: error: 'VM_EXEC' undeclared
>>
>> This is the result of including of <linux/io.h> from <linux/irq.h>,
>> which is now necessary due to the use of readl and writel from irq.h.
>> This causes recursive inclusions in hexagon code; cacheflush.h is included
>> from mm.h prior to the definition of VM_EXEC.
>>
>> Fix the problem by moving copy_to_user_page from the hexagon include file to
>> arch/hexagon/mm/cache.c, similar to other architectures. After this change,
>> several redefinitions of readl and writel are reported. Those are caused
>> by recursive inclusions of io.h and asm/cacheflush.h. Fix those problems by
>> reducing the number of files included from those files. Also, it was necessary
>> to stop including asm-generic/cacheflush.h from asm/cacheflush.h. Instead,
>> functionality originally provided by asm-generic/cacheflush.h is now coded
>> in asm/cacheflush.h directly.
>>
>> Cc: Kevin Cernekee <cernekee@gmail.com>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> Compile tested only. Applies to linux-next as well as mainline.
>>
>>   arch/hexagon/include/asm/cacheflush.h | 36 ++++++++++++++++++-----------------
>>   arch/hexagon/include/asm/io.h         |  5 -----
>>   arch/hexagon/kernel/setup.c           |  1 +
>>   arch/hexagon/mm/cache.c               | 10 ++++++++++
>>   arch/hexagon/mm/ioremap.c             |  1 +
>>   5 files changed, 31 insertions(+), 22 deletions(-)
>>
>
> Thanks for the cleanup; tested working on hardware.
>
> I'm fine taking this into my tree, or it can go via another tree if more
> expedient.
>
Hi Richard,

Your tree should be fine as long as you plan to push your changes to Linus
during the current release cycle.

Thanks,
Guenter

