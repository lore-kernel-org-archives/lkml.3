Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaDXWsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:48:11 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45513 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053AbaDXWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140424162954.GX18016@ZenIV.linux.org.uk>
References: <1398089562-5925-1-git-send-email-yfw.kernel@gmail.com>
	<20140423215804.GU18016@ZenIV.linux.org.uk>
	<CADUXgx7-5SQg2wVbJ1rp6DRhepcK9MWU67bixVwhXA6rr0skuA@mail.gmail.com>
	<20140424162954.GX18016@ZenIV.linux.org.uk>
Date: Fri, 25 Apr 2014 06:48:04 +0800
Message-ID: <CADUXgx5uaQ=JMNvYzokqhevFq3k8Q8w+YkhkpX2L76o5=FKLJQ@mail.gmail.com>
Subject: Re: [PATCH] Fix seq_read dead loop and trigger memory allocation failure.
From: Fengwei Yin <yfw.kernel@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Apr 24, 2014 at 10:26:50PM +0800, Fengwei Yin wrote:
>> On Thu, Apr 24, 2014 at 5:58 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Mon, Apr 21, 2014 at 10:12:42PM +0800, Fengwei Yin wrote:
>> >> When dump /proc/xxx/maps, if d_path return error in seq_path, the
>> >> buffer will be exhaust and trigger dead loop in seq_read. Till
>> >> kmalloc fails with -ENOMEM.
>> >
>> > *WHAT* d_path error?  -ENAMETOOLONG, aka. "you've got too little space"?
>> >
>> I could check it and get you back. But I suppose it's not this one
>> because it still  fails even I have buffer with 4M size.
>
> Please, do.  One thing to watch out for is bogus ->d_dname() return
> value; instances of ->d_dname() are only allowed to return valid pointers or
> ERR_PTR(-ENAMETOOLONG), the latter - only if the buffer really is too short
> (i.e. disappearing on sufficiently large one).  That holds in mainline, but
> that's the most likely vector by which the breakage could be introduced in
> some out-of-tree code.
>
> Here's the braindump on that bunch (basically, everything in fs/dcache.c
> from prepend() to dentry_path()):
>         * their char * arguments are never ERR_PTR(...)
>         * their char ** arguments never point to ERR_PTR(...) - not on entry
> to function and not on return from it, regardless of return value.
>         * prepend(), prepend_name() and prepend_unreachable() always return
> either 0 or -ENAMETOOLONG.
>         * return value of prepend_path() and path_with_deleted() can only be
> 0, 1, 2 or -ENAMETOOLONG.
>         * __d_path() returns NULL, a pointer to string or
> ERR_PTR(-ENAMETOOLONG).
>         * d_absolute_path() returns a pointer to string, ERR_PTR(-ENAMETOOLONG)
> or ERR_PTR(-EINVAL), the last one being for the case when its path argument
> points into an unmounted vfsmount.
>         * d_path(), __dentry_path(), dentry_path_raw(), dentry_path() and
> ->d_dname() instances return a pointer to string or ERR_PTR(-ENAMETOOLONG).
>         * all in-tree instances of ->d_dname() are either simple_dname() or
> trivial wrappers for dynamic_dname(), so for mainline it's enough to check
> those two helpers; out-of-tree code providing ->d_dname() instances needs
> to be checked, of course.
>         * given sufficiently large buffer ->d_dname() should succeed.
> Persistent ERR_PTR(-ENAMETOOLONG) from it is a bug.  Note that use of
> dynamic_dname() with format that might exceed 64 characters of output
> is wrong; that's the reason why e.g. mm/shmem.c uses simple_dname() instead.
> AFAICS, all remaining callers of dynamic_dname() in mainline are guaranteed
> to stay within its limitations (either <short string>[<unsigned long decimal>]
> or anon_inode:<short string passed to anon_inode_get{file,fd}>).  Out-of-tree
> code needs to be checked, of course.

Cool. I just found that you already fixed the issue (long name in
ashmem) by change
to simple_dname from dynamic_dname on tip. Android still stick to old
kernel and hit
this issue.

Thanks a lot.
