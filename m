Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3HTDxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3HTDxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:53:17 -0400
Message-ID: <1376970790.2657.40.camel@ul30vt.home>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Alex Williamson <alex.williamson@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>, Tejun Heo <tj@kernel.org>
Date: Mon, 19 Aug 2013 21:53:10 -0600
In-Reply-To: <20130820031821.GF27005@ZenIV.linux.org.uk>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <20130820031821.GF27005@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 04:18 +0100, Al Viro wrote:
> On Wed, Aug 14, 2013 at 04:42:14PM -0600, Bjorn Helgaas wrote:
> > [+cc Al, linux-fsdevel for fdget/fdput usage]
> 
> fdget/fdput use looks sane, the only thing is that I would rather
> have an explicit include of linux/file.h instead of relying upon
> linux/eventfd.h pulling it.

Thanks for reviewing, I'll add an explicit include.

>   Incidentally, there are only 5 files
> that include the latter without an explicit include of the former -
> drivers/vfio/pci/vfio_pci.c, drivers/vhost/scsi.c, kernel/cgroup.c,
> mm/memcontrol.c and mm/vmpressure.c.  And only kernel/cgroup.c (and,
> with this patch, vfio_pci.c) really wants anything from linux/file.h,
> so I'd rather kill that indirect include in eventfd.h and slapped
> an explicit include of file.h in these two files...
> 
> BTW, most of the eventfd_fget() users might as well be using fget()
> (or fdget(), for that matter).  They tend to be immediately followed
> by eventfd_ctx_fileget(), which repeats the "is that an eventfd file?"
> check anyway.

Hmm, I've got one of those elsewhere in vfio code too.  Thanks for the
tip.

Alex

> Completely untested patch below does that to kernel/cgroup.c; Tejun,
> Davide - do you have any objections against the following?
> 
> Kill indirect include of file.h from eventfd.h, use fdget() in cgroup.c
> 
> kernel/cgroup.c is the only place in the tree that relies on eventfd.h
> pulling file.h; move that include there.  Switch from eventfd_fget()/fput()
> to fdget()/fdput(), while we are at it - eventfd_ctx_fileget() will fail
> on non-eventfd descriptors just fine, no need to do that check twice...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index cf5d2af..ff0b981 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -9,7 +9,6 @@
>  #define _LINUX_EVENTFD_H
>  
>  #include <linux/fcntl.h>
> -#include <linux/file.h>
>  #include <linux/wait.h>
>  
>  /*
> @@ -26,6 +25,8 @@
>  #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>  #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
>  
> +struct file;
> +
>  #ifdef CONFIG_EVENTFD
>  
>  struct file *eventfd_file_create(unsigned int count, int flags);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 781845a..f88ecaf 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -60,6 +60,7 @@
>  #include <linux/poll.h>
>  #include <linux/flex_array.h> /* used in cgroup_attach_task */
>  #include <linux/kthread.h>
> +#include <linux/file.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -3969,8 +3970,8 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  	struct cgroup_event *event = NULL;
>  	struct cgroup *cgrp_cfile;
>  	unsigned int efd, cfd;
> -	struct file *efile = NULL;
> -	struct file *cfile = NULL;
> +	struct fd efile;
> +	struct fd cfile;
>  	char *endp;
>  	int ret;
>  
> @@ -3993,31 +3994,31 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
>  	INIT_WORK(&event->remove, cgroup_event_remove);
>  
> -	efile = eventfd_fget(efd);
> -	if (IS_ERR(efile)) {
> -		ret = PTR_ERR(efile);
> -		goto fail;
> +	efile = fdget(efd);
> +	if (!efile.file) {
> +		ret = -EBADF;
> +		goto fail1;
>  	}
>  
> -	event->eventfd = eventfd_ctx_fileget(efile);
> +	event->eventfd = eventfd_ctx_fileget(efile.file);
>  	if (IS_ERR(event->eventfd)) {
>  		ret = PTR_ERR(event->eventfd);
> -		goto fail;
> +		goto fail2;
>  	}
>  
> -	cfile = fget(cfd);
> -	if (!cfile) {
> +	cfile = fdget(cfd);
> +	if (!cfile.file) {
>  		ret = -EBADF;
> -		goto fail;
> +		goto fail3;
>  	}
>  
>  	/* the process need read permission on control file */
>  	/* AV: shouldn't we check that it's been opened for read instead? */
> -	ret = inode_permission(file_inode(cfile), MAY_READ);
> +	ret = inode_permission(file_inode(cfile.file), MAY_READ);
>  	if (ret < 0)
>  		goto fail;
>  
> -	event->cft = __file_cft(cfile);
> +	event->cft = __file_cft(cfile.file);
>  	if (IS_ERR(event->cft)) {
>  		ret = PTR_ERR(event->cft);
>  		goto fail;
> @@ -4027,7 +4028,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  	 * The file to be monitored must be in the same cgroup as
>  	 * cgroup.event_control is.
>  	 */
> -	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
> +	cgrp_cfile = __d_cgrp(cfile.file->f_dentry->d_parent);
>  	if (cgrp_cfile != cgrp) {
>  		ret = -EINVAL;
>  		goto fail;
> @@ -4043,7 +4044,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  	if (ret)
>  		goto fail;
>  
> -	efile->f_op->poll(efile, &event->pt);
> +	efile.file->f_op->poll(efile.file, &event->pt);
>  
>  	/*
>  	 * Events should be removed after rmdir of cgroup directory, but before
> @@ -4056,21 +4057,18 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  	list_add(&event->list, &cgrp->event_list);
>  	spin_unlock(&cgrp->event_list_lock);
>  
> -	fput(cfile);
> -	fput(efile);
> +	fdput(cfile);
> +	fdput(efile);
>  
>  	return 0;
>  
>  fail:
> -	if (cfile)
> -		fput(cfile);
> -
> -	if (event && event->eventfd && !IS_ERR(event->eventfd))
> -		eventfd_ctx_put(event->eventfd);
> -
> -	if (!IS_ERR_OR_NULL(efile))
> -		fput(efile);
> -
> +	fdput(cfile);
> +fail3:
> +	eventfd_ctx_put(event->eventfd);
> +fail2:
> +	fdput(efile);
> +fail1:
>  	kfree(event);
>  
>  	return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



