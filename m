Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaBCVMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:12:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59633 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaBCVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:12:53 -0500
Message-ID: <52F00653.40802@wwwdotorg.org>
Date: Mon, 03 Feb 2014 14:12:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: protect pinctrl_list add
References: <20140203113900.GD1725@redhat.com>
In-Reply-To: <20140203113900.GD1725@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 04:39 AM, Stanislaw Gruszka wrote:
> We have few fedora bug reports about list corruption on pinctrl,
> for example:
> https://bugzilla.redhat.com/show_bug.cgi?id=1051918
> 
> Most likely corruption happen due lack of protection of pinctrl_list
> when adding new nodes to it. Patch corrects that.
> 
> Fixes: 57b676f9c1b ("pinctrl: fix and simplify locking")

After that patch ...

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> @@ -851,7 +851,9 @@ static struct pinctrl *create_pinctrl(struct device *dev)
>  	kref_init(&p->users);
>  
>  	/* Add the pinctrl handle to the global list */
> +	mutex_lock(&pinctrl_list_mutex);

That variable doesn't exist; it got replaced with the "global"
pinctrl_mutex. Also, since that patch, IIRC some other changes have been
made to the locking structure, so this patch might need adjustments not
to conflict with those changes?

>  	list_add_tail(&p->node, &pinctrl_list);
> +	mutex_unlock(&pinctrl_list_mutex);

