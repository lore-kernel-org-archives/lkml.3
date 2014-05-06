Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaEFSIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:08:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61141 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEFSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:08:08 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-08-536925060226
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH] usb: gadget: s3c-hsotg: Mark
 s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() inline
Date: Tue, 06 May 2014 20:08:02 +0200
Message-id: <2511463.ZWBomfirPI@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1399397822-351-1-git-send-email-geert@linux-m68k.org>
References: <1399397822-351-1-git-send-email-geert@linux-m68k.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jAV021cxgg8XneCwO3q+3eHCrlcni
	2a29TBbNi9ezWVzeNYfNYtGyVmaLB4d3sjuwezx7OZnJ49DhDkaP/XPXsHv0bVnF6HH8xnYm
	j8+b5ALYorhsUlJzMstSi/TtErgydraeYCzYLFkx78gypgbGlSJdjJwcEgImEosmPGGFsMUk
	Ltxbz9bFyMUhJLCIUeLyviXMEE4Lk8Shn4uYQarYBKwkJravYuxi5OAQEdCVmPOTCaSGWeAe
	o0TfpkvsIHFhgRSJvg2qIOUsAqoSu19/ZwKxeQU0Jab2nwOzRQU8JXZsX8kGYnMKOEtsefKR
	BcQWEnCS+PqpE6peUOLH5HtgcWYBeYl9+6eyQtg6Evtbp7FNYBSYhaRsFpKyWUjKFjAyr2IU
	TS1ILihOSs811CtOzC0uzUvXS87P3cQIDvZnUjsYVzZYHGIU4GBU4uG1eJsRLMSaWFZcmXuI
	UYKDWUmEV0YuM1iINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMH
	p1QD4949sevL3Rvb3vJuvKayKMvuQV6Fqa3jbd9lUvfYfjKtuGUfOX/Sq+ZsuzcfdYWeufT0
	Tn/1aHnJTbMn7l/W3xGXDkq44rii0lZnRZuAffW76LAVRrV1Dt+NdCc6FzhEmjyUuZ7xt/fd
	Js+5k6dMUlaY+Vd5W96vV9MnLfhsFM9+ky9IUWxGnBJLcUaioRZzUXEiAEkmUmRyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, May 06, 2014 07:37:01 PM Geert Uytterhoeven wrote:
> If NO_DMA=y, depending on the gcc version:
> 
>     drivers/built-in.o: In function `s3c_hsotg_map_dma':
>     s3c-hsotg.c:(.text+0x375b2c): undefined reference to `usb_gadget_map_request'
>     drivers/built-in.o: In function `s3c_hsotg_unmap_dma':
>     s3c-hsotg.c:(.text+0x376a32): undefined reference to `usb_gadget_unmap_request'
>     make[3]: *** [vmlinux] Error 1
> 
> The obvious fix of making USB_S3C_HSOTG depend on HAS_DMA is a bit overkill,
> as DMA is never actually used. All (two) calls to s3c_hsotg_map_dma() and
> s3c_hsotg_unmap_dma() are protected by a call into the using_dma() checking
> function, which always returns false:
> 
>     static inline bool using_dma(struct s3c_hsotg *hsotg)
>     {
>             return false;   /* support is not complete */
>     }
> 
> Due to the constant return value, gcc optimizes away the calls to
> s3c_hsotg_map_dma() and s3c_hsotg_unmap_dma(). But some versions of gcc
> (e.g. 4.1.2) still emit the functions themselves, causing link errors.
> 
> Marking s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() inline fixes this.

How's about just removing the dead code instead?  It has never worked since
the driver introduction back in June 2009 (almost 5 years) and it is trivial
to bring it back from kernel git repository if needed in the future.

PS Could you please fix -next kernels as well (drivers/usb/gadget/s3c-hsotg.c
has moved to drivers/usb/dwc2/gadget.c recently)?

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This replaces "[PATCH/RFC] usb: gadget: CONFIG_USB_S3C_HSOTG should depend on
> HAS_DMA"
> 
>  drivers/usb/gadget/s3c-hsotg.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index 2a9cb674926a..2740042228a4 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -437,9 +437,9 @@ static inline int is_ep_periodic(struct s3c_hsotg_ep *hs_ep)
>   * This is the reverse of s3c_hsotg_map_dma(), called for the completion
>   * of a request to ensure the buffer is ready for access by the caller.
>   */
> -static void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
> -				struct s3c_hsotg_ep *hs_ep,
> -				struct s3c_hsotg_req *hs_req)
> +static inline void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
> +				       struct s3c_hsotg_ep *hs_ep,
> +				       struct s3c_hsotg_req *hs_req)
>  {
>  	struct usb_request *req = &hs_req->req;
>  
> @@ -861,9 +861,9 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
>   * DMA memory, then we map the memory and mark our request to allow us to
>   * cleanup on completion.
>   */
> -static int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
> -			     struct s3c_hsotg_ep *hs_ep,
> -			     struct usb_request *req)
> +static inline int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
> +				    struct s3c_hsotg_ep *hs_ep,
> +				    struct usb_request *req)
>  {
>  	struct s3c_hsotg_req *hs_req = our_req(req);
>  	int ret;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

