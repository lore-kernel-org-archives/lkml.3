Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3JERq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:46:56 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38858 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3JERqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:46:54 -0400
MIME-Version: 1.0
In-Reply-To: <1380826284-18381-1-git-send-email-mkl@pengutronix.de>
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de>
Date: Sat, 5 Oct 2013 14:46:52 -0300
Message-ID: <CAOMZO5BekS_BvJzrt8vM1=7LjsiO=3hKL=mMfTjxkO3aZ4qwRQ@mail.gmail.com>
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
From: Fabio Estevam <festevam@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Thu, Oct 3, 2013 at 3:51 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:

> For example:
>
> The imx28.dtsi gives this compatible string for its CAN core:
>
>>       compatible = "fsl,imx28-flexcan", "fsl,p1010-flexcan";
>
> The flexcan driver defines:
>
>> static const struct of_device_id flexcan_of_match[] = {
>>       { .compatible = "fsl,p1010-flexcan", .data = &fsl_p1010_devtype_data, },
>>       { .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
>>       { .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
>>       { /* sentinel */ },
>> };
>
> The "p1010" was the first Freescale SoC with the flexcan core. But this SoC has
> a bug, so a workaround has to be enabled in the driver. The mx28 has this bug
> fixed, so we don't need this quite costly workaround.

What about defining in imx28.dtsi:
compatible = "fsl,imx28-flexcan".

and the in the flexcan driver we could do the same as in the fec_main driver:

static struct platform_device_id fec_devtype[] = {
    {
        /* keep it for coldfire */
        .name = DRIVER_NAME,
        .driver_data = 0,
    }, {
        .name = "imx25-fec",
        .driver_data = FEC_QUIRK_USE_GASKET,
    }, {
        .name = "imx27-fec",
        .driver_data = 0,
    }, {
        .name = "imx28-fec",
        .driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME,
    }, {
        .name = "imx6q-fec",
        .driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
                FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
                FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358,
    }, {
        .name = "mvf600-fec",
        .driver_data = FEC_QUIRK_ENET_MAC,
    }, {
        /* sentinel */
    }
};

So that we know which SoC needs to have the workaround applied or not.
