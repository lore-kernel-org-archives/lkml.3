Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697Ab3E2BMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:12:09 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52443 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3E2BMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:12:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] media: davinci: vpif: Convert to devm_* api
Date: Wed, 29 May 2013 03:12:01 +0200
Message-ID: <25368927.Jiqsh9t82O@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51A218F7.7050804@cogentembedded.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com> <1492638.E2728sugZv@avalon> <51A218F7.7050804@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Sunday 26 May 2013 18:15:19 Sergei Shtylyov wrote:
> On 26-05-2013 4:49, Laurent Pinchart wrote:
> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> 
> >> Use devm_ioremap_resource instead of reques_mem_region()/ioremap().
> >> This ensures more consistent error values and simplifies error paths.
> >> 
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> ---
> >> 
> >>   drivers/media/platform/davinci/vpif.c |   27
> >>   ++++-----------------------
> >>   1 files changed, 4 insertions(+), 23 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/davinci/vpif.c
> >> b/drivers/media/platform/davinci/vpif.c index 761c825..164c1b7 100644
> >> --- a/drivers/media/platform/davinci/vpif.c
> >> +++ b/drivers/media/platform/davinci/vpif.c
> 
> [...]
> 
> >> @@ -421,23 +419,12 @@ EXPORT_SYMBOL(vpif_channel_getfid);
> >> 
> >>   static int vpif_probe(struct platform_device *pdev)
> >>   {
> >> 
> >> -	int status = 0;
> >> +	static struct resource	*res;
> >> 
> >>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> 
> >> -	if (!res)
> >> -		return -ENOENT;
> >> -
> >> -	res_len = resource_size(res);
> >> -
> >> -	res = request_mem_region(res->start, res_len, res->name);
> >> -	if (!res)
> >> -		return -EBUSY;
> >> -
> >> -	vpif_base = ioremap(res->start, res_len);
> >> -	if (!vpif_base) {
> >> -		status = -EBUSY;
> >> -		goto fail;
> >> -	}
> >> +	vpif_base = devm_ioremap_resource(&pdev->dev, res);
> >> +	if (IS_ERR(vpif_base))
> >> +		return PTR_ERR(vpif_base);
> > 
> > You're loosing the request_mem_region().
> 
> He's not losing anything, first look at how devm_ioremp_resource() is
> defined.

My bad. I'm not sure where I got that idea from. Thanks for pointing out the 
mistake.

> > You should use devm_request_and_ioremap()
> 
>      Already deprecated by now.
> 
> > function instead of devm_ioremap_resource(). With that change,
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

