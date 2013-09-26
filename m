Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3IZLt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:49:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3IZLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:49:54 -0400
Date: Thu, 26 Sep 2013 14:48:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik@d-paulus.de>
Cc: Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        usbip-devel@lists.sourceforge.net,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Harvey Yang <harvey.huawei.yang@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Bart Westgeest <bart@elbrys.com>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Bernard Blackham <b-linuxgit@largestprime.net>
Subject: Re: [PATCH 5/7] staging: usbip: Add encryption support to kernel
Message-ID: <20130926114810.GA6414@mwanda>
References: <20130923105842.GH6192@mwanda>
 <20130923103504.GG6192@mwanda>
 <20130923095929.GF6192@mwanda>
 <20130926101833.GA8677@d-paulus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926101833.GA8677@d-paulus.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 12:18:34PM +0200, Dominik Paulus wrote:
> > I think a return of zero should mean total = -EBADMSG;.  In other words
> > this check should be "if (ret < 0) {" and we hit the next else if.
> > Same below again.
> 
> As we are wrapping kernel_recvmsg here, we wanted to leave the semantics
> intact as far as possible. The calling code already checks for the correct
> size.

Hm...  Ok.  Sometimes zero is interpretted as a connection closed and
sometimes reading less than expected is considered a TCP error.

> No, currently, the caller (usbip_sendmsg() / usbip_recvmsg() are the
> only functions calling usbip_crypt(), which itself is static) ensures
> this.
> Admittedly, this isn't great design. We added a check for packetsize <
> USBIP_AUTHSIZE and an appropiate return here.
> 
> > > +	if (encrypt)
> > > +		ret = crypto_aead_encrypt(req);
> > > +	else
> > > +		ret = crypto_aead_decrypt(req);
> > > +
> > 
> > Good on you for figuring out what crypto_aead_en/decrypt() returns.
> > Where are these functions documented?
> > 
> > > +        switch (ret) {
> > > +        case 0: /* Success */
> > > +                break;
> > > +        case -EINPROGRESS:
> > > +        case -EBUSY:
> > > +                wait_for_completion(&result.completion);
> > > +                break;
> > > +        default:
> > > +                aead_request_free(req);
> > > +                return ret;
> > > +        }
> > > +
> 
> They aren't, actually. Documentation/crypto/api-intro.txt refers to the
> regression test module, which uses exactly those return-values in
> crypto/testmgr.c.

Well that sucks.

> We noticed that wait_for_completion might not be the best idea, since it could
> hang indefinitely, testmgr.c uses wait_for_completion_interruptible. Do we
> want 'interruptible' or 'killable' here?

I think you want the interruptible one wait_for_completion_interruptible()

regards,
dan carpenter
