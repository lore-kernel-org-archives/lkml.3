Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaCCTV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:21:59 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:61162 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbaCCTV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:21:56 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd11:e931:9870:b4c4:1877]
In-Reply-To: <1393432147-31355-2-git-send-email-johannes.thumshirn@men.de>
References: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
	<1393432147-31355-2-git-send-email-johannes.thumshirn@men.de>
Date: Mon, 3 Mar 2014 11:21:55 -0800
Message-ID: <CAOesGMjmdfRWddG+NWBg29mPik_s21fMQerCqUbEWUz8vP3KfQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] drivers: Introduce MEN Chameleon Bus
From: Olof Johansson <olof@lixom.net>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 8:29 AM, Johannes Thumshirn
<johannes.thumshirn@men.de> wrote:
> The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> FPGA based devices. It is used to identify MCB based IP-Cores within
> an FPGA and provide the necessary framework for instantiating drivers
> for these devices.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  MAINTAINERS                     |   6 +
>  drivers/Kconfig                 |   2 +
>  drivers/Makefile                |   1 +
>  drivers/mcb/Kconfig             |  15 ++
>  drivers/mcb/Makefile            |   5 +
>  drivers/mcb/mcb-core.c          | 414 ++++++++++++++++++++++++++++++++++++++++
>  drivers/mcb/mcb-internal.h      | 116 +++++++++++
>  drivers/mcb/mcb-parse.c         | 159 +++++++++++++++
>  include/linux/mcb.h             | 119 ++++++++++++
>  include/linux/mod_devicetable.h |   5 +
>  10 files changed, 842 insertions(+)
>  create mode 100644 drivers/mcb/Kconfig
>  create mode 100644 drivers/mcb/Makefile
>  create mode 100644 drivers/mcb/mcb-core.c
>  create mode 100644 drivers/mcb/mcb-internal.h
>  create mode 100644 drivers/mcb/mcb-parse.c
>  create mode 100644 include/linux/mcb.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 85b3dd8..5d35f6c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5667,6 +5667,12 @@ L:       linux-watchdog@vger.kernel.org
>  S:     Supported
>  F:     drivers/watchdog/mena21_wdt.c
>
> +MEN CHAMELEON BUS (mcb)
> +M:     Johannes Thumshirn <johannes.thumshirn@men.de>
> +S:     Supported
> +F:     drivers/mcb/
> +F:     include/linux/mcb.h
> +
>  METAG ARCHITECTURE
>  M:     James Hogan <james.hogan@imgtec.com>
>  L:     linux-metag@vger.kernel.org
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index b3138fb..df2ac52 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -170,4 +170,6 @@ source "drivers/phy/Kconfig"
>
>  source "drivers/powercap/Kconfig"
>
> +source "drivers/mcb/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 8e3b8b0..c5bf50c 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -155,3 +155,4 @@ obj-$(CONFIG_IPACK_BUS)             += ipack/
>  obj-$(CONFIG_NTB)              += ntb/
>  obj-$(CONFIG_FMC)              += fmc/
>  obj-$(CONFIG_POWERCAP)         += powercap/
> +obj-$(CONFIG_MCB)              += mcb/

No single-driver directories like these. This needs to go somewhere else.

> diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
> new file mode 100644
> index 0000000..44c82d6
> --- /dev/null
> +++ b/drivers/mcb/Kconfig
> @@ -0,0 +1,15 @@
> +#
> +# MEN Chameleon Bus (MCB) support
> +#
> +
> +menuconfig MCB
> +          tristate "MCB support"
> +          default m

Don't default to 'm' for new drivers. Just leave out the default (so
it will default to 'n').

> +          help
> +
> +          The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> +          FPGA based devices. It is used to identify MCB based IP-Cores within
> +          an FPGA and provide the necessary framework for instantiating drivers
> +          for these devices.
> +
> +          If build as a module, the module is called mcb.ko


Not reviewing the rest of the driver, came across the patch due to
causing build breakage on last night's next ebsa110_defconfig for ARM:

drivers/mcb/mcb-parse.c:105:2: error: implicit declaration of function
'memcpy_fromio' [-Werror=implicit-function-declaration]


-Olof
