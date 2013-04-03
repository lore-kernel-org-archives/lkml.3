Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3DCVFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:05:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074Ab3DCVFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:05:43 -0400
Date: Wed, 3 Apr 2013 17:05:38 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Tejun Heo <tj@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
        Christoph Hellwig <chellwig@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Track block device users that created dirty pages
In-Reply-To: <x491uau1csj.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.1304031656420.31007@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com>
 <x491uau1csj.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Apr 2013, Jeff Moyer wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > The new semantics is: if a process did some buffered writes to the block
> > device (with write or mmap), the cache is flushed when the process
> > closes the block device. Processes that didn't do any buffered writes to
> > the device don't cause cache flush. It has these advantages:
> > * processes that don't do buffered writes (such as "lvm") don't flush
> >   other process's data.
> > * if the user runs "dd" on a block device, it is actually guaranteed
> >   that the data is flushed when "dd" exits.
> 
> Why don't applications that want data to go to disk just call fsync
> instead of relying on being the last process to have had the device
> open?
> 
> Cheers,
> Jeff

Because the user may forget to specify "conv=fsync" on dd command line.

Anyway, when using dd to copy partitions, it should either always flush 
buffers on exit or never do it. The current state, when dd mostly flushes 
buffers, but doesn't with very low probability (if it races with lvm or 
udev) is confusing.

If the admin sees that dd flushes buffers on block devices for all his 
trials, he assumes that dd always flushes buffers on block devices. He 
doesn't know that there is a tiny race condition that makes dd not flush 
buffers.

Mikulas
