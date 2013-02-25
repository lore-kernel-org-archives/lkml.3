Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3BYHHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:07:55 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:33746 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3BYHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:07:54 -0500
Date: Sun, 24 Feb 2013 23:07:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 1/3] mfd: syscon: Removed support for unloading
Message-ID: <20130225070751.GA4614@core.coreip.homeip.net>
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
 <512955F7.1020309@wwwdotorg.org>
 <20130224075533.GB18844@core.coreip.homeip.net>
 <1361775222.578079910@f398.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361775222.578079910@f398.i.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 10:53:42AM +0400, Alexander Shiyan wrote:
> > On Sat, Feb 23, 2013 at 04:51:19PM -0700, Stephen Warren wrote:
> > > On 02/22/2013 10:28 PM, Alexander Shiyan wrote:
> > > >> On 02/22/2013 10:15 PM, Alexander Shiyan wrote:
> > > >>> The driver can be used in various subsystems and therefore should not
> > > >>> be unloaded when it is defined in the kernel configuration, so remove
> > > >>> support for unloading it.
> > > >>
> > > >> Why not fix the clients to module_get() at the appropriate times; then
> > > >> you could still allow unloading, couldn't you?
> > > > 
> > > > I has explain this before.
> > > 
> > > If multiple people have asked this, perhaps it'd be a good idea to
> > > include the answer in the commit description.
> > > 
> > > > Driver defined as "bool" and loaded via postcore_initcall.
> > > 
> > > Being defined as a "bool" sounds like a reasonable reason that no
> > > remove() is required.
> > 
> > No, it is not - I can still unbind the device from driver via sysfs. Now
> > what will happen is resources are leaked and won't be available when
> > trying to bin (via sysfs) again.
> > 
> > This patch is broken.
> 
> I will try to resolve the dispute.
> Initially, the first part of the patch (this) was an attempt to prevent the unloading
> (unregister) of the driver (not the device), ie remove module_exit call.
> The patch also removes the code to remove the device. Inclusion in this patch
> of the code was a mistake. Because of this, people are confused about the terms,
> including me.
> Code, relating to the removal of the device should be moved to the third patch.
> Since all moved to using the managed resources, it should not have any questions.
> 
> About uloading (unregister) driver: As far i understand "__exit" section is
> completely discarded when kernel compiled without module support.
> But where is this call (module_exit) is placing in case "bool" driver and
> kernel is compiled with module support? Fixme please.

In both cases __exit code goes to .exit.text section which is either
discarded (code is compiled into the kernel) or kept (code is built as a
module).

Still, because the device can forcibly be unbound from the driver, all
these changes are pretty useless for the stated purpose. All in all, it
seems to me that this code should not be a driver at all, but rather
rolled into regmap infrastructure and be part of it's initialization
process.

Thanks.

-- 
Dmitry
