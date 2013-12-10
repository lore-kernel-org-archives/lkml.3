Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3LJWXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:23:14 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:42604 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:23:12 -0500
Date: Tue, 10 Dec 2013 14:23:08 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 08/36] mtd: devices: Provide header for shared
 OPCODEs and SFDP commands
Message-ID: <20131210222308.GG27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-9-git-send-email-lee.jones@linaro.org>
 <20131210214849.GE27149@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210214849.GE27149@ld-irv-0074.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:48:49PM -0800, Brian Norris wrote:
> It doesn't look to me like the dual/quad bitfields are laid out very
> usefully. Can't they be divided so that their bit position is more
> meaningful? Like reserve bits [8:23] for dual/quad descriptions, then
> give the following:
> 
>  [8:11]  number of pins for the opcode (1=single; 2=dual; 4=quad)
>  [12:15] number of pins for the address (1=single; 2=dual; ...)
>  [16:19] number of pins for the data
>  [20]    read or write opcode (0=read; 1=write)
> 
> (you could easily pack these differently, but you get the idea)
> 
> Then:
> 
> #define FLASH_FLAG_DUAL_MASK	0x00022200
> #define FLASH_FLAG_QUAD_MASK	0x00044400
> 
> And we could do things like:
> 
> #define FLASH_FLAG_OPCODE_PINS(x)	(((x) & 0x00000f00) >> 8)
> #define FLASH_FLAG_ADDR_PINS(x)		(((x) & 0x0000f000) >> 12)
> #define FLASH_FLAG_DATA_PINS(x)		(((x) & 0x000f0000) >> 16)
> 
> (and maybe replace those mask/shifts with macro names)

I realized you are packing these tight because you're using them as
combinable (bitwise OR) flags (hence the name FLASH_FLAG_*, duh!). So
while my scheme is nicer for representing a single opcode w.r.t.
controller requirements, it is not able to represent the exact opcodes
supported by a particular flash. Hence, this is not the right place for
it.

But I don't want to imitate your flags in any generic framework; we need
a method (that doesn't involve too many extra tables like in your
driver; or that supports these tables generically, to share with other
drivers) to map the "supported opcodes" flags to useful properties that
the controller/driver can examine.

Is it possible, for instance, to describe a range of opcodes supported
using patterns? Like "this flash supports opcodes for 1-4 data pins and
1-2 address pins"? Or am I being too idealistic, and most flash really
support a totally arbitrary combination of opcodes?

Brian
