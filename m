Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3BKIQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:16:25 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:56223 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934Ab3BKIQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:16:23 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: "sjur@brendeland.net" <sjur@brendeland.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>,
        Vikram ARV <vikram.arv@stericsson.com>, Ido Yariv <ido@wizery.com>
Date: Mon, 11 Feb 2013 09:15:55 +0100
Subject: RE: [PATCH vringh 2/2] caif_virtio: Introduce caif over virtio
Thread-Topic: [PATCH vringh 2/2] caif_virtio: Introduce caif over virtio
Thread-Index: Ac4IJSEdhK89pBw1TqWjjqXCKhHh/gAB7BxA
Message-ID: <81C3A93C17462B4BBD7E272753C105792458EDD161@EXDCVYMBSTM005.EQ1STM.local>
References: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360494273-27889-3-git-send-email-sjur.brandeland@stericsson.com>
 <87vc9zfic8.fsf@rustcorp.com.au>
In-Reply-To: <87vc9zfic8.fsf@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

> From: Rusty Russell [mailto:rusty@rustcorp.com.au]
> sjur.brandeland@stericsson.com writes:
> > From: Vikram ARV <vikram.arv@stericsson.com>
> >
> > Add the the Virtio shared memory driver for STE Modems.
> > caif_virtio is implemented utilizing the virtio framework
> > for data transport and is managed with the remoteproc frameworks.
> >
> > The Virtio queue is used for transmitting data to the modem, and
> > the new vringh implementation is receiving data over the vring.
> 
> OK, let's refine vringh now we can see another user:
> 
> > + * @head: Last descriptor ID we received from vringh_getdesc_kern.
> > + *	  We use this to put descriptor back on the used ring. USHRT_MAX is
> > + *	  used to indicate invalid head-id.
> 
> > + */
> > +struct cfv_napi_context {
> > +	struct vringh_kiov riov;
> > +	unsigned short head;
> > +};
> 
> Usually we use an int, and -1.  I imagine it'll take no more space,
> due to padding.

I'm passing a pointer to "head" to vringh_getdesc_kern() directly, are you
suggesting to change the head argument in  vringh_getdesc_kern()
to a int pointer as well then?

> > +static inline void ctx_prep_iov(struct cfv_napi_context *ctx)
> > +{
> > +	if (ctx->riov.allocated) {
> > +		kfree(ctx->riov.iov);
> > +		ctx->riov.iov = NULL;
> > +		ctx->riov.allocated = false;
> > +	}
> > +	ctx->riov.iov = NULL;
> > +	ctx->riov.i = 0;
> > +	ctx->riov.max = 0;
> > +}
> 
> Hmm, we should probably make sure you don't have to do this: that if
> allocated once, you can simply reuse it by setting i = 0.

Yes, I had problems getting the alloc/free of iov right. This is
perhaps the least intuitively part of the API. I maybe it's just me, but
I think some more helper functions and support from vringh in this
area would be great.

> 
> (This requires some care in the error handling paths, so we don't
> free it from under you)...
> 
> And you probably want to free this up in cfv_remove() instead?

OK, I'll look into this when you have a some more code ready...

> 
> I'll create and test a patch now.
> 
> > +		if (riov->i == riov->max) {
> > +			if (cfv->ctx.head != USHRT_MAX) {
> > +				vringh_complete_kern(cfv->vr_rx,
> > +						     cfv->ctx.head,
> > +						     0);
> > +				cfv->ctx.head = USHRT_MAX;
> > +			}
> > +
> > +			ctx_prep_iov(&cfv->ctx);
> > +			err = vringh_getdesc_kern(
> > +				cfv->vr_rx,
> > +				riov,
> > +				&wiov,
> > +				&cfv->ctx.head,
> > +				GFP_ATOMIC);
> > +
> > +			if (err <= 0)
> > +				goto out;
> > +
> > +			if (wiov.max != 0) {
> > +				/* CAIF does not use write descriptors */
> > +				err = -EPROTO;
> > +				goto out;
> > +			}
> 
> This is probably a common case, so we should generate this error inside
> vringh_getdesc (if wiov is NULL).
> 
> I'll do that too...
> 
> > +module_driver(caif_virtio_driver, register_virtio_driver,
> > +	      unregister_virtio_driver);
> > +MODULE_DEVICE_TABLE(virtio, id_table);
> 
> The comment on module_driver says:
> 
>  * Use this macro to construct bus specific macros for registering
>  * drivers, and do not use it on its own.
> 
> Want to send me a patch to define module_virtio_driver?

Sure, I can do that.

Thanks a lot Rusty.

Regards,
Sjur
