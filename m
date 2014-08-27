Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264AbaH0QJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:09:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:43495 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934744AbaH0QJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:09:19 -0400
Message-ID: <53FE029B.1030200@parallels.com>
Date: Wed, 27 Aug 2014 20:08:59 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        open list:
	AIO <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>	<1408031441-31156-6-git-send-email-ming.lei@canonical.com>	<20140815163111.GA16652@infradead.org>	<53EE370D.1060106@kernel.dk>	<53EE3966.60609@kernel.dk>	<CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>	<53F0EAEC.9040505@kernel.dk>	<CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>	<CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>	<53F3B89D.6070703@kernel.dk> <CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>
In-Reply-To: <CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:44 AM, Ming Lei wrote:
> On Wed, Aug 20, 2014 at 4:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
>>
>> Reworked a bit more:
>>
>> http://git.kernel.dk/?p=linux-block.git;a=commit;h=a323185a761b9a54dc340d383695b4205ea258b6
> One big problem of the commit is that it is basically a serialized workqueue
> because of single &hctx->run_work, and per-req work_struct has to be
> used for concurrent implementation.  So looks the approach isn't flexible
> enough compared with doing that in driver, or any idea about how to fix
> that?
>

I'm interested what's the price of handling requests in a separate 
thread at large. I used the following fio script:

     [global]
     direct=1
     bsrange=512-512
     timeout=10
     numjobs=1
     ioengine=sync

     filename=/dev/loop0 # or /dev/nullb0

     [f1]
     rw=randwrite

to compare the performance of:

1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops
2) the same as above, but call loop_queue_work() directly from 
loop_queue_rq() -- 270K iops
3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops

Taking into account so big difference (11K vs. 270K), would it be worthy 
to implement pure non-blocking version of aio_kernel_submit() returning 
error if blocking needed? Then loop driver (or any other in-kernel user) 
might firstly try that non-blocking submit as fast-path, and, only if 
it's failed, fall back to queueing.

Thanks,
Maxim
