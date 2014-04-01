Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaDAEUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:20:47 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:33109 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaDAEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <7093981.6c4k98qyGh@amdc1032>
References: <7093981.6c4k98qyGh@amdc1032>
Date: Tue, 1 Apr 2014 09:50:42 +0530
X-Google-Sender-Auth: OsTRezQmblXPUmr9oD69nTTeMc8
Message-ID: <CAOh2x=n8PGuykczfpi0T1-WwVmakURyX+RuuOQiFVhpYPmrS6A@mail.gmail.com>
Subject: Re: [PATCH] pata_arasan_cf: fix ata_host_activate() failure handling
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tejun Heo <tj@kernel.org>, Shiraz Hashim <shiraz.hashim@st.com>,
        "...)" <linux-ide@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:19 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Add missing cf_exit() and clk_put() calls to ata_host_activate()
> failure path.
>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: Shiraz Hashim <shiraz.hashim@st.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/ata/pata_arasan_cf.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> Index: b/drivers/ata/pata_arasan_cf.c
> ===================================================================
> --- a/drivers/ata/pata_arasan_cf.c      2014-03-31 16:57:47.443727785 +0200
> +++ b/drivers/ata/pata_arasan_cf.c      2014-03-31 17:09:48.171715498 +0200
> @@ -898,9 +898,15 @@ static int arasan_cf_probe(struct platfo
>
>         cf_card_detect(acdev, 0);
>
> -       return ata_host_activate(host, acdev->irq, irq_handler, 0,
> -                       &arasan_cf_sht);
> +       ret = ata_host_activate(host, acdev->irq, irq_handler, 0,
> +                               &arasan_cf_sht);
> +       if (ret)
> +               goto exit_cf;
>
> +       return 0;

Probably this would be better:

if (!ret)
    return 0

and then no need of a goto..

> +
> +exit_cf:
> +       cf_exit(acdev);
>  free_clk:
>         clk_put(acdev->clk);
>         return ret;
>
