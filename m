Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaHOR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:58:13 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:31415 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:58:12 -0400
Message-ID: <53EE4A31.5080407@hp.com>
Date: Fri, 15 Aug 2014 13:58:09 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com> <1407119782-41119-3-git-send-email-Waiman.Long@hp.com> <1407125450.4710.38.camel@j-VirtualBox> <53DFAA53.4010003@hp.com> <20140813055153.GD20518@dastard> <53EB9522.2070804@hp.com> <20140815033447.GJ20518@dastard>
In-Reply-To: <20140815033447.GJ20518@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 11:34 PM, Dave Chinner wrote:
>
> <create sparse vm image file of 500TB on ssd with XFS on it>
> xfs_io -f -c "truncate 500t" -c "extsize 1m" /path/to/vm/image/file
>
> <start 16p/16GB RAM vm with image file configured as:
> -drive file=/path/to/vm/image/file,if=virtio,cache=none>
>
> In vm:
>
> download and build fsmark from here:
>
> git://oss.sgi.com/dgc/fs_mark
>
> download and install xfsprogs v3.2.1 from here:
>
> git://oss.sgi.com/xfs/cmds/xfsprogs.git tags/v3.2.1
>
> Setup up the target filesystem:
>
> # mkfs.xfs -f -m "crc=1,finobt=1" /dev/vda
> # mount -o logbsize=262144,nobarrier /dev/vda /mnt/scratch
>
>
> Run:
>
> # fs_mark  -D  10000  -S0  -n  50000  -s  0  -L  32 \
>          -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
>          -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
>          -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
>          -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
>          -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
>          -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
>          -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
>          -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
>
> If you've got everything set up right, that should run at around
> 200-250,000 file creates/s. When finished, unmount and run:
>
> # xfs_repair -o bhash=500000 /dev/vda
>
> And that should spend quite a long while pounding on the mmap_sem
> until the the userspace buffer cache stops growing.
>
> I just ran the above on 3.16, saw this from perf:
>
>    37.30%  [kernel]  [k] _raw_spin_unlock_irqrestore
>     - _raw_spin_unlock_irqrestore
>        - 62.00% rwsem_wake
>           - call_rwsem_wake
>              + 83.52% sys_mprotect
>              + 16.23% __do_page_fault
>        + 35.15% try_to_wake_up
>        + 0.96% update_blocked_averages
>        + 0.61% pagevec_lru_move_fn
> -  23.35%  [kernel]  [k] _raw_spin_unlock_irq
>     - _raw_spin_unlock_irq
>        + 51.37% finish_task_switch
>        + 39.37% rwsem_down_write_failed
>        + 8.49% rwsem_down_read_failed
>          0.62% run_timer_softirq
> +   5.22%  [kernel]  [k] native_read_tsc
> +   3.89%  [kernel]  [k] rwsem_down_write_failed
> .....
>
> Cheers,
>
> Dave.
>

Thank for the testing recipe. I am afraid that I can't find a 500TB SSD 
for testing purpose. Do you think the test will still be valid for 
exercising rwsem if I use a smaller SSD or maybe mechanical hard disk?

-Longman
