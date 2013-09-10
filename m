Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3IJX2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:28:48 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:60963 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3IJX2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:28:47 -0400
Date: Wed, 11 Sep 2013 02:27:25 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130910232725.GC2450@swordfish>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910143416.GC2270@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/10/13 17:34), Sergey Senozhatsky wrote:
[..]
> > 
> > Now I think we can drop the call to handle_pending_slot_free() in
> > zram_bvec_rw() altogether. As long as the write lock is held when
> > handle_pending_slot_free() is called, there is no race. It's no different
> > from any write request and the current code handles R/W concurrency
> > already.
> 
> Yes, I think that can work. 
> 
> To summarize, there should be 3 patches:
> 1) handle_pending_slot_free() in zram_bvec_rw() (as suggested by Jerome Marchand)
> 2) handle_pending_slot_free() race with reset (found by Dan Carpenter)
> 3) drop init_done and use init_done()
> 
> I'll prepare a patches later today.

I've sent two patches:
 staging: zram: fix handle_pending_slot_free() and zram_reset_device() race
 staging: zram: remove init_done from zram struct (v3)

Cc'd driverdev-devel@linuxdriverproject.org as suggested by Dan.

please discard any previous patches and sorry for the noise.

Thanks,
	-ss

> 
> > Jerome
> > 
> > > 
> > >>
> > >> 1) You haven't given us any performance numbers so it's not clear if the
> > >>    locking is even a problem.
> > >>
> > >> 2) The v2 patch introduces an obvious deadlock in zram_slot_free()
> > >>    because now we take the rw_lock twice.  Fix your testing to catch
> > >>    this kind of bug next time.
> > >>
> > >> 3) Explain why it is safe to test zram->slot_free_rq when we are not
> > >>    holding the lock.  I think it is unsafe.  I don't want to even think
> > >>    about it without the numbers.
> > >>
> > >> regards,
> > >> dan carpenter
> > >>
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > > 
> > 
