Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3EELjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 07:39:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59415 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3EELjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 07:39:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: myungjoo.ham@samsung.com, Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] PM / devfreq: tie suspend/resume to runtime-pm
Date: Sun, 05 May 2013 13:48:09 +0200
Message-ID: <8888976.pxWaKvWiK0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1366205301-4249-1-git-send-email-rajagopal.venkat@linaro.org>
References: <1366205301-4249-1-git-send-email-rajagopal.venkat@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 17, 2013 06:58:21 PM Rajagopal Venkat wrote:
> Devfreq core runtime suspend/resume of a device is explicitly
> handled by devfreq driver using devfreq_suspend_device() and
> devfreq_resume_device() apis typically called from runtime
> suspend/resume callbacks. This patch aims to take away this
> from devfreq drivers and handle it from runtime-pm core. So
> that devfreq core runtime suspend/resume of a device is
> automatically done with runtime pm suspend/resume. The devfreq
> drivers shouldn't be concerned on when to suspend/resume the
> devfreq.

I agree, but perhaps there's a better way to achieve that than fumbling
in the PM core?

Did you consider using a PM domain for that?

> This patch is targeted to handle devfreq core load monitoring
> runtime suspend/resume only. Not the actual hardware itself.
> All the resources like clocks and regulators must still be
> handled by device driver using runtime-pm. The sequence of
> devfreq and device runtime suspend/resume is,
> 
> pm_runtime_suspend(dev) will first suspend device devfreq
> (if available) before device is suspended to ensure devfreq load
> monitoring is stopped and no device resources like clocks are
> accessed while device suspend is in progress.
> 
> pm_runtime_resume(dev) will resume device devfreq(if available)
> after device is resumed to ensure device resources like clocks
> are ready for use.
> 
> As devfreq runtime suspend/resume is done automatically from runtime
> core, this patch removes the existing devfreq_suspend_device() and
> devfreq_resume_device() apis.
> 
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>

I'm having a problem with this patch, because it's adding overhead into
rpm_suspend() and rpm_resume() for all devices, even though many of them
may not use devfreq.  Worse yet, there are systems in which devfreq will
never be used at all.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
