Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3GBHTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:19:43 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40717 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GBHTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:19:42 -0400
Date: Tue, 02 Jul 2013 02:19:38 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] nbd: correct disconnect behavior
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-kernel@vger.kernel.org,
        nbd-general@lists.sourceforge.net
In-Reply-To: <20130626162107.9237360f7646ec25f23cf5aa@linux-foundation.org>
	(from akpm@linux-foundation.org on Wed Jun 26 18:21:07 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1372749578.5019.8@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 06:21:07 PM, Andrew Morton wrote:
> On Wed, 19 Jun 2013 17:09:18 -0400 (EDT) Paul Clements  
> <paul.clements@steeleye.com> wrote:
> 
> > Currently, when a disconnect is requested by the user (via  
> NBD_DISCONNECT
> > ioctl) the return from NBD_DO_IT is undefined (it is usually one of
> > several error codes). This means that nbd-client does not know if a
> > manual disconnect was performed or whether a network error occurred.
> > Because of this, nbd-client's persist mode (which tries to  
> reconnect after
> > error, but not after manual disconnect) does not always work  
> correctly.
> >
> > This change fixes this by causing NBD_DO_IT to always return 0 if a  
> user
> > requests a disconnect. This means that nbd-client can correctly  
> either
> > persist the connection (if an error occurred) or disconnect (if the  
> user
> > requested it).
> 
> This sounds like something which users of 3.10 and earlier kernels
> might want, so I added the Cc:stable tag.  Please let me know if
> you disagree.
> 
> > --- a/drivers/block/nbd.c
> > +++ b/drivers/block/nbd.c
> > @@ -623,6 +623,8 @@ static int __nbd_ioctl(struct block_device  
> *bdev, struct nbd_device *nbd,
> >  		if (!nbd->sock)
> >  			return -EINVAL;
> >
> > +		nbd->disconnect = 1;
> > +
> >  		nbd_send_req(nbd, &sreq);
> >                  return 0;
> >  	}
> > @@ -654,6 +656,7 @@ static int __nbd_ioctl(struct block_device  
> *bdev, struct nbd_device *nbd,
> >  				nbd->sock = SOCKET_I(inode);
> >  				if (max_part > 0)
> >  					bdev->bd_invalidated = 1;
> > +				nbd->disconnect = 0; /* we're connected  
> now */
> >  				return 0;
> >  			} else {
> >  				fput(file);
> > @@ -742,6 +745,8 @@ static int __nbd_ioctl(struct block_device  
> *bdev, struct nbd_device *nbd,
> >  		set_capacity(nbd->disk, 0);
> >  		if (max_part > 0)
> >  			ioctl_by_bdev(bdev, BLKRRPART, 0);
> > +		if (nbd->disconnect) /* user requested, ignore socket  
> errors */
> > +			return 0;
> >  		return nbd->harderror;
> >  	}
> 
> hm, how does nbd work...  Hard to tell as nothing seems to be  
> documented
> anywhere :(

I wrote the busybox version, which might be a bit simpler:

   http://git.busybox.net/busybox/tree/networking/nbd-client.c

(Sorry about the #ifdefs, they're not mine.)

> afacit the code assumes that the user will run ioctl(NBD_DISCONNECT)  
> and
> then ioctl(NBD_DO_IT) and then ioctl(NBD_SET_SOCK), yes?  Does this
> change mean that if userspace calls the ioctls in an
> other-than-expected order, Weird Things will happen?  Would it be  
> safer
> to clear ->disconnect in NBD_DO_IT?
> > --- a/include/linux/nbd.h
> > +++ b/include/linux/nbd.h
> > @@ -41,6 +41,7 @@ struct nbd_device {
> >  	u64 bytesize;
> >  	pid_t pid; /* pid of nbd-client, if attached */
> >  	int xmit_timeout;
> > +	int disconnect; /* a disconnect has been requested by user */
> >  };
> 
> The cool kids are using bool lately ;)

No, they're not. The C++ guys and stuffy old ex-cobol types are, and  
think it helps. (Does any architecture anywhere _not_ use int for bool?)

Rob