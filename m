Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3GJRMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:12:33 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57926 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3GJRMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:12:31 -0400
Date: Wed, 10 Jul 2013 19:12:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx
 devices
In-Reply-To: <20130710022602.1F6F16609DE@gitolite.kernel.org>
Message-ID: <alpine.DEB.2.02.1307101859360.29717@ayla.of.borg>
References: <20130710022602.1F6F16609DE@gitolite.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Linux Kernel Mailing List wrote:
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/hw.h

> +#define SUPPORTED_FW_MAJOR	1
> +#define SUPPORTED_FW_MINOR	0
> +#define SUPPORTED_FW_RELEASE	0
> +#define SUPPORTED_FW_BUILD	629

> +static int ath10k_check_fw_version(struct ath10k *ar)
> +{
> +	char version[32];
> +
> +	if (ar->fw_version_major >= SUPPORTED_FW_MAJOR &&
> +	    ar->fw_version_minor >= SUPPORTED_FW_MINOR &&
> +	    ar->fw_version_release >= SUPPORTED_FW_RELEASE &&
> +	    ar->fw_version_build >= SUPPORTED_FW_BUILD)
> +		return 0;

My attention got triggered by:

drivers/net/wireless/ath/ath10k/core.c: In function ‘ath10k_check_fw_version’:
drivers/net/wireless/ath/ath10k/core.c:79: warning: comparison is always true due to limited range of data type

as an u16 is always larger or equal than zero. Not much you can do to
silence that warning, though.

However, I don't think the version check is correct.
Shouldn't it stop checking later fields if an exact match is found in an
earlier field?

I.e.

	if (ar->fw_version_major > SUPPORTED_FW_MAJOR ||
	    (ar->fw_version_major == SUPPORTED_FW_MAJOR &&
	     ar->fw_version_minor > SUPPORTED_FW_MINOR) ||
	     ...) { ... }

Currently e.g. (major, minor) = (3, 0) is considered older than (2, 1).

Or perhaps minor is never reset to zero when major is increased? In that
case, the check is correct, but IMHO it's a bit silly to split the version
number in seperate fields.

> +	snprintf(version, sizeof(version), "%u.%u.%u.%u",
> +		 SUPPORTED_FW_MAJOR, SUPPORTED_FW_MINOR,
> +		 SUPPORTED_FW_RELEASE, SUPPORTED_FW_BUILD);
> +
> +	ath10k_warn("WARNING: Firmware version %s is not officially supported.\n",
> +		    ar->hw->wiphy->fw_version);
> +	ath10k_warn("Please upgrade to version %s (or newer)\n", version);
> +
> +	return 0;
> +}

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
