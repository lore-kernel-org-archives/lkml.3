Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbaCQLal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:30:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:38833 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaCQLaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:30:39 -0400
Message-ID: <5326DCD2.1040303@parallels.com>
Date: Mon, 17 Mar 2014 15:30:26 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: <linux-kernel@vger.kernel.org>, <criu@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] proc: show mnt_id in fdinfo files
References: <1395052750-8525-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1395052750-8525-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 02:39 PM, Andrey Vagin wrote:
> Currently we don't have a way how to determing from which mount point
> file has been opened. This information is required for proper dumping
> and restoring file descriptos due to presence of mount namespaces. It's
> possible, that two file descriptors are opened using the same paths, but
> one fd references mount point from one namespace while the other fd --
> from other namespace.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

These IDs are already shown in the /proc/$pid/mountinfo, and for some FSs
can be obtained via path_to_handle_at(), so this patch just makes it work
for any FS and speeds things up.

Acked-by: Pavel Emelyanov <xemul@parallels.com>

> ---
>  fs/proc/fd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/fd.c b/fs/proc/fd.c
> index 985ea88..0788d09 100644
> --- a/fs/proc/fd.c
> +++ b/fs/proc/fd.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/proc_fs.h>
>  
> +#include "../mount.h"
>  #include "internal.h"
>  #include "fd.h"
>  
> @@ -48,8 +49,9 @@ static int seq_show(struct seq_file *m, void *v)
>  	}
>  
>  	if (!ret) {
> -                seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
> -			   (long long)file->f_pos, f_flags);
> +		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
> +			   (long long)file->f_pos, f_flags,
> +			   real_mount(file->f_path.mnt)->mnt_id);
>  		if (file->f_op->show_fdinfo)
>  			ret = file->f_op->show_fdinfo(m, file);
>  		fput(file);
> 


