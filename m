Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaETO0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:26:49 -0400
Received: from kanga.kvack.org ([205.233.56.17]:33725 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaETO0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:26:47 -0400
Date: Tue, 20 May 2014 10:26:46 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: hanging aio process
Message-ID: <20140520142646.GG2915@kvack.org>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1405201508450.1606@denkbrett>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:16:47PM +0200, Sebastian Ott wrote:
> On Tue, 20 May 2014, Sebastian Ott wrote:
> > On Mon, 19 May 2014, Benjamin LaHaise wrote:
> > > It is entirely possible the bug isn't 
> > > caused by the referenced commit, as the commit you're pointing to merely 
> > > makes io_destroy() syscall wait for all aio outstanding to complete 
> > > before returning.
> > 
> > I cannot reproduce this when I revert said commit (on top of 14186fe). If
> > that matters - the arch is s390.

> Hm, ok - maybe that commit is really just highlighting a refcounting bug.
> I just compared traces for a good and a few bad cases. The good case:
...

> (4 fio workers, free_ioctx_reqs is called 4 times)


> One of the bad cases:
....
> (1 fio worker in D state, free_ioctx_reqs is called 3 times)

This would seem to indicate that the problem is not with Anatol's change, 
and the hang is a consequence of the AIO not completing.  Can you trace 
calls to aio_complete() in addition to free_ioctx_reqs() to see if a 
completion is happening in the failed case?  If aio_complete() is only 
getting called 3 times, the problem is not in the aio layer.

		-ben


> Regards,
> Sebastian
> 
> > > 
> > > > git bisect points to:
> > > > 	commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c
> > > > 	Author: Anatol Pomozov <anatol.pomozov@gmail.com>
> > > > 	Date:   Tue Apr 15 11:31:33 2014 -0700
> > > > 
> > > > 	    aio: block io_destroy() until all context requests are completed
> > > > 
> > > > 
> > > > The fio workers are on the wait_for_completion in sys_io_destroy.
> > > > 
> > > > Regards,
> > > > Sebastian
> > > > [global]
> > > > blocksize=4K
> > > > size=256M
> > > > rw=randrw
> > > > verify=md5
> > > > iodepth=32
> > > > ioengine=libaio
> > > > direct=1
> > > > end_fsync=1
> > > > 
> > > > [file1]
> > > > filename=/dev/scma
> > > > 
> > > > [file2]
> > > > filename=/dev/scmbw
> > > > 
> > > > [file3]
> > > > filename=/dev/scmc
> > > > 
> > > > [file4]
> > > > filename=/dev/scmx
> > > 
> > > 
> > > -- 
> > > "Thought is the essence of where you are now."
> > > 
> > > 
> > 

-- 
"Thought is the essence of where you are now."
