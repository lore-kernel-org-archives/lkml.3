Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaCNOHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:07:08 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41042 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaCNOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:07:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140314130712.GC12613@htj.dyndns.org>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
	<20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
	<CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
	<CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
	<20140313200119.GB504@quack.suse.cz>
	<20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
	<20140314130712.GC12613@htj.dyndns.org>
Date: Fri, 14 Mar 2014 23:07:04 +0900
Message-ID: <CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
From: Roman Peniaev <r.peniaev@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tejun.

On Fri, Mar 14, 2014 at 10:07 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Andrew.
>
> On Thu, Mar 13, 2014 at 02:34:56PM -0700, Andrew Morton wrote:
>> Jens isn't talking to us.  Tejun, are you able explain REQ_SYNC?
>
> It has nothing to do with data integrity.  It's just a hint telling
> the block layer that someone is waiting for the IO so it'd be a good
> idea to prioritize it.  For example, nothing visible to userland
> really waits for periodic writebacks, so we can delay their processing
> to prioritize, for example, READs triggered from a page fault, which
> is obviously causing userland visible latency.
>
> Block layer treats all READs as REQ_SYNC and also allows upper layers
> to mark some writes REQ_SYNC for cases where somebody is waiting for
> the write to complete for cases like flush(2).
>
>> From: Roman Pen <r.peniaev@gmail.com>
>> Subject: fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write
>>
>> In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity
>> write, thus mark request as WRITE_SYNC.
>
> So, at least this patch description is very misleading.  WRITE_SYNC
> has *NOTHING* to do with data integrity.  The only thing matters is
> whether somebody is waiting for its completion or not.

The thing is that I started investigating WB_SYNC_ALL and WRITE_SYNC
from the __filemap_fdatawrite_range call which has explicit comment:

 * If sync_mode is WB_SYNC_ALL then this is a "data integrity" operation, as
 * opposed to a regular memory cleansing writeback.

So, in the commit msg I want to say that when we are doing integrity write
(sync, fsync calls) we have to mark requests as WRITE_SYNC, and there
is only one path
(mpage writeback path)  where WRITE_SYNC is missed. That was the idea.
(not WRITE_SYNC is responsible for integrity write, but in case of
integrity write)

Seems the following message should be better:
When data inegrity operation (sync, fsync, fdatasync calls) happens
writeback control is set to WB_SYNC_ALL.
In that case all write requests are marked with WRITE_SYNC, but on
mpage writeback path
WRITE_SYNC is missed. This patch fixes this.

Is it ok, what do you think?

Also, could you please help me do understand how can I guarantee
integrity in case of block device with big volatile
cache and filesystem, which does not support REQ_FLUSH/FUA?

Even if I am doing fsync, block device will never receive any
indication, that these requests should really be stored on device,
or cache should be flushed right now (like REQ_FLUSH/FUA behaviour).

Seems it is impossible to do explicit block device cache flush if
filesystem does not care about it.

Thanks.

--
Roman

>
> Thanks.
>
> --
> tejun
