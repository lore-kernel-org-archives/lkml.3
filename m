Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbaD3S4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:56:12 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57401 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbaD3S4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:56:09 -0400
MIME-Version: 1.0
In-Reply-To: <1398749704-10196-1-git-send-email-inderpal.s@samsung.com>
References: <1398749704-10196-1-git-send-email-inderpal.s@samsung.com>
Date: Wed, 30 Apr 2014 11:56:08 -0700
X-Google-Sender-Auth: YjmOqWngDitcIWN9mSGCjmK94nc
Message-ID: <CAD=FV=Vo+GLTt7fh4639XFsJfSUTN0ARBsOy+O24gtB_87MgLw@mail.gmail.com>
Subject: Re: [RFC PATCH] regulator: virtual: Introduce a new virtual locker
 regulator type
From: Doug Anderson <dianders@chromium.org>
To: Inderpal Singh <inderpal.s@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 28, 2014 at 10:35 PM, Inderpal Singh <inderpal.s@samsung.com> wrote:
> On some SoCs there could be requirements that two or more voltage
> regulators need to maintain certain skew for proper functioning.
>
> This patch implements a new vitual locker type regulator which can
> have multiple output and input regulators. The real regulators will
> be hidden under the virtual output regulators. The consumer of the
> real regulators need not change anything. Only the name of the real
> regulators need to be changed.
>
> This patch has been tested on exynos5420 based smdk5420.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
>  .../bindings/regulator/locker-regulator.txt        |  36 ++
>  drivers/regulator/Kconfig                          |   9 +
>  drivers/regulator/Makefile                         |   1 +
>  drivers/regulator/locker.c                         | 472 +++++++++++++++++++++
>  include/linux/regulator/locker.h                   |  35 ++
>  5 files changed, 553 insertions(+)

I cornered Rob and Mark Rutland a little bit about this at ELC today
(sorry!).  Neither of them was a huge ran of adding a pseudo device.
Rob suggested that Mark Brown might be the best person to give
direction here.  Mark Brown: any thoughts?

Potentially we could also make this type of thing a core regulator property:

  buck2_reg: BUCK2 {
          regulator-name = "vdd_arm";
          regulator-min-microvolt = <800000>;
          regulator-max-microvolt = <1500000>;
          regulator-always-on;
          regulator-boot-on;
          regulator-op-mode = <1>;
          regulator-ramp-delay = <12500>;
  };
  buck3_reg: BUCK3 {
          regulator-name = "vdd_int";
          regulator-min-microvolt = <800000>;
          regulator-max-microvolt = <1400000>;
          regulator-always-on;
          regulator-boot-on;
          regulator-op-mode = <1>;
          regulator-ramp-delay = <12500>;
          regulator-lock-to = <&buck2>;
          regulator-lock-within = <300000>;
  };

Another option is to add no device tree code at all and add code to
the devfreq / cpufreq drivers used on this device.  In order to do
this cleanly I think we'd need to extend the regulator core's
notification scheme to introduce a new event:
REGULATOR_EVENT_VOLTAGE_CHANGING that's called _before_ a voltage
change happened.


Or maybe there's some yet different (cleaner) solution that I haven't
thought of.

-Doug
