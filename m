Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3IINVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:21:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41761 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3IINVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:21:44 -0400
Date: Mon, 9 Sep 2013 16:21:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130909132124.GY6329@mwanda>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909124942.GA2221@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 03:49:42PM +0300, Sergey Senozhatsky wrote:
> > > Calling handle_pending_slot_free() for every RW operation may
> > > cause unneccessary slot_free_lock locking, because most likely
> > > process will see NULL slot_free_rq. handle_pending_slot_free()
> > > only when current detects that slot_free_rq is not NULL.
> > > 
> > > v2: protect handle_pending_slot_free() with zram rw_lock.
> > > 
> > 
> > zram->slot_free_lock protects zram->slot_free_rq but shouldn't the zram
> > rw_lock be wrapped around the whole operation like the original code
> > does?  I don't know the zram code, but the original looks like it makes
> > sense but in this one it looks like the locks are duplicative.
> > 
> > Is the down_read() in the original code be changed to down_write()?
> >
> 
> I'm not touching locking around existing READ/WRITE commands.
> 

Your patch does change the locking because now instead of taking the
zram lock once it takes it and then drops it and then retakes it.  This
looks potentially racy to me but I don't know the code so I will defer
to any zram maintainer.

1) You haven't given us any performance numbers so it's not clear if the
   locking is even a problem.

2) The v2 patch introduces an obvious deadlock in zram_slot_free()
   because now we take the rw_lock twice.  Fix your testing to catch
   this kind of bug next time.

3) Explain why it is safe to test zram->slot_free_rq when we are not
   holding the lock.  I think it is unsafe.  I don't want to even think
   about it without the numbers.

regards,
dan carpenter

