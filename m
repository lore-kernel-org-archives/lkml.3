Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaBIHrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:47:42 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:49828 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaBIHrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:47:41 -0500
Message-ID: <1391932042.11170.20.camel@localhost.localdomain>
Subject: Re: [PATCHv4] driver core/platform: don't leak memory allocated for
 dma_mask
From: Yann Droneaud <ydroneaud@opteya.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Sun, 09 Feb 2014 08:47:22 +0100
In-Reply-To: <20140208150958.GK17045@pengutronix.de>
References: <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
	 <20140113225606.GA4132@kroah.com>
	 <1389683909-17495-1-git-send-email-ydroneaud@opteya.com>
	 <20140114081944.GO29475@pengutronix.de>
	 <1389693453.1585.26.camel@localhost.localdomain>
	 <20140114103648.GT29475@pengutronix.de> <20140114180204.GD27791@kroah.com>
	 <1390771138-28348-1-git-send-email-ydroneaud@opteya.com>
	 <1390817152-30898-1-git-send-email-ydroneaud@opteya.com>
	 <20140207232005.GA23477@kroah.com> <20140208150958.GK17045@pengutronix.de>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le samedi 08 février 2014 à 16:09 +0100, Uwe Kleine-König a écrit :
> On Fri, Feb 07, 2014 at 03:20:05PM -0800, Greg Kroah-Hartman wrote:
> > On Mon, Jan 27, 2014 at 11:05:52AM +0100, Yann Droneaud wrote:
> > > Since commit 01dcc60a7cb8, platform_device_register_full() is
> > > available to allocate and register a platform device.
> > > 
> > > If a dma_mask is provided as part of platform_device_info,
> > > platform_device_register_full() allocate memory for a u64 using
> > > kmalloc().
> > > 
> > > A comment in the code state that "[t]his memory isn't freed when the
> > > device is put".
> > > 
> > > It's never a good thing to leak memory, but there's only very few
> > > users of platform_device_info's dma_mask, and those are mostly
> > > "static" devices that are not going to be plugged/unplugged often.
> > > 
> > > So memory leak is not really an issue, but allocating 8 bytes through
> > > kmalloc() seems overkill.
> > > 
> > > And it's a pity to have to allocate 8 bytes for the dma_mask while up
> > > to 7 bytes are wasted at the end of struct platform_object in the form
> > > of padding after name field: unfortunately this padding is not used
> > > when allocating the memory to hold the name.
> > >
> > > To address theses issues, this patch adds dma_mask to platform_object
> > > struct so that it is always allocated for all struct platform_device
> > > allocated through platform_device_alloc() or platform_device_register_full().
> > > And since it's within struct platform_object, dma_mask won't be leaked
> > > anymore when struct platform_device got released. Storage for dma_mask
> > > is added almost for free by removing the padding at the end of struct
> > > platform_object.

> How does the padding of name change? The only thing that I see changing
> for .name is that it's a char[] now instead of a char[1]. As it was
> used as a flexible array already before the padding (which only applies
> to a stand alone struct platform_object) doesn't matter.
> I guess that is a tool problem that still some padding changes are
> reported?
> 

When name is defined as char name[1] at the end of the structure, the
compiler is required to add padding after it (since the structure is not
"packed" through some compiler extension).
This padding is added in order to have a size multiple of the highest
required alignement for types insided the structure. This is required so
that each item of an array of "struct platform_object" are aligned.

Changing name[1] to name[0] or name[] free the compiler from adding
storage space for name and thus remove the need for padding after it.

> Other than that the patch looks good.
> 

Thanks a lot.

-- 
Yann Droneaud
OPTEYA


