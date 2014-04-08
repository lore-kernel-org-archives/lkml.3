Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaDHLJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:09:31 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48879 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:09:29 -0400
Date: Tue, 8 Apr 2014 19:15:28 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] vfs: add closefrom(2) syscall
Message-ID: <20140408111528.GA23533@gmail.com>
Mail-Followup-To: Mateusz Guzik <mguzik@redhat.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Zheng Liu <wenqing.lz@taobao.com>
References: <1396941142-24821-1-git-send-email-wenqing.lz@taobao.com>
 <20140408082136.GA21510@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408082136.GA21510@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:21:37AM +0200, Mateusz Guzik wrote:
> On Tue, Apr 08, 2014 at 03:12:22PM +0800, Zheng Liu wrote:
> >  
> > +int __close_fds(struct files_struct *files, int lowfd)
> > +{
> > +	struct file *file;
> > +	struct fdtable *fdt;
> > +	int fd;
> > +
> > +	if (lowfd < 0)
> > +		lowfd = 0;
> > +	spin_lock(&files->file_lock);
> > +	fdt = files_fdtable(files);
> > +	if (lowfd >= fdt->max_fds)
> > +		goto out_unlock;
> > +	for (fd = lowfd; fd < fdt->max_fds; fd++) {
> > +		file = fdt->fd[fd];
> > +		if (!file)
> > +			continue;
> > +
> > +		rcu_assign_pointer(fdt->fd[fd], NULL);
> > +		__clear_close_on_exec(fd, fdt);
> > +		__put_unused_fd(files, fd);
> > +		spin_unlock(&files->file_lock);
> > +		filp_close(file, files);
> > +		spin_lock(&files->file_lock);
> > +	}
> > +
> > +out_unlock:
> > +	spin_unlock(&files->file_lock);
> > +	return 0;
> > +}
> > +
> 
> Can't comment on the usefulness of the patch, but I would like to note:
> 
> 1. fdt could be freed after you drop the lock, but you never reload the
> pointer, thus this looks like use-after-free
> 2. most of this looks like __close_fd, maybe some parts could be moved
> to an inline function so that code duplication is reduced?

Ah, yes, my fault.  I will fix them in next version.  Thanks for
pointing it out.

Regards,
                                                - Zheng
