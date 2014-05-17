Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaEQBX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 21:23:58 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63318 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaEQBX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 21:23:56 -0400
Message-ID: <5376BA1E.8050309@gmail.com>
Date: Sat, 17 May 2014 03:23:42 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-pm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 0/3] Generic Device Tree based power domain look-up
References: <1399553355-6615-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1399553355-6615-1-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08.05.2014 14:49, Tomasz Figa wrote:
> Up till now there was no single generic method to bind devices to their
> power domains using Device Tree. Each platform has been doing this using
> its own way, example of which are Exynos power domain bindings [1] and
> look-up code [2].
> 
> This series is intended to change this and provide generic DT bindings for
> power domain specification and generic code performing look-up of power
> domains and binding them to devices.
> 
> First two patches are the most important part of this series, as they
> introduce $subject. Patch 3 converts mach-exynos to use the new generic
> method. Further patches are adding one more user of the new code,
> mach-s3c64xx, with first 3 patches (4-6) required to clean-up its power
> domain driver a bit and last 3 patches (9-11) adding display support for
> Mini6410 board, including a node for display controller (FIMD) which is
> a power domain consumer.
> 
> The design of DT bindings and provider code is heavily inspired by
> implementation of clock providers in Common Clock Framework, while
> the code binding devices to power domains by my Exynos power domain
> implementation (now removed by this series ;)).
> 
> Successfully tested on Exynos4210-based Trats and Exynos4412-based Trats2
> boards using MFC, 
> 
> [1] Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> [2] arch/arm/mach-exynos/pm_domains.c
> 
> Changes since v3:
> (http://thread.gmane.org/gmane.linux.power-management.general/44571)
>  - rebased onto current Rafael's linux-pm bleeding-edge branch (0a112bf),
>  - renamed "power-domain" property to "power-domains" to facilitate further
>    extension to support multiple power domains per device in future.
> 
> Changes since v2:
> (http://thread.gmane.org/gmane.linux.kernel/1658926)
>  - rebased onto current Rafael's linux-pm bleeding-edge branch,
>  - dropped patches for s3c64xx for now. I will send them in separate series,
>  - do not call pm_genpd_dev_need_restore(true) in genpd_bind_domain(),
>  - fixed various stylistic issues reported in review comments.
> 
> Changes since v1 (RFC):
> [https://lkml.org/lkml/2014/1/11/141]
>  - rebased onto current Rafael's linux-pm bleeding-edge branch,
>  - reordered the patches a bit (to have the generic ones first),
>  - dropped renaming of S3C64xx power domains (as suggested by Mark Brown),
>  - added support for deferred probing (as suggested by Stephen Boyd),
>  - fixed several minor issues pointed by Stephen Boyd,
>  - replaced notifiers with direct hooks in driver core to make power domain
>    support independent from specific bus type and allow error handling.
> 
> Tomasz Figa (3):
>   base: power: Add generic OF-based power domain look-up
>   drivercore: Bind/unbind power domain on probe/remove
>   ARM: exynos: Move to generic power domain bindings
> 
>  .../bindings/arm/exynos/power_domain.txt           |  12 +-
>  .../devicetree/bindings/power/power_domain.txt     |  51 ++++
>  arch/arm/mach-exynos/pm_domains.c                  |  81 +-----
>  drivers/base/dd.c                                  |   9 +-
>  drivers/base/power/domain.c                        | 283 +++++++++++++++++++++
>  include/linux/pm_domain.h                          |  46 ++++
>  kernel/power/Kconfig                               |   4 +
>  7 files changed, 398 insertions(+), 88 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt
> 

Rob, Mark, could we have your ACK (or NAK if you find some issues) for
DT bindings introduced by this series?

Rafael, I wonder if we could still have this series applied for 3.16. I
know it is a bit late already, but the series isn't too invasive, as it
mostly generalizes what was being done on per-platform basis and makes
the code generic. Also I have already seen at least two other series
depending on this one, so they would benefit from this being merged.

Best regards,
Tomasz
