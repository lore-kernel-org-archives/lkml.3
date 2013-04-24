Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3DXGxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:53:53 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:34379 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab3DXGxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:53:51 -0400
Date: Wed, 24 Apr 2013 07:53:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 04/10] usb: musb: ux500: harden checks for platform data
Message-ID: <20130424065344.GB17416@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-5-git-send-email-lee.jones@linaro.org>
 <5176E927.908@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5176E927.908@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

> >  	struct musb_hdrc_platform_data *plat = dev->platform_data;
> >-	struct ux500_musb_board_data *data = plat->board_data;
> >+	struct ux500_musb_board_data *data;

> >-	param_array = data->dma_rx_param_array;
> >+	param_array = (data) ? data->dma_rx_param_array : NULL;
> 
>    Why enclose a simple variable in parens?

Because 'data' is a pointer, so it contains a memory location, but if
'plat->board_data' is NULL, then 'data' will be NULL (essentially
memory location 0x00000000).

So if we were to read-in to 'struct ux500_musb_board_data *data', by
index 'dma_rx_param_array', which I believe is '0' in this case:

struct ux500_musb_board_data {
        void    **dma_rx_param_array;
        void    **dma_tx_param_array;
        bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
};

... then we're saying take the data from this memory location:

param_array = *((0x00000000)->(0x0));

Which will cause a kernel Oops, due to the fact that address 0x0 isn't
allocated to us, so you get something like:

"Unable to handle kernel NULL pointer dereference at virtual address 00000000"

Hope that helps.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
