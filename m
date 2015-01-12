Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbbALLmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:42:47 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42440 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbALLmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:42:46 -0500
Message-ID: <54B3B32E.7070709@hitachi.com>
Date: Mon, 12 Jan 2015 20:42:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lizefan@huawei.com
Subject: Re: [PATCH] kprobes: bugfix: force unoptimize when disable kprobes.
References: <1420461140-27153-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420461140-27153-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/05 21:32), Wang Nan wrote:
> Original code failed to disarm the probed instruction after
> 
> echo 0 > /sys/kernel/debug/kprobes/enabled
> 
> if OPTPROBE is enabled.
> 
> This is caused by a piece of logically inconsistent code:
> 
> 	unoptimize_kprobe(p, false);
> 	if (!kprobe_queued(p)) {
> 		...
> 	}
> 
> unoptimize_kprobe() with 'force' == false queues p onto
> unoptimizing_list, so following kprobe_queued() check always fail unless
> another core schedules optimizer and does the unoptimization very soon.
> This logic causes arch_disarm_kprobe() failed to get execute, lefts a
> breakpoint at the probed address, instead of restoring it.

No, the root cause of this failure comes from the lack of checking
kprobes_all_disarmed in unoptimized_kprobe(). It should check the flag
and return soon if it is set.

So, I Nak this patch.

> 
> This patch uses force unoptimize instead.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  kernel/kprobes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index b185464..9fbe0c3 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -869,7 +869,7 @@ static void __disarm_kprobe(struct kprobe *p, bool reopt)
>  {
>  	struct kprobe *_p;
>  
> -	unoptimize_kprobe(p, false);	/* Try to unoptimize */
> +	unoptimize_kprobe(p, true);	/* Try to unoptimize */
>  
>  	if (!kprobe_queued(p)) {
>  		arch_disarm_kprobe(p);
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


