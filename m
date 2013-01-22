Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3AVLtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:49:53 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38174 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3AVLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:49:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130122100447.GA31140@quack.suse.cz>
References: <1358561834-8108-1-git-send-email-linkinjeon@gmail.com>
	<20130121110442.GF5588@quack.suse.cz>
	<CAKYAXd-_chC9zFtC7A=puo9AgQSAD5JbkF=y=ZYP5vS7bO7-dg@mail.gmail.com>
	<20130122100447.GA31140@quack.suse.cz>
Date: Tue, 22 Jan 2013 20:49:50 +0900
Message-ID: <CAKYAXd_3Fxxsw=nQs3aZK8V+DqfhYgWmF14Qxr7J-QJ+i-9=Ug@mail.gmail.com>
Subject: Re: [PATCH] udf: add extent cache support in case of file reading
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/22, Jan Kara <jack@suse.cz>:
> On Tue 22-01-13 09:45:09, Namjae Jeon wrote:
>> 2013/1/21, Jan Kara <jack@suse.cz>:
>> > @@ -2222,6 +2219,8 @@ int udf_read_extent_cache(struct inode *inode,
>> > loff_t
>> > bcount,
>> >  		*lbcount = iinfo->cached_extent.lstart;
>> >  		memcpy(pos, &iinfo->cached_extent.epos,
>> >  		       sizeof(struct extent_position));
>> > +		if (pos->bh)
>> > +			get_bh(pos->bh);
>> >  		spin_unlock(&iinfo->i_extent_cache_lock);
>> >  		return 1;
>> >  	} else
>> >   This is the most important - we should give buffer reference to
>> > pos->bh.
>> > Caller will eventually free it right?
>> This change is not required as we give buffer reference to pos->bh at
>> the time of cache update.
>> When we start reading a file, first we try to read the cache which
>> will lead to cache miss.
>> So, we would really access the pos->bh in udf_update_extent_cache for
>> the first time, and this is where the buffer reference is incremented.
>> Calling get_bh at 2 places will eventually lead to mem leak.
>> Let me know your opinion.
>   Yes, udf_update_extent_cache() gets its own reference to bh but that is
> dropped in udf_clear_extent_cache(). So I think udf_read_extent_cache()
> needs to get a reference to the caller (as the caller will eventually free
> the bh via brelse(epos.bh) e.g. in udf_extend_file(). Also I realized
> udf_update_extent_cache() needs to first clear the cache if it is valid.
> Otherwise it just overwrites bh pointer and reference is leaked. Is it
> clearer now?
Yes, you're right. Also, this patch looks good to me.
>
>   I've also changed locking of udf_clear_extent_cache() so that
> i_extent_cache_lock is always taken for that function - it makes the
> locking rules obvious at the first sight.
Yes, right. it is needed.
When we test with this patch, working fine.
Thanks Jan!
>
>   Attached is the patch I currently carry.
>
> 								Honza
>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
