Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3KKXJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:09:45 -0500
Received: from forward13.mail.yandex.net ([95.108.130.120]:39107 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3KKXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:09:40 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Evgeny Boger <eugenyboger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Evgeny Boger <boger@contactless.ru>
In-Reply-To: <1384180614-9025-1-git-send-email-boger@contactless.ru>
References: <1384180614-9025-1-git-send-email-boger@contactless.ru>
Subject: Re: [PATCH 1/1] Add strong pullup emulation to w1-gpio master driver.
MIME-Version: 1.0
Message-Id: <10261384211376@web11j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 12 Nov 2013 03:09:36 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

11.11.2013, 18:37, "Evgeny Boger" <eugenyboger@gmail.com>:
> šStrong pullup is emulated by driving pin logic high after write command when
> šusing tri-state push-pull GPIO.
>
> Signed-off-by: Evgeny Boger <boger@contactless.ru>
> ---
> šdrivers/w1/masters/w1-gpio.c | 22 ++++++++++++++++++++++
> šdrivers/w1/w1_int.c ššššššššš| 12 ------------
> šinclude/linux/w1-gpio.h ššššš| š1 +
> š3 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index f54ece2..cb7f89b 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -18,10 +18,31 @@
> š#include <linux/of_gpio.h>
> š#include <linux/err.h>
> š#include <linux/of.h>
> +#include <linux/delay.h>
>
> š#include "../w1.h"
> š#include "../w1_int.h"
>
> +static u8 w1_gpio_set_pullup(void *data, int delay)
> +{
> + struct w1_gpio_platform_data *pdata = data;
> +
> + if (delay) {
> + pdata->pullup_duration = delay;
> + } else {
> + if (pdata->pullup_duration) {
> + gpio_direction_output(pdata->pin, 1);
> +
> + msleep(pdata->pullup_duration);

This doesn't look like a good idea - kernel will sleep for that long not doing usual w1 job

> --- a/drivers/w1/w1_int.c
> +++ b/drivers/w1/w1_int.c
> @@ -117,18 +117,6 @@ int w1_add_master_device(struct w1_bus_master *master)
> ššššššššššššššššprintk(KERN_ERR "w1_add_master_device: invalid function set\n");
> ššššššššššššššššreturn(-EINVAL);
> ššššššššš}
> - /* While it would be electrically possible to make a device that
> - * generated a strong pullup in bit bang mode, only hardware that
> - * controls 1-wire time frames are even expected to support a strong
> - * pullup. šw1_io.c would need to support calling set_pullup before
> - * the last write_bit operation of a w1_write_8 which it currently
> - * doesn't.
> - */
> - if (!master->write_byte && !master->touch_bit && master->set_pullup) {
> - printk(KERN_ERR "w1_add_master_device: set_pullup requires "
> - "write_byte or touch_bit, disabling\n");
> - master->set_pullup = NULL;
> - }
>

Why did you drop this check? It has nothing with w1-gpio driver
