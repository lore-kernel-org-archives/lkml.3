Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaCVQpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:45:47 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:37611 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaCVQpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140322151657.GA23606@www.outflux.net>
References: <20140322151657.GA23606@www.outflux.net>
Date: Sat, 22 Mar 2014 11:45:43 -0500
Message-ID: <CAL_JsqKjt3oBxeHPdDjUGoH+JMma21rbgFjUab62yCXtck_SZA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: mm: fix reporting of read-only PMD bits
From: Rob Herring <robherring2@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Steve Capper <steve.capper@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 10:16 AM, Kees Cook <keescook@chromium.org> wrote:
> On non-LPAE ARMv6+, read-only PMD bits are defined with the combination
> "PMD_SECT_APX | PMD_SECT_AP_WRITE". Adjusted the bit masks to correctly
> report this.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
>  - check for pre-v6 CPUs on the page table report.
> v2:
>  - reorder bits, suggested by Olof.
> ---
>  arch/arm/mm/dump.c |   31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index ef69152f9b52..c1122d266c45 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -121,23 +121,42 @@ static const struct prot_bits pte_bits[] = {
>
>  static const struct prot_bits section_bits[] = {
>  #ifndef CONFIG_ARM_LPAE
> -       /* These are approximate */
> +# if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V6K) || defined(CONFIG_CPU_V7)

You can simplify the ifdef logic like this:

#ifdef CONFIG_ARM_LPAE /* Implies v7 */

#elif __LINUX_ARM_ARCH__ >= 6

#else
/* v4/v5 */
#endif
