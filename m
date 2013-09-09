Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3IIOoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:44:25 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33735 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3IIOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:44:23 -0400
Date: Mon, 9 Sep 2013 17:42:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130909144259.GB2221@swordfish.minsk.epam.com>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909132124.GY6329@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/09/13 16:21), Dan Carpenter wrote:
> On Mon, Sep 09, 2013 at 03:49:42PM +0300, Sergey Senozhatsky wrote:
> > > > Calling handle_pending_slot_free() for every RW operation may
> > > > cause unneccessary slot_free_lock locking, because most likely
> > > > process will see NULL slot_free_rq. handle_pending_slot_free()
> > > > only when current detects that slot_free_rq is not NULL.
> > > > 
> > > > v2: protect handle_pending_slot_free() with zram rw_lock.
> > > > 
> > > 
> > > zram->slot_free_lock protects zram->slot_free_rq but shouldn't the zram
> > > rw_lock be wrapped around the whole operation like the original code
> > > does?  I don't know the zram code, but the original looks like it makes
> > > sense but in this one it looks like the locks are duplicative.
> > > 
> > > Is the down_read() in the original code be changed to down_write()?
> > >
> > 
> > I'm not touching locking around existing READ/WRITE commands.
> > 
> 
> Your patch does change the locking because now instead of taking the
> zram lock once it takes it and then drops it and then retakes it.  This
> looks potentially racy to me but I don't know the code so I will defer
> to any zram maintainer.
>

it takes it only when there is zram->slot_free_rq. otherwise it just
pointer comparison. original code does (schematically for READ case)

down_read()
	spin_lock()
		if (!NULL) {...}
	spin_unlock();
up_read();


patch adds the `if (!NULL)' check before N concurrent readers will
stuck on spin_lock() to just unlock spin_lock because zram->slot_free_rq
is NULL.

> 1) You haven't given us any performance numbers so it's not clear if the
>    locking is even a problem.

good point, I did not perform any testing. here they are:

 ./iozone -t -T -R -l 3 -u 3 -r 16K -s 60M -I +Z

	Record Size 16 KB
	File size set to 61440 KB
	O_DIRECT feature enabled
	Command line used: ./iozone -t -T -R -l 3 -u 3 -r 16K -s 60M -I +Z
	Output is in Kbytes/sec
	Time Resolution = 0.000001 seconds.
	Processor cache size set to 1024 Kbytes.
	Processor cache line size set to 32 bytes.
	File stride size set to 17 * record size.
	Min process = 3 
	Max process = 3 
	Throughput test with 3 processes
	Each process writes a 61440 Kbyte file in 16 Kbyte records


test             |    w/o patch   |    w/ patch
--------------------------------------------------
           Read  |   1895278.31   |   2778439.78
        Re-read  |   2638231.06   |   2630383.88
   Reverse Read  |   1378348.80   |   1538697.89
    Stride read  |   1698457.96   |   2043402.42
    Random read  |   1818998.33   |   2038670.38
 Mixed workload  |    376585.98   |    435064.57
          Pread  |   1402478.04   |    992575.22
          Fread  |   4955286.31   |   5199061.31

> 2) The v2 patch introduces an obvious deadlock in zram_slot_free()
>    because now we take the rw_lock twice.  Fix your testing to catch
>    this kind of bug next time.

yes it is. and I'm sorry about that. I sent v3 yesterday https://lkml.org/lkml/2013/9/8/42

> 3) Explain why it is safe to test zram->slot_free_rq when we are not
>    holding the lock.  I think it is unsafe.  I don't want to even think
>    about it without the numbers.

atomic pointer test, which is either NULL or !NULL.

for NULL case we don't take spin lock and just skip the whole
handle_pending_slot_free() thing.

for !NULL we call handle_pending_slot_free(). any operations with zram->slot_free_rq
(walking, removal or addition of element) are protected by spin lock within
handle_pending_slot_free(). most requests will see NULL zram->slot_free_rq.

if someone set zram->slot_free_rq to !NULL right after current process checked
it, then next request will see it !NULL and perform handle_pending_slot_free().

	-ss

> regards,
> dan carpenter
>
