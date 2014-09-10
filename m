Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaIJHqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:46:36 -0400
Received: from mail-bl2on0133.outbound.protection.outlook.com ([65.55.169.133]:41435
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbaIJHqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:46:34 -0400
X-Greylist: delayed 1927 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 03:46:34 EDT
From: "chen.fang@freescale.com" <chen.fang@freescale.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
CC: Shawn Guo <Shawn.Guo@freescale.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
Thread-Topic: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
Thread-Index: AQHPzMEDUFYOXamYk0u51V8bS8XVeJv58E4AgAACowA=
Date: Wed, 10 Sep 2014 07:14:24 +0000
Message-ID: <566c6b8349ba4c2ead8f76ff04b52e65@BY2PR03MB556.namprd03.prod.outlook.com>
References: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
 <540FF70E.9050203@xs4all.nl>
In-Reply-To: <540FF70E.9050203@xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019019)(6009001)(189002)(199003)(24454002)(51704005)(13464003)(377454003)(479174003)(4396001)(108616004)(85306004)(2501002)(230783001)(79102001)(90102001)(99396002)(66066001)(50986999)(76176999)(575784001)(77982001)(76482001)(105586002)(106116001)(81342001)(81542001)(74662001)(46102001)(74502001)(107046002)(54356999)(2656002)(101416001)(20776003)(99286002)(19580395003)(86362001)(74316001)(92566001)(19580405001)(87936001)(83322001)(95666004)(2201001)(64706001)(85852003)(80022001)(31966008)(106356001)(21056001)(97736003)(76576001)(83072002)(33646002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB346;H:BY2PR03MB556.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not a theoretically issue, it is a real case that the mapping failed issue happens in 3.14.y kernel but not happens in previous 3.10.y kernel.
So I need your confirmation on it.

Thanks.

Best regards,
Fancy Fang

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Wednesday, September 10, 2014 3:01 PM
To: Fang Chen-B47543; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Marek Szyprowski
Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().

On 09/10/14 07:28, Fancy Fang wrote:
> When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core 
> will assign the corresponding offset to the 'boff' field of the 
> videobuf_buffer for each requested buffer sequentially. Later, user 
> may call mmap() to map one or all of the buffers with the 'offset'
> parameter which is equal to its 'boff' value. Obviously, the 'offset'
> value is only used to find the matched buffer instead of to be the 
> real offset from the buffer's physical start address as used by 
> vm_iomap_memory(). So, in some case that if the offset is not zero,
> vm_iomap_memory() will fail.

Is this just a fix for something that can fail theoretically, or do you actually have a case where this happens? I am very reluctant to make any changes to videobuf. Drivers should all migrate to vb2.

I have CC-ed Marek as well since he knows a lot more about this stuff than I do.

Regards,

	Hans

> 
> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
> ---
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c 
> b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index bf80f0f..8bd9889 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  	/* Try to remap memory */
>  	size = vma->vm_end - vma->vm_start;
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	retval = vm_iomap_memory(vma, mem->dma_handle, size);
> +	retval = remap_pfn_range(vma, vma->vm_start,
> +				 mem->dma_handle >> PAGE_SHIFT,
> +				 size, vma->vm_page_prot);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ",
>  			retval);
> 

