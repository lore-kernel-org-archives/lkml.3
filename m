Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3CKVz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:55:58 -0400
Received: from void.printf.net ([89.145.121.20]:39618 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab3CKVz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:55:57 -0400
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-mmc@vger.kernel.org
Subject: Re: Regulator API ignored return values
References: <201303112043.53334.arnd@arndb.de>
Date: Mon, 11 Mar 2013 17:55:39 -0400
In-Reply-To: <201303112043.53334.arnd@arndb.de> (Arnd Bergmann's message of
	"Mon, 11 Mar 2013 20:43:53 +0000")
Message-ID: <87a9q9iotg.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 11 2013, Arnd Bergmann wrote:
> ==> build/dove_defconfig/faillog <==
> /git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
> /git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring
> return value of 'regulator_enable', declared with attribute
> warn_unused_result [-Wunused-result]

Thanks, this looks like the right fix to me:


Subject: [PATCH] mmc: sdhci: Don't ignore regulator_enable() return value

Fixes:
/git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
/git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring
return value of 'regulator_enable', declared with attribute
warn_unused_result [-Wunused-result]

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/sdhci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 51bbba4..fbf0b93 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2907,12 +2907,17 @@ int sdhci_add_host(struct sdhci_host *host)
 			host->vqmmc = NULL;
 		}
 	} else {
-		regulator_enable(host->vqmmc);
+		ret = regulator_enable(host->vqmmc);
 		if (!regulator_is_supported_voltage(host->vqmmc, 1700000,
 			1950000))
 			caps[1] &= ~(SDHCI_SUPPORT_SDR104 |
 					SDHCI_SUPPORT_SDR50 |
 					SDHCI_SUPPORT_DDR50);
+		if (ret) {
+			pr_warn("%s: Failed to enable vqmmc regulator: %d\n",
+				mmc_hostname(mmc), ret);
+			host->vqmmc = NULL;
+		}
 	}
 
 	if (host->quirks2 & SDHCI_QUIRK2_NO_1_8_V)
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
