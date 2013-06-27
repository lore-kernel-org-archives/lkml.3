Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3F0WYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:24:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48104 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3F0WYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:24:14 -0400
MIME-Version: 1.0
Date: Thu, 27 Jun 2013 18:24:13 -0400
Message-ID: <CAECXXi7evzCqEzpVpT3QAKeEJ=cGO-N4UvBGQjL=S1wRD+X-2A@mail.gmail.com>
Subject: Re: [PATCH] nbd: correct disconnect behavior
From: Paul Clements <paul.clements@us.sios.com>
To: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 7:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 19 Jun 2013 17:09:18 -0400 (EDT) Paul Clements <paul.clements@steeleye.com> wrote:
>
> This sounds like something which users of 3.10 and earlier kernels
> might want, so I added the Cc:stable tag.  Please let me know if
> you disagree.


That is a good idea. It would be useful in stable.


> > --- a/drivers/block/nbd.c
> > +++ b/drivers/block/nbd.c
> > @@ -623,6 +623,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
> >               if (!nbd->sock)
> >                       return -EINVAL;
> >
> > +             nbd->disconnect = 1;
> > +
> >               nbd_send_req(nbd, &sreq);
> >                  return 0;
> >       }
> > @@ -654,6 +656,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
> >                               nbd->sock = SOCKET_I(inode);
> >                               if (max_part > 0)
> >                                       bdev->bd_invalidated = 1;
> > +                             nbd->disconnect = 0; /* we're connected now */
> >                               return 0;
> >                       } else {
> >                               fput(file);
> > @@ -742,6 +745,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
> >               set_capacity(nbd->disk, 0);
> >               if (max_part > 0)
> >                       ioctl_by_bdev(bdev, BLKRRPART, 0);
> > +             if (nbd->disconnect) /* user requested, ignore socket errors */
> > +                     return 0;
> >               return nbd->harderror;
> >       }
>
> hm, how does nbd work...  Hard to tell as nothing seems to be documented
> anywhere :(


I think most people look at the nbd-client to see. :)

But I will work on some docs for the ioctls...

Briefly, though, it goes something like this:

nbd-client and nbd-server negotiate parameters, including the server
telling the client how big the export is

Then the nbd-client does a series of ioctls to set up the device:

NBD_SET_SIZE - set the size of the device
NBD_SET_SOCK - tell the kernel which socket to use
NBD_DO_IT - this ioctl lasts for the life of the device and causes
nbd-client to go into a receive loop, handling I/O replies from the
nbd-server

NBD_DISCONNECT, meanwhile, can be called from a separate thread
(usually "nbd-client -d" calls it). This requests a disconnect of the
device.


>
> > --- a/include/linux/nbd.h
> > +++ b/include/linux/nbd.h
> > @@ -41,6 +41,7 @@ struct nbd_device {
> >       u64 bytesize;
> >       pid_t pid; /* pid of nbd-client, if attached */
> >       int xmit_timeout;
> > +     int disconnect; /* a disconnect has been requested by user */
> >  };
>
> The cool kids are using bool lately ;)


Hey, maybe I want to be able to compile with gcc 2.7.2 ? :)
