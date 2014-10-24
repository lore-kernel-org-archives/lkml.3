Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaJXHaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:30:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58808 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaJXHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:30:17 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-17-544a00060888
Message-id: <1414135811.2989.8.camel@AMDC1943>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
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
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 24 Oct 2014 09:30:11 +0200
In-reply-to: <54492ADA.4000309@ti.com>
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
 <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
 <54492ADA.4000309@ti.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xa7psDF4hBt3HRS1urTvHatF77iST
	xcYZ61ktrnx9z2bRvHg9m8XKKSwWk+5PYLF4ce8ii0XvgqtsFmeb3rBbzJqyl8li0+NrrBaX
	d81hs/jce4TRYsb5fUwWa4/cZbe4e+oom8WZ05dYLWZMfslmcXxtuIOIx+I9L5k87lzbw+ax
	/dsDVo/9c9ewe9zvPs7ksXlJvceWq+0sHn1bVjF6HL+xncljxerv7B6fN8kFcEdx2aSk5mSW
	pRbp2yVwZaxvOMxUcEe54lTrF+YGxtlyXYycHBICJhKfWv4zQ9hiEhfurWfrYuTiEBJYyiix
	aO9hJgjnM6PEz9tXGEGqeAX0JF717gDrEBbwl/h06x5YnE3AWGLz8iVsILaIgIHEujPzGEGa
	mQWeskqcOHeMHSTBIqAqcfzKcrAGTgE1icVv21ggNixklHizczoLSIJZQF1i0rxFQBs4gG5S
	lmjsd4NYLCjxY/I9qBJ5ic1r3jJPYBSYhaRjFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0u
	zUvXS87P3cQIidCvOxiXHrM6xCjAwajEw/tji2eIEGtiWXFl7iFGCQ5mJRHemv9AId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYyrlp1vOCSy4rTAisWLtX6yXzpbmrqoWnzjjkmPkvb3tfyboKyf
	scFAL0DvpuXfn+sja8TbJwufary8zchVSnbeNq20A8X2L0/OK6l/EJS0hEleooe3XNW5+P77
	0plzHKcF8/gssJ4z+fLC1mimaBnpw6fEUhI7pzlXr4t7o9d59e6rL7mH7/opsRRnJBpqMRcV
	JwIAbW2+La4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-23 at 19:20 +0300, Grygorii Strashko wrote:
> Hi Krzysztof,
> 
> On 10/23/2014 04:48 PM, Krzysztof Kozlowski wrote:
> > When resuming the system the power domain has to be powered on early so
> > any runtime PM aware devices could resume.
> > 
> > This fixes following scenario reproduced on Exynos DRM:
> > 1. Power domain is off before suspending the system.
> > 2. System is suspended to RAM.
> > 3. Resuming starts. The Exynos DRM driver resume callback is called.
> > 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
> >     the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
> > 5. The Exynos DSI driver calls pm_runtime_get. The driver runtime
> >     resumes and this should turn LCD power domain on.
> > 6. Unfortunately the domain cannot be turned on because system resume is
> >     in progress and genpd->prepared_count is positive.
> 
> Just interesting, what value will be returned by pm_runtime_enabled()
> from any of your .resume() callback (for any device which belongs to
> some Generic PM domain)?

exynos_drm_resume: false
exynos_dsi_enable: true

