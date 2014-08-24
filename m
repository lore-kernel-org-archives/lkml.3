Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaHXRmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:42:05 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:41240 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaHXRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:42:03 -0400
Message-ID: <53FA23E5.5010603@colorfullife.com>
Date: Sun, 24 Aug 2014 19:41:57 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Cyrill Gorcunov <gorcunov@openvz.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipc/shm: fix the historical/wrong mm->start_stack
 check
References: <20140823144246.GA6281@redhat.com> <20140823144327.GA6299@redhat.com>
In-Reply-To: <20140823144327.GA6299@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2014 04:43 PM, Oleg Nesterov wrote:
> The ->start_stack check in do_shmat() looks ugly and simply wrong.
>
> 1. ->start_stack is only valid right after exec(), the application
>     can switch to another stack and even unmap this area.
>
> 2. The reason for this check is not clear at all. The application
>     should know what it does. And why 4 pages? And why in fact it
>     requires 5 pages?
>
> 3. This wrongly assumes that the stack can only grown down.
>
> Personally I think we should simply kill this check, but I did not
> dare to do this. So the patch only fixes the 1st problem (mostly to
> avoid the usage of mm->start_stack) and ignores VM_GROWSUP.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
> [snip]

> +		if (vma) {
> +			if (vma->vm_flags & VM_GROWSDOWN)
> +				end += PAGE_SIZE * 4; /* can't overflow */
Why is an overflow impossible?
> +			if (end > vma->vm_start)
> +				goto invalid;
> +		}
>   	}
>   
>   	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
--
     Manfred
