Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKDRPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:15:49 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:55569 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaKDRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:15:38 -0500
Date: Tue, 4 Nov 2014 17:15:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Bryan Wu'" <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: use of_find_backlight_by_node stub when
 backlight class disabled
Message-ID: <20141104171532.GS17577@x1>
References: <50522512.UJWUZtqLop@diego>
 <001101cff818$bfe149b0$3fa3dd10$%han@samsung.com>
 <20141104144220.GR17577@x1>
 <28305505.Hd0ru0QyPE@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28305505.Hd0ru0QyPE@diego>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Heiko Stübner wrote:

> Am Dienstag, 4. November 2014, 14:42:20 schrieb Lee Jones:
> > On Tue, 04 Nov 2014, Jingoo Han wrote:
> > > On Tuesday, November 04, 2014 6:08 PM, Heiko Stübner wrote:
> > > > On Mon, 03 Nov 2014, Lee Jones wrote:
> > > > > On Wed, 29 Oct 2014, Heiko Stübner wrote:
> > > > > > Drivers may want to search for an optional backlight even when the
> > > > > > backlight class is disabled. In this case the linker would miss the
> > > > > > function referenced in the backlight header.
> > > > > > 
> > > > > > Therefore use the stub function also when the backlight class is
> > > > > > disabled.
> > > > > > 
> > > > > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > > > > > ---
> > > > > > 
> > > > > >  include/linux/backlight.h | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > Applied to Backlight -next with Jingoo's Ack.
> > > > 
> > > > I've removed this patch, as it causes unexpected:
> > > >   Redefinition of of_find_backlight_by_node()
> > > 
> > > I reproduced the same build error.
> > > 
> > > Then, how about folding the following two patches into
> > > one single patch? These two patches were already sent by Heiko Stübner.
> > > 
> > >   [PATCH] backlight: use of_find_backlight_by_node stub when backlight
> > >   class disabled [PATCH] backlight: extend of_find_backlight_by_node
> > >   stub-check to modules> 
> > > Then, the one single patch will do as follows.
> > > 
> > > -#ifdef CONFIG_OF
> > > +#if defined(CONFIG_OF) && (defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || \
> > > +			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
> > > 
> > > In this case, I cannot find any build errors.
> > 
> > That's a neat trick.  I didn't know you could do that.
> > 
> > However, it's bit messy consider different formatting, or a nested
> > #ifdef instead please.
> 
> I guess it is a matter of me "not seeing the forrest for the trees", but how
> would a nested ifdef look like, as this would result in 3 possible results
> when for CONFIG_OF first and then for one of the BACKLIGHT_CLASS defines?
> 
> Formatting wise, when applied both defined(CONFIG_BACKLIGHT_foo) parts
> are exactly below each other, making it (hopefully) clear where the "or" is
> part of. What would look better?

Actually there is a better way still:

#ifdef CONFIG_OF && IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
struct backlight_device *of_find_backlight_by_node(struct device_node *node);
#else
static inline struct backlight_device *
of_find_backlight_by_node(struct device_node *node)
{
      return NULL;
}
#endif


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
