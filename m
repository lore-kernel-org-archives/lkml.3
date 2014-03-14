Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaCNOR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:17:58 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:43773 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaCNOR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140314141143.GH12613@htj.dyndns.org>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
	<20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
	<CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
	<CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
	<20140313200119.GB504@quack.suse.cz>
	<20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
	<20140314130712.GC12613@htj.dyndns.org>
	<CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
	<20140314141143.GH12613@htj.dyndns.org>
Date: Fri, 14 Mar 2014 23:17:56 +0900
Message-ID: <CACZ9PQWtHJh6j_bKwB-HF4h3rU3813AN2qUibkCs7tmXUrLJoQ@mail.gmail.com>
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

On Fri, Mar 14, 2014 at 11:11 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Mar 14, 2014 at 11:07:04PM +0900, Roman Peniaev wrote:
>> Seems the following message should be better:
>> When data inegrity operation (sync, fsync, fdatasync calls) happens
>> writeback control is set to WB_SYNC_ALL.
>> In that case all write requests are marked with WRITE_SYNC, but on
>> mpage writeback path
>> WRITE_SYNC is missed. This patch fixes this.
>>
>> Is it ok, what do you think?
>
> I think the description should make it clear that WRITE_SYNC is about
> latency, not about integrity and we probably should add comments
> explaining why we're using WRITE_SYNC for WB_SYNC_ALL (because there
> probably is someone waiting).
>
>> Also, could you please help me do understand how can I guarantee
>> integrity in case of block device with big volatile
>> cache and filesystem, which does not support REQ_FLUSH/FUA?
>
> If a device has a volatile cache but doesn't support flush, it can't
> guarantee integrity.  There's no way for its user to determine or
> force whether certain data is on non-volatile media.  It's an
> inherently broken device.

No, no. Not device does not support flush, filesystem does not care about flush.
(take any old school, e.g. ext2)

We did some write, and then we did fsync.
But filesystem does not support REQ_FLUSH/FUA so block device will never
get the checkpoint where it should really flush everything.

So, fsync will not guarantee any integrity in that case.


>
> Thanks.
>
> --
> tejun
