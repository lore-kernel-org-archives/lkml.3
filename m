Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaHKRul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:50:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47873 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaHKRuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:50:40 -0400
Date: Mon, 11 Aug 2014 10:50:36 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: Use ULL-suffix for big u64 constant
Message-ID: <20140811175036.GU3711@ld-irv-0074>
References: <1407604073-7484-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407604073-7484-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 07:07:53PM +0200, Geert Uytterhoeven wrote:
> drivers/mtd/nand/nand_timings.c:45: warning: integer constant is too large for ‘long’ type

On what compiler / static analyzer?

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/mtd/nand/nand_timings.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
> index 8b36253420fa..e81470a8ac67 100644
> --- a/drivers/mtd/nand/nand_timings.c
> +++ b/drivers/mtd/nand/nand_timings.c
> @@ -42,7 +42,7 @@ static const struct nand_sdr_timings onfi_sdr_timings[] = {
>  		.tRHZ_max = 200000,
>  		.tRLOH_min = 0,
>  		.tRP_min = 50000,
> -		.tRST_max = 250000000000,
> +		.tRST_max = 250000000000ULL,

See [1] and [2]. I'm pretty sure it is a bug in your tool to warn about
this. The C standard seems pretty clear that the large literal constant
is automatically promoted to a sufficiently large type, so AIUI there
should be no need for such a warning. A standards-compliant compiler
will do the right thing.

It really seems like this type of warning is only appropriate where a
smaller literal constant is immediately operated on such that it will
overflow. e.g.:

		.tRST_max = 250 * 1000 * 1000 * 1000,

But this usually results in a different type of (correct) warning, like:

  warning: integer overflow in expression [-Woverflow]

However, I could be convinced to apply this, if only to satisfy broken
tools and to avoid addressing this question over and over...

>  		.tWB_max = 200000,
>  		.tRR_min = 40000,
>  		.tWC_min = 100000,

Brian

[1] http://lists.infradead.org/pipermail/linux-mtd/2014-July/054750.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/252494.html
