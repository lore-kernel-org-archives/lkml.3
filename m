Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaHVTZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaHVTZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:25:21 -0400
Date: Fri, 22 Aug 2014 21:22:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
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
Message-ID: <20140822192241.GA26512@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

I think the patch is fine but I can't understand the usage of mmap_sem
and alloc_lock,

> +	stack_vma = find_vma(mm, (unsigned long)prctl_map->start_stack);

OK, find_vma() needs mmap_sem. But otherwise, why this should be called
under down_read(&mm->mmap_sem) ? What this lock tries to protect?

> +	if (prctl_map.auxv_size) {
> +		up_read(&mm->mmap_sem);
> +		memset(user_auxv, 0, sizeof(user_auxv));
> +		error = copy_from_user(user_auxv,
> +				       (const void __user *)prctl_map.auxv,
> +				       prctl_map.auxv_size);
> +		down_read(&mm->mmap_sem);

And if we actually need this lock, why it is safe to drop it temporary?
And why we can't move this copy_from_user() up before down_read) in any
case?

> +	if (prctl_map.auxv_size) {
> +		/* Last entry must be AT_NULL as specification requires */
> +		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
> +		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
> +
> +		task_lock(current);
> +		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> +		task_unlock(current);

Again, could you explain this task_lock() ?

Oleg.

