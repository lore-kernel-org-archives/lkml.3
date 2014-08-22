Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaHVUPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:15:55 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:40913 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaHVUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:15:54 -0400
Date: Sat, 23 Aug 2014 00:15:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
 added to -mm tree
Message-ID: <20140822201550.GA25918@moon>
References: <20140822192241.GA26512@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822192241.GA26512@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 09:22:41PM +0200, Oleg Nesterov wrote:
> Hi Cyrill,
> 
> I think the patch is fine but I can't understand the usage of mmap_sem
> and alloc_lock,
> 
> > +	stack_vma = find_vma(mm, (unsigned long)prctl_map->start_stack);
> 
> OK, find_vma() needs mmap_sem. But otherwise, why this should be called
> under down_read(&mm->mmap_sem) ? What this lock tries to protect?

It should protect from allocation/devetion/mergin of another vma. IOW when
I lookup for vma I need to be sure it exist and won't disappear at least
while I validate it.

> > +	if (prctl_map.auxv_size) {
> > +		up_read(&mm->mmap_sem);
> > +		memset(user_auxv, 0, sizeof(user_auxv));
> > +		error = copy_from_user(user_auxv,
> > +				       (const void __user *)prctl_map.auxv,
> > +				       prctl_map.auxv_size);
> > +		down_read(&mm->mmap_sem);
> 
> And if we actually need this lock, why it is safe to drop it temporary?
> And why we can't move this copy_from_user() up before down_read) in any
> case?

Good point, thanks! I agreed that better to move this copying of user_auxv
before taking read-lock (once Andrew answer me my question about copying of
offsets in prctl_mm_map structure, I'll update on top).

> > +	if (prctl_map.auxv_size) {
> > +		/* Last entry must be AT_NULL as specification requires */
> > +		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
> > +		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
> > +
> > +		task_lock(current);
> > +		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> > +		task_unlock(current);
> 
> Again, could you explain this task_lock() ?

It is used for serialization access to saved_auxv, ie when we fill it
with new data the other reader (via procfs interface) should wait until
we finish.

Thanks for comments, Oleg!
