Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaGZJTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 05:19:14 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49836 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGZJTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 05:19:12 -0400
X-Originating-IP: 78.210.48.61
Date: Sat, 26 Jul 2014 11:18:45 +0200
From: Guillaume =?iso-8859-1?Q?CL=C9MENT?= <gclement@baobob.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: vt6655: fix direct dereferencing of user pointer
Message-ID: <20140726091843.GA5956@pleinair.baobob.org>
References: <20140725123301.GZ13737@mwanda>
 <1406292443-11734-1-git-send-email-gclement@baobob.org>
 <53D2E3BD.1000208@gmail.com>
 <20140726082429.GA3121@pleinair.baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140726082429.GA3121@pleinair.baobob.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 10:24:30AM +0200, Guillaume CLÉMENT wrote:
> Hi Malcolm,
>
> On Sat, Jul 26, 2014 at 12:09:49AM +0100, Malcolm Priestley wrote:
> > Hi Guillaume
> >
> > On 25/07/14 13:47, Guillaume Clement wrote:
> > > Sparse reported that the data from tagSCmdRequest is given by
> > > userspace, so it should be tagged as such.
> > extra is not in user space
> >
>
> All right.
>
> This is still confusing to me because, taking the SIOCSIWGENIE ioctl as
> an example, in device_main.c, we have this code:
>
> rc = iwctl_siwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
>
> Here the extra parameter is the last one, wrq->u.data.pointer.
>
> I was led to believe that wrq->u.data.pointer is in userspace (this was
> reported by sparse actually) because the pointer field in data is
> actually defined as __user.
>
>
By the way, the original code (before my patch) reads:

	if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
		ret = -EINVAL;
		goto out;
	}
	if (wrq->length > MAX_WPA_IE_LEN) {
		ret = -ENOMEM;
		goto out;
	}
	memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
	if (copy_from_user(pMgmt->abyWPAIE, extra, wrq->length)) {
		ret = -EFAULT;
		goto out;
	}

Note extra[1] and later copy_from_user(x, extra, y).

If extra is not in userspace, we should not call copy_from_user, and if
it is, we should not dereference it. There is definitely something fishy
here.
