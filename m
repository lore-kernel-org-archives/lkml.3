Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaG0SVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:21:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaG0SVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:21:01 -0400
Date: Sun, 27 Jul 2014 11:21:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Guillaume =?iso-8859-1?Q?CL=C9MENT?= <gclement@baobob.org>,
        devel@driverdev.osuosl.org, Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: fix direct dereferencing of user pointer
Message-ID: <20140727182101.GA11593@kroah.com>
References: <20140725123301.GZ13737@mwanda>
 <1406292443-11734-1-git-send-email-gclement@baobob.org>
 <53D2E3BD.1000208@gmail.com>
 <20140726082429.GA3121@pleinair.baobob.org>
 <20140726091843.GA5956@pleinair.baobob.org>
 <53D386A9.9040001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D386A9.9040001@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 11:44:57AM +0100, Malcolm Priestley wrote:
> On 26/07/14 10:18, Guillaume CLÉMENT wrote:
> >On Sat, Jul 26, 2014 at 10:24:30AM +0200, Guillaume CLÉMENT wrote:
> >>Hi Malcolm,
> >>
> >>On Sat, Jul 26, 2014 at 12:09:49AM +0100, Malcolm Priestley wrote:
> >>>Hi Guillaume
> >>>
> >>>On 25/07/14 13:47, Guillaume Clement wrote:
> >>>>Sparse reported that the data from tagSCmdRequest is given by
> >>>>userspace, so it should be tagged as such.
> >>>extra is not in user space
> >>>
> >>
> >>All right.
> >>
> >>This is still confusing to me because, taking the SIOCSIWGENIE ioctl as
> >>an example, in device_main.c, we have this code:
> >>
> >>rc = iwctl_siwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
> >>
> >>Here the extra parameter is the last one, wrq->u.data.pointer.
> >>
> >>I was led to believe that wrq->u.data.pointer is in userspace (this was
> >>reported by sparse actually) because the pointer field in data is
> >>actually defined as __user.
> >>
> >>
> >By the way, the original code (before my patch) reads:
> >
> >	if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
> >		ret = -EINVAL;
> >		goto out;
> >	}
> >	if (wrq->length > MAX_WPA_IE_LEN) {
> >		ret = -ENOMEM;
> >		goto out;
> >	}
> >	memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
> >	if (copy_from_user(pMgmt->abyWPAIE, extra, wrq->length)) {
> >		ret = -EFAULT;
> >		goto out;
> >	}
> >
> >Note extra[1] and later copy_from_user(x, extra, y).
> >
> >If extra is not in userspace, we should not call copy_from_user, and if
> >it is, we should not dereference it. There is definitely something fishy
> >here.
> >
> 
> I got it wrong when the iw_handler is not present a standard ioctl is called
> extra is in userspace.
> 
> Sorry for the noise.

So this patch is acceptable?

confused,

greg k-h
