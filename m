Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3FNOD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:03:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:53448 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3FNODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:03:54 -0400
Message-ID: <51BB2295.1020105@parallels.com>
Date: Fri, 14 Jun 2013 18:03:01 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 09/14] fuse: Implement writepages and write_begin/write_end
 callbacks - v3
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru> <20130401104202.19027.99619.stgit@maximpc.sw.ru> <CAJfpegskt2zmKyx5sB49em86HqEJH3mZFH5hnuDXPuD_EtYzyw@mail.gmail.com>
In-Reply-To: <CAJfpegskt2zmKyx5sB49em86HqEJH3mZFH5hnuDXPuD_EtYzyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

04/25/2013 02:35 PM, Miklos Szeredi пишет:
> On Mon, Apr 1, 2013 at 12:42 PM, Maxim V. Patlasov
> <MPatlasov@parallels.com> wrote:
>> The .writepages one is required to make each writeback request carry more than
>> one page on it.
> I'd split this into two parts:
>
> 1) implement ->writepages() and enable it unconditionally for mmaped
> writeback (why is it not enabled by this patch?)
>
> 2) implement ->write_begin() and ->write_end() and conditionally
> enable cached writeback
>
> More comments inline.

Thanks a lot for careful review. I agree with most of your comments and 
will address them in the next version of patchset. The only point I 
disagree is the following:

>> +
>> +       spin_lock(&fc->lock);
>> +       list_add(&req->writepages_entry, &fi->writepages);
>> +       spin_unlock(&fc->lock);
>> +
>> +       for (i = 0; i < req->num_pages; i++) {
>> +               struct page *page = req->pages[i];
>> +               struct page *tmp_page;
>> +
>> +               tmp_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
>> +               if (tmp_page) {
>> +                       copy_highpage(tmp_page, page);
>> +                       inc_bdi_stat(bdi, BDI_WRITEBACK);
>> +                       inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
> Is there a reason why we do the page allocation/copying here instead
> of at fill time?  I'd guess it would be simpler and more logical
> there.

There is a problem to have in mind: we can't call 
end_page_writeback(page) before update of fuse writeback state 
(fi->writepages). Otherwise a nasty race would be possible when an 
activity for that particular page offset intervenes in the middle of 
writeback leading to multiple in-flight fuse requests for given page offset.

What you suggested is doable but would require additional space to stash 
pointers to original pages because we cannot release them immediately 
after copying (due to the problem described above). The size of the 
space is not known in advance because we don't know how many pages 
write_cache_pages() will process. The size is currently limited by 
sizeof(struct page *) * FUSE_MAX_PAGES_PER_REQ, but may become variable 
in future (a lot of people complain about 128K limit of fuse request). 
Adding dynamically growing array of pages would make the code neither 
simpler nor logical.

The approach I implemented utilizes the fact that 
fuse_page_is_writeback() and friends require only 
req->misc.write.in.offset and req->num_pages to be set correctly. Actual 
pointers in req->pages[] doesn't matter. Thus, as soon as the two 
parameters are known, I add the request to fi->writepages (blocking 
other operations on given page offset) and perform "in place" 
allocation/copying avoiding need for extra space to stash page pointers.

Thanks,
Maxim
