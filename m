Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaLEPOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:14:10 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39462 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751023AbaLEPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:14:08 -0500
Date: Fri, 5 Dec 2014 15:13:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Rabin Vincent <rabin@rab.in>, "David A. Long" <dave.long@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_work_pending: Enable interrupts in do_work_pending()
Message-ID: <20141205151355.GU11285@n2100.arm.linux.org.uk>
References: <1417791066-5458-1-git-send-email-moon.linux@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417791066-5458-1-git-send-email-moon.linux@yahoo.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 08:21:06PM +0530, Anand Moon wrote:
> @@ -574,12 +574,14 @@ asmlinkage int
>  do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>  {
>  	do {
> +		if (unlikely(!user_mode(regs)))
> +			return 0;
> +		/* Enable interrupts; they are disabled again on return to
> +		 * caller. */
> +		local_irq_enable();
>  		if (likely(thread_flags & _TIF_NEED_RESCHED)) {
>  			schedule();
>  		} else {
> -			if (unlikely(!user_mode(regs)))
> -				return 0;
> -			local_irq_enable();
>  			if (thread_flags & _TIF_SIGPENDING) {
>  				int restart = do_signal(regs, syscall);
>  				if (unlikely(restart)) {

I'm happy with the hunk above, but:

> @@ -588,6 +590,7 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>  					 * Deal with it without leaving
>  					 * the kernel space.
>  					 */
> +					local_irq_disable();
>  					return restart;

not this one.  The code expects in the non-zero return case, that
interrupts will be enabled, otherwise we will be restarting the syscall
with IRQs disabled, and calling into the syscall function with IRQs
disabled.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
