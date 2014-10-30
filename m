Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbaJ3Hgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:36:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJ3Hgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:36:39 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-ea-5451ea84afea
Content-transfer-encoding: 8BIT
Message-id: <1414654594.5114.8.camel@AMDC1943>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 30 Oct 2014 08:36:34 +0100
In-reply-to: <7hk33iahvu.fsf@deeprootsystems.com>
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
 <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
 <7hk33iahvu.fsf@deeprootsystems.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/xq7otrwJDDL5e4rK4te4cq0XvuZNM
	FhtnrGe1uPL1PZtF8+L1bBaT7k9gsXhx7yKLRe+Cq2wWTzc/ZrI42/SG3WLWlL1MFpseX2O1
	uLxrDpvF594jjBYzzu9jslh75C67xd1TR9kszpy+xGoxY/JLNgdhj8V7XjJ5bFrVyeax/dsD
	Vo/9c9ewe9zvPs7ksXlJvceWq+0sHn1bVjF6rFj9nd3j8ya5AK4oLpuU1JzMstQifbsEroxF
	r44xFXzjqujZfYGtgfE1RxcjJ4eEgInEgoWLmSBsMYkL99azdTFycQgJLGWUODhnC1iCV0BQ
	4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+ZUeLRlHXMEPV6EhvmngKzhQX8JT7duscI
	YrMJGEtsXr6EDcQWEVCV+LVyJ1gzs8BeVolf00+zgyRYgBKL500Ha+YUMJT49LePFWLDGkaJ
	+ztmMYJcISGgLNHY7zaBUWAWkvtmIdw3C8l9CxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefn
	bmKEROPXHYxLj1kdYhTgYFTi4Y04FhAixJpYVlyZe4hRgoNZSYQ38XJgiBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQZGhl39HkIuLhdOR+38lrCjoeh2nWr8H5N7Kz9vffRhjZFjud6Lt4ueGl3w
	tMuzu2vo/0AoW37yWi6W2K1z31XvEap89f2O9buaUkfGkrofVuGTrxrZtkmeff1+u9OjjzUf
	TbXYb0mu9Dtd2i1n9lsxQXEpZ2fVlbonW5Yc/On4SfV2RKAY94X1SizFGYmGWsxFxYkADgHp
	/qQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-29 at 10:46 -0700, Kevin Hilman wrote:
> Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:
> 
> > When resuming the system the power domain has to be powered on early so
> > any runtime PM aware devices could resume.
> >
> > This fixes following scenario reproduced on Exynos DRM:
> > 1. Power domain is off before suspending the system.
> > 2. System is suspended to RAM.
> > 3. Resuming starts. The Exynos DRM driver resume callback is called.
> > 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
> >    the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
> 
> Dumb Q: if the device (and power domain) were off before (and during)
> suspend, why are they being resumed?
> 
> Shouldn't the resume path restore things to the same state they were
> before suspend?

One could expect that... but the Exynos DRM driver behaves differently
(and some other drivers also). In resume method it calls
drm_helper_resume_force_mode() which forces restoring mode setting
configuration. Apparently setting a mode needs DPMS on:
static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
{
	...
	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
	...

The previous DPMS status (status during suspend) is completely ignored
here.

I dunno why... maybe someone from DRM could share some thoughts?


Best regards,
Krzysztof

