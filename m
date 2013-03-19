Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025Ab3CSVJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:09:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3CSVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:09:42 -0400
Date: Tue, 19 Mar 2013 14:09:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] mqueue: sys_mq_open: do not call mnt_drop_write() if
 read-only
Message-Id: <20130319140940.fa84e0b678235076815fce64@linux-foundation.org>
In-Reply-To: <1363685478-9997-1-git-send-email-vdavydov@parallels.com>
References: <1363685478-9997-1-git-send-email-vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 13:31:18 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> mnt_drop_write() must be called only if mnt_want_write() succeeded,
> otherwise the mnt_writers counter will diverge.
> 
> ...
>
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -840,7 +840,8 @@ out_putfd:
>  		fd = error;
>  	}
>  	mutex_unlock(&root->d_inode->i_mutex);
> -	mnt_drop_write(mnt);
> +	if (!ro)
> +		mnt_drop_write(mnt);
>  out_putname:
>  	putname(name);
>  	return fd;

huh, that's been there for a while.  What were the runtime-visible
effects of the bug?
