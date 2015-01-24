Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbbAXCp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 21:45:26 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39900 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbAXCpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 21:45:18 -0500
Message-ID: <54C3072A.1030604@roeck-us.net>
Date: Fri, 23 Jan 2015 18:44:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: mmotm 2015-01-22-15-04: qemu failures due to 'mm: account pmd
 page tables to the process'
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>	<20150123050445.GA22751@roeck-us.net>	<20150123111304.GA5975@node.dhcp.inet.fi>	<54C263CC.1060904@roeck-us.net> <20150123135519.9f1061caf875f41f89298d59@linux-foundation.org>
In-Reply-To: <20150123135519.9f1061caf875f41f89298d59@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54C3073D.00A8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On 01/23/2015 01:55 PM, Andrew Morton wrote:
> On Fri, 23 Jan 2015 07:07:56 -0800 Guenter Roeck <linux@roeck-us.net> wrote:
>
>>>>
>>>> qemu:microblaze generates warnings to the console.
>>>>
>>>> WARNING: CPU: 0 PID: 32 at mm/mmap.c:2858 exit_mmap+0x184/0x1a4()
>>>>
>>>> with various call stacks. See
>>>> http://server.roeck-us.net:8010/builders/qemu-microblaze-mmotm/builds/15/steps/qemubuildcommand/logs/stdio
>>>> for details.
>>>
>>> Could you try patch below? Completely untested.
>>>
>>> >From b584bb8d493794f67484c0b57c161d61c02599bc Mon Sep 17 00:00:00 2001
>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>> Date: Fri, 23 Jan 2015 13:08:26 +0200
>>> Subject: [PATCH] microblaze: define __PAGETABLE_PMD_FOLDED
>>>
>>> Microblaze uses custom implementation of PMD folding, but doesn't define
>>> __PAGETABLE_PMD_FOLDED, which generic code expects to see. Let's fix it.
>>>
>>> Defining __PAGETABLE_PMD_FOLDED will drop out unused __pmd_alloc().
>>> It also fixes problems with recently-introduced pmd accounting.
>>>
>>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>>
>> Tested working.
>>
>> Tested-by: Guenter Roeck <linux@roeck-us.net>
>>
>> Any idea how to fix the sh problem ?
>
> Can you tell us more about it?  All I'm seeing is "qemu:sh fails to
> shut down", which isn't very clear.
>

qemu command line:

/opt/buildbot/bin/qemu-system-sh4 -M r2d -kernel ./arch/sh/boot/zImage \
         -drive file=rootfs.ext2,if=ide \
         -append "root=/dev/sda console=ttySC1,115200 noiotrap"
         -serial null -serial stdio -net nic,model=rtl8139 -net user
         -nographic -monitor null

--
Poweroff log in mainline (v3.19-rc5-119-gb942c65):

/ # poweroff
The system is going down NOW!
Sent SIGTERM to all processes
Sent SIGKILL to all processes
Requesting system poweroff
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
reboot: Power down

--
Poweroff log in mmotm (v3.19-rc5-417-gc64429b):

/ # poweroff

[ nothing else happens until I kill the qemu session ]

The "halt" command does not work either.

--
The message "The system is going down NOW" is from the init process.
If I use "kill -12 1" instead of "halt" or "poweroff", the system does
shut down as expected. "poweroff -f" also works.

Trying to debug this further, I noticed that the "ps" command hangs
as well, so the problem is not limited to poweroff or halt.

I'll be happy to debug this further, I just have no idea where to start.

Thanks,
Guenter

