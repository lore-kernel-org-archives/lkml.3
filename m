Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3BYHld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:41:33 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47854 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3BYHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:41:32 -0500
Date: Mon, 25 Feb 2013 02:41:27 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: Olaf Hering <aepfle@gmail.com>
Cc: gregkh@linuxfoundation.org, kys@microsoft.com, jasowang@redhat.com,
        haiyangz@microsoft.com, linux-kernel@vger.kernel.org,
        habdi@microsoft.com
Message-ID: <2084552526.3159126.1361778087674.JavaMail.root@redhat.com>
In-Reply-To: <20130222185741.GA10588@gmail.com>
Subject: Re: [PATCH] tools: hv: Fix how ifcfg-* file is created
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.4.165]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Sun, Jan 13, Tomas Hozza wrote:
> 
> > -# IPADDR=ipaddr1
> > -# IPADDR_1=ipaddr2
> > -# IPADDR_x=ipaddry (where y = x + 1)
> > +# IPADDR0=ipaddr1
> > +# IPADDR1=ipaddr2
> > +# IPADDRx=ipaddry (where y = x + 1)
> 
> Before this change it was IPADDR=, now its IPADDR0=.
> Furthermore, IPADDR_n was changed to IPADDRn.

>From initscripts (ifcfg-* part) documentation:

Base items:
    NAME=
      Most important for PPP.  Only used in front ends.
    DEVICE=PPP
      devices where it is the "logical name")>
    IPADDRn=
    PREFIXn=
      Network prefix.  It is used for all configurations except aliases
      and ippp devices.  It takes precedence over NETMASK when both
      PREFIX and NETMASK are set.
    NETMASKn=
      Subnet mask; just useful for aliases and ippp devices.  For all other
      configurations, use PREFIX instead.

    The "n" is expected to be consecutive positive integers starting from 0.
    It can be omitted if there is only one address being configured.


So I think this explains a lot. In hyperv KVP daemon source there is no logic
to determine if we are going to set more than SINGLE IP address to the interface.
Therefore we have to set the first one as IPADDR0. This is completely OK and
in compliance with the documentation.

> Does that match what the tools consuming the ifcfg-* files expect?

Since the current format looks the same as described in documentation
I assume tools consuming ifcfg-* files expect exactly this. I also checked
scripts handling those ifcfg-* files and they did not expect it to be
IPADDR_n for some "n". We also tested the daemon and it worked just fine.

> Why did it work before this change?

For single IPADDR this should work just fine and it is expected to. But did you
try also to set more than just a single IP address to the interface?

Regards,
Tomas Hozza
