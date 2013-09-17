Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3IQU7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3IQU7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:59:51 -0400
Date: Tue, 17 Sep 2013 16:59:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com, ejt@redhat.com
Subject: Re: staging: Add dm-writeboost
Message-ID: <20130917205936.GB12001@redhat.com>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52384E66.6050101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17 2013 at  8:43am -0400,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Hi, Mike
> 
> There are two designs in my mind
> regarding the formatting cache.
> 
> You said
> >   administer the writeboost devices.  There is no need for this.  Just
> >   have a normal DM target whose .ctr takes care of validation and
> >   determines whether a device needs formatting, etc.  
> makes me wonder how I format the cache device.
> 
> 
> There are two choices for formatting cache and create a writeboost device
> standing on the point of removing writeboost-mgr existing in the current design.
> I will explain them from how the interface will look like.
> 
> (1) dmsetup create myDevice ... "... $backing_path $cache_path"
> which will returns error if the superblock of the given cache device
> is invalid and needs formatting.
> And then the user formats the cache device by some userland tool.
> 
> (2) dmsetup create myDevice ... "... $backing_path $cache_path $do_format"
> which also returns error if the superblock of the given cache device
> is invalid and needs formatting when $do_format is 0.
> And then user formats the cache device by setting $do_format to 1 and try again.
> 
> There pros and cons about the design tradeoffs:
> - (i)  (1) is simpler. do_format parameter in (2) doesn't seem to be sane.
>        (1) is like the interfaces of filesystems where dmsetup create is like mounting a filesystem.
> - (ii) (2) can implement everything in kernel. It can gather all the information
>        about how the superblock in one place, kernel code.
> 
> Excuse for the current design:
> - The reason I design writeboost-mgr is almost regarding (ii) above.
>   writeboost-mgr has a message "format_cache_device" and
>   writeboost-format-cache userland command kicks the message to format cache.
> 
> - writeboost-mgr has also a message "resume_cache"
>   that validates and builds a in-memory structure according to the cache binding to given $cache_id
>   and user later dmsetup create the writeboost device with the $cache_id.
>   However, resuming the cache metadata should be done under .ctr like dm-cache does
>   and should not relate LV to create and cache by external cache_id
>   is what I realized by looking at the code of dm-cache which
>   calls dm_cache_metadata_open() routines under .ctr .

Right, any in-core structures should be allocated in .ctr()

> writeboost-mgr is something like smell of over-engineering but
> is useful for simplifying the design for above reasons.
> 
> 
> Which do you think better?

Have you looked at how both dm-cache and dm-thinp handle this?
Userspace takes care to write all zeroes to the start of the metadata
device before the first use in the kernel.

In the kernel, see __superblock_all_zeroes(), the superblock on the
metadata device is checked to see whether it is all 0s or not.  If it is
all 0s then the kernel code knows it needs to format (writing the
superblock, etc).

I see no reason why dm-writeboost couldn't use the same design.

Also, have you looked at forking dm-cache as a starting point for
dm-writeboost?  It is an option, not yet clear if it'd help you as there
is likely a fair amount of work picking through code that isn't
relevant.  But it'd be nice to have the writeboost code follow the same
basic design principles.

Like I mentioned before, especially if the log structured block code
could be factored out.  I haven't yet looked close enough at that aspect
of writeboost code to know if it could benefit from the existing
bio-prison code or persistent-data library at all.  writeboost would
obviously need a new space map type, etc.

Could be the log structured nature of writeboost is very different.
I'll review this closer tomorrow.
