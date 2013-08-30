Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3H3Ouc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:50:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:59217 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab3H3Oub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:50:31 -0400
Message-ID: <5220B12A.1060008@parallels.com>
Date: Fri, 30 Aug 2013 18:50:18 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <riel@redhat.com>, Kirill Korotaev <dev@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>, <linux-mm@kvack.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <fengguang.wu@intel.com>,
        <devel@openvz.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 10/16] fuse: Implement writepages callback
References: <20130629172211.20175.70154.stgit@maximpc.sw.ru> <20130629174525.20175.18987.stgit@maximpc.sw.ru> <20130719165037.GA18358@tucsk.piliscsaba.szeredi.hu> <51FBD2DF.50506@parallels.com> <CAJfpegtr4+vv_ZzuM7EE7MkHPqNi4brQamg4ZOWb2Me+iG87JQ@mail.gmail.com> <52050474.8040608@parallels.com> <20130830101207.GD19636@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20130830101207.GD19636@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

08/30/2013 02:12 PM, Miklos Szeredi пишет:
> On Fri, Aug 09, 2013 at 07:02:12PM +0400, Maxim Patlasov wrote:
>> 08/06/2013 08:25 PM, Miklos Szeredi пишет:
>>> Hmm.  Direct IO on an mmaped file will do get_user_pages() which will
>>> do the necessary page fault magic and ->page_mkwrite() will be called.
>>> At least AFAICS.
>> Yes, I agree.
>>
>>> The page cannot become dirty through a memory mapping without first
>>> switching the pte from read-only to read-write first.  Page accounting
>>> logic relies on this too.  The other way the page can become dirty is
>>> through write(2) on the fs.  But we do get notified about that too.
>> Yes, that's correct, but I don't understand why you disregard two
>> other cases of marking page dirty (both related to direct AIO read
>> from a file to a memory region mmap-ed to a fuse file):
>>
>> 1. dio_bio_submit() -->
>>        bio_set_pages_dirty() -->
>>          set_page_dirty_lock()
>>
>> 2. dio_bio_complete() -->
>>        bio_check_pages_dirty() -->
>>           bio_dirty_fn() -->
>>              bio_set_pages_dirty() -->
>>                 set_page_dirty_lock()
>>
>> As soon as a page became dirty through a memory mapping (exactly as
>> you explained), nothing would prevent it to be written-back. And
>> fuse will call end_page_writeback almost immediately after copying
>> the real page to a temporary one. Then dio_bio_submit may re-dirty
>> page speculatively w/o notifying fuse. And again, since then nothing
>> would prevent it to be written-back once more. Hence we can end up
>> in more then one temporary page in fuse write-back. And similar
>> concern for dio_bio_complete() re-dirty.
>>
>> This make me think that we do need fuse_page_is_writeback() in
>> fuse_writepages_fill(). But it shouldn't be harmful because it will
>> no-op practically always due to waiting for fuse writeback in
>> ->page_mkwrite() and in course of handling write(2).
> The problem is: if we need it in ->writepages, we need it in ->writepage too.
> And that's where we can't have it because it would deadlock in reclaim.

I thought we're protected from the deadlock by the following chunk (in 
the very beginning of fuse_writepage):

> +	if (fuse_page_is_writeback(inode, page->index)) {
> +		if (wbc->sync_mode != WB_SYNC_ALL) {
> +			redirty_page_for_writepage(wbc, page);
> +			return 0;
> +		}
> +		fuse_wait_on_page_writeback(inode, page->index);
> +	}

Because reclaimer will never call us with WB_SYNC_ALL. Did I miss 
something?

>
> There's a way to work around this:
>
>     - if the request is still in queue, just update it with the contents of the
>       new page
>
>     - if the request already in userspace, create a new reqest, but only let
>       userspace have it once the previous request for the same page completes, so
>       the ordering is not messed up
>
> But that's a lot of hairy code.

Is it exactly how NFS solves similar problem?

>
> Any other ideas?
>
> The best would be if we could get rid of the ugly temporary page requirement for
> fuse writeback.  The big blocker has always been direct reclaim: allocation must
> not wait on fuse writebacks.  AFAICS there's still a wait_on_page_writeback() in
> relation to memcg.  And it interacts with page migration which also has them.
> Those are the really difficult ones...

Yes, I agree. I think there are pretty many reasons not to keep original 
page under writeback for long. And not to make it dependant on userspace 
process as well.

>
> The other offender, balance_dirty_pages() is much easier and needs to be tought
> about fuse behavior anyway.

BTW, strictlimit feature (including its enable for fuse) is already in 
linux-next.

Thanks,
Maxim
