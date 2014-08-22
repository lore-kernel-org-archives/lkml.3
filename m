Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaHVOEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:04:14 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:44739 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaHVOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:04:10 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140821160855.11005.86653.stgit@localhost.localdomain>
References: <20140821160304.11005.15166.stgit@localhost.localdomain>
	<20140821160855.11005.86653.stgit@localhost.localdomain>
Date: Fri, 22 Aug 2014 16:04:10 +0200
Message-ID: <CAJfpegteyt_+g59skASpubFBSgs-c8XoOG-3Y+coKyr1nvyKfw@mail.gmail.com>
Subject: Re: [PATCH 4/6] fuse: enable close_wait synchronous release
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 6:09 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
> The patch enables the feature by passing 'true' to fuse_file_put in
> fuse_release_common.
>
> Previously, this was safe only in special cases when we sure that
> multi-threaded userspace won't deadlock if we'll synchronously send
> FUSE_RELEASE in the context of read-ahead or write-back callback. Now, it's
> always safe because callbacks don't send requests to userspace anymore.

But we do want to make this privileged, as there are unlikely but
possible DoS scenarios with a sync release.

Thanks,
Miklos

>
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---
>  fs/fuse/file.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 73bce1b..cd55488 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -333,7 +333,8 @@ void fuse_release_common(struct file *file, int opcode)
>          * synchronous RELEASE is allowed (and desirable) in this case
>          * because the server can be trusted not to screw up.
>          */
> -       fuse_file_put(ff, ff->fc->destroy_req != NULL);
> +       fuse_file_put(ff, ff->fc->destroy_req != NULL ||
> +                         must_release_synchronously(ff));
>  }
>
>  static int fuse_open(struct inode *inode, struct file *file)
>
