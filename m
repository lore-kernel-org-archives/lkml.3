Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaKTOTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:19:47 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49936 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:19:46 -0500
Date: Thu, 20 Nov 2014 09:19:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
Message-ID: <20141120141942.GD14877@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113221139.GG2598@htj.dyndns.org>
 <546DC5AD.3040606@plexistor.com>
 <20141120115052.GA32237@htj.dyndns.org>
 <546DE065.3090502@plexistor.com>
 <20141120131118.GB14877@htj.dyndns.org>
 <546DF745.1070901@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546DF745.1070901@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:14:29PM +0200, Boaz Harrosh wrote:
> On 11/20/2014 03:11 PM, Tejun Heo wrote:
> > Hello, Boaz.
> > 
> <>
> > W/ preloading, one way to do it is,
> > 
> > 	if (preload())
> > 		handle -ENOMEM;
> > 	lock;
> > 	error = insert();
> > 	if (error)
> > 		handle error which can't be -ENOMEM;
> > 	unlock;
> > 	preload_end();
> > 
> 
> I like this one, cause of the place I come from. Where
> in a cluster you want the local fails as early as possible
> before you start to commit remotely, and need to undo on
> errors.
> 
> And I can see the real flow of things
> 
> > Another way is
> > 
> > 	preload();	// can't fail
> > 	lock;
> > 	error = insert();
> > 	if (error)
> > 		handle error;'
> > 	unlock;
> > 	preload_end();
> > 
> > Both ways have pros and cons.  The latter seems to lead to simpler
> > code in general.  Not always, but the overall.
> > 
> 
> I still like the over all simplicity of the above pattern to
> this behind the seen complexity hidden away under the carpet.

Maybe the right thing to do is allowing both.  It really depends on
the use cases.  For a lot of cases, the error handling and unrolling
are necessary anyway so the deferred preload failure doesn't add any
complexity but there are cases where the insertion can be guaranteed
to succeed.  The only change necessary is making preload return
-ENOMEM which can be ignored by the caller anyway.  The caller can
either ignore and handle the deferred failure later or handle it and
know that later insertion won't fail with -ENOMEM.

Anyways, let's see how minimal linked list implementation works out.

Thanks.

-- 
tejun
