Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaDYOXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:23:02 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46320 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaDYOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:22:54 -0400
Message-ID: <535A6FBB.6010902@kernel.dk>
Date: Fri, 25 Apr 2014 08:22:51 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/1] random vs blk-mq
References: <20140425073610.GA2143@infradead.org> <20140425140344.GG11124@thunk.org>
In-Reply-To: <20140425140344.GG11124@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 08:03 AM, Theodore Ts'o wrote:
> On Fri, Apr 25, 2014 at 12:36:10AM -0700, Christoph Hellwig wrote:
>> But this also brings up an interesting question:  blk-mq currently
>> does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
>> simply converting a driver to blk-mq will mean it stops contributing
>> to the random pool.  Do we need a more fine grained way to control
>> this, especially for SCSI?
> 
> In general, more fine grained control is always good.
> 
> But getting the defaults right is even more important.  It occurs to
> me that what might make sense is to turn on QUEUE_FLAG_ADD_RANDOM if
> we know that it is a rotational disk.  But in the case where we know
> it's a SSD or a NVMe, it's likely that add_disk_randomness() is not
> going to do much in the way that's useful, since we estimate entropy
> credits based on the jiffies delta, so if we interrupts more
> frequently than the 10ms, we're not going to get any entropy credit
> anyway.

This is exactly why the flag was added in the first place:

commit e2e1a148bc45855816ae6b4692ce29d0020fa22e
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Wed Jun 9 10:42:09 2010 +0200

    block: add sysfs knob for turning off disk entropy contributions

    There are two reasons for doing this:

    - On SSD disks, the completion times aren't as random as they
      are for rotational drives. So it's questionable whether they
      should contribute to the random pool in the first place.

    - Calling add_disk_randomness() has a lot of overhead.

-- 
Jens Axboe

