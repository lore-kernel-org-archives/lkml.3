Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaJFPc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:32:28 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:57570 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJFPc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:32:27 -0400
Date: Mon, 6 Oct 2014 11:32:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Arun KS <arunks.linux@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        laijs@cn.fujitsu.com, Silesh C V <saileshcv@gmail.com>,
        Arun KS <getarunks@gmail.com>
Subject: Re: [Workqueue] crash in process_one_work
Message-ID: <20141006153224.GC18303@htj.dyndns.org>
References: <CAKZGPAPS+x2V3Ajj323EUStpWGmZ6taOuovjqA3_kaYXA3T_Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKZGPAPS+x2V3Ajj323EUStpWGmZ6taOuovjqA3_kaYXA3T_Ag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arun.

On Mon, Sep 29, 2014 at 09:40:50PM +0530, Arun KS wrote:
...
> The value of data is 0xffffffe0, which is basically the value after an
> INIT_WORK() or WORK_DATA_INIT().
> This can happen if a driver calls INIT_WORK on same struct work again
> after queuing it.
> 
> From the above details of the work_struct shows that the work is
> queued from kernel/async.c. async_schedule dynamically allocates the
> work_struct and queues it to system_unbonded_wq. And possibility of
> calling INIT_WORK on same work is not there.
> 
> After inspecting ramdump for async_entry structure in kernel/async.c
> 
> crash> struct async_entry ed7cf140
> struct async_entry {
>   domain_list = {
>     next = 0xed7cf140,
>     prev = 0xed7cf140
>   },
>   global_list = {
>     next = 0xed7cf148,
>     prev = 0xed7cf148
>   },
>   work = {
>     data = {
>       counter = 0xffffffe0
>     },
>     entry = {
>       next = 0xed7cf154,
>       prev = 0xed7cf154
>     },
>     func = 0xc0140ac4 <async_run_entry_fn>
>   },
>   cookie = 0x263e5,
>   func = 0xc074dda0 <dapm_post_sequence_async>,
>   data = 0xed48432c,
>   domain = 0xe5457dec
> }
> 
> the func points to dapm_post_sequence_async. and you can see the
> domain_list and global_list is empty. Which shows that the work has
> finished execution and there is no pending execution in async.
> 
> But how come this struct work was with work queue data structures?
> Is there any corner case in work queue which can miss unlinking the
> struct_work from pool_workqueue after executing them?

I sure hope not.  How reproducible is the issue?  Can you try w/
CONFIG_DEBUG_OBJECTS_WORK enabled?

Thanks.

-- 
tejun
