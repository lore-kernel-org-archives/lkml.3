Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaIYJDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:03:21 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:50582 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIYJDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:03:15 -0400
Date: Thu, 25 Sep 2014 11:03:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-tegra@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v7 2/5] ARM: add AFTR mode support to firmware do_idle
 method
Message-ID: <20140925090310.GA12046@ulmo>
References: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
 <1411561488-1739-3-git-send-email-b.zolnierkie@samsung.com>
 <5423D104.4050809@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <5423D104.4050809@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 05:23:32PM +0900, Kukjin Kim wrote:
> On 09/24/14 21:24, Bartlomiej Zolnierkiewicz wrote:
> >On some platforms (i.e. EXYNOS ones) more than one idle mode is
> >available and we need to distinguish them in firmware do_idle method.
> >
> >Add mode parameter to do_idle firmware method and AFTR mode support
> >to EXYNOS do_idle implementation.
> >
> >This change is a preparation for adding secure firmware support to
> >EXYNOS cpuidle driver.
> >
> >This patch shouldn't cause any functionality changes.
> >
> >Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> >Acked-by: Kyungmin Park<kyungmin.park@samsung.com>
> >---
> >v7:
> >- fixed build on Tegra
> >- updated summary line
> >
> >  arch/arm/include/asm/firmware.h        |  2 +-
> >  arch/arm/mach-exynos/common.h          |  5 +++++
> >  arch/arm/mach-exynos/firmware.c        | 10 ++++++++--
> >  arch/arm/mach-tegra/cpuidle-tegra114.c |  2 +-
> >  4 files changed, 15 insertions(+), 4 deletions(-)
> >
> >diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firm=
ware.h
> >index 5904f59..89aefe1 100644
> >--- a/arch/arm/include/asm/firmware.h
> >+++ b/arch/arm/include/asm/firmware.h
> >@@ -28,7 +28,7 @@ struct firmware_ops {
> >  	/*
> >  	 * Enters CPU idle mode
> >  	 */
> >-	int (*do_idle)(void);
> >+	int (*do_idle)(unsigned long mode);
> >  	/*
> >  	 * Sets boot address of specified physical CPU
> >  	 */
> >diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common=
=2Eh
> >index c218200..2d830df 100644
> >--- a/arch/arm/mach-exynos/common.h
> >+++ b/arch/arm/mach-exynos/common.h
> >@@ -119,6 +119,11 @@ extern void __iomem *sysram_base_addr;
> >  extern void __iomem *pmu_base_addr;
> >  void exynos_sysram_init(void);
> >
> >+enum {
> >+	FW_DO_IDLE_SLEEP,
> >+	FW_DO_IDLE_AFTR,
> >+};
> >+
> >  void exynos_firmware_init(void);
> >
> >  extern u32 exynos_get_eint_wake_mask(void);
> >diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firm=
ware.c
> >index f5e626d..e57b7c3 100644
> >--- a/arch/arm/mach-exynos/firmware.c
> >+++ b/arch/arm/mach-exynos/firmware.c
> >@@ -28,9 +28,15 @@
> >  #define EXYNOS_BOOT_ADDR	0x8
> >  #define EXYNOS_BOOT_FLAG	0xc
> >
> >-static int exynos_do_idle(void)
> >+static int exynos_do_idle(unsigned long mode)
> >  {
> >-	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
> >+	switch (mode) {
> >+	case FW_DO_IDLE_AFTR:
> >+		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
> >+		break;
> >+	case FW_DO_IDLE_SLEEP:
> >+		exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
> >+	}
> >  	return 0;
> >  }
> >
> >diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegr=
a/cpuidle-tegra114.c
> >index e3ebdce..425b6c8 100644
> >--- a/arch/arm/mach-tegra/cpuidle-tegra114.c
> >+++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
> >@@ -49,7 +49,7 @@ static int tegra114_idle_power_down(struct cpuidle_dev=
ice *dev,
> >  	call_firmware_op(prepare_idle);
> >
> >  	/* Do suspend by ourselves if the firmware does not implement it */
> >-	if (call_firmware_op(do_idle) =3D=3D -ENOSYS)
> >+	if (call_firmware_op(do_idle, 0) =3D=3D -ENOSYS)
> >  		cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
> >
> >  	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,&dev->cpu);
>=20
> + Thierry(using nvidia.com e-mail address)
>=20
> Hi Thierry,
>=20
> For supporting AFTR mode in call_firmware_op(do_idle), need to modify teg=
ra
> stuff as you can see. The functionality will be same with before. Is it OK
> to you? If you have no objection, I'd like to take this series into samsu=
ng
> tree.

I'm only aware of any devices using TrustedFirmware on Tegra, which is
what the above code handles. The implementation for TrustedFirmware does
not implement do_idle() (yet?) so I don't think this patch would cause
any damage.

Acked-by: Thierry Reding <treding@nvidia.com>

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI9pOAAoJEN0jrNd/PrOhLaIQALkgTf/L59tBx3qPUziYpTfU
Xp4LRKzA6Bo15lN9oeI039VoxLr7xWGqdT7KEQMSHUFv5webCveB93XXMLsoMHpH
GLuzdYNac9+gE8cTrnszkaO6XcTXtmM/ry+0xVFNZlt39JZWOcH50UQCTcbwXHM1
IHtNC2zaRJbB7BD8/MVWHg4El0eQmsgOQT4ia1UebaHs0xLMXejYhRMPm0sthqsP
eFXBqF0EBAK0A0405huwk5Qk6w10SumJw6m0g7QpyAQGPkhzDt4zA7YC2kXMVc4p
dObQrnKKJwmRF+s6Oh3ISYW+Oxkeroiwb+2tFQV6CVbD7hucOWKqyLU6t/NPwrDu
pyNSf+65AAtqLODmpYYd+xqd0SW6DeVs0L/K+R/Px4UbSV6sCJDm7E16LQqHvoY+
W6EXnBSLKVZ7PI2Vy+UdWqtmv7gv8EpZEULw4GdtjZV4SANglkn39YgFQREtyz9P
BmnsLgkddV52g+B4j/Sj9lpM8NmlhbQ6G91jv67HcYQ2D3JNhMecET1EdsYJ7WN2
GLamj12PGvFuYkXHaSonF4m2Bc/FWI7FgDvAP5e0BkbVfBskOTO7SSnVwk4nyKlw
kfVnldKUZOjR/7WdXDJynGucfxO4RHqd+AkEf3Nt7Dj3bVM2PBj43O1fufe5F4+w
gc1f18vTLcOXotViCAuG
=3py4
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
