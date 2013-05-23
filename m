Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3EWRFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:05:08 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33512 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab3EWRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:05:06 -0400
Message-ID: <519E4C3C.7010400@gmail.com>
Date: Thu, 23 May 2013 10:05:00 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Wladislav Wiebe <wladislav.kw@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, david.daney@cavium.com,
        Maxim Uvarov <muvarov@gmail.com>, davem@davemloft.net,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] MIPS: Octeon: fix for held reboot_mutex lock at
 task exit time
References: <519DDF8D.70700@gmail.com>
In-Reply-To: <519DDF8D.70700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 02:21 AM, Wladislav Wiebe wrote:
> When kernel halt's will reboot_mutex lock still hold at exit.
> It will issue with 'halt' command:
> $ halt
> ..
> Sent SIGKILL to all processes
> Requesting system halt
> [66.729373] System halted.
> [66.733244]
> [66.734761] =====================================
> [66.739473] [ BUG: lock held at task exit time! ]
> [66.744188] 3.8.7-0-sampleversion-fct #49 Tainted: G           O
> [66.750202] -------------------------------------
> [66.754913] init/21479 is exiting with locks still held!
> [66.760234] 1 lock held by init/21479:
> [66.763990]  #0:  (reboot_mutex){+.+...}, at: [<ffffffff801776c8>] SyS_reboot+0xe0/0x218
> [66.772165]
> [66.772165] stack backtrace:
> [66.776532] Call Trace:
> [66.778992] [<ffffffff805780a8>] dump_stack+0x8/0x34
> [66.783972] [<ffffffff801618b0>] do_exit+0x610/0xa70
> [66.788948] [<ffffffff801777a8>] SyS_reboot+0x1c0/0x218
> [66.794186] [<ffffffff8013d6a4>] handle_sys64+0x44/0x64
>
>
[...]
>
> Acked-by: Maxim Uvarov <muvarov@gmail.com>
> Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
> ---
>   arch/mips/cavium-octeon/setup.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
> index b0baa29..04ce396 100644
> --- a/arch/mips/cavium-octeon/setup.c
> +++ b/arch/mips/cavium-octeon/setup.c
> @@ -457,6 +457,10 @@ static void octeon_halt(void)
>   	}
>
>   	octeon_kill_core(NULL);
> +
> +	/* We stop here */
> +	while (1)
> +		;

I want to put a WAIT here so we don't burn so much power.

I will send a patch to do that instead.

>   }
>
>   /**
>

