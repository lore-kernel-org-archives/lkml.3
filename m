Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3H2NBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:01:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:57774 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3H2NBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:01:10 -0400
Message-ID: <521F4612.9090708@parallels.com>
Date: Thu, 29 Aug 2013 17:01:06 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <xemul@parallels.com>, <fuse-devel@lists.sourceforge.net>,
        <bfoster@redhat.com>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <linux-fsdevel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH] fuse: hotfix truncate_pagecache() issue
References: <20130828121920.23965.78383.stgit@maximpc.sw.ru> <20130829092533.GA18044@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20130829092533.GA18044@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

08/29/2013 01:25 PM, Miklos Szeredi пишет:
> On Wed, Aug 28, 2013 at 04:21:46PM +0400, Maxim Patlasov wrote:
>> The way how fuse calls truncate_pagecache() from fuse_change_attributes()
>> is completely wrong. Because, w/o i_mutex held, we never sure whether
>> 'oldsize' and 'attr->size' are valid by the time of execution of
>> truncate_pagecache(inode, oldsize, attr->size). In fact, as soon as we
>> released fc->lock in the middle of fuse_change_attributes(), we completely
>> loose control of actions which may happen with given inode until we reach
>> truncate_pagecache. The list of potentially dangerous actions includes mmap-ed
>> reads and writes, ftruncate(2) and write(2) extending file size.
>>
>> The typical outcome of doing truncate_pagecache() with outdated arguments is
>> data corruption from user point of view. This is (in some sense) acceptable
>> in cases when the issue is triggered by a change of the file on the server
>> (i.e. externally wrt fuse operation), but it is absolutely intolerable in
>> scenarios when a single fuse client modifies a file without any external
>> intervention. A real life case I discovered by fsx-linux looked like this:
>>
>> 1. Shrinking ftruncate(2) comes to fuse_do_setattr(). The latter sends
>> FUSE_SETATTR to the server synchronously, but before getting fc->lock ...
>> 2. fuse_dentry_revalidate() is asynchronously called. It sends FUSE_LOOKUP
>> to the server synchronously, then calls fuse_change_attributes(). The latter
>> updates i_size, releases fc->lock, but before comparing oldsize vs attr->size..
>> 3. fuse_do_setattr() from the first step proceeds by acquiring fc->lock and
>> updating attributes and i_size, but now oldsize is equal to outarg.attr.size
>> because i_size has just been updated (step 2). Hence, fuse_do_setattr()
>> returns w/o calling truncate_pagecache().
>> 4. As soon as ftruncate(2) completes, the user extends file size by write(2)
>> making a hole in the middle of file, then reads data from the hole either by
>> read(2) or mmap-ed read. The user expects to get zero data from the hole, but
>> gets stale data because truncate_pagecache() is not executed yet.
>>
>> The patch is a hotfix resolving the issue in a simplistic way: let's skip
>> dangerous i_size update and truncate_pagecache if an operation changing file
>> size is in progress. This simplistic approach looks correct for the cases
>> w/o external changes. And to handle them properly, more sophisticated and
>> intrusive techniques (e.g. NFS-like one) would be required. I'd like
>> to postpone it until the issue is well discussed on the mailing list(s).
> Thanks for the analysis!
>
> Okay, what about this even more simplistic approach?
>
> Not tested, but I think it addresses the very crux of the issue: not truncating
> the page cache even though we should.

The patch looks fine, but it solves only one side of the problem 
(exactly what you formulated above). Another side is opposite: 
truncating page cache too late, when the state of inode changed 
significantly. The beginning may be as in the scenario above: 
fuse_dentry_revalidate() discovered that i_size changed (due to our own 
fuse_do_setattr()) and is going to call truncate_pagecache() for some 
'new_size' it believes valid right now. But by the time that particular 
truncate_pagecache() is called, a lot of things may happen:

1) fuse_do_setattr() called truncate_pagecache() according to your patch
2) the file was extended either by write(2) or ftruncate(2) or fallocate(2).
3) mmap-ed write make a page in the extended region dirty

The result will be the lost of data user wrote on the step '3)'. (my 
patch solves the issue at least for all cases w/o external changes)

>
> AFAICS there's no such issue with write(2) or fallocate(2).  But I haven't
> thought about this very deeply.

I added bits to the fuse_perform_write() to address that other side of 
the issue. Fixing fallocate is also required, but I postponed it until 
you include that another fix for fallocate (incorrect use of 
fuse_set_nowrite()).

Thanks,
Maxim
