Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbbAKXx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:53:29 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34660 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbAKXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <1420719905-15994-1-git-send-email-jilin@nvidia.com>
References: <1420719905-15994-1-git-send-email-jilin@nvidia.com>
Date: Mon, 12 Jan 2015 00:53:26 +0100
Message-ID: <CACRpkdZg7C9figdwiP5Lu9f_=EzWJgVdf7x8d=xCBUBzcZ44Lg@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: Fix two deadlocks
From: Linus Walleij <linus.walleij@linaro.org>
To: Jim Lin <jilin@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 1:25 PM, Jim Lin <jilin@nvidia.com> wrote:

> This patch is to fix two deadlock cases.
> Deadlock 1:
> CPU #1
>  pinctrl_register-> pinctrl_get ->
>  create_pinctrl
>  (Holding lock pinctrl_maps_mutex)
>  -> get_pinctrl_dev_from_devname
>  (Trying to acquire lock pinctrldev_list_mutex)
> CPU #0
>  pinctrl_unregister
>  (Holding lock pinctrldev_list_mutex)
>  -> pinctrl_put ->> pinctrl_free ->
>  pinctrl_dt_free_maps -> pinctrl_unregister_map
>  (Trying to acquire lock pinctrl_maps_mutex)
>
> Simply to say
> CPU#1 is holding lock A and trying to acquire lock B,
> CPU#0 is holding lock B and trying to acquire lock A.
>
> Deadlock 2:
> CPU #3
>  pinctrl_register-> pinctrl_get ->
>  create_pinctrl
>  (Holding lock pinctrl_maps_mutex)
>  -> get_pinctrl_dev_from_devname
>  (Trying to acquire lock pinctrldev_list_mutex)
> CPU #2
>  pinctrl_unregister
>  (Holding lock pctldev->mutex)
>  -> pinctrl_put ->> pinctrl_free ->
>  pinctrl_dt_free_maps -> pinctrl_unregister_map
>  (Trying to acquire lock pinctrl_maps_mutex)
> CPU #0
>  tegra_gpio_request
>  (Holding lock pinctrldev_list_mutex)
>  -> pinctrl_get_device_gpio_range
>  (Trying to acquire lock pctldev->mutex)
>
> Simply to say
> CPU#3 is holding lock A and trying to acquire lock D,
> CPU#2 is holding lock B and trying to acquire lock A,
> CPU#0 is holding lock D and trying to acquire lock B.
>
> Signed-off-by: Jim Lin <jilin@nvidia.com>

Impressive and good catch. Applied to fixes and tagged for stable!

Yours,
Linus Walleij
