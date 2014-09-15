Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbaIOVwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:52:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaIOVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:52:13 -0400
Date: Mon, 15 Sep 2014 14:51:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 10/13] eeepc-laptop: compare proper return values in
 get_cpufv
Message-ID: <20140915215125.GA21435@kroah.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-11-git-send-email-fransklaver@gmail.com>
 <20140915214902.GB64909@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915214902.GB64909@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 02:49:02PM -0700, Darren Hart wrote:
> On Sat, Sep 13, 2014 at 01:06:49AM +0200, Frans Klaver wrote:
> > In get_cpufv the return value of get_acpi is stored in the cpufv struct.
> > Right before this value is checked for errors, it is and'ed with 0xff.
> > This means c->cur can never be less than zero. Besides that, the actual
> > error value is ignored.
> > 
> > c->num is also and'ed with 0xff, which means we can ignore values below
> > zero.
> > 
> > Check the result of get_acpi() right away. While at it, propagate the
> > error if we got one.
> > 
> > Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> > ---
> >  drivers/platform/x86/eeepc-laptop.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> > index 47488d3..828db56 100644
> > --- a/drivers/platform/x86/eeepc-laptop.c
> > +++ b/drivers/platform/x86/eeepc-laptop.c
> > @@ -332,9 +332,12 @@ struct eeepc_cpufv {
> >  static int get_cpufv(struct eeepc_laptop *eeepc, struct eeepc_cpufv *c)
> >  {
> >  	c->cur = get_acpi(eeepc, CM_ASL_CPUFV);
> > +	if (c->cur < 0)
> > +		return c->cur;
> > +
> >  	c->num = (c->cur >> 8) & 0xff;
> >  	c->cur &= 0xff;
> > -	if (c->cur < 0 || c->num <= 0 || c->num > 12)
> > +	if (c->num == 0 || c->num > 12)
> >  		return -ENODEV;
> >  	return 0;
> 
> This patch is fine as is. However, Greg has supported propogating the error code
> through to the sysfs interface (if I understand him correctly on an earlier post
> to this list). This would require an addition change to this patch would
> propogated the get_cpufv error code in show_available_cpuv(), show_cpuv(), and
> store_cpuv(). As it is, we return -ENODEV on any failure, where an ACPI call
> error should probably return -ENXIO as I understand it.

I really have no idea at this point in time what to recommend.  How
about just stick with what is happening today so that:

> However, there was a rather famous change in error code handling in which pulse
> audio broke and Linus was very upset with one of his maintainers.

That doesn't happen :)

thanks,

greg k-h
