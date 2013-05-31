Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3EaBQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:16:33 -0400
Received: from muin.pair.com ([209.68.1.55]:55224 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3EaBQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <3808365.SOUxDqkW9J@wuerfel>
References: <27e53d5633766ab0dc1ac492023d5a0d0199e3aa.1369906849.git.michal.simek@xilinx.com>
	<a15de155a3f32fc1416833df1b281db05d347541.1369906849.git.michal.simek@xilinx.com>
	<3808365.SOUxDqkW9J@wuerfel>
Date: Thu, 30 May 2013 20:16:16 -0500
Message-ID: <CAOZdJXVn9fyhgZKYc9fhJ=Gis9Nqdv1B8EqVNcaswKV5+iCQ1g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] video: xilinxfb: Do not use out_be32 IO function
From: Timur Tabi <timur@tabi.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        lkml <linux-kernel@vger.kernel.org>, Michal Simek <monstr@monstr.eu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 5:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> This is probably missing barriers, and is wrong on systems on which
> the endianess of the device is different from the CPU.


I suggest what was done in fsl_ssi.c:

#ifdef PPC
#define read_ssi(addr)             in_be32(addr)
#define write_ssi(val, addr)         out_be32(addr, val)
#define write_ssi_mask(addr, clear, set) clrsetbits_be32(addr, clear, set)
#elif defined ARM
#define read_ssi(addr)             readl(addr)
#define write_ssi(val, addr)         writel(val, addr)
/*
 * FIXME: Proper locking should be added at write_ssi_mask caller level
 * to ensure this register read/modify/write sequence is race free.
 */
static inline void write_ssi_mask(u32 __iomem *addr, u32 clear, u32 set)
{
    u32 val = readl(addr);
    val = (val & ~clear) | set;
    writel(val, addr);
}
#endif
