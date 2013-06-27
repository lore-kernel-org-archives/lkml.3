Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3F0W2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:28:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3F0W2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:28:02 -0400
Date: Thu, 27 Jun 2013 15:28:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@us.sios.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Subject: Re: [PATCH] nbd: correct disconnect behavior
Message-Id: <20130627152800.494a6043607a62feb35e9739@linux-foundation.org>
In-Reply-To: <CAECXXi54NUvQLY1O0oWKqgDpdXWUCCcs_4jJkRJE29DctMYVUA@mail.gmail.com>
References: <20130619210918.DF616222D8@clements>
	<20130626162107.9237360f7646ec25f23cf5aa@linux-foundation.org>
	<CAECXXi54NUvQLY1O0oWKqgDpdXWUCCcs_4jJkRJE29DctMYVUA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 18:20:37 -0400 Paul Clements <paul.clements@us.sios.com> wrote:

> > --- a/drivers/block/nbd.c
> > > +++ b/drivers/block/nbd.c
> > > @@ -623,6 +623,8 @@ static int __nbd_ioctl(struct block_device *bdev,
> > struct nbd_device *nbd,
> > >               if (!nbd->sock)
> > >                       return -EINVAL;
> > >
> > > +             nbd->disconnect = 1;
> > > +
> > >               nbd_send_req(nbd, &sreq);
> > >                  return 0;
> > >       }
> > > @@ -654,6 +656,7 @@ static int __nbd_ioctl(struct block_device *bdev,
> > struct nbd_device *nbd,
> > >                               nbd->sock = SOCKET_I(inode);
> > >                               if (max_part > 0)
> > >                                       bdev->bd_invalidated = 1;
> > > +                             nbd->disconnect = 0; /* we're connected
> > now */
> > >                               return 0;
> > >                       } else {
> > >                               fput(file);
> > > @@ -742,6 +745,8 @@ static int __nbd_ioctl(struct block_device *bdev,
> > struct nbd_device *nbd,
> > >               set_capacity(nbd->disk, 0);
> > >               if (max_part > 0)
> > >                       ioctl_by_bdev(bdev, BLKRRPART, 0);
> > > +             if (nbd->disconnect) /* user requested, ignore socket
> > errors */
> > > +                     return 0;
> > >               return nbd->harderror;
> > >       }
> >
> > hm, how does nbd work...  Hard to tell as nothing seems to be documented
> > anywhere :(
> >
> 
> I think most people look at the nbd-client to see. :)
> 
> But I will work on some docs for the ioctls...
> 
> Briefly, though, it goes something like this:
> 
> nbd-client and nbd-server negotiate parameters, including the server
> telling the client how big the export is
> 
> Then the nbd-client does a series of ioctls to set up the device:
> 
> NBD_SET_SIZE - set the size of the device
> NBD_SET_SOCK - tell the kernel which socket to use
> NBD_DO_IT - this ioctl lasts for the life of the device and causes
> nbd-client to go into a receive loop, handling I/O replies from the
> nbd-server
> 
> NBD_DISCONNECT, meanwhile, can be called from a separate thread (usually
> "nbd-client -d" calls it). This requests a disconnect of the device.

OK, but.  "Would it be safer to clear ->disconnect in NBD_DO_IT?"

If not safer, would it be cleaner?

> > The cool kids are using bool lately ;)
> >
> 
> Hey, maybe I want to be able to compile with gcc 2.7.2 ? :)

Sob, I miss 2.7.2.  It was a good 50% faster than the new improved
models.  But I don't think this yearning makes us cool.
