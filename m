Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaH1LtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:49:09 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:49499 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbaH1LtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:49:06 -0400
Message-ID: <53FF1703.3010204@mellanox.com>
Date: Thu, 28 Aug 2014 14:48:19 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Shawn Bohrer <shawn.bohrer@gmail.com>,
        Shachar Raindel <raindel@mellanox.com>
CC: Roland Dreier <roland@kernel.org>, Christoph Lameter <cl@linux.com>,
        "Sean Hefty" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomk@rgmadvisors.com" <tomk@rgmadvisors.com>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH] ib_umem_release should decrement mm->pinned_vm from ib_umem_get
References: <1407860855-6564-1-git-send-email-shawn.bohrer@gmail.com> <20140820232212.GA5487@sbohrermbp13-local.rgmadvisors.com> <6B2A6E60C06CCC42AE31809BF572352B010E235B4A@MTLDAG02.mtl.com> <20140825210700.GA5759@sbohrermbp13-local.rgmadvisors.com>
In-Reply-To: <20140825210700.GA5759@sbohrermbp13-local.rgmadvisors.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.3.227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/2014 00:07, Shawn Bohrer wrote:
>>>> The following patch fixes the issue by storing the mm_struct of the
>> > 
>> > You are doing more than just storing the mm_struct - you are taking
>> > a reference to the process' mm.  This can lead to a massive resource
>> > leakage. The reason is bit complex: The destruction flow for IB
>> > uverbs is based upon releasing the file handle for it. Once the file
>> > handle is released, all MRs, QPs, CQs, PDs, etc. that the process
>> > allocated are released.  For the kernel to release the file handle,
>> > the kernel reference count to it needs to reach zero.  Most IB
>> > implementations expose some hardware registers to the application by
>> > allowing it to mmap the uverbs device file.  This mmap takes a
>> > reference to uverbs device file handle that the application opened.
>> > This reference is dropped when the process mm is released during the
>> > process destruction.  Your code takes a reference to the mm that
>> > will only be released when the parent MR/QP is released.
>> > 
>> > Now, we have a deadlock - the mm is waiting for the MR to be
>> > destroyed, the MR is waiting for the file handle to be destroyed,
>> > and the file handle is waiting for the mm to be destroyed.
>> > 
>> > The proper solution is to keep a reference to the task_pid (using
>> > get_task_pid), and use this pid to get the task_struct and from it
>> > the mm_struct during the destruction flow.
>  
> I'll put together a patch using get_task_pid() and see if I can
> test/reproduce the issue.  This may take a couple of days since we
> have to test this in production at the moment.
>  

Hi,

I just wanted to point out that while working on the on demand paging patches
we also needed to keep a reference to the task pid (to make sure we always 
handle page faults on behalf of the correct mm struct). You can find the 
relevant code in the patch titled "IB/core: Add support for on demand paging 
regions" [1].

Haggai

[1] https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg20552.html
