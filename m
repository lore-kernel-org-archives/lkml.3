Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3FHCTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:19:21 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61040 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3FHCTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370595932-29889-1-git-send-email-adam.lee@canonical.com>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
	<1370595932-29889-1-git-send-email-adam.lee@canonical.com>
Date: Sat, 8 Jun 2013 10:19:18 +0800
Message-ID: <CAFeW=pZp_j9GdFdxM1CxoOen314HA_wwdH+uXs0UJ6KD-3fCug@mail.gmail.com>
Subject: Re: [PATCH v2] thinkpad_acpi: return -NODEV while operating
 uninitialized LEDs
From: Amos Kong <kongjianjun@gmail.com>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 5:05 PM, Adam Lee <adam.lee@canonical.com> wrote:
>
> Not all 0-15 LEDs are available for all models, sometimes it's even not
> safe. This patch return -NODEV while operating uninitialized LEDs.
>
> Signed-off-by: Adam Lee <adam.lee@canonical.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index 54d31c0..d2ac4e8 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -5401,9 +5401,12 @@ static int led_write(char *buf)
>                 return -ENODEV;
>
>         while ((cmd = next_cmd(&buf))) {
> -               if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > 15)
> +               if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > (TPACPI_LED_NUMLEDS -1))
>                         return -EINVAL;
>
> +               if (!tpacpi_leds[led].led)


The .led filed might be set to '0' in led_init(), how about set the
uninitiated .led to -1? and check by "if (tpacpi_leds[led].led < 0)"

        for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
                if (!tpacpi_is_led_restricted(i) &&
                    test_bit(i, &useful_leds)) {
                        rc = tpacpi_init_led(i);
                        if (rc < 0) {
                                led_exit();
                                return rc;
-                       }
+                       } else
+                               tpacpi_leds[led].led = -1;

                } else tpacpi_leds[led].led = -1;
        }


> +                       return -ENODEV;
> +
>                 if (strstr(cmd, "off")) {
>                         s = TPACPI_LED_OFF;
>                 } else if (strstr(cmd, "on")) {
> --
> 1.7.10.4
