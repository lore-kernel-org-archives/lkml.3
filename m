Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaJPTMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:12:50 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37855 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaJPTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:12:49 -0400
Message-ID: <544018AF.5090507@hurleysoftware.com>
Date: Thu, 16 Oct 2014 15:12:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ia64: Pin controlling tty for unaligned fault message
References: <1413486653-26010-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1413486653-26010-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 03:10 PM, Peter Hurley wrote:
> Prevent destruction of the controlling tty before tty_write_message()
> can determine if the tty is safe to use.

This does not make tty_write_message() bulletproof from concurrent
teardown, but that's on my todo list.


> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  arch/ia64/kernel/unaligned.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/ia64/kernel/unaligned.c b/arch/ia64/kernel/unaligned.c
> index 622772b..e7ae608 100644
> --- a/arch/ia64/kernel/unaligned.c
> +++ b/arch/ia64/kernel/unaligned.c
> @@ -1336,8 +1336,11 @@ ia64_handle_unaligned (unsigned long ifa, struct pt_regs *regs)
>  			 * Don't call tty_write_message() if we're in the kernel; we might
>  			 * be holding locks...
>  			 */
> -			if (user_mode(regs))
> -				tty_write_message(current->signal->tty, buf);
> +			if (user_mode(regs)) {
> +				struct tty_struct *tty = get_current_tty();
> +				tty_write_message(tty, buf);
> +				tty_kref_put(tty);
> +			}
>  			buf[len-1] = '\0';	/* drop '\r' */
>  			/* watch for command names containing %s */
>  			printk(KERN_WARNING "%s", buf);
> 

