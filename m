Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3EJQfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:35:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36159 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3EJQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:35:35 -0400
Message-ID: <518D21D4.6000609@wwwdotorg.org>
Date: Fri, 10 May 2013 10:35:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, linux-tegra@vger.kernel.org
Subject: Re: [RFC 04/42] drivers/dma: don't check resource with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-5-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368173847-5661-5-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 02:16 AM, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c

>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "No mem resource for DMA\n");
> -		return -EINVAL;
> -	}
> -
>  	tdma->base_addr = devm_ioremap_resource(&pdev->dev, res);

One issue here is that it's not obvious just from reading the code
that's left behind that the "missing" error-checking of the
platform_get_resource() return value is OK because
devm_ioremap_resource() will check it "for us". Everyone now has to
mentally maintain a list of exceptions where it's OK not to error-check.
A similar situation exists for e.g. kzalloc already spewing an error
when allocations fail, and so drivers don't need to print a diagnostic
in that case, but it's helpful if they do in most other cases, but
that's another issue.

Would it be better to introduce a new devm_ioremap_pdev_resource(pdev,
index) that replaced both those two API calls with a single one. That
way, only the author/reader of the new devm_ioremap_pdev_resource()
would have to remember that caveat, and a single comment could be added
so people unfamiliar with the code remember, without duplicating the
comment in every driver.
