Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab3GPVnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:43:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab3GPVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:43:17 -0400
Date: Tue, 16 Jul 2013 14:43:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Colin Cross <ccross@android.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: shift VM_GROWS* check from mmap_region() to
 do_mmap_pgoff()
Message-Id: <20130716144315.2a8e80479d9b4789df69fb91@linux-foundation.org>
In-Reply-To: <20130714165451.GA20847@redhat.com>
References: <20130714165432.GA20828@redhat.com>
	<20130714165451.GA20847@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jul 2013 18:54:51 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set.
> In particular this means that mmap_region()->vma_merge(file, vm_flags)
> must always fail if vm_flags & VM_GROWS. So it does not make sense to
> check VM_GROWS* after we already allocated the new vma, the only caller,
> do_mmap_pgoff(), which can pass this flag can do the check itself.
> 
> And this looks a bit more correct, mmap_region() already unmapped the
> old mapping at this stage. But if mmap() is going to fail, it should
> avoid do_munmap() if possible.
> 
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1327,6 +1327,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>  		}
>  	}
>  
> +	/* Only MAP_PRIVATE|MAP_ANONYMOUS can use MAP_GROWS */
> +	if ((vm_flags & VM_MAYSHARE) && (vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))

That is of course vm_flags&(VM_MAYSHARE|VM_GROWSDOWN|VM_GROWSUP), but
that perhaps is less clear.

> +		return -EINVAL;

I had to stare for a while but yes, the change looks OK to me.
