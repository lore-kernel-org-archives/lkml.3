Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3DYQTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:19:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:56591 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3DYQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:19:08 -0400
Message-ID: <517956ED.7060102@parallels.com>
Date: Thu, 25 Apr 2013 20:16:45 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, <devel@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, <fengguang.wu@intel.com>,
        <mgorman@suse.de>
Subject: Re: [fuse-devel] [PATCH 14/14] mm: Account for WRITEBACK_TEMP in
 balance_dirty_pages
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru> <20130401104250.19027.27795.stgit@maximpc.sw.ru> <51793DE6.3000503@parallels.com> <CAJfpegv1zc4oeE=YXrQd0jmzVXB8jjvXkz-_4Nv_ELcvfsa74Q@mail.gmail.com>
In-Reply-To: <CAJfpegv1zc4oeE=YXrQd0jmzVXB8jjvXkz-_4Nv_ELcvfsa74Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

04/25/2013 07:49 PM, Miklos Szeredi пишет:
> On Thu, Apr 25, 2013 at 4:29 PM, Maxim V. Patlasov
> <mpatlasov@parallels.com> wrote:
>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>> index 0713bfb..c47bcd4 100644
>>> --- a/mm/page-writeback.c
>>> +++ b/mm/page-writeback.c
>>> @@ -1235,7 +1235,8 @@ static void balance_dirty_pages(struct address_space
>>> *mapping,
>>>                   */
>>>                  nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>>>
>>> global_page_state(NR_UNSTABLE_NFS);
>>> -               nr_dirty = nr_reclaimable +
>>> global_page_state(NR_WRITEBACK);
>>> +               nr_dirty = nr_reclaimable +
>>> global_page_state(NR_WRITEBACK) +
>>> +                       global_page_state(NR_WRITEBACK_TEMP);
>>>                  global_dirty_limits(&background_thresh, &dirty_thresh);
>>
>> Please drop this patch. As we discussed in LSF/MM, the fix above is correct,
>> but it's not enough: we also need to ensure disregard of NR_WRITEBACK_TEMP
>> when balance_dirty_pages() is called from fuse daemon. I'll send a separate
>> patch-set soon.
> Please elaborate.  From a technical perspective "fuse daemon" is very
> hard to define, so anything that relies on whether something came from
> the fuse daemon or not is conceptually broken.

As Mel Gorman pointed out, fuse daemon diving into balance_dirty_pages 
should not kick flusher judging on NR_WRITEBACK_TEMP. Essentially, all 
we need in balance_dirty_pages is:

     if (I'm not fuse daemon)
         nr_dirty += global_page_state(NR_WRITEBACK_TEMP);

The way how to identify fuse daemon was not thoroughly scrutinized 
during LSF/MM. Firstly, I thought it would be enough to set a 
per-process flag handling fuse device open. But now I understand that 
fuse daemon may be quite a complicated multi-threaded multi-process 
construction. I'm going to add new FUSE_NOTIFY to allow fuse daemon 
decide when it works on behalf of draining writeout-s. Having in mind 
that fuse-lib is multi-threaded, I'm also going to inherit the flag on 
copy_process(). Does it make sense for you?

Also, another patch will put this ad-hoc FUSE_NOTIFY under fusermount 
control. This will prevent malicious unprivileged fuse mounts from 
setting the flag for malicious purposes.

Thanks,
Maxim
