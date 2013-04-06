Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138Ab3DFSdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 14:33:03 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58100 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476Ab3DFSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 14:33:01 -0400
Message-ID: <51606A7F.3050803@prisktech.co.nz>
Date: Sun, 07 Apr 2013 06:33:35 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, akpm@linux-foundation.org
Subject: PWM backlight build warning
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Sorry it's taken so long to report this but I've been tied up with other 
patches recently. I noticed a build warning on the pwm_bl driver in 
3.9-rcX but I'm not sure what the correct resolution would be. This patch:

commit e2c17bc6f717a8847df2a867caec6ba4fe85f3fc
backlight: convert pwm_bl to dev_pm_ops

Should be no functional changes, mainly a reorganisation to support 
future work.

[akpm@linux-foundation.org: fix CONFIG_PM=n build]
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

has introduced a two build warnings in my config:
drivers/video/backlight/pwm_bl.c:278:12: warning: 
‘pwm_backlight_suspend’ defined but not used [-Wunused-function]
drivers/video/backlight/pwm_bl.c:292:12: warning: ‘pwm_backlight_resume’ 
defined but not used [-Wunused-function]

Although I noticed it doesn't have your acked-by ;)


Selecting "Run-time PM core functionality" without "Suspend to RAM and 
standby" causes the unused function warning.
With CONFIG_PM=n, no warnings. With CONFIG_PM=y and CONFIG_PM_SLEEP=y, 
no warnings.

The problem occurs because when CONFIG_PM=y but CONFIG_PM_SLEEP=n:

#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
const struct dev_pm_ops name = { \
SET_SYSTEM_SLEEP_PM_OPS(syspend_fn, resume_fn) \
}

#ifdef CONFIG_PM_SLEEP
#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
.suspend = suspend_fn, \
.resume = resume_fn, \
.freeze = suspend_fn, \
.thaw = resume_fn, \
.poweroff = suspend_fn, \
.restore = resume_fn,
#else
#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
#endif

I guess this would be a problem on every driver that has been converted 
to SIMPLE_DEV_PM_OPS.
I don't know enough about the PM code to offer a fix, or whethermy 
chosen config is just 'invalid'.

Regards
Tony P
