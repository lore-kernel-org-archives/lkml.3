Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab3C1KJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:09:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45961 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3C1KJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:09:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] davinci: vpif: add pm_runtime support
Date: Thu, 28 Mar 2013 11:10:45 +0100
Message-ID: <3365178.uRYh2rr3nD@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CA+V-a8uMaNKBXF-tJRtOMaYpjA1PsMA9qhG6MgwORTU8YRvDbQ@mail.gmail.com>
References: <1364460632-21697-1-git-send-email-prabhakar.csengg@gmail.com> <1650338.UonQ4LqB70@avalon> <CA+V-a8uMaNKBXF-tJRtOMaYpjA1PsMA9qhG6MgwORTU8YRvDbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Thursday 28 March 2013 15:36:11 Prabhakar Lad wrote:
> On Thu, Mar 28, 2013 at 2:39 PM, Laurent Pinchart wrote:
> > On Thursday 28 March 2013 14:20:32 Prabhakar lad wrote:
> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> 
> >> Add pm_runtime support to the TI Davinci VPIF driver.
> >> Along side this patch replaces clk_get() with devm_clk_get()
> >> to simplify the error handling.
> >> 
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> ---
> >> 
> >>  drivers/media/platform/davinci/vpif.c |   21 +++++++++++----------
> >>  1 files changed, 11 insertions(+), 10 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/davinci/vpif.c
> >> b/drivers/media/platform/davinci/vpif.c index 28638a8..7d14625 100644
> >> --- a/drivers/media/platform/davinci/vpif.c
> >> +++ b/drivers/media/platform/davinci/vpif.c

[snip]

> >> @@ -439,12 +440,17 @@ static int vpif_probe(struct platform_device *pdev)
> >>               goto fail;
> >>       }
> >> 
> >> -     vpif_clk = clk_get(&pdev->dev, "vpif");
> >> +     vpif_clk = devm_clk_get(&pdev->dev, "vpif");
> >>       if (IS_ERR(vpif_clk)) {
> >>               status = PTR_ERR(vpif_clk);
> >>               goto clk_fail;
> >>       }
> >> 
> >> -     clk_prepare_enable(vpif_clk);
> >> +     clk_put(vpif_clk);
> > 
> > Why do you need to call clk_put() here ?
> 
> The above check is to see if the clock is provided, once done
> we free it using clk_put().

In that case you shouldn't use devm_clk_get(), otherwise clk_put() will be 
called again automatically at remove() time.

> >> +     pm_runtime_enable(&pdev->dev);
> >> +     pm_runtime_resume(&pdev->dev);
> >> +
> >> +     pm_runtime_get(&pdev->dev);
> > 
> > Does runtime PM automatically handle your clock ? If so can't you remove
> > clock handling from the driver completely ?
> 
> Yes  pm runtime take care of enabling/disabling the clocks
> so that we don't have to do it in drivers. I believe clock
> handling is removed with this patch, with just  devm_clk_get() remaining ;)

When is the clk_get() call expected to fail ? If the clock is provided by the 
SoC and always available, can't the check be removed completely ?

-- 
Regards,

Laurent Pinchart

