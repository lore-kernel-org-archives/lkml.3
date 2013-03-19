Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3CSIRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:17:43 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:35178 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab3CSIRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <1363676658.27362.3.camel@kjgkr>
References: <1363585809-8138-1-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd9VawA5p+mWXdQUgq2rfNoYeRcj+zt0OM+k6eALCQjtcA@mail.gmail.com>
	<1363676658.27362.3.camel@kjgkr>
Date: Tue, 19 Mar 2013 17:17:39 +0900
Message-ID: <CAKYAXd8vJOkUorWVY8PTC+MqK8UPaaYB=4oQyUyFwdV+WqRALg@mail.gmail.com>
Subject: Re: [PATCH] f2fs: reduce unncessary locking pages during read
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/19, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-19 (화), 13:54 +0900, Namjae Jeon:
>> >
>> > -	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>> > -	if (err) {
>> > -		f2fs_put_page(page, 1);
>> > -		return ERR_PTR(err);
>> > +	if (PageUptodate(page)) {
>> > +		unlock_page(page);
>> > +		return page;
>> >  	}
>> > -	unlock_page(page);
>> Hi Jaegeuk.
>> > +
>> > +	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>> > +	wait_on_page_locked(page);
>> > +	if (!PageUptodate(page))
>> > +		return ERR_PTR(-EIO);
>> We don't need to release page before returning EIO ?
>
> Good catch! :)
>
>>
>> >  	return page;
>> >  }
>> >
>> > @@ -241,9 +244,13 @@ struct page *get_lock_data_page(struct inode
>> > *inode,
>> > pgoff_t index)
>> >  	BUG_ON(dn.data_blkaddr == NULL_ADDR);
>> >
>> >  	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>> > -	if (err) {
>> > -		f2fs_put_page(page, 1);
>> > +	if (err)
>> >  		return ERR_PTR(err);
>> Here is also same. We don't need to release page in case of err ?
>
> It's different.
> The f2fs_readpage() releases the page if error is occurred.
> Thanks,
Right~.  you can add
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
>
>>
