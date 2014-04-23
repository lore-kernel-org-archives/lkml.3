Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaDWFFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:05:52 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45647 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaDWFFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:05:51 -0400
Message-ID: <53574867.5010108@gmail.com>
Date: Wed, 23 Apr 2014 06:58:15 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: mtk.manpages@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] ipc/shm.c: check for ulong overflows in shmat
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com> <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 04:26 PM, Manfred Spraul wrote:
> find_vma_intersection does not work as intended if addr+size overflows.
> The patch adds a manual check before the call to find_vma_intersection.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/shm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7645961..382e2fb 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -1160,6 +1160,9 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
>  	down_write(&current->mm->mmap_sem);
>  	if (addr && !(shmflg & SHM_REMAP)) {
>  		err = -EINVAL;
> +		if (addr + size < addr)
> +			goto invalid;
> +
>  		if (find_vma_intersection(current->mm, addr, addr + size))
>  			goto invalid;
>  		/*
> 

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
