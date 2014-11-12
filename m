Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaKLTIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:08:47 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:63131 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaKLTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:08:44 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.100.67]
In-Reply-To: <1410553499-55951-5-git-send-email-s-anna@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-5-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 12 Nov 2014 21:08:22 +0200
Message-ID: <CAK=WgbamdqAufjC4Xb5moERRBSB-cO6c1RPTE=f+dp75F+Eh7A@mail.gmail.com>
Subject: Re: [PATCHv6 4/5] hwspinlock/core: add common OF helpers
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Fri, Sep 12, 2014 at 11:24 PM, Suman Anna <s-anna@ti.com> wrote:
> +int of_hwspin_lock_get_id(struct device_node *np, int index)
> +{
> +       struct hwspinlock_device *bank;
> +       struct of_phandle_args args;
> +       int id;
> +       int ret;
> +
> +       ret = of_parse_phandle_with_args(np, "hwlocks", "#hwlock-cells", index,
> +                                        &args);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&hwspinlock_tree_lock);
> +       list_for_each_entry(bank, &hwspinlock_devices, list)
> +               if (bank->dev->of_node == args.np)
> +                       break;
> +       mutex_unlock(&hwspinlock_tree_lock);
> +       if (&bank->list == &hwspinlock_devices) {
> +               ret = -EPROBE_DEFER;
> +               goto out;
> +       }

Is this the validation you mentioned which requires the existence of
"hwspinlock/core: maintain a list of registered hwspinlock banks" ?

I'm not convinced this is needed for several reasons:
- the user isn't using the lock yet at this point, and may only need
the id in order to communicate it to a remote processor
- if the user will try to use the lock prematurely,
hwspin_lock_request_specific should stop her
- moreover, hwspin_lock_request_specific must be the one who validates
the id, since in heterogeneous systems the user may get the id from a
remote processor and not via of_hwspin_lock_get_id

 "hwspinlock/core: maintain a list of registered hwspinlock banks"
adds complexity which must be very strongly justified.

If we're not sure there is a strong justification for it, we better
not merge it.

> +EXPORT_SYMBOL_GPL(of_hwspin_lock_get_base_id);
...
> +EXPORT_SYMBOL_GPL(of_hwspin_lock_get_num_locks);

Do we really must expose these two helpers globally?

Can we instead make these "static inline" methods and embed them in
hwspinlock_internal.h ?

Thanks,
Ohad.
