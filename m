Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaJ3LBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:01:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22356 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaJ3LBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:01:41 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f5-b7f956d000005ed7-88-54521a936c3a
Content-transfer-encoding: 8BIT
Message-id: <54521A8F.5070808@samsung.com>
Date: Thu, 30 Oct 2014 12:01:35 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
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
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
 <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
 <7hk33iahvu.fsf@deeprootsystems.com> <1414654594.5114.8.camel@AMDC1943>
In-reply-to: <1414654594.5114.8.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4Nd3JUkEhBlO28Vn0njvJZLFxxnpW
	iytf37NZNC9ez2Yx6f4EFosX9y6yWLx+YWjRu+Aqm8XTzY+ZLM42vWG3mDVlL5PFpsfXWC0u
	75rDZvG59wijxYzz+5gs1h65y25x99RRNoszpy+xWsyY/JLNQdhj8Z6XTB6bVnWyeWz/9oDV
	Y//cNewe97uPM3lsXlLvseVqO4tH35ZVjB4rVn9n9/i8SS6AK4rLJiU1J7MstUjfLoEr48rL
	9YwFX3grfk76xtTAuJa7i5GTQ0LAROL7xNeMELaYxIV769m6GLk4hASWMkq0fnnJBJLgFRCU
	+DH5HksXIwcHs4C8xJFL2RCmusSUKbkQ5Z8YJR7uewFVriVx52wXmM0ioCrxfeoJMJtNQFPi
	7+abbCC2qECExJU1c8D2igiESez6vZQFZBCzwDRWiZmv/7ODJIQF/CU+3brHCLHhPKPEhDOH
	wbo5BfQldn9+zzKBUWAWkvtmIdw3C+G+BYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFC
	IvHrDsalx6wOMQpwMCrx8EYcCwgRYk0sK67MPcQowcGsJMK7WiwoRIg3JbGyKrUoP76oNCe1
	+BAjEwenVAOj8cZXQvfcJyTP2MDv1na9iIe1x2Om2Fn3IoN37fFsFRsfhh56ffNS0ZlQuxLv
	ZxsnLglcV/zN6eHJeZFhJ74Hh0c8DH95kl3ybYdk8jzB27dVXh0K+RFzQKMn5M/xeca7tG58
	Ovm8zKFBuPdf+8176y8XvE/K+Gp6uUhvhmPGDMuYqC2qFvOElFiKMxINtZiLihMB2DSBtKIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 08:36 AM, Krzysztof Kozlowski wrote:
> On śro, 2014-10-29 at 10:46 -0700, Kevin Hilman wrote:
>> Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:
>>
>>> When resuming the system the power domain has to be powered on early so
>>> any runtime PM aware devices could resume.
>>>
>>> This fixes following scenario reproduced on Exynos DRM:
>>> 1. Power domain is off before suspending the system.
>>> 2. System is suspended to RAM.
>>> 3. Resuming starts. The Exynos DRM driver resume callback is called.
>>> 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
>>>    the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
>> Dumb Q: if the device (and power domain) were off before (and during)
>> suspend, why are they being resumed?
>>
>> Shouldn't the resume path restore things to the same state they were
>> before suspend?
> One could expect that... but the Exynos DRM driver behaves differently
> (and some other drivers also). In resume method it calls
> drm_helper_resume_force_mode() which forces restoring mode setting
> configuration. Apparently setting a mode needs DPMS on:
> static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
> {
> 	...
> 	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
> 	...
>
> The previous DPMS status (status during suspend) is completely ignored
> here.

Suspend callback switches off all connectors (thus all other devs in
their pipeline) by calling dpms_off,
in restore callback all devs are restored to their previous state by
calling appropriate dpms.
So I guess drm_helper_resume_force_mode() call at the end of resume is
incorrect.
On the other side it is present in many other drivers, so I am also
little bit confused.

Regards
Andrzej


