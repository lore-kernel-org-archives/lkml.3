Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaAHRuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:50:32 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47102 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAHRua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:50:30 -0500
Date: Wed, 8 Jan 2014 09:48:28 -0800
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, chzigotzky@xenosoft.de,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] powerpc: Fix alignment of secondary cpu spin vars
Message-ID: <20140108174828.GA16830@quad.lixom.net>
References: <1388264507-5100-1-git-send-email-olof@lixom.net>
 <CAOesGMhHw-G-T7ZfNsVU92ftOucCNe9shNJtA7SWzqX=dQBQng@mail.gmail.com>
 <CAOesGMgsY0R6KBXXH_ibTBYb1i_auWESwnoDkvi-esb58Pc+2A@mail.gmail.com>
 <20140103081219.GA10233@quad.lixom.net>
 <1389154189.2076.5.camel@concordia>
 <1389154706.4672.21.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389154706.4672.21.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 03:18:26PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2014-01-08 at 15:09 +1100, Michael Ellerman wrote:
> > > Of course, main worry is that this is just hiding some latent NULL
> > deref in
> > > the kernel now... :-/
> > 
> > Wow, that would have to come close to winning the
> > grossest-hack-in-arch-powerpc
> > award :)
> > 
> > Have you tried changing the value at 8 to point to a reserved page?
> > 
> > Some other possibilities:
> > 
> >  * Change the #define so FIXUP_ENDIAN is empty for PASEMI, that would
> > mean
> >    you'd only be able to boot pasemi_defconfig.

No thanks -- this went uncaught because that used to be all I booted
(and for some random reason it didn't trigger in that case).

> >  * Move the hack into FIXUP_ENDIAN
> 
> We actually found the root cause on irc the other day, I was waiting for
> Olof to send a fix :-)

Yeah, I'm low on spare time these days, in particular spare time to spend on
ppc stuff. :-(

> Olof: Can you try this totally untested patch ?

With one fixup below:

Tested-by: Olof Johansson <olof@lixom.net>

> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -1986,8 +1986,6 @@ static void __init prom_init_stdout(void)
>         /* Get the full OF pathname of the stdout device */
>         memset(path, 0, 256);
>         call_prom("instance-to-path", 3, 1, prom.stdout, path, 255);
> -       stdout_node = call_prom("instance-to-package", 1, 1, prom.stdout);
> -       val = cpu_to_be32(stdout_node);
>         prom_setprop(prom.chosen, "/chosen", "linux,stdout-package",
>                      &val, sizeof(val));
>         prom_printf("OF stdout device is: %s\n", of_stdout_device);
> @@ -1995,10 +1993,14 @@ static void __init prom_init_stdout(void)
>                      path, strlen(path) + 1);
>  
>         /* If it's a display, note it */
> -       memset(type, 0, sizeof(type));
> -       prom_getprop(stdout_node, "device_type", type, sizeof(type));
> -       if (strcmp(type, "display") == 0)
> -               prom_setprop(stdout_node, path, "linux,boot-display", NULL, 0);
> +       stdout_node = call_prom("instance-to-package", 1, 1, prom.stdout);
> +       if (stdout_node != PROM_ERROR) {
> +               val = cpu_to_be32(stdout_node);
> +               memset(type, 0, sizeof(type));
> +               prom_getprop(stdout_node, "device_type", type, sizeof(type));
> +               if (strcmp(type, "display") == 0)
> +                       prom_setprop(stdout_node, path, "linux,boot-display", NU

Line is cut off, this needs "NULL, 0);" at the end.



-Olof
