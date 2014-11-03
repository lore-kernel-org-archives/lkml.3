Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaKCQNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:13:24 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63326 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaKCQNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:13:21 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
	<1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
	<7hk33iahvu.fsf@deeprootsystems.com>
	<1414654594.5114.8.camel@AMDC1943> <54521A8F.5070808@samsung.com>
Date: Mon, 03 Nov 2014 08:13:17 -0800
In-Reply-To: <54521A8F.5070808@samsung.com> (Andrzej Hajda's message of "Thu,
	30 Oct 2014 12:01:35 +0100")
Message-ID: <7hbnoojm8y.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrzej Hajda <a.hajda@samsung.com> writes:

> On 10/30/2014 08:36 AM, Krzysztof Kozlowski wrote:
>> On śro, 2014-10-29 at 10:46 -0700, Kevin Hilman wrote:
>>> Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:
>>>
>>>> When resuming the system the power domain has to be powered on early so
>>>> any runtime PM aware devices could resume.
>>>>
>>>> This fixes following scenario reproduced on Exynos DRM:
>>>> 1. Power domain is off before suspending the system.
>>>> 2. System is suspended to RAM.
>>>> 3. Resuming starts. The Exynos DRM driver resume callback is called.
>>>> 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
>>>>    the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
>>> Dumb Q: if the device (and power domain) were off before (and during)
>>> suspend, why are they being resumed?
>>>
>>> Shouldn't the resume path restore things to the same state they were
>>> before suspend?
>> One could expect that... but the Exynos DRM driver behaves differently
>> (and some other drivers also). In resume method it calls
>> drm_helper_resume_force_mode() which forces restoring mode setting
>> configuration. Apparently setting a mode needs DPMS on:
>> static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
>> {
>> 	...
>> 	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>> 	...
>>
>> The previous DPMS status (status during suspend) is completely ignored
>> here.
>
> Suspend callback switches off all connectors (thus all other devs in
> their pipeline) by calling dpms_off,
> in restore callback all devs are restored to their previous state by
> calling appropriate dpms.
> So I guess drm_helper_resume_force_mode() call at the end of resume is
> incorrect.

Though I'm not terribly familiar with DRM, it seems incorrect because I
expect resume to restore the state of things when suspend happened, not
forcibly resume everything.

> On the other side it is present in many other drivers, so I am also
> little bit confused.

Many other DRM drivers?  or other drivers too?

Kevin