Full backtrace leading to exynos_dsi_enable:
[   37.944830] ------------[ cut here ]------------
[   37.944860] WARNING: CPU: 0 PID: 3125 at drivers/gpu/drm/exynos/exynos_drm_dsi.c:1360 exynos_dsi_dpms+0xc0/0x398()
[   37.944869] Modules linked in:
[   37.944883] CPU: 0 PID: 3125 Comm: bash Tainted: G        W      3.17.0-next-20141020-00050-g844ed80678d5-dirty #479
[   37.944923] [<c0013d64>] (unwind_backtrace) from [<c0010eb0>] (show_stack+0x10/0x14)
[   37.944949] [<c0010eb0>] (show_stack) from [<c04a37b0>] (dump_stack+0x70/0xbc)
[   37.944977] [<c04a37b0>] (dump_stack) from [<c0021420>] (warn_slowpath_common+0x64/0x88)
[   37.944992] [<c0021420>] (warn_slowpath_common) from [<c0021460>] (warn_slowpath_null+0x1c/0x24)
[   37.945011] [<c0021460>] (warn_slowpath_null) from [<c0268940>] (exynos_dsi_dpms+0xc0/0x398)
[   37.945024] [<c0268940>] (exynos_dsi_dpms) from [<c0263520>] (exynos_drm_encoder_commit+0x24/0x40)
[   37.945044] [<c0263520>] (exynos_drm_encoder_commit) from [<c023f0b4>] (drm_crtc_helper_set_mode+0x400/0x4e8)
[   37.945057] [<c023f0b4>] (drm_crtc_helper_set_mode) from [<c023f204>] (drm_helper_resume_force_mode+0x68/0x124)
[   37.945083] [<c023f204>] (drm_helper_resume_force_mode) from [<c0262b9c>] (exynos_drm_resume+0x80/0x90)
[   37.945100] [<c0262b9c>] (exynos_drm_resume) from [<c02832f8>] (platform_pm_resume+0x2c/0x4c)
[   37.945118] [<c02832f8>] (platform_pm_resume) from [<c028a320>] (dpm_run_callback.isra.7+0x2c/0x64)
[   37.945130] [<c028a320>] (dpm_run_callback.isra.7) from [<c028a404>] (device_resume+0xac/0x180)
[   37.945141] [<c028a404>] (device_resume) from [<c028b65c>] (dpm_resume+0xe8/0x20c)
[   37.945152] [<c028b65c>] (dpm_resume) from [<c028b91c>] (dpm_resume_end+0xc/0x18)
[   37.945175] [<c028b91c>] (dpm_resume_end) from [<c0054b48>] (suspend_devices_and_enter+0x230/0x3c8)
[   37.945190] [<c0054b48>] (suspend_devices_and_enter) from [<c0054f48>] (pm_suspend+0x268/0x29c)
[   37.945202] [<c0054f48>] (pm_suspend) from [<c0053a74>] (state_store+0x6c/0xbc)
[   37.945220] [<c0053a74>] (state_store) from [<c01d0890>] (kobj_attr_store+0x14/0x20)
[   37.945235] [<c01d0890>] (kobj_attr_store) from [<c011e56c>] (sysfs_kf_write+0x44/0x48)
[   37.945245] [<c011e56c>] (sysfs_kf_write) from [<c011dc10>] (kernfs_fop_write+0xc0/0x17c)
[   37.945268] [<c011dc10>] (kernfs_fop_write) from [<c00c7bfc>] (vfs_write+0xa0/0x1a8)
[   37.945282] [<c00c7bfc>] (vfs_write) from [<c00c7f14>] (SyS_write+0x40/0x8c)
[   37.945299] [<c00c7f14>] (SyS_write) from [<c000e6e0>] (ret_fast_syscall+0x0/0x30)
[   37.945307] ---[ end trace e930e0edfd9a5ad2 ]---


> I'm asking, because as I can see Runtime PM can be disabled from pm_genpd_prepare().
> 
> Thank you.
> 
> Oh. I've just found that you might get this issue if you will try to do
> suspend when PM domain is ON ;)
> 
> Any way, In my opinion, It might be better to fix pm_genpd_prepare() so
> it will not increment prepared_count when initial state of the GPD is
> GPD_STATE_POWER_OFF. Seems it's needed only in opposite case -
> when state of GPD has to be restored from pm_genpd_resume_noirq().

That sounds good but what about cases when the device will runtime
resume during suspend (early at suspend)? Actually I seen this with
framebuffer console. Right after starting suspend the console is flushed
and poked which leads to powering on LCD.

Best regards,
Krzysztof


