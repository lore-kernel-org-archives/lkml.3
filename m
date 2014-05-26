Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaEZM55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:57:57 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44378 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaEZM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <1401056560-16893-1-git-send-email-kroosec@gmail.com>
References: <1401056560-16893-1-git-send-email-kroosec@gmail.com>
Date: Mon, 26 May 2014 08:57:55 -0400
Message-ID: <CAECXXi5vDhnC4P9ixZy=9ZCkkLigv-kBvvD8O1kYyDGHEn5ZUg@mail.gmail.com>
Subject: Re: [PATCHv2] nbd: Zero from and len fields in NBD_CMD_DISCONNECT.
From: Paul Clements <paul.clements@us.sios.com>
To: Hani Benhabiles <kroosec@gmail.com>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 6:22 PM, Hani Benhabiles <kroosec@gmail.com> wrote:
> Len field is already set to zero, but not the from field which is sent as
> 0xfffffffffffffe00. This makes no sense, and may cause confuse server
> implementations doing sanity checks (qemu-nbd is an example.)
>
> Signed-off-by: Hani Benhabiles <hani@linux.com>
> ---
>
> Compared to v1:
> * Zero the request structure instead of conditionally zeroing specific fields.


Yeah, this one looks good. Sorry for the confusion on the structs...


>  drivers/block/nbd.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 3a70ea2..8e1df52 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -243,14 +243,11 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
>         struct nbd_request request;
>         unsigned long size = blk_rq_bytes(req);
>
> +       memset(&request, 0, sizeof(request));
>         request.magic = htonl(NBD_REQUEST_MAGIC);
>         request.type = htonl(nbd_cmd(req));
>
> -       if (nbd_cmd(req) == NBD_CMD_FLUSH) {
> -               /* Other values are reserved for FLUSH requests.  */
> -               request.from = 0;
> -               request.len = 0;
> -       } else {
> +       if (nbd_cmd(req) != NBD_CMD_FLUSH && nbd_cmd(req) != NBD_CMD_DISC) {
>                 request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
>                 request.len = htonl(size);
>         }
> --
> 1.8.3.2
>
