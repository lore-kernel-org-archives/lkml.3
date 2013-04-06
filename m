Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3DFRhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 13:37:18 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47560 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3DFRhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 13:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <515FF3CC.80106@gmail.com>
References: <515FF3CC.80106@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 6 Apr 2013 13:36:56 -0400
Message-ID: <CAHGf_=p=U8urX0NF4M0=brffLhvWYU-6kcA2+sBWa8f1JFGkzw@mail.gmail.com>
Subject: Re: [PATCH 4/4] fsfreeze: avoid to return zero in __get_user_pages
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 6:07 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> In case of VM_FAULT_RETRY, __get_user_pages returns the number
> of pages alredy gotten, but there isn't a check if this number is
> zero. Instead, we have to return a proper error code so we can avoid
> a possible extra call of __get_user_pages. There are several
> places where get_user_pages is called inside a loop until all the
> pages requested are gotten or an error code is returned.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  mm/memory.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 494526a..cca14ed 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1858,7 +1858,7 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                                 if (ret & VM_FAULT_RETRY) {
>                                         if (nonblocking)
>                                                 *nonblocking = 0;
> -                                       return i;
> +                                       return i ? i : -ERESTARTSYS;

nonblock argument is only used from __mm_populate() and it expect
__get_user_pages() return 0.
