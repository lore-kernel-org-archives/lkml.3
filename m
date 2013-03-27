Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3C0Xt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:49:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54176 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3C0Xt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:49:57 -0400
Message-ID: <5153859A.8000801@wwwdotorg.org>
Date: Wed, 27 Mar 2013 17:49:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pinctrl: disable and free setting in select_state
 in case of error
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com> <1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 08:47 AM, Richard Genoud wrote:
> If enabling a pin fails in pinctrl_select_state_locked(), all the
> previous enabled pins have to be disabled to get back to the previous
> state.

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> @@ -910,13 +910,35 @@ static int pinctrl_select_state_locked(struct pinctrl *p,

>  		if (ret < 0) {
> -			/* FIXME: Difficult to return to prev state */
> -			return ret;
> +			goto unapply_new_state;
>  		}

Those { } should really be removed there, since there's only 1 line left
in the block.

> +unapply_new_state:
> +	pr_info("Error applying setting, reverse things back\n");

That should be dev_err() on the client device.

> +	/*
> +	 * If the loop stopped on the 1st entry, nothing has been enabled,
> +	 * so jump directly to the 2nd phase
> +	 */
> +	if (list_entry(&setting->node, typeof(*setting), node) ==
> +	    list_first_entry(&state->settings, typeof(*setting), node))
> +		goto reapply_old_state;

That's just an optimization, not a correctness issue isn't it?

I think it'd be simpler to just always run the list_for_each_entry()
below and let it bail out on the first loop if that's where the failure
happened. It's a lot simpler than understanding the conditional above,
which I didn't really try to do.

> +	list_for_each_entry(setting2, &state->settings, node) {
> +		if (&setting2->node == &setting->node)
> +			break;
> +		pinctrl_free_setting(true, setting2);

That's clearly wrong.

pinctrl_free_setting() is supposed to free any memory associated with
the setting; the storage that holds the representation of that setting.

It's only appropriate to do that in pinctrl_put(), when actually
destroying the whole struct pinctrl object. If pinctrl_select() fails,
we don't want to destroy/invalidate the struct pinctrl content, but
rather keep it around in case the driver uses it again even if the face
of previous errors.

In other words, what you should be doing inside this loop body is
exactly what the body of the first loop inside pinctrl_select_state()
does to "undo" any previously selected state, which is to call
pinmux_disable_setting() for each entry, or something similar to that.

> +	}
> +reapply_old_state:
> +	/* FIXME: re-enable old setting */
> +	return ret;
>  }

