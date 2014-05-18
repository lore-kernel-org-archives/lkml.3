Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbaERJLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 05:11:23 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:48520 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaERJLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 05:11:21 -0400
Date: Sun, 18 May 2014 10:11:13 +0100
From: Hani Benhabiles <kroosec@gmail.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nbd: Zero from and len fields in NBD_CMD_DISCONNECT.
Message-ID: <20140518091113.GA3770@Inspiron-3521>
References: <1400283807-27930-1-git-send-email-kroosec@gmail.com>
 <CAECXXi4_RJ-yk8Ct=sPPe-pq=shdU-4cKvRTT3yNvsoY42-8_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAECXXi4_RJ-yk8Ct=sPPe-pq=shdU-4cKvRTT3yNvsoY42-8_Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:56:33PM -0400, Paul Clements wrote:
> Agreed. But better yet, the request structure should just be zeroed when
> it's allocated.
> 

It is already initialized  in __nbd_ioctl() with the blk_rq_init() call which
sets the __sector value to -1 (which is 0xfffffffffffffe00 after the left shifts.)

This is the only (non-ugly / non-intrusive) way to do it afaict.

> --
> Paul
> 
> 
> On Fri, May 16, 2014 at 7:43 PM, Hani Benhabiles <kroosec@gmail.com> wrote:
> 
> > Len field is already set to zero, but not the from field which is sent as
> > 0xfffffffffffffe00. This makes no sense, and may cause confuse server
> > implementations doing sanity checks (qemu-nbd is an example.)
> >
> > Signed-off-by: Hani Benhabiles <hani@linux.com>
> > ---
> >  drivers/block/nbd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> > index 3a70ea2..657bdac 100644
> > --- a/drivers/block/nbd.c
> > +++ b/drivers/block/nbd.c
> > @@ -246,7 +246,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct
> > request *req)
> >         request.magic = htonl(NBD_REQUEST_MAGIC);
> >         request.type = htonl(nbd_cmd(req));
> >
> > -       if (nbd_cmd(req) == NBD_CMD_FLUSH) {
> > +       if (nbd_cmd(req) == NBD_CMD_FLUSH || nbd_cmd(req) == NBD_CMD_DISC)
> > {
> >                 /* Other values are reserved for FLUSH requests.  */
> >                 request.from = 0;
> >                 request.len = 0;
> > --
> > 1.8.3.2
> >
> >
