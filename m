Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3BEI0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:26:36 -0500
Received: from shutemov.name ([204.155.152.216]:37797 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3BEI0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:26:32 -0500
Date: Tue, 5 Feb 2013 10:28:20 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
Message-ID: <20130205082820.GA22220@shutemov.name>
References: <510CB733.2080904@huawei.com>
 <510CB744.7000300@huawei.com>
 <20130202155858.GA13022@shutemov.name>
 <20130204101521.GA18322@shutemov.name>
 <51107F42.1090401@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51107F42.1090401@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 11:40:50AM +0800, Li Zefan wrote:
> On 2013/2/4 18:15, Kirill A. Shutemov wrote:
> > On Sat, Feb 02, 2013 at 05:58:58PM +0200, Kirill A. Shutemov wrote:
> >> On Sat, Feb 02, 2013 at 02:50:44PM +0800, Li Zefan wrote:
> >>> When an eventfd is closed, a wakeup with POLLHUP will be issued,
> >>> but cgroup wants to issue wakeup explicitly, so when a cgroup is
> >>> removed userspace can be notified.
> >>>
> >>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> > Hm.. Looks like it will break eventfd semantics:
> > 
> > 1. One eventfd can be used for deliver more then one notification from
> > one or more cgroups. POLLHUP on removing one of cgroups is not valid.
> > 
> > 2. It's valid to have eventfd opened only by one userspace application. We
> > should not close it, just because cgroup is removed.
> > 
> > I think problem with multiple threads waiting an event on eventfd should
> > be handled in userspace.
> > 
> 
> I didn't realize this.. and if a cgroup is removed, the woken thread may not
> be the thread that is waiting on this cgroup.

Why? The only threads who read() or poll() the eventfd will be wake up,
won't they? Do you have a code sample to demonstrate the issue?

> How crappy.. I don't know how
> userspace is going to deal with all these.
> 
> And another bug spotted. We can pass fd of memory.usage_in_bytes of cgroup A
> to cgroup.event_control of cgroup B, and then we won't get memory usage
> notification from A but B! What's worse, if A and B are in different mount
> hierarchy, boom!

I think we can ignore which cgroup event_control is belong to, and just
use cgroup of cfile as base. It also means you can use one event_control fd
for registering events to different cgroups. It can be handy.

> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cgroup.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3d21adf..e496359 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3825,6 +3825,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  				      const char *buffer)
>  {
>  	struct cgroup_event *event = NULL;
> +	struct cgroup *cgrp_cfile;
>  	unsigned int efd, cfd;
>  	struct file *efile = NULL;
>  	struct file *cfile = NULL;
> @@ -3880,6 +3881,16 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>  		goto fail;
>  	}
>  
> +	/*
> +	 * The file to be monitored must be in the same cgroup as
> +	 * cgroup.event_control is.
> +	 */
> +	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
> +	if (cgrp_cfile != cgrp) {
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
>  	if (!event->cft->register_event || !event->cft->unregister_event) {
>  		ret = -EINVAL;
>  		goto fail;
> -- 
> 1.8.0.2
> 
> 

-- 
 Kirill A. Shutemov
