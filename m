Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaHKEcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 00:32:39 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:59498 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbaHKEch convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 00:32:37 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 00:32:37 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=EaIe3b0K0y0RxE3UvYH92YFhed/oiyNWCEVYjMWc6o4aj0Y4k+wFfrSg8aQu1kb5;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Mon, 11 Aug 2014 00:22:10 -0400
From: Bill Fink <billfink@mindspring.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Dexuan Cui <decui@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Shao <huishao@microsoft.com>,
        "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Message-Id: <20140811002210.2a697052767e9ec1989cb219@mindspring.com>
In-Reply-To: <53E83DD4.1060500@gmail.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
	<53CCD6F2.6020909@nod.at>
	<20140721091851.GA28171@aepfle.de>
	<20140721.143225.2040366896972949930.davem@davemloft.net>
	<CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
	<EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
	<20140808033220.GB10503@kroah.com>
	<EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
	<20140808134549.GD4427@kroah.com>
	<EE124450C0AAF944A40DD71E61F878C991B653@SINEX14MBXC417.southpacific.corp.microsoft.com>
	<53E83DD4.1060500@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4dcde8babb8f841a0c935bfd535d58a8bf350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.179.3.200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2014, Florian Fainelli wrote:

> Le 10/08/2014 20:23, Dexuan Cui a écrit :
> >> -----Original Message-----
> >> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> >>>>>
> >>>>> IMO the most feasible and need-the-least-change solution may be:
> >>>>> the hyperv network VSC driver passes the event
> >>>>> RNDIS_STATUS_NETWORK_CHANGE to the udev daemon?
> >>>>>
> >>>> No, don't do that, again, act like any other network device, drop the
> >>>> link and bring it up when it comes back.
> >>>>
> >>> Hi Greg,
> >>> Do you mean tearing down the net device and re-creating it (by
> >>> register_netdev() and unregister_netdev)?
> >>
> >> No, don't you have link-detect for your network device?  Toggle that, I
> >> thought patches to do this were posted a while ago...
> >>
> >> But if you really want to tear the whole network device down and then
> >> back up again, sure, that would also work.
> > Hi Greg, Stephen,
> >
> > Thanks for the comments!
> >
> > I suppose you meant the below logic:
> > if (refresh) {
> >          rtnl_lock();
> >          netif_carrier_off(net);
> >          netif_carrier_on(net);
> >          rtnl_unlock();
> > }
> >
> > We have discussed this in the previous mails of this thread itself:
> > e.g., http://marc.info/?l=linux-driver-devel&m=140593811715975&w=2
> >
> > Unluckily this logic doesn't work because the user-space daemons
> > like ifplugd, usually don't renew the DHCP immediately as long as they
> > receive a link-down message: they usually wait for some seconds and if
> > they find the link becomes up soon, they won't trigger renew operations.
> > (I guess this behavior can be somewhat reasonable: maybe the daemons
> > try to not trigger DHCP renew on temporary link instability)
> 
> Is that such a big deal? If you know you spend much of your time in 
> ifplugd, why not use something different that triggers a DHCP renewal 
> faster, or fix ifplugd?

In the case of ifplugd, it has parameters -u | --delay-up= which
defaults to 0 seconds, and -d | --delay-down= which defaults to
5 seconds.  Maybe for hyperv you could specify --delay-down=0.
I don't know if other daemons such as systemd have similar options.
It might still be good to have some modest delay between the
netif_carrier_off(net) and netif_carrier_on(net).

						-Bill
