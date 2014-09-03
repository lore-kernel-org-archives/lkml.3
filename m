Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaICDaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:30:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40244 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaICDaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:30:20 -0400
Message-ID: <54068B3A.1090300@huawei.com>
Date: Wed, 3 Sep 2014 11:30:02 +0800
From: Xue jiufei <xuejiufei@huawei.com>
Reply-To: <xuejiufei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Junxiao Bi <junxiao.bi@oracle.com>, Dave Chinner <david@fromorbit.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH] fs/super.c: do not shrink fs slab during direct memory
 reclaim
References: <54004E82.3060608@huawei.com> <20140901235102.GI26465@dastard> <540587DF.6040302@huawei.com> <54067117.4060201@oracle.com>
In-Reply-To: <54067117.4060201@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.96]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Junxiao
On 2014/9/3 9:38, Junxiao Bi wrote:
> Hi Jiufei,
> 
> On 09/02/2014 05:03 PM, Xue jiufei wrote:
>> Hi, Dave
>> On 2014/9/2 7:51, Dave Chinner wrote:
>>> On Fri, Aug 29, 2014 at 05:57:22PM +0800, Xue jiufei wrote:
>>>> The patch trys to solve one deadlock problem caused by cluster
>>>> fs, like ocfs2. And the problem may happen at least in the below
>>>> situations:
>>>> 1)Receiving a connect message from other nodes, node queues a
>>>> work_struct o2net_listen_work.
>>>> 2)o2net_wq processes this work and calls sock_alloc() to allocate
>>>> memory for a new socket.
>>>> 3)It would do direct memory reclaim when available memory is not
>>>> enough and trigger the inode cleanup. That inode being cleaned up
>>>> is happened to be ocfs2 inode, so call evict()->ocfs2_evict_inode()
>>>> ->ocfs2_drop_lock()->dlmunlock()->o2net_send_message_vec(),
>>>> and wait for the unlock response from master.
>>>> 4)tcp layer received the response, call o2net_data_ready() and
>>>> queue sc_rx_work, waiting o2net_wq to process this work.
>>>> 5)o2net_wq is a single thread workqueue, it process the work one by
>>>> one. Right now it is still doing o2net_listen_work and cannot handle
>>>> sc_rx_work. so we deadlock.
>>>>
>>>> It is impossible to set GFP_NOFS for memory allocation in sock_alloc().
>>>> So we use PF_FSTRANS to avoid the task reentering filesystem when
>>>> available memory is not enough.
>>>>
>>>> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
>>>
>>> For the second time: use memalloc_noio_save/memalloc_noio_restore.
>>> And please put a great big comment in the code explaining why you
>>> need to do this special thing with memory reclaim flags.
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>> Thanks for your reply. But I am afraid that memalloc_noio_save/
>> memalloc_noio_restore can not solve my problem. __GFP_IO is cleared
>> if PF_MEMALLOC_NOIO is set and can avoid doing IO in direct memory
>> reclaim. However, __GFP_FS is still set that can not avoid pruning
>> dcache and icache in memory allocation, resulting in the deadlock I
>> described.
> 
> You can use PF_MEMALLOC_NOIO to replace PF_FSTRANS, set this flag in
> ocfs2 and check it in sb shrinker.
> 
Thanks for your advice. But I think using another process flag is better.
Do you think so? I will send another patch later.

Thanks,
XueJiufei 

> Thanks,
> Junxiao.
>>

>> Thanks.
>> XueJiufei
>>
>>
>>
> 
> .
> 


