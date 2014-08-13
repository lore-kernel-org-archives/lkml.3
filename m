Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaHMNlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:41:13 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33730 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMNlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:41:11 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.17.117]
In-Reply-To: <53EA3E78.6000304@ti.com>
References: <1404420815-42108-1-git-send-email-s-anna@ti.com>
 <CAK=WgbaRJNVXqbM+MyY+UtUYYCnR2t3CP5UdTXSpLJy=MTJKJQ@mail.gmail.com> <53EA3E78.6000304@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 13 Aug 2014 16:40:50 +0300
Message-ID: <CAK=WgbYLUcnK1p0qUkfONavk+W1eXg5fcaTNcU4W3ova6wySuQ@mail.gmail.com>
Subject: Re: [PATCH] rpmsg: compute number of buffers to allocate from vrings
To: Suman Anna <s-anna@ti.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Tue, Aug 12, 2014 at 7:19 PM, Suman Anna <s-anna@ti.com> wrote:
> Yes, I was playing around with using less buffers in the remoteproc
> resource table for the vrings. The remoteproc virtio code creates the
> vrings using the number of buffers based on .num field value of struct
> fw_rsc_vdev_vring in the resource table. The virtio rpmsg probe code
> though tries to set up the receive buffers for the same virtqueue based
> on the current hard-coded value of 512 buffers and virtqueue_add_inbuf
> would fail as the virtqueue is created with less number of buffers and
> throws a WARN_ON.

Gotcha - thanks for the details.

Limiting the number of buffers in case the vrings are too small makes
sense, but let's use RPMSG_NUM_BUFS as an upper bound, so wacky
resource tables won't trigger unreasonable memory waste.

Something in the lines of:

vrp->num_bufs = min(PMSG_NUM_BUFS, virtqueue_get_vring_size(vrp->rvq) * 2);

Should probably do the trick.

Does this satisfy your requirement?

Thanks,
Ohad.
