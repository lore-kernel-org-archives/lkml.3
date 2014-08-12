Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaHLQTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:19:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbaHLQTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:19:10 -0400
Message-ID: <53EA3E78.6000304@ti.com>
Date: Tue, 12 Aug 2014 11:19:04 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] rpmsg: compute number of buffers to allocate from vrings
References: <1404420815-42108-1-git-send-email-s-anna@ti.com> <CAK=WgbaRJNVXqbM+MyY+UtUYYCnR2t3CP5UdTXSpLJy=MTJKJQ@mail.gmail.com>
In-Reply-To: <CAK=WgbaRJNVXqbM+MyY+UtUYYCnR2t3CP5UdTXSpLJy=MTJKJQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 08/12/2014 10:30 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, Jul 3, 2014 at 11:53 PM, Suman Anna <s-anna@ti.com> wrote:
>> The buffers to be used for communication are allocated during
>> the rpmsg virtio driver's probe, and the number of buffers is
>> currently hard-coded to 512. Remove this hard-coded value, as
>> this can vary from one platform to another or between different
>> remote processors. Instead, rely on the number of buffers the
>> virtqueue vring is setup with in the first place.
> 
> Is there a specific problem you bumped into which you are fixing with
> this approach? Can you please describe it?

Yes, I was playing around with using less buffers in the remoteproc
resource table for the vrings. The remoteproc virtio code creates the
vrings using the number of buffers based on .num field value of struct
fw_rsc_vdev_vring in the resource table. The virtio rpmsg probe code
though tries to set up the receive buffers for the same virtqueue based
on the current hard-coded value of 512 buffers and virtqueue_add_inbuf
would fail as the virtqueue is created with less number of buffers and
throws a WARN_ON.


   /* set up the receive buffers */
   for (i = 0; i < RPMSG_NUM_BUFS / 2; i++) {
         struct scatterlist sg;
         void *cpu_addr = vrp->rbufs + i * RPMSG_BUF_SIZE;

         sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);

         err = virtqueue_add_inbuf(vrp->rvq, &sg, 1, cpu_addr,
                                                           GFP_KERNEL);
         WARN_ON(err); /* sanity check; this can't really happen */
   }

> I'm concerned that coupling the vring size with coherent memory
> allocated by rpmsg may not be safe. It'd also be an implicit side
> effect that may surprise users, so let's consider our alternatives.

If anything, we are allocating more buffers if the configuration uses
smaller number of buffers. This can be autoconfigured properly using the
virtqueue_get_vring_size from the virtqueue it wants to add the buffers to.

regards
Suman

