Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366AbbA1EzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:55:13 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59638 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbbA1EzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:55:09 -0500
Date: Wed, 28 Jan 2015 13:55:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] zram: free meta out of init_lock
Message-ID: <20150128045501.GC32712@blaptop>
References: <20150126141709.GA985@swordfish>
 <20150126160007.GC528@blaptop>
 <20150127021704.GA665@swordfish>
 <20150127031823.GA16797@blaptop>
 <20150127040305.GB665@swordfish>
 <20150128001526.GA25828@blaptop>
 <20150128002203.GB25828@blaptop>
 <20150128020759.GA343@swordfish>
 <20150128025707.GB32712@blaptop>
 <20150128035354.GA7790@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128035354.GA7790@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 12:53:54PM +0900, Sergey Senozhatsky wrote:
> On (01/28/15 11:57), Minchan Kim wrote:
> [..]
> > > second,
> > > after kick_all_cpus_sync() new RW operations will see false init_done().
> > > bdev->bd_holders protects from resetting device which has read/write
> > > operation ongoing on the onther CPU.
> > > 
> > > I need to refresh on how ->bd_holders actually incremented/decremented.
> > > can the following race condition take a place?
> > > 
> > > 	CPU0					CPU1
> > > reset_store()
> > > bdev->bd_holders == false
> > > 					zram_make_request
> > > 						-rm- down_read(&zram->init_lock);
> > > 					init_done(zram) == true
> > > zram_reset_device()			valid_io_request()
> > > 					__zram_make_request
> > > down_write(&zram->init_lock);		zram_bvec_rw
> > > [..]
> > > set_capacity(zram->disk, 0);
> > > zram->init_done = false;
> > > kick_all_cpus_sync();			zram_bvec_write or zram_bvec_read()
> > > zram_meta_free(zram->meta);		
> > > zcomp_destroy(zram->comp);		zcomp_compress() or zcomp_decompress()
> > 
> > You're absolutely right. I forgot rw path is blockable so
> > kick_all_cpus_sync doesn't work for our case, unfortunately.
> > So, I want to go with srcu. Do you agree? or another suggestion?
> 
> yes, I think we need to take a second look on srcu approach.
> 
> 	-ss

Another idea is to introduce atomic refcount on zram for meta's lifetime management
so that rw path should get a ref for right before using the meta and put it on done.
If the refcount is negative, anyone shouldn't go with it.

However, I guess we can do it simple and more scalable with srcu rather than
introducing new atomic count. ;-)

-- 
Kind regards,
Minchan Kim
