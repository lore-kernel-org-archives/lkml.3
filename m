Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab3DHDw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:52:57 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40662 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777Ab3DHDw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:52:56 -0400
MIME-Version: 1.0
In-Reply-To: <5162390C.5060804@asianux.com>
References: <5162390C.5060804@asianux.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 7 Apr 2013 23:52:34 -0400
Message-ID: <CAHGf_=rPcUWc=YvR4YTQJH=+SSEQ40nSYmSQXX_aJLDMquiPGw@mail.gmail.com>
Subject: Re: [PATCH] kernel: tsacct: strncpy, always be sure of NUL terminated.
To: Chen Gang <gang.chen@asianux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 11:27 PM, Chen Gang <gang.chen@asianux.com> wrote:
>
>   for NUL terminated string, always set '\0' at the end.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/tsacct.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/tsacct.c b/kernel/tsacct.c
> index a1dd9a1..01bcc4e 100644
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -78,7 +78,8 @@ void bacct_add_tsk(struct user_namespace *user_ns,
>         stats->ac_minflt = tsk->min_flt;
>         stats->ac_majflt = tsk->maj_flt;
>
> -       strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
> +       strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm) - 1);
> +       stats->ac_comm[sizeof(stats->ac_comm) - 1] = '\0';

sizeof(tsk->comm) is 16 and sizeof(stats->ac_comm) is 32. then this statement
is strange. and set_task_comm ensure tsk->comm is nul-terminated.

so your code never change the behavior, right?

And, If buggy driver change tsk->comm not to use set_task_comm and tsk->comm
is not nul-terminated, strncpy() still touch unrelated memory and ac_comm may
expose kernel internal info. that's bad.
