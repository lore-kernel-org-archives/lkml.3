Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3CJQkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 12:40:21 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37522 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3CJQkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 12:40:20 -0400
Date: Sun, 10 Mar 2013 09:41:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
Message-ID: <20130310164102.GD4392@kroah.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
 <20130308204113.GA15334@kroah.com>
 <CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
 <CA+ydwtqHtwizg1=-KeLOjUUr+tzoFSPWRaeitE=10sm+pOYYKw@mail.gmail.com>
 <CACVXFVNJR69B=0G59FEqnu4Vhpn0_S_gf8j+vdUG2+0oLSPi_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNJR69B=0G59FEqnu4Vhpn0_S_gf8j+vdUG2+0oLSPi_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 04:53:11PM +0800, Ming Lei wrote:
> On Sun, Mar 10, 2013 at 12:36 AM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> > [   40.089036]  [<ffffffff81222e29>] sysfs_get_dirent+0x39/0x80
> > [   40.089036]  [<ffffffff81224ad9>] sysfs_remove_group+0x29/0x100
> > [   40.089036]  [<ffffffff8113f2c4>] blk_trace_remove_sysfs+0x14/0x20
> > [   40.089036]  [<ffffffff813453ae>] blk_unregister_queue+0x5e/0x90
> > [   40.089036]  [<ffffffff8134d417>] del_gendisk+0x107/0x250
> > [   40.089036]  [<ffffffff814f66b8>] loop_remove+0x18/0x40
> 
> Then the crash is triggered in device release path, which should have
> been avoided in device add path.
> 
> If we want to fix the problem completely, add_disk() must handle failure
> path correctly and return error code on failures, which may involve big
> work, since add_disk() are called by 50+ drivers.

Ok, but the root problem here is add_disk() is being called to create a
disk that was already created, right?  Surely the caller should have
detected this before it called to the block core?

Who is calling add_disk() here?  Is this a fuse device?  If so, then any
user can trigger this, right?

That should be the "easier" fix at the moment to resolve this issue.

greg k-h
