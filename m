Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab3ENTd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:33:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60123 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757884Ab3ENTd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:33:56 -0400
Message-ID: <1368560034.24692.4.camel@joe-AO722>
Subject: Re: [PATCH v2] watchdog: New watchdog driver for MEN A21 watchdogs
From: Joe Perches <joe@perches.com>
To: johannes.thumshirn@men.de
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 May 2013 12:33:54 -0700
In-Reply-To: <1368558589-3156-1-git-send-email-johannes.thumshirn@men.de>
References: <20130513224440.GA13891@roeck-us.net>
	 <1368558589-3156-1-git-send-email-johannes.thumshirn@men.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 21:09 +0200, johannes.thumshirn@men.de wrote:
> From: Johannes Thumshirn <johannes.thumshirn@men.de>
> 
> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.

trivia:

> diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c

add:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include to prefix pr_<level> messages.

> +#include <linux/module.h>
[]
> +static int a21_wdt_probe(struct platform_device *pdev)
> +{
> +	struct a21_wdt_drv *drv;
> +	int ret;
> +
> +	dev_info(&pdev->dev, "MEN A21 watchdog timer driver enabled\n");
> +
> +	drv = devm_kzalloc(&pdev->dev, sizeof(struct a21_wdt_drv), GFP_KERNEL);
> +	if (!drv) {
> +		dev_err(&pdev->dev,
> +			"Unable to allocate memory for watchdog device\n");

OOM messages aren't particularly useful as all
failed memory allocations (without __GFP_NOWARN)
get a generic dump_stack().

> +	ret = watchdog_register_device(&a21_wdt);
> +	if (ret) {
> +		pr_err("Cannot register watchdog device\n");
> +		goto err_register_wd;
> +	}
> +
> +	ret = register_reboot_notifier(&a21_wdt_notifier);
> +	if (ret) {
> +		pr_err("Cannot register reboot notifier\n");
> +		goto err_register_notif;
> +	}
> +
> +	ret = a21_wdt_create_files(&a21_wdt);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot create sysfs entries\n");
> +		goto err_create_sysfs;
> +	}

Mixing pr_err and dev_err may not be that useful.

Why not all dev_err?  Then there'd be no pr_<level>
uses at all and you wouldn't need the pr_fmt either.


