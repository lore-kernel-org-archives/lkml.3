Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3HMNpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:45:39 -0400
Received: from relay.parallels.com ([195.214.232.42]:37618 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3HMNph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:45:37 -0400
Message-ID: <520A388B.7030001@parallels.com>
Date: Tue, 13 Aug 2013 17:45:47 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Brian Foster <bfoster@redhat.com>
CC: <miklos@szeredi.hu>, <fuse-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        <xemul@parallels.com>
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate()
References: <20130812163739.10366.64896.stgit@maximpc.sw.ru> <20130812163935.10366.88320.stgit@maximpc.sw.ru> <520A2114.1040203@redhat.com> <520A2D0E.5050103@parallels.com> <520A3352.5070709@redhat.com>
In-Reply-To: <520A3352.5070709@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08/13/2013 05:23 PM, Brian Foster пишет:
> On 08/13/2013 08:56 AM, Maxim Patlasov wrote:
>> Hi,
>>
>> 08/13/2013 04:05 PM, Brian Foster пишет:
>>> ...
>>> @@ -2478,8 +2516,11 @@ static long fuse_file_fallocate(struct file
>>> *file, int mode, loff_t offset,
>>>          if (lock_inode) {
>>>            mutex_lock(&inode->i_mutex);
>>> -        if (mode & FALLOC_FL_PUNCH_HOLE)
>>> -            fuse_set_nowrite(inode);
>>> +        if (mode & FALLOC_FL_PUNCH_HOLE) {
>>> +            truncate_pagecache_range(inode, offset,
>>> +                         offset + length - 1);
>>> +            fuse_wait_on_writeback(inode, offset, length);
>>> +        }
>>> If this happens to be the first attempt on an fs that doesn't support
>>> fallocate, we'll return -EOPNOTSUPP after having already punched out the
>>> data in the pagecache.
>> Yes, this is unpleasant, but it's not critical, imo. We're returning an
>> error code (even though equal to -EOPNOTSUPP) and a sane application
>> should not make any assumption about current state of the punched
>> region. Also, the application intended to discard given region of the
>> file, so why should it pay care for its content afterwards?
>>
> I agree, though most users probably wouldn't expect that a blatant error
> like EOPNOTSUPP leave the range in a weird state. What's more, it only
> does so if it's the first attempt and behaves more appropriately after
> that.
>
>>> What about replacing the nowrite logic with a
>>> flush (and still followed by your new writeback wait logic) rather than
>>> moving the pagecache truncate?
>> The "flush" you mentioned should firstly flush page cache.
>> invalidate_inode_pages2_range() seems to be a candidate. We definitely
>> cannot ignore error code from it because it can be fuse_launder_page()
>> who got -ENOMEM from fuse_writepage_locked(). In case of err == -ENOMEM,
>> we could safely fail fallocate, but what should we do if it's -EBUSY?
>> Any ideas?
>>
> I was referring to something like filemap_write_and_wait_range(), for
> example. Then continue to use truncate_pagecache_range() as we do today.
> Thoughts

Looks nice. I'll send updated patch after some testing. Thanks a lot for 
the suggestion!

Maxim
