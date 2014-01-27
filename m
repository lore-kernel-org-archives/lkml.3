Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaA0OQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:16:49 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:47906 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaA0OQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:16:48 -0500
MIME-Version: 1.0
In-Reply-To: <1390731668-904-1-git-send-email-geert@linux-m68k.org>
References: <1390731668-904-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 27 Jan 2014 08:16:47 -0600
Message-ID: <CAL_JsqLq+3Ehns0QaPajzLQCYUL+k+vx3j2vHTCdKMt948h6-g@mail.gmail.com>
Subject: Re: [PATCH] of: Fix uninitialized child warning in
 for_each_child_of_node() if !OF
From: Rob Herring <robherring2@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 4:21 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> If CONFIG_OF=n:
>
> drivers/i2c/i2c-mux.c: In function ‘i2c_add_mux_adapter’:
> drivers/i2c/i2c-mux.c:158: warning: ‘child’ is used uninitialized in this function
> drivers/leds/leds-lp55xx-common.c: In function ‘lp55xx_of_populate_pdata’:
> drivers/leds/leds-lp55xx-common.c:560: warning: ‘child’ is used uninitialized in this function
> drivers/leds/leds-pwm.c: In function ‘led_pwm_probe’:
> drivers/leds/leds-pwm.c:89: warning: ‘child’ is used uninitialized in this function
> drivers/mfd/stmpe.c: In function ‘stmpe_of_probe’:
> drivers/mfd/stmpe.c:1112: warning: ‘child’ is used uninitialized in this function
> drivers/mfd/tc3589x.c: In function ‘tc3589x_probe’:
> drivers/mfd/tc3589x.c:324: warning: ‘child’ is used uninitialized in this function
> drivers/power/charger-manager.c: In function ‘of_cm_parse_desc’:
> drivers/power/charger-manager.c:1606: warning: ‘child’ is used uninitialized in this function
>
> Introduced by commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
> ("include/linux/of.h: make for_each_child_of_node() reference its args when
> CONFIG_OF=n").
>
> Instead of dropping the "__of_use_dn(child)" again, explicitly set child
> to NULL, to protect against code using child after the loop (child == NULL
> is the loop termination condition if CONFIG_OF=y).
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Just got fixed in mainline:

commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jan 23 15:54:02 2014 -0800

    include/linux/of.h: make for_each_child_of_node() reference its
args when CONFIG_OF=n

    Make for_each_child_of_node() reference its args when CONFIG_OF=n to
    avoid warnings like:

        drivers/leds/leds-pwm.c:88:22: warning: unused variable 'node'
[-Wunused-variable]
          struct device_node *node = pdev->dev.of_node;
                              ^

    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Grant Likely <grant.likely@linaro.org>
    Cc: Rob Herring <robh+dt@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


> ---
>  include/linux/of.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 70c64ba17fa5..0bf44f2fe092 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -383,7 +383,7 @@ static inline void __of_use_dn(const struct device_node *np)
>  }
>
>  #define for_each_child_of_node(parent, child) \
> -       while (__of_use_dn(parent), __of_use_dn(child), 0)
> +       while (__of_use_dn(parent), child = NULL, 0)
>
>  #define for_each_available_child_of_node(parent, child) \
>         while (0)
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
