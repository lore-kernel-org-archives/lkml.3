Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3GIXga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:36:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36231 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3GIXgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:36:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC][PATCH 6/8] ACPI / hotplug / PCI: Drop acpiphp_handle_to_bridge()
Date: Wed, 10 Jul 2013 01:46:05 +0200
Message-ID: <1584852.Uglv2uCyLO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130709093726.GK4898@intel.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3804403.VVlzfJfUyu@vostro.rjw.lan> <20130709093726.GK4898@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 09, 2013 12:37:26 PM Mika Westerberg wrote:
> On Tue, Jul 09, 2013 at 02:20:31AM +0200, Rafael J. Wysocki wrote:
> > @@ -953,37 +937,49 @@ static void acpiphp_sanitize_bus(struct
> >   * ACPI event handlers
> >   */
> >  
> > -static acpi_status
> > -check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> > +static acpi_status check_sub_bridges(acpi_handle handle, u32 lvl, void *data,
> > +				     void **rv)
> >  {
> > -	struct acpiphp_bridge *bridge;
> > -	char objname[64];
> > -	struct acpi_buffer buffer = { .length = sizeof(objname),
> > -				      .pointer = objname };
> > +	struct acpiphp_context *context = acpiphp_get_context(handle);
> > +
> > +	if (!context)
> > +		return AE_OK;
> >  
> > -	bridge = acpiphp_handle_to_bridge(handle);
> > -	if (bridge) {
> > +	if (context->bridge) {
> > +		struct acpiphp_bridge *bridge = context->bridge;
> > +		char objname[64];
> > +		struct acpi_buffer buffer = { .length = sizeof(objname),
> > +					      .pointer = objname };
> > +
> > +		get_bridge(bridge);
> >  		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > -		dbg("%s: re-enumerating slots under %s\n",
> > -			__func__, objname);
> > +		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
> 
> Although not related to this patch directly, how about using
> acpi_handle_debug() or similar here?

Well, we don't have acpi_handle_debug() and I remember there was a reason why,
but I can't recall what the reason was at the moment. :-)

> >  		acpiphp_check_bridge(bridge);
> >  		put_bridge(bridge);
> >  	}
> > +	acpiphp_put_context(context);
> >  	return AE_OK ;
> >  }
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
