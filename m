Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaAISL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:11:57 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41893 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaAISLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:11:47 -0500
MIME-Version: 1.0
In-Reply-To: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
Date: Thu, 9 Jan 2014 10:11:47 -0800
X-Google-Sender-Auth: GH1M1fE9edT6sEl-11x6-R8wFyw
Message-ID: <CAGXu5jJkf9anm3QDQEGG+NPF+Lo6Obi9gEqZhXf4Dhr2+OvtbQ@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
        Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 4:52 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> Since addition of %pT itself seems to be agreed, I refreshed this patch using
> linux-next-20140109. Please pick up if this patch is OK for you; I will start
> making patches for killing most of direct ->comm readers.

Looks good; thanks for chasing this. :)

>
> Regards.
> ----------------------------------------
> >From 0d1f03d59a477459f3d3c190593d9e78f5d67de8 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 9 Jan 2014 21:32:22 +0900
> Subject: [PATCH] lib/vsprintf: add %pT format specifier
>
> Since task_struct->comm can be modified by other threads while the current
> thread is reading it, it is recommended to use get_task_comm() for reading it.
>
> However, since get_task_comm() holds task_struct->alloc_lock spinlock,
> some users cannot use get_task_comm(). Also, a lot of users are directly
> reading from task_struct->comm even if they can use get_task_comm().
> Such users might obtain inconsistent result.
>
> This patch introduces %pT format specifier for printing task_struct->comm.
> Currently %pT does not provide consistency. I'm planning to change to use RCU
> in the future. By using RCU, the comm name read from task_struct->comm will be
> guaranteed to be consistent. But before modifying set_task_comm() to use RCU,
> we need to kill direct ->comm users who do not use get_task_comm().
>
> An example for converting direct ->comm users is shown below. Since many debug
> printings use p == current, you can pass NULL instead of p if p == current.
>
>   pr_info("comm=%s\n", p->comm);       => pr_info("comm=%pT\n", p);
>   pr_info("comm=%s\n", current->comm); => pr_info("comm=%pT\n", NULL);
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
