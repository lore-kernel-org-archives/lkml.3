Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3H2Q1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:27:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:37429 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3H2Q1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:27:33 -0400
Message-ID: <521F7672.7050407@parallels.com>
Date: Thu, 29 Aug 2013 20:27:30 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <xemul@parallels.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate()
 -v2
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru> <20130816112854.5630.1907.stgit@maximpc.sw.ru> <20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

08/29/2013 07:41 PM, Miklos Szeredi пишет:
> On Fri, Aug 16, 2013 at 03:30:27PM +0400, Maxim Patlasov wrote:
>> The patch fixes a race between mmap-ed write and fallocate(PUNCH_HOLE):
>>
>> 1) An user makes a page dirty via mmap-ed write.
>> 2) The user performs fallocate(2) with mode == PUNCH_HOLE|KEEP_SIZE
>>     and <offset, size> covering the page.
>> 3) Before truncate_pagecache_range call from fuse_file_fallocate,
>>     the page goes to write-back. The page is fully processed by fuse_writepage
>>     (including end_page_writeback on the page), but fuse_flush_writepages did
>>     nothing because fi->writectr < 0.
>> 4) truncate_pagecache_range is called and fuse_file_fallocate is finishing
>>     by calling fuse_release_nowrite. The latter triggers processing queued
>>     write-back request which will write stale data to the hole soon.
>>
>> Changed in v2 (thanks to Brian for suggestion):
>>   - Do not truncate page cache until FUSE_FALLOCATE succeeded. Otherwise,
>>     we can end up in returning -ENOTSUPP while user data is already punched
>>     from page cache. Use filemap_write_and_wait_range() instead.
> The problem with fuse_wait_on_writeback() is starvation.  You could have the
> page range continually being dirtied and written back and fallocate() livelocked
> in fuse_wait_on_writeback() for ever AFAICS.

Yes, I agree. I thought being infinitely dirtied is impossible if 
i_mutex is held, but now I understand it's not true for mmap-ed writes. 
I need to think more about it (livelock avoidance).

>
> So having a barrier like FUSE_NOWRITE is good but then we need to take care of
> throwing away the truncated part of the queue.  But that should be doable by
> passing the truncated range explicitly to fuse_release_nowrite().

Yes, I considered this approach, but splitting a fuse request into two 
in fuse_send_writepage() made me sick. What if allocation fails?

Thanks,
Maxim
