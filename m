Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaDOToK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:44:10 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49840 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaDOToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAAYSxhrmCbGLsu43mK15ParXHa_FJ9OVQiCPUdqyWEpTE=r1uw@mail.gmail.com>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
	<1397526163-20126-4-git-send-email-abrestic@chromium.org>
	<CAAYSxhrmCbGLsu43mK15ParXHa_FJ9OVQiCPUdqyWEpTE=r1uw@mail.gmail.com>
Date: Tue, 15 Apr 2014 12:44:02 -0700
X-Google-Sender-Auth: QVhfxowjGrXehei-uwIBN-myFRo
Message-ID: <CAL1qeaH19h3D49C3O3qQ+GtWSeOdu79TQTZGfj9dC-+-G1c3kA@mail.gmail.com>
Subject: Re: [PATCH 3/4] mmc: sdhci: defer probing on regulator_get_optional() failures
From: Andrew Bresticker <abrestic@chromium.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mike.looijmans@topic.nl
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:03 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> On Mon, Apr 14, 2014 at 6:42 PM, Andrew Bresticker
> <abrestic@chromium.org> wrote:
>> If regulator_get_optional() returns EPROBE_DEFER, it indicates
>> that the regulator may show up later (e.g. the DT property is
>> present but the corresponding regulator may not have probed).
>> Instead of continuing without the regulator, return EPROBE_DEFER
>> from sdhci_add_host().  Also, fix regulator leaks in the error
>> paths in sdhci_add_host().
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  drivers/mmc/host/sdhci.c | 19 ++++++++++++++++---
>>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> This appears to be an improvement on Mike Looijmans patch:
>
> https://lkml.org/lkml/2014/4/7/34
>
> The regulator_put() calls are appropriate but I wonder if we should
> take this a step farther.  Ulf is sure to point out that
> mmc_regulator_get_supply() can be used to get regulators (though it
> does stuff the pointers in host->mmc->supply.vmmc/vqmmc instead of
> host->vmmc/vqmmc).  However, that function doesn't put back the
> reference to vmmc if the request for vqmmc returns EPROBE_DEFER.  If
> it did, it believe it could be used here to simplify the error
> handling as all the regulator checks would happen up front.  What do
> you think?

Seems reasonable.  The put()s aren't necessary with
mmc_regulator_get_supply() since it uses the devm_* API, however it
doesn't return an error in case of EPROBE_DEFER when getting vqmmc,
which is what we want in this case.

>
> -Tim
