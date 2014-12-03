Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaLCRql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:46:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:1696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaLCRqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:46:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424618472"
Date: Wed, 3 Dec 2014 19:10:57 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Fabio Estevam <festevam@gmail.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: DT parsing : duplicate name error
Message-ID: <20141203171057.GD28857@lahna.fi.intel.com>
References: <CAL8zT=iXizKqJjWDcLT-chZ7=ioPYtQcB4GeqZpiL7kCpGOKZw@mail.gmail.com>
 <CACxGe6sRULEmOvdxFvR=Mcbf4Cgd3YijrJg1q9Uz1vgYw5tG+w@mail.gmail.com>
 <CAL8zT=geUOJnmUHvqyYk651U+HF3NSy3XU7hiWUn3gPX0sVjPg@mail.gmail.com>
 <CACxGe6skTZDe40eJN06BDapfKuN-KzMqgbEWNyLiTeXTt5dw5g@mail.gmail.com>
 <CAOMZO5AmA5-Ji6SDUv6b3qrhSi-KvSNYDV=ZaL7HoOhh-6SnsA@mail.gmail.com>
 <CACxGe6s-dKRtwjBhVE2d1L-qOYX_71hQOT9svu4m_+kDZESPaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6s-dKRtwjBhVE2d1L-qOYX_71hQOT9svu4m_+kDZESPaw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 04:07:58PM +0000, Grant Likely wrote:
> On Wed, Dec 3, 2014 at 4:04 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > On Wed, Dec 3, 2014 at 1:41 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >
> >> From a quick reading of the backlog, for some reason the new device is
> >> getting assigned NULL as the device name in led_classdev_register().
> >> Probably because led_cdev->name is set to NULL. The leds are getting
> >> bound to the LED driver in gpio_led_probe() which is the non-DT path
> >> for creating LED devices. That would mean there is pdata attached to
> >> the LED device, but I haven't dug any farther than that. Really need
> >> the bisect to narrow down what is going on.
> >
> > Ok, so this issue happens when two or more gpio-leds do not contain
> > the 'label' property.
> >
> > 'label' is an optional property according to
> > Documentation/devicetree/bindings/leds/common.txt:
> >
> > "Optional properties for child nodes:
> > - label : The label for this LED.  If omitted, the label is
> >   taken from the node name (excluding the unit address)."
> >
> > This works fine on 3.17.1 as we used to have this logic in leds-gpio:
> > led.name = of_get_property(child, "label", NULL) ? : child->name;
> >
> > ,but since commit a43f2cbbb009f96 ("leds: leds-gpio: Make use of
> > device property API "), this is no longer true:
> >
> >  + fwnode_property_read_string(child, "label", &led.name);
> >
> > If 'label' is not present then both of the LEDs will have the same
> > name and then the duplicate name error will happen.
> >
> > So we would need something like this:
> >
> >  if (fwnode_property_present(child, "label"))
> >        fwnode_property_read_string(child, "label", &led.name);
> >  else
> >      get the name from the child ---> This is what I am not sure how
> > to do after the conversion to use fwnode_handle.
> 
> Ah, that makes sense. The device properties change needs to be
> reworked/fixed up to have a DT specific part when the label property
> is missing. Either that or the device properties API needs to gain the
> ability to return the node name.

Does it need to be taken from the node name? What if we generate the
name based on the leds device name?

Something like "leds-gpio:0" and "leds-gpio:1" or so.
