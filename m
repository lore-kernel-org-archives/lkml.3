Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3FGQ5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:57:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39228 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3FGQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:57:44 -0400
Message-ID: <51B21105.1080301@wwwdotorg.org>
Date: Fri, 07 Jun 2013 10:57:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paul Walmsley <pwalmsley@nvidia.com>
CC: linux-tegra@vger.kernel.org, mturquette@linaro.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121901.21868.65416.stgit@dusk.lan>
In-Reply-To: <20130607121901.21868.65416.stgit@dusk.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 06:19 AM, Paul Walmsley wrote:
> Add DFLL DVCO reset line control functions to the CAR IP block driver.
> 
> The DVCO present in the DFLL IP block has a separate reset line,
> exposed via the CAR IP block.  This reset line is asserted upon SoC
> reset.  Unless something (such as the DFLL driver) deasserts this
> line, the DVCO will not oscillate, although reads and writes to the
> DFLL IP block will complete.
> 
> Thanks to Aleksandr Frid <afrid@nvidia.com> for identifying this and
> saving hours of debugging time.

> diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h

>  void tegra114_clock_tune_cpu_trimmers_high(void);
>  void tegra114_clock_tune_cpu_trimmers_low(void);
>  void tegra114_clock_tune_cpu_trimmers_init(void);
> +void tegra114_clock_assert_dfll_dvco_reset(void);
> +void tegra114_clock_deassert_dfll_dvco_reset(void);

Where/what is the code that will call these new APIs? If it's going to
be something in drivers/clk, that seems fine. If not, then this seems to
be inventing a bunch of new custom APIs exported by the clock driver.
I'm not sure if that's a good idea. (Although I guess that
include/linux/clk/tegra.h has a bunch of other custom APIs to support
CPU hotplug and related functionality, so perhaps it's not a big deael).

The reset assert/de-assert functions at least might be worth exposing
using the new generic module reset API. I believe Prashant Gaikwad is
working on converting the Tegra clock driver to be a module reset
provider, hence removing the existing custom
tegra_periph_reset_{de,}assert() APIs.
