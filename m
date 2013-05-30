Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3E3WES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:04:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab3E3WEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:04:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] video: xilinxfb: Do not use out_be32 IO function
Date: Fri, 31 May 2013 00:04:01 +0200
Message-ID: <3808365.SOUxDqkW9J@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <a15de155a3f32fc1416833df1b281db05d347541.1369906849.git.michal.simek@xilinx.com>
References: <27e53d5633766ab0dc1ac492023d5a0d0199e3aa.1369906849.git.michal.simek@xilinx.com> <a15de155a3f32fc1416833df1b281db05d347541.1369906849.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TKETzEtYcDeQbyLOroHelkc0NLeJ4s9MMCJXy2Ce0My
 Jq34xwu4R8H/57M7fm6UqS9MoX6qY34ZFlcrLOb5AWZdnEvsVZ
 vRTxkdQQpMYCAPuRtnj6qeRD4UKPLGZRyLed3WEwQDlFLscl89
 Jl9CKgHDEvnHcqbN+vKZMIEmf/X7o5zBH4qH7R3M+m/+VX/D2Y
 KjQ4g7GM6PKlxRKBRsWNalXOos+GnRTs9xBbCXSUWi8gfV/Kt0
 EIpXNyn8E8gEl4JyRdHBI5qaWPfezE+MUopCIDgmS+PWmr0hWX
 5mPtqTDTxm3hcjypL+Gr6sX3JTYI26egUh78W+VUrGYQwyI6Zp
 5apvWaz2kaqOhCPPZf4I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 May 2013 11:41:01 Michal Simek wrote:
>   * To perform the read/write on the registers we need to check on
>   * which bus its connected and call the appropriate write API.
>   */
> -static void xilinx_fb_out_be32(struct xilinxfb_drvdata *drvdata, u32 offset,
> +static void xilinx_fb_out32(struct xilinxfb_drvdata *drvdata, u32 offset,
>                                 u32 val)
>  {
>         if (drvdata->flags & PLB_ACCESS_FLAG)
> -               out_be32(drvdata->regs + (offset << 2), val);
> +               __raw_writel(val, drvdata->regs + (offset << 2));
>  #ifdef CONFIG_PPC_DCR
>         else
>                 dcr_write(drvdata->dcr_host, offset, val);
> 

This is probably missing barriers, and is wrong on systems on which
the endianess of the device is different from the CPU.

You already have an indirection in there, so I guess it won't hurt
to create a third case for little-endian registers and add
another bit in drvdata->flags, or make it depend on the architecture,
if the endianess of the device registers is known at compile time.

	Arnd
