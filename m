Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaLXQxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:53:16 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34351 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLXQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:53:14 -0500
MIME-Version: 1.0
Date: Wed, 24 Dec 2014 12:53:13 -0400
Message-ID: <CAB9dFdty+3JXgJqhMNNHuDXivx9_paK2=zd7Vb_D4-suU6OGBg@mail.gmail.com>
Subject: Re: [GIT PULL] fuse update for 3.19
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 6:02 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Hi Linus,
>
> Please pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
>
> First part makes sure we don't hold up umount with pending async requests.  In
> addition to being a cleanup, this is a small behavioral change (for the better)
> and unlikely to break anything.  Second part prepares for a cleanup of the fuse
> device I/O code by adding a helper for simple request submission, with some
> savings in line numbers already realized.
>
> Thanks,
> Miklos
>
> ---
> Miklos Szeredi (6):
>       fuse: don't wake up reserved req in fuse_conn_kill()
>       fuse: flush requests on umount
>       fuse: hold inode instead of path after release
>       fuse: reduce max out args
>       fuse: introduce fuse_simple_request() helper
>       fuse: use file_inode() in fuse_file_fallocate()
>

Hi Miklos,

Commit 7078187a795f ("fuse: introduce fuse_simple_request() helper")
from the above pull request triggers some EIO errors for me in some
tests that rely on fuse.

Looking at the code changes and a bit of debugging info I think
there's a general problem here that fuse_get_req checks and possibly
waits for fc->initialized, and this was always called first.  But this
commit changes the ordering and in many places fc->minor is now
possibly used before fuse_get_req, and we can't be sure that fc has
been initialized.  In my case fuse_lookup_init sets
req->out.args[0].size to the wrong size because fc->minor at that
point is still 0, leading to the EIO error.

Assuming the analysis makes sense, it wasn't obvious what the best fix
should be.

Thanks,
Marc
