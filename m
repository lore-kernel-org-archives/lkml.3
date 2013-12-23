Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3LWOZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:25:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab3LWOZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:25:54 -0500
Date: Mon, 23 Dec 2013 15:26:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] secure unlock_task_sighand() call
Message-ID: <20131223142636.GA24504@redhat.com>
References: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com> <CA+55aFyVrrvDzUt0OU4d9YZM8C-N+ycSKEa3+-5nowUoZ=rb8w@mail.gmail.com> <20131222143427.GA12544@redhat.com> <CAJ8eaTxq5tL1WT_2rsDg5nKwW4xxW_Md6ZTgk9f5DX75cN=pRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTxq5tL1WT_2rsDg5nKwW4xxW_Md6ZTgk9f5DX75cN=pRg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, naveen yadav wrote:
>
> Happy Christmas !!!

Thanks, the same to you ;)

> We are facing OOPS during core dump on kernel 3.8.x on ARM target.

Do you have any traces? Any additional info?

Can you try the fresh kernels?

Not that I can recall any change in this area which could help, but
perhaps this is arm specific...

> So we were doing core review and found this.

Do you mean that with this patch the kernel doesn't crash?

>  Also I think in zap_process() there is no need to send SIGKILL to
> ZOMBIE or DEAD process.

Yes, it would be very wrong to account a zombie, but:

> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -271,17 +271,19 @@ static int zap_process(struct task_struct
> *start, int exit_code)
>
> -               if (t != current && t->mm) {
> +               if (t->exit_state) {
> +                       nr++;
> +               } else if (t != current && t->mm) {

This change adds no harm, but it is misleading and unneeded. Please note
that t->mm != NULL && t->exit_state != 0 is not possible, exit_mm() is
called before exit_notify(). IOW, a zombie thread can't have ->mm.

Oleg.

