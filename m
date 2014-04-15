Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaDOS2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:28:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59764 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDOS2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:28:48 -0400
Message-ID: <534D7A5D.9090707@wwwdotorg.org>
Date: Tue, 15 Apr 2014 12:28:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mmc: sdhci: defer probing on regulator_get_optional()
 failures
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org> <1397526163-20126-4-git-send-email-abrestic@chromium.org>
In-Reply-To: <1397526163-20126-4-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 07:42 PM, Andrew Bresticker wrote:
> If regulator_get_optional() returns EPROBE_DEFER, it indicates
> that the regulator may show up later (e.g. the DT property is
> present but the corresponding regulator may not have probed).
> Instead of continuing without the regulator, return EPROBE_DEFER
> from sdhci_add_host().  Also, fix regulator leaks in the error
> paths in sdhci_add_host().

> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c

>  	if (IS_ERR_OR_NULL(host->vqmmc)) {

This is a pre-existing condition, but ick: Why doesn't this test either
IS_ERR() /or/ == NULL, but not both. On error, the regulator API should
either return and error-point or return NULL, so that client code
shouldn't need to check for both.

> +put_vmmc:
> +	if (host->vmmc)
> +		regulator_put(host->vmmc);
> +put_vqmmc:
> +	if (host->vqmmc)
> +		regulator_put(host->vqmmc);

If IS_ERR_OR_NULL() really is required above, it should be used here
too. More likely, I hope you need to replace if (host->vmmc) with if
(!IS_ERR(host->vmmc)).

I wonder if fixing this would help solve the crashes that Alex saw?
