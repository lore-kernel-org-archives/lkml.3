Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaICIdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:33:20 -0400
Received: from mx8.pku.edu.cn ([162.105.129.171]:36994 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751588AbaICIdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:33:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -306.932
Date: Wed, 3 Sep 2014 16:32:59 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <926403536.39754.1409733179383.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140903035811.GA954@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_?=
 =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E?=
 =?utf-8?Q?=E5=A4=8D=EF=BC=9A_Status_of_'unic?=
 =?utf-8?Q?ore32'_architecture_in_Linux_kernel?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Guenter Roeck <linux@roeck-us.net> 写道：
> On Wed, Sep 03, 2014 at 08:09:28AM +0800, Xuetao Guan  wrote:
> > 
> > [...]
> > > > 
> > > > > 
> > > > > unicore32: Add ocd console and qemu-defconfig to support qemu simulator
> > > > > 	This patch adds a primitive OCD console to communicate with qemu.
> > > > > 	The same code is already used for early console support.
> > > > 
> > > > Do you mean there's the same/similar code in QEMU.
> > > > 
> > > No, I mean that the ocd functions in the linux kernel (such as ocd_putc) are
> > > used by both earlyprintk and the ocd console code.
> > Yes. By the way, it's only for qemu and fpga debug.
> > 
> > > 
> > > > > 
> > > > > With this patch added, and with qemu_defconfig as provided by the same patch,
> > > > > it is possible to build and load a unicore32 image in qemu using the following
> > > > > qemu command line.
> > > > > 
> > > > > qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage
> > > > > 
> > > > > Caveats:
> > > > > - The use of -nographic instead of -curses causes a qemu crash
> > > > Yes, since qemu curses code was modified to meet the simple OCD console requirement.
> > > > 
> > > The lack of support for -nographic is a problem for scripted testing.
> > > The issue is that we have to interpret console output for scripted testing,
> > > and having to go through curses makes that a bit difficult.
> > > 
> > > Wonder if '-nographic' can be modeled as '-curses' with no available terminal
> > > configuration. At least in theory that should work, but executing the above
> > > command with TERM=dumb yields no output. Wonder how difficult it would be to
> > > change that.
> > 
> > I see. I'll try to make -nographic work anyway.
> > 
> Please try the following patch. That seems to do it.
> I am sure it can be improved, but it is a start.
> 
> Thanks,
> Guenter

Thanks. I'll test it.
BTW, Qemu codestyle is different, and tab should be replaced with blanks.

Xuetao

> 
> ---
> From a7c89177b3c00e4c16bea25a0b4b2f9dc511e07b Mon Sep 17 00:00:00 2001
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Tue, 2 Sep 2014 20:55:02 -0700
> Subject: [PATCH] qemu: unicore32: Add support for non-curses display
> 
> Add basic support for DT_NONE and DT_NOGRAPHIC display types.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  target-unicore32/helper.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/target-unicore32/helper.c b/target-unicore32/helper.c
> index e5ebbf4..dda3772 100644
> --- a/target-unicore32/helper.c
> +++ b/target-unicore32/helper.c
> @@ -13,6 +13,7 @@
>  #include "exec/gdbstub.h"
>  #include "exec/helper-proto.h"
>  #include "qemu/host-utils.h"
> +#include "sysemu/sysemu.h"
>  #ifndef CONFIG_USER_ONLY
>  #include "ui/console.h"
>  #endif
> @@ -223,7 +224,18 @@ static void putc_on_screen(unsigned char ch)
>  
>  void helper_cp1_putc(target_ulong x)
>  {
> -    putc_on_screen((unsigned char)x);   /* Output to screen */
> +    switch(display_type) {
> +    case DT_CURSES:
> +	putc_on_screen((unsigned char)x);   /* Output to screen */
> +	break;
> +    case DT_NOGRAPHIC:
> +    case DT_NONE:
> +	putchar((int)x);
> +	break;
> +    default:
> +	break;
> +    }
> +
>      DPRINTF("%c", x);                   /* Output to stdout */
>  }
>  #endif
> -- 
> 1.9.1
> 

