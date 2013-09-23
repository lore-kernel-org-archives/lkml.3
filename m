Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3IWLRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:17:47 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:55277
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314Ab3IWLRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:17:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z1039mzbb2dI98dI9371I1432I1453Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275ch1de098h1de097h8275bh8275dhz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5240234B.4070800@freescale.com>
Date: Mon, 23 Sep 2013 19:17:31 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Rob Landley <rob@landley.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Christian Daudt <bcm@fixthebug.org>,
        James King <james.king@linaro.org>
Subject: Re: [RFC PATCH] thermal: add generic cpu hotplug cooling device
References: <1379715336-22620-1-git-send-email-zoran.markovic@linaro.org>
In-Reply-To: <1379715336-22620-1-git-send-email-zoran.markovic@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 06:15 AM, Zoran Markovic wrote:
> This patch implements a generic CPU hotplug cooling device. The
> implementation scales down the number of running CPUs when temperature
> increases through a thermal trip point and prevents booting CPUs
> until thermal conditions are restored. Upon restoration, the action
> of starting up a CPU is left to another entity (e.g. CPU offline
> governor, for which a patch is in the works).
>
> In the past two years, ARM considerably reduced the time required for
> CPUs to boot and shutdown; this time is now measured in microseconds.
> This patch is predominantly intended for ARM big.LITTLE architectures
> where big cores are expected to have a much bigger impact on thermal
> budget than little cores, resulting in fast temperature ramps to a trip
> point, i.e. thermal runaways. Switching off the big core(s) may be one
> of the recovery mechanisms to restore system temperature, but the actual
> strategy is left to the thermal governor.
>
> The assumption is that CPU shutdown/startup is a rare event, so no
> attempt was made to make the code atomic, i.e. the code evidently races
> with CPU hotplug driver. The set_cur_state() function offlines CPUs
> iteratively one at a time, checking the cooling state before each CPU
> shutdown. A hotplug notifier callback validates any CPU boot requests
> against current cooling state and approves/denies accordingly. This
> mechanism guarantees that the desired cooling state could be reached in a
> maximum of d-c iterations, where d and c are the "desired" and "current"
> cooling states expressed in the number of offline CPUs.
>
> Credits to Amit Daniel Kachhap for initial attempt to upstream this feature.
>
> Cc: Zhang Rui<rui.zhang@intel.com>
> Cc: Eduardo Valentin<eduardo.valentin@ti.com>
> Cc: Rob Landley<rob@landley.net>
> Cc: Amit Daniel Kachhap<amit.daniel@samsung.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Durgadoss R<durgadoss.r@intel.com>
> Cc: Christian Daudt<bcm@fixthebug.org>
> Cc: James King<james.king@linaro.org>
> Signed-off-by: Zoran Markovic<zoran.markovic@linaro.org>
> ---
>   Documentation/thermal/cpu-cooling-api.txt |   17 ++
>   drivers/thermal/Kconfig                   |   10 +
>   drivers/thermal/Makefile                  |    1 +
>   drivers/thermal/cpu_hotplug.c             |  362 +++++++++++++++++++++++++++++
>   include/linux/cpuhp_cooling.h             |   57 +++++
>   5 files changed, 447 insertions(+)
>   create mode 100644 drivers/thermal/cpu_hotplug.c
>   create mode 100644 include/linux/cpuhp_cooling.h
Only form my point of view:
I like the name of cpu_hotplug_cooling.c and cpu_hotplug_cooling.h
we already have a cpu_cooling.c, that isn't so exact either because we 
have more than one method to cool a CPU, these c and h files should be 
renamed to cpu_freq_cooling.c and cpu_freq_cooling.h later.

By the way, some servers with tens of CPUs may need this patch too.



