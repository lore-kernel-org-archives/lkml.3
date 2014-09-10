Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaIJDdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:33:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJDdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:33:13 -0400
Date: Tue, 9 Sep 2014 20:33:04 -0700
From: Darren Hart <dvhart@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Frans Klaver <fransklaver@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
Message-ID: <20140910033304.GB39541@vmdeb7>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
 <1409814488.5546.63.camel@x220>
 <20140906021757.GA9197@vmdeb7>
 <7288841.ayNsq2yeGO@vostro.rjw.lan>
 <1410252608.22255.5.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410252608.22255.5.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:50:08AM +0200, Paul Bolle wrote:
> Hi Darren,
> 
> On Sat, 2014-09-06 at 23:17 +0200, Rafael J. Wysocki wrote:
> > On Friday, September 05, 2014 07:17:57 PM Darren Hart wrote:
> > > On Thu, Sep 04, 2014 at 09:08:08AM +0200, Paul Bolle wrote:
> > > [...]
> > > >  static ssize_t store_sys_acpi(struct device *dev, int cm,
> > > > @@ -278,12 +276,13 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
> > > >  	struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
> > > >  	int rv, value;
> > > >  
> > > > -	rv = parse_arg(buf, count, &value);
> > > > -	if (rv > 0)
> > > > -		value = set_acpi(eeepc, cm, value);
> > > > +	rv = parse_arg(buf, &value);
> > > > +	if (rv < 0)
> > > > +		return rv;
> > > > +	value = set_acpi(eeepc, cm, value);
> > > >  	if (value < 0)
> > > 
> > > I suppose it's harmless, but it would be more explicit to reuse rv here instead
> > > of value.
> 
> Fine with me.
>  
> > > >  		return -EIO;
> > > 
> > > And as with Frans' version, I suggest propogating the error. We're talking about
> > > a missing/invalid ACPI control method name here, ENODEV seems approprirate.
> > > 
> > > Rafael, do you have a strong preference about what to return in such an event?
> > 
> > No, I don't, although -ENXIO could be used here too.
> 
> If you could say what value you'd like best I'll resend using that
> value. (I don't know what the effect is of using a specific error here,
> so I guess I'll have to bluff about it in the commit explanation.)

First, I would prefer we propogate the error code rather than remap it.

We could consider changing what the callee returns...

#define EIO              5      /* I/O error */
#define ENXIO            6      /* No such device or address */
#define ENODEV          19      /* No such device */

Of those, ENXIO seems like the most appropriate in this case.

-- 
Darren Hart
Intel Open Source Technology Center
