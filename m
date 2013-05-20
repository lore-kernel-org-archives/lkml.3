Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab3ETUlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:41:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36148 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3ETUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:40:59 -0400
Message-ID: <519A8A57.9060007@wwwdotorg.org>
Date: Mon, 20 May 2013 14:40:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: sink pinctrldev_list_mutex
References: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 01:48 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The pinctrldev_list_mutex is sinked into the functions that
> actually traverse the list and lock it there. The code makes
> much more sense in this way. All the callers are in
> non-performance critical paths and the code is way more
> readable this way.
> 
> Also refactor the function get_pinctrl_dev_from_devname() to
> follow the design pattern of get_pinctrl_dev_from_of_node()
> which is slightly simpler.

This seems fine on the surface, but I do have one question:

I think the pinctrl lock serves a couple of purposes:

1) Basic protection for accesses to the pinctrldev_list itself.

This patch seems just fine w.r.t. this point.

2) Preventing pinctrl drivers from being unregistered (and their modules
unloaded) when some operation is being performed on/to them.

So, that means some code is written as follows:

lock
find pinctrl device
perform operation on pinctrl device
unlock
// only now could the found pinctrl device be unregistered

However, I think this patch changes that to the following for some
operations:

lock
find pinctrl device
unlock
// now the found pinctrl device can be unregistered
perform operation on pinctrl device

Is this true here, or am I off-base?

If this isn't an issue, then the patch is fine by me. But, how is the
unregistration prevented while the device is being operated on then?
