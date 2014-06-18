Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaFRTH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:07:57 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42113 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaFRTH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 18 Jun 2014 14:07:35 -0500
Message-ID: <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:54 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> Machine name from board description is some generic name on DT kernel.
> DT provides machine name property which is specific for board, so use
> it instead generic one when possible.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/kernel/setup.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 8a16ee5..fbc7b4f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -875,10 +875,13 @@ void __init setup_arch(char **cmdline_p)
>
>         setup_processor();
>         mdesc = setup_machine_fdt(__atags_pointer);
> -       if (!mdesc)
> +       if (mdesc)
> +               machine_name = of_flat_dt_get_machine_name();
> +       else
>                 mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
>         machine_desc = mdesc;
> -       machine_name = mdesc->name;
> +       if (!machine_name)
> +               machine_name = mdesc->name;
>
>         if (mdesc->reboot_mode != REBOOT_HARD)
>                 reboot_mode = mdesc->reboot_mode;

I did a similar patch previously[1]. Like my original patch, your
patch unconditionally changes the name which could be considered part
of the userspace ABI. It's arguably not good practice for userspace to
depend on the name, but there are likely cases that do. So I think
this needs to be optional and only use the DT name if the machine desc
name is NULL.

So something like the below and then change the machine descriptors
you care about. The default generic DT machine desc should definitely
be changed.

I had a follow-up discussion with Grant about his concerns in the
thread about knowing which machine desc used to boot. He said he was
okay if just the machine desc address is printed out.


diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 50e198c..1479250 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -887,7 +887,7 @@ void __init setup_arch(char **cmdline_p)
        if (!mdesc)
                mdesc = setup_machine_tags(__atags_pointer,
__machine_arch_type);
        machine_desc = mdesc;
-       machine_name = mdesc->name;
+       machine_name = mdesc->name ? mdesc->name :
of_flat_dt_get_machine_name();

        if (mdesc->reboot_mode != REBOOT_HARD)
                reboot_mode = mdesc->reboot_mode;


[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/208878.html
