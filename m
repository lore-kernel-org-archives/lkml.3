Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3FGKCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:02:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab3FGKCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:02:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Shuah Khan'" <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH] backlight: add CONFIG_PM_SLEEP to suspend/resume functions
Date: Fri, 07 Jun 2013 12:02:31 +0200
Message-ID: <1944274.r5ID26zhWd@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
References: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0PWEoe5miJKpjcXoeHYtq4cRhjhrJMkJG692kBMyjOg
 j8Yrpz3OxEWdSwCWnYND9BOIHYwCZuUZOj99+k6OqzuSy7aSSK
 2LS9HPAx7CDcSeVj+YFpm7FtJIX7NxxnYi5DBUTbKshkiA43I/
 YaodeqWFseC+Kt2wzu60c7GexugMUC+6jodA86Kf7xFgJyURk8
 IRVPahg3u2ECpfFVTF/w/fKz8WBT8JXIRVmRN7b7Wy6XyD1Y7b
 H5syATbrCS7Ho9XjdMDpEv7UJSgMOv0UynjI/H+ow5bsbXfmkV
 s89kHVeLcG7s9AsqUri4MY5DrrfZEQuVSACUjfo39jQEz3Ai3j
 icxuJhxC2egDp5ckrud0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 10:39:20 Jingoo Han wrote:
> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
> build warning when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
> the CONFIG_PM_SLEEP is enabled.
> 
> drivers/video/backlight/backlight.c:211:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
> drivers/video/backlight/backlight.c:225:12: warning: 'backlight_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/backlight.c |    2 ++
>  1 file changed, 2 insertions(+)

Your patch looks ok, but I find it extremely annoying to have new warnings
like this one come up every single day in linux-next. It really shouldn't
be this hard to use a macro called SIMPLE_DEV_PM_OPS() correctly.

Below is an implementation of SIMPLE_DEV_PM_OPS and UNIVERSAL_DEV_PM_OPS
that avoids this issue by introducing an unused reference to the suspend
and resume functions. gcc is smart enough to leave out that unused code
by itself, and it would actually improve compile-time coverage to have
something like this, besides being harder to misuse.

This would be a better approach if we didn't already have all the "#ifdef
CONFIG_PM_SLEEP" in place that hide the functions now. Unfortunately we
already have over 300 uses of SIMPLE_DEV_PM_OPS/UNIVERSAL_DEV_PM_OPS
in the kernel today, so removing all the #ifdef atomically without
creating more build errors is rather hard to do.

Maybe someone has an idea how to extend my approach so it works with
and without the #ifdef, to let us transition to a situation that no
longer needs them.

	Arnd

diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..5a801bd 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -320,6 +320,9 @@ struct dev_pm_ops {
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #endif
 
+#define UNUSED_DEV_PM_OPS(name, func...) \
+static const int (*__unused_ ## name[])(struct device*) __maybe_unused = { func };
+
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
@@ -327,7 +332,8 @@ struct dev_pm_ops {
 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
 const struct dev_pm_ops name = { \
 	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-}
+}; \
+UNUSED_DEV_PM_OPS(name, suspend_fn, resume_fn)
 
 /*
  * Use this for defining a set of PM operations to be used in all situations
@@ -346,7 +352,8 @@ const struct dev_pm_ops name = { \
 const struct dev_pm_ops name = { \
 	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
-}
+}; \
+UNUSED_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn)
 
 /**
  * PM_EVENT_ messages

