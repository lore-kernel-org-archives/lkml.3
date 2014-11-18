Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaKRMac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:30:32 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38457 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaKRMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:30:31 -0500
Date: Tue, 18 Nov 2014 07:30:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
Message-ID: <20141118123027.GD7809@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113221139.GG2598@htj.dyndns.org>
 <546B374A.1010902@electrozaur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B374A.1010902@electrozaur.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Boaz.

On Tue, Nov 18, 2014 at 02:10:50PM +0200, Boaz Harrosh wrote:
> Right? well if so than those special inodes do
> not hold any data and never do IO of any kind
> so all the inode members that are needed for IO
> are candidates.

It may not carry dirty pages but the inode itself still can get
dirtied tho.

> example: i_wb_list; i_lru; i_dio_count i_writecount

So, neither i_wb_list or i_lru can be used.  It could be that some of
the atomic counters can be used but that requires collecting four such
counters consecutively.

> i_dquot (when QUOTA is on) i_private and more

If quota is off?  i_private maybe but it's not big enough.

> Even union with the "cgroup writback support" you
> want to add.

Again, these inodes can get dirtied.

I think unions are okay when lifetime rules clearly separate how the
field is used or the usages are contained in a logical unit but
overloading random fields which may be used across lifetime in a data
structure which is as widely used and abused as inode is likely to
lead to later headaches.

This is really something special and local {block|char}_dev are doing
which doens't have to interfere with anything else.  I think it's a
better approach to confine it to {block|char}_dev in the long term
even if that means carrying a bit more code.

Thanks.

-- 
tejun
