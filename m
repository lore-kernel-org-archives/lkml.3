Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaJBMnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:43:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:42221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaJBMm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:42:57 -0400
Message-ID: <1412253722.28143.17.camel@pasglop>
Subject: Re: [PATCH v2 15/17] cxl: Userspace header file.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Michael Neuling <mikey@neuling.org>,
        greg <greg@kroah.com>, arnd <arnd@arndb.de>, anton <anton@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 22:42:02 +1000
In-Reply-To: <1412243942-sup-5336@delenn.ozlabs.ibm.com>
References: <20141002060237.E9963140180@ozlabs.org>
	 <1412243942-sup-5336@delenn.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 20:28 +1000, Ian Munsie wrote:
> Hey Michael,
> 
> Excerpts from Michael Ellerman's message of 2014-10-02 16:02:37 +1000:
> > > +/* ioctls */
> > > +struct cxl_ioctl_start_work {
> > > +    __u64 wed;
> > > +    __u64 amr;
> > > +    __u64 reserved1;
> > > +    __u32 reserved2;
> > > +    __s16 num_interrupts; /* -1 = use value from afu descriptor */
> > > +    __u16 process_element; /* returned from kernel */
> > > +    __u64 reserved3;
> > > +    __u64 reserved4;
> > > +    __u64 reserved5;
> > > +    __u64 reserved6;
> > 
> > Why so many reserved fields?
> 
> The first two are reserved for the context save area (reserved1) and
> size (reserved2) of the "shared" (AKA time sliced) virtualisation model,
> which we don't yet support. That only leaves us with four reserved
> fields for anything that we haven't thought of or that the hardware team
> hasn't come up with yet ;-)
> 
> > What mechanism is there that will allow you to ever unreserve them?
> >
> > ie. how does a new userspace detect that the kernel it's running on supports
> > new fields?
> 
> The ioctl will return -EINVAL if any of them are set to non-zero values,
> so userspace can easily tell if it's running on an old kernel.

Not good enough in my experience. Throw in a flags field I'd say..

> > Or conversely how does a new kernel detect that userspace has passed it a
> > meaningful value in one of the previously reserved fields?
> 
> They would have to be non-zero (certainly true of the context save
> area's size), or one could turn into a flags field or api version.

If you go that way you need to negociate as well latest compatible
etc...

> > > +#define CXL_MAGIC 0xCA
> > > +#define CXL_IOCTL_START_WORK      _IOWR(CXL_MAGIC, 0x00, struct cxl_ioctl_start_work)
> > 
> > What happened to 0x1 ?
> 
> That was used to dynamically program the FPGA with a new AFU image, but
> we don't have anything to test it on yet and I'm not convinced that the
> procedure won't change by the time we do, so we pulled the code.
> 
> We can repack the ioctl numbers easily enough... Will do :)
> 
> > > +enum cxl_event_type {
> > > +    CXL_EVENT_READ_FAIL     = -1,
> > 
> > I don't see this used?
> 
> That was used in the userspace library to mark it's buffer as bad if the
> read() call failed for whatever reason... but you're right - it isn't
> used by the kernel and doesn't belong in this header. Will remove.
> 
> > > +struct cxl_event_header {
> > > +    __u32 type;
> > > +    __u16 size;
> > > +    __u16 process_element;
> > > +    __u64 reserved1;
> > > +    __u64 reserved2;
> > > +    __u64 reserved3;
> > > +};
> > 
> > Again lots of reserved fields?
> 
> Figured it was better to have a bit more than we expect we might need
> just in case... We can reduce this if you feel it is excessive?
> 
> In an earlier version of the code the kernel would fill out the header
> and not clear an event if a buffer was passed in that was too small, so
> userspace could realloc a larger buffer and try again. This made the API
> a bit more complex and our internal users weren't too keen on it, so we
> decided to use a fixed-size buffer and make it larger than we strictly
> needed so we have plenty of room for further expansion.
> 
> > Rather than having the header included in every event, would it be clearer if
> > the cxl_event was:
> > 
> > struct cxl_event {
> >     struct cxl_event_header header;
> >     union {
> >         struct cxl_event_afu_interrupt irq;
> >         struct cxl_event_data_storage fault;
> >         struct cxl_event_afu_error afu_err;
> >     };
> > };
> 
> Sounds like a good idea to me :)
> 
> Cheers,
> -Ian


