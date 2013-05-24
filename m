Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab3EXIEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:04:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61830 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab3EXIEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <519A8A57.9060007@wwwdotorg.org>
References: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com>
	<519A8A57.9060007@wwwdotorg.org>
Date: Fri, 24 May 2013 10:04:44 +0200
Message-ID: <CACRpkdZieCmFnHCGUkv8EqcAtb3DA7dSZpimSdB4P81tZPJRoQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sink pinctrldev_list_mutex
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:40 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> This seems fine on the surface, but I do have one question:
>
> I think the pinctrl lock serves a couple of purposes:
>
> 1) Basic protection for accesses to the pinctrldev_list itself.
>
> This patch seems just fine w.r.t. this point.
>
> 2) Preventing pinctrl drivers from being unregistered (and their modules
> unloaded) when some operation is being performed on/to them.

Prevention of module unloading of pin controllers has never
been working properly, as there is no way to release the
pinctrl handles taken by different drivers.

I think that is why most pin controller drivers are bool rather
than tristate.

Currently only pinctrl-single is tristate. Part of me want to
change that to bool, I think it only will work when using the
single with hogs (that will be properly free:ed when unloading
the driver).

Tony: is this really working with non-hogs?

If we really want to support loading/unloading of pin controllers
I think the mutex is the least of the problems, and we should
probably create a separate lock for handling that instead of
relying on the list lock in that case.

While it's probably possible to *unload* the driver properly
after some hacking like this, we get to the problem of
re-probing the driver and re-associating all pinctrl handles
(at that point floating in space with no driver back-end)
with the driver again.

I feel this needs to be driven by someone who actually
need to load/unload pinctrl modules.

Yours,
Linus Walleij
