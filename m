Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763930Ab3ECXf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:35:59 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43826 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772Ab3ECXf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:35:57 -0400
Date: Fri, 3 May 2013 19:35:35 -0400 (EDT)
From: Pavel Simerda <psimerda@redhat.com>
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, kaber@trash.net,
        torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
        Jiri Pirko <jpirko@redhat.com>
Message-ID: <1925922763.4087858.1367624135286.JavaMail.root@redhat.com>
In-Reply-To: <CAHXqBF+S3mSbktoDzuHkzvEQkfxa6-2R-sYpqVsZBzMDTjUifQ@mail.gmail.com>
References: <20130502.041625.412316202038784117.davem@davemloft.net> <20130502083619.GA22010@macbook.localnet> <87d2t9bvj1.fsf@nemi.mork.no> <20130502.051727.949429506738234701.davem@davemloft.net> <1367490491.5106.137.camel@deadeye.wl.decadent.org.uk> <87zjwda9bl.fsf@nemi.mork.no> <CAHXqBF+S3mSbktoDzuHkzvEQkfxa6-2R-sYpqVsZBzMDTjUifQ@mail.gmail.com>
Subject: Re: [GIT] Networking
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: Networking
Thread-Index: pHD2SyZ8vi2jX+Tiv36y73SK9F5RhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Michał Mirosław" <mirqus@gmail.com>
> To: "Bjørn Mork" <bjorn@mork.no>, "Pavel Šimerda" <psimerda@redhat.com>
> Cc: "Ben Hutchings" <bhutchings@solarflare.com>, "David Miller" <davem@davemloft.net>, kaber@trash.net,
> torvalds@linux-foundation.org, hayeswang@realtek.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
> linux-kernel@vger.kernel.org
> Sent: Thursday, May 2, 2013 6:22:47 PM
> Subject: Re: [GIT] Networking
> 
> 2013/5/2 Bjørn Mork <bjorn@mork.no>:
> > Ben Hutchings <bhutchings@solarflare.com> writes:
> >> On Thu, 2013-05-02 at 05:17 -0400, David Miller wrote:
> >>> From: Bjørn Mork <bjorn@mork.no>
> >>> Date: Thu, 02 May 2013 11:06:42 +0200
> >>>
> >>> > Adding the new netdev features will make it go from 1 to 2:
> >>>
> >>> We already had more than 31 feature bits before Patrick's
> >>> changes, and I'm pretty sure this was the case when we added
> >>> that ethtool API.
> >>
> >> It wasn't, but this should be OK.  Userland is supposed to query the
> >> number of features using ETHTOOL_GSSET_INFO and then work out the number
> >> of words/blocks using FEATURE_BITS_TO_BLOCKS().
> >
> >
> > Looking at
> > http://cgit.freedesktop.org/NetworkManager/NetworkManager/tree/src/platform/nm-linux-platform.c#n1025
> > there seems to be a couple of bugs in this area. This is certainly
> > abusing the exported API, but it does mean that NM breaks if you ever
> > move NETIF_F_VLAN_CHALLENGED (like the 802.1ad patch did):
> >
> > ----
> > #define NETIF_F_VLAN_CHALLENGED (1 << 10)
> >
> > static gboolean
> > link_supports_vlans (NMPlatform *platform, int ifindex)
> > {
> >         auto_nl_object struct rtnl_link *rtnllink = link_get (platform,
> >         ifindex);
> >         const char *name = nm_platform_link_get_name (ifindex);
> >         struct {
> >                 struct ethtool_gfeatures features;
> >                 struct ethtool_get_features_block features_block;
> >         } edata = { .features = { .cmd = ETHTOOL_GFEATURES, .size = 1 } };
> >
> >         /* Only ARPHRD_ETHER links can possibly support VLANs. */
> >         if (!rtnllink || rtnl_link_get_arptype (rtnllink) != ARPHRD_ETHER)
> >                 return FALSE;
> >
> >         if (!name || !ethtool_get (name, &edata))
> >                 return FALSE;
> >
> >         return !(edata.features.features[0].active &
> >         NETIF_F_VLAN_CHALLENGED);
> > }
> > ----
> >
> >
> > Not that I see how this particular bug matters unless you need VLAN
> > support in NM.  But there could be similar issues around.  I guess
> > avoiding unnecessary renumbering of the NETIF_F bits can save us some
> > trouble.  Although you can certainly argue that those bits never were
> > intended to be part of the API, and that using them like this is a user
> > application bug.
> 
> This is certainly a bug in NM, and a fresh one: commit
> b636ea86b1c0a28b77eda311c84d3b2417cad22e from 2013-04-10 14:40:58
> (GMT). Userspace is expected to use ETHTOOL_GSTRINGS for
> ETH_SS_FEATURES and find a corresponding bit position by feature name
> ("vlan-challenged" in this case).
> 
> Cc: commit's author.

Recorded the bug with NetworkManager bugzilla blocking the upcoming release:

https://bugzilla.gnome.org/show_bug.cgi?id=699649

The code is experimental and is not used by NetworkManager even in the 'master' branch except by nm-platform's automated tests. Once we fix it, you don't need to worry about it.

Thanks!

Pavel
