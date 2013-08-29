Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3H2MiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:38:25 -0400
Received: from relay.parallels.com ([195.214.232.42]:53096 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3H2MiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:38:24 -0400
Message-ID: <521F40BE.901@parallels.com>
Date: Thu, 29 Aug 2013 16:38:22 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, <xemul@parallels.com>
Subject: Re: [PATCH] fuse: fix race in fuse_writepages()
References: <20130816115057.6492.39356.stgit@maximpc.sw.ru> <20130829114650.GA19636@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20130829114650.GA19636@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

08/29/2013 03:46 PM, Miklos Szeredi пишет:
> On Fri, Aug 16, 2013 at 03:51:41PM +0400, Maxim Patlasov wrote:
>> The patch is for
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git writepages.v2
>>
>> The patch fixes a race between ftruncate(2), mmap-ed write and write(2):
>>
>> 1) An user makes a page dirty via mmap-ed write.
>> 2) The user performs shrinking truncate(2) intended to purge the page.
>> 3) Before fuse_do_setattr calls truncate_pagecache, the page goes to
>>     writeback. fuse_writepages_fill attaches a new page to FUSE_WRITE request,
>>     then releases the original page by end_page_writeback and unlock it.
>> 4) fuse_do_setattr completes and successfully returns. Since now, i_mutex
>>     is free.
>> 5) Ordinary write(2) extends i_size back to cover the page. Note that
>>     fuse_send_write_pages do wait for fuse writeback, but for another
>>     page->index.
>> 6) fuse_writepages_fill attaches more pages to the request (if any), then
>>     fuse_writepages_send is eventually called. It is supposed to crop
>>     inarg->size of the request, but it doesn't because i_size has already been
>>     extended back.
>>
>> Moving end_page_writeback behind fuse_writepages_send guarantees that
>> __fuse_release_nowrite (called from fuse_do_setattr) will crop inarg->size
>> of the request before write(2) gets the chance to extend i_size.
> Thanks for the report.  Your analysis looks correct.
>
> Just one nit, why orig_pages? req->pages is already there, so why duplicate it?

req->pages is there, but it is already occupied by new pages (allocated 
by fuse_writepages_fill). We can't re-use req->pages for original pages 
because as soon as we put the request to bg_queue (in 
fuse_writepages_send) and released fc->lock, req->pages may be accessed 
w/o any delay. So we have two bunches of pointers to "struct page" to be 
stashed somewhere : original and new one. req->pages is for new pages, 
orig_pages[] is for original ones.

> Note: you can do __fuse_get_request()/fuse_put_request() to prevent the req from
> going away after it's been sent.

Yes, I experimented with this technique before adding orig_pages[]. I 
was very reluctant about duplicating that page array and was looking for 
any opportunity to avoid it. Pinning original pages to new ones using 
page->private looked promising, but unfortunately it didn't work because 
__fuse_get_request() protects only request itself from disappearing, not 
from releasing pages that req->pages[] points to. And obviously, as soon 
as a page released, it's not correct to rely on the content of its 
'private' field.

Thanks,
Maxim
