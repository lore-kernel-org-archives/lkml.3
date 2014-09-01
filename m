Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaIAGcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:32:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:59530 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaIAGcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:32:42 -0400
MIME-Version: 1.0
In-Reply-To: <1409540991-7573-1-git-send-email-leoy@marvell.com>
References: <1409540991-7573-1-git-send-email-leoy@marvell.com>
Date: Mon, 1 Sep 2014 08:32:40 +0200
Message-ID: <CAKv+Gu998+fVe3=ufC-37LXke3brG12k1=1vGxiSfkcWrHhv6g@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: fix bug for reloading FPSIMD state after cpu
 power off
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Leo Yan <leoy@marvell.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2014 05:09, Leo Yan <leoy@marvell.com> wrote:
> Now arm64 defers reloading FPSIMD state, but this optimization also
> introduces the bug after cpu resume back from low power mode.
>
> The reason is after the cpu has been powered off, s/w need set the
> cpu's fpsimd_last_state to NULL so that it will force to reload
> FPSIMD state for the thread, otherwise there has the chance to meet
> the condition for both the task's fpsimd_state.cpu field contains the
> id of the current cpu, and the cpu's fpsimd_last_state per-cpu variable
> points to the task's fpsimd_state, so finally kernel will skip to reload
> the context during it return back to userland.
>
> Signed-off-by: Leo Yan <leoy@marvell.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/kernel/fpsimd.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index ad8aebb..3dca156 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -270,6 +270,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
>         case CPU_PM_ENTER:
>                 if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
>                         fpsimd_save_state(&current->thread.fpsimd_state);
> +               this_cpu_write(fpsimd_last_state, NULL);
>                 break;
>         case CPU_PM_EXIT:
>                 if (current->mm)
> --
> 1.9.1
>
