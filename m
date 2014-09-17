Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaIQRYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:24:19 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:47371 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaIQRYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:24:18 -0400
Date: Wed, 17 Sep 2014 10:24:17 -0700
From: Zach Brown <zab@zabbo.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Milosz Tanski <milosz@adfin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140917172417.GD20887@lenny.home.zabbo.net>
References: <cover.1410810247.git.milosz@adfin.com>
 <057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
 <20140917154327.GA12190@thunk.org>
 <CANP1eJFQv51E7yfXw70ONxkjhOVatV6ERwgaY6Srv9-6VcDrjQ@mail.gmail.com>
 <20140917165930.GA24887@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917165930.GA24887@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:59:30PM -0400, Theodore Ts'o wrote:
> On Wed, Sep 17, 2014 at 12:05:23PM -0400, Milosz Tanski wrote:
> > Theodore,
> > 
> > I might be missing understanding something, but... I already omitted
> > read2 and write2 which can be implemented in userspace by libc (as you
> > pointed out). In the case of readv vs. preadv there's an extra
> > positional argument (file offset) and preadv version doesn't change
> > the file location. I didn't want to overload the meaning of preadv2 to
> > take a special negative offset value that uses the current file
> > position but also changes the file position.
> 
> off_t has to be signed, so having a magic negative value doesn't
> bother me that much.  Or you could use a flag bitvalue which means to
> use the fd's offset and to ignore the positional value.  (More
> bike-shedding :-)

splice has already set the precedent for an optionally specified offset
that falls back to the files's position.

static long do_splice(struct file *in, loff_t __user *off_in,
                      struct file *out, loff_t __user *off_out,
                      size_t len, unsigned int flags)
{
...
                if (off_out) {
                        if (copy_from_user(&offset, off_out, sizeof(loff_t)))
                                return -EFAULT;
                } else {
                        offset = out->f_pos;
                }

...
                if (!off_out)
                        out->f_pos = offset;
                else if (copy_to_user(off_out, &offset, sizeof(loff_t)))
                        ret = -EFAULT;

It's nice and simple and lets you update the user's offset.

> So the suggestion was one of trying to (probably fruitlessly) trying
> to stem the expnoential increase in read/write system calls.  :-)

I support this windmill tilting :). 

- z
