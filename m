Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3BDKVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:21:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab3BDKVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:21:30 -0500
Date: Mon, 4 Feb 2013 11:21:27 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: Re: [PATCH] udf: add extent cache support in case of file reading
Message-ID: <20130204102127.GB7523@quack.suse.cz>
References: <1358561834-8108-1-git-send-email-linkinjeon@gmail.com>
 <20130121110442.GF5588@quack.suse.cz>
 <CAKYAXd-_chC9zFtC7A=puo9AgQSAD5JbkF=y=ZYP5vS7bO7-dg@mail.gmail.com>
 <20130122100447.GA31140@quack.suse.cz>
 <CAKYAXd_3Fxxsw=nQs3aZK8V+DqfhYgWmF14Qxr7J-QJ+i-9=Ug@mail.gmail.com>
 <CAKYAXd8YuAmy+EDK9ck8n1kq_GgzRUfhSbgrVZWa5sdaPUKPKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd8YuAmy+EDK9ck8n1kq_GgzRUfhSbgrVZWa5sdaPUKPKA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 02-02-13 15:21:09, Namjae Jeon wrote:
> Hi. Jan.
> 
> Sorry for interrupt.
> Have you taken this patch to your tree ? I can not find it..
> or Is there any issue regarding this patch ?
  I had it in my tree but not in the for_next branch. Did it now so you
should see the patch in tomorrow's linux-next.

									Honza
> 2013/1/22, Namjae Jeon <linkinjeon@gmail.com>:
> > 2013/1/22, Jan Kara <jack@suse.cz>:
> >> On Tue 22-01-13 09:45:09, Namjae Jeon wrote:
> >>> 2013/1/21, Jan Kara <jack@suse.cz>:
> >>> > @@ -2222,6 +2219,8 @@ int udf_read_extent_cache(struct inode *inode,
> >>> > loff_t
> >>> > bcount,
> >>> >  		*lbcount = iinfo->cached_extent.lstart;
> >>> >  		memcpy(pos, &iinfo->cached_extent.epos,
> >>> >  		       sizeof(struct extent_position));
> >>> > +		if (pos->bh)
> >>> > +			get_bh(pos->bh);
> >>> >  		spin_unlock(&iinfo->i_extent_cache_lock);
> >>> >  		return 1;
> >>> >  	} else
> >>> >   This is the most important - we should give buffer reference to
> >>> > pos->bh.
> >>> > Caller will eventually free it right?
> >>> This change is not required as we give buffer reference to pos->bh at
> >>> the time of cache update.
> >>> When we start reading a file, first we try to read the cache which
> >>> will lead to cache miss.
> >>> So, we would really access the pos->bh in udf_update_extent_cache for
> >>> the first time, and this is where the buffer reference is incremented.
> >>> Calling get_bh at 2 places will eventually lead to mem leak.
> >>> Let me know your opinion.
> >>   Yes, udf_update_extent_cache() gets its own reference to bh but that is
> >> dropped in udf_clear_extent_cache(). So I think udf_read_extent_cache()
> >> needs to get a reference to the caller (as the caller will eventually
> >> free
> >> the bh via brelse(epos.bh) e.g. in udf_extend_file(). Also I realized
> >> udf_update_extent_cache() needs to first clear the cache if it is valid.
> >> Otherwise it just overwrites bh pointer and reference is leaked. Is it
> >> clearer now?
> > Yes, you're right. Also, this patch looks good to me.
> >>
> >>   I've also changed locking of udf_clear_extent_cache() so that
> >> i_extent_cache_lock is always taken for that function - it makes the
> >> locking rules obvious at the first sight.
> > Yes, right. it is needed.
> > When we test with this patch, working fine.
> > Thanks Jan!
> >>
> >>   Attached is the patch I currently carry.
> >>
> >> 								Honza
> >>
> >> --
> >> Jan Kara <jack@suse.cz>
> >> SUSE Labs, CR
> >>
> >
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
