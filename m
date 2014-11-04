Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaKDNoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:44:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53962 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaKDNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:44:07 -0500
Message-ID: <5458D7FC.2040406@ti.com>
Date: Tue, 4 Nov 2014 15:43:24 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>, Andrzej Hajda <a.hajda@samsung.com>
CC: Len Brown <len.brown@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>, <linux-pm@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com> <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com> <7hk33iahvu.fsf@deeprootsystems.com> <1414654594.5114.8.camel@AMDC1943> <54521A8F.5070808@samsung.com> <7hbnoojm8y.fsf@deeprootsystems.com>
In-Reply-To: <7hbnoojm8y.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 06:13 PM, Kevin Hilman wrote:
> Andrzej Hajda <a.hajda@samsung.com> writes:
> 
>> On 10/30/2014 08:36 AM, Krzysztof Kozlowski wrote:
>>> On śro, 2014-10-29 at 10:46 -0700, Kevin Hilman wrote:
>>>> Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:
>>>>
>>>>> When resuming the system the power domain has to be powered on early so
>>>>> any runtime PM aware devices could resume.
>>>>>
>>>>> This fixes following scenario reproduced on Exynos DRM:
>>>>> 1. Power domain is off before suspending the system.
>>>>> 2. System is suspended to RAM.
>>>>> 3. Resuming starts. The Exynos DRM driver resume callback is called.
>>>>> 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
>>>>>     the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
>>>> Dumb Q: if the device (and power domain) were off before (and during)
>>>> suspend, why are they being resumed?
>>>>
>>>> Shouldn't the resume path restore things to the same state they were
>>>> before suspend?
>>> One could expect that... but the Exynos DRM driver behaves differently
>>> (and some other drivers also). In resume method it calls
>>> drm_helper_resume_force_mode() which forces restoring mode setting
>>> configuration. Apparently setting a mode needs DPMS on:
>>> static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
>>> {
>>> 	...
>>> 	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>>> 	...
>>>
>>> The previous DPMS status (status during suspend) is completely ignored
>>> here.
>>
>> Suspend callback switches off all connectors (thus all other devs in
>> their pipeline) by calling dpms_off,
>> in restore callback all devs are restored to their previous state by
>> calling appropriate dpms.
>> So I guess drm_helper_resume_force_mode() call at the end of resume is
>> incorrect.
> 
> Though I'm not terribly familiar with DRM, it seems incorrect because I
> expect resume to restore the state of things when suspend happened, not
> forcibly resume everything.
> 
>> On the other side it is present in many other drivers, so I am also
>> little bit confused.
> 
> Many other DRM drivers?  or other drivers too?

If I understand GPD code right :)
There is "small" problem :( Now if PM domain is OFF before suspend
- it's prohibited to turn it on during suspending/resuming.
   commit 596ba34bcd2978ee9823cc1d84df230576f8ffb9
   PM / Domains: System-wide transitions support for generic domains (v5)

But, it is possible to have devices which supports few power states, like:
on, sleep/low power, off (for example OMAP devices and also I saw this
for some I2C devices - can recollect only that it was some sensor and touchscreen). 
In normal operational mode Runtime PM switches device between on and sleep/low power states,
but during suspend device need to be woken up and reconfigured to off state.

Also I found, that It looks like due to continuous refactoring the call of
pm_generic_suspend_noirq(dev) was finally dropped from pm_genpd_suspend_noirq(),
so .suspend_noirq() callback will never be called for devices from GPD.

Seems, that is the problem which this patch tries to fix and looks like there are
 will be more such kind of report as GPD is become used widely.

regards,
-grygorii
