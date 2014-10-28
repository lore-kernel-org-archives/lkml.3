Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaJ1Pi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:38:29 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:39120 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaJ1Pi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <1413792260-4265-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
	<1413792260-4265-3-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 28 Oct 2014 16:38:27 +0100
Message-ID: <CACRpkdaPPcUkWrQ8G19igEdDGCXGUGd=utFzny54oRpZ=UNuYA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: add helpers for group based drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:04 AM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:

> Since the group based drivers have their dt properties documented in the
> generic pinctrl documentation, add generic helpers to avoid duplicating
> code and to be sure new drivers won't use specific bindings for a known
> purpose.
>
> This patch add two functions to help group based drivers map their
> nodes:
> - of_pinctrl_utils_read_function(): reads the function name of a
>   specified node, and gets the number of groups it should be
>   applied to.
> - of_pinctrl_for_each_function_group(): navigates through the groups of
>   a specified node, reading at each iteration the name of the current
>   group.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

GOOD IDEA!

Let's work from this and change a few drivers.

Some comments:

> +#ifdef CONFIG_OF
> +int of_pinctrl_utils_read_function(struct pinctrl_dev *pctldev,
> +               struct device_node *node, const char **function_name,
> +               int *ngroups)
> +{
> +       int ret;
> +
> +       ret = of_property_read_string(node, "function", function_name);
> +       if (ret) {
> +               dev_err(pctldev->dev, "missing function property in node %s\n",
> +                       node->name);
> +               return -EINVAL;
> +       }
> +
> +       *ngroups = of_property_count_strings(node, "groups");
> +       if (ngroups <= 0) {
> +               dev_err(pctldev->dev, "missing groups property in node %s\n",
> +                       node->name);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_pinctrl_utils_read_function);
> +#endif

Isn't it nasty to print dev_err() here if you maybe just want
to check if this node has a "function" element and proceed to
see if it's a pin config group in case it hasn't?

Or should we add of_pinctrl_utils_node_is_mux() and
of_pinctrl_utils_node_is_config() to check this?

> +#define of_pinctrl_for_each_function_group(node, prop, group_name)     \
> +               of_property_for_each_string(node, "groups", prop, group_name)

I *really* like this macro.

Yours,
Linus Walleij
