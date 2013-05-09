Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3EIJCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:02:50 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46671 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3EIJCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:02:47 -0400
Date: Thu, 9 May 2013 05:02:21 -0400 (EDT)
From: Pavel Simerda <psimerda@redhat.com>
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, kaber@trash.net,
        torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
        Jiri Pirko <jpirko@redhat.com>
Message-ID: <1222107388.5643197.1368090141553.JavaMail.root@redhat.com>
In-Reply-To: <1925922763.4087858.1367624135286.JavaMail.root@redhat.com>
References: <20130502.041625.412316202038784117.davem@davemloft.net> <20130502083619.GA22010@macbook.localnet> <87d2t9bvj1.fsf@nemi.mork.no> <20130502.051727.949429506738234701.davem@davemloft.net> <1367490491.5106.137.camel@deadeye.wl.decadent.org.uk> <87zjwda9bl.fsf@nemi.mork.no> <CAHXqBF+S3mSbktoDzuHkzvEQkfxa6-2R-sYpqVsZBzMDTjUifQ@mail.gmail.com> <1925922763.4087858.1367624135286.JavaMail.root@redhat.com>
Subject: Re: [GIT] Networking
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: Networking
Thread-Index: pHD2SyZ8vi2jX+Tiv36y73SK9F5RhaiE7L+N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Pavel Simerda" <psimerda@redhat.com>
> To: "Michał Mirosław" <mirqus@gmail.com>
> Cc: "Bjørn Mork" <bjorn@mork.no>, "Ben Hutchings" <bhutchings@solarflare.com>, "David Miller" <davem@davemloft.net>,
> kaber@trash.net, torvalds@linux-foundation.org, hayeswang@realtek.com, akpm@linux-foundation.org,
> netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>, "Jiri Pirko"
> <jpirko@redhat.com>
> Sent: Saturday, May 4, 2013 1:35:35 AM
> Subject: Re: [GIT] Networking
> 
> ----- Original Message -----
> > From: "Michał Mirosław" <mirqus@gmail.com>
> > To: "Bjørn Mork" <bjorn@mork.no>, "Pavel Šimerda" <psimerda@redhat.com>
> > Cc: "Ben Hutchings" <bhutchings@solarflare.com>, "David Miller"
> > <davem@davemloft.net>, kaber@trash.net,
> > torvalds@linux-foundation.org, hayeswang@realtek.com,
> > akpm@linux-foundation.org, netdev@vger.kernel.org,
> > linux-kernel@vger.kernel.org
> > Sent: Thursday, May 2, 2013 6:22:47 PM
> > Subject: Re: [GIT] Networking
> > 
> > 2013/5/2 Bjørn Mork <bjorn@mork.no>:
> > > Ben Hutchings <bhutchings@solarflare.com> writes:
> > >> On Thu, 2013-05-02 at 05:17 -0400, David Miller wrote:
> > >>> From: Bjørn Mork <bjorn@mork.no>
> > >>> Date: Thu, 02 May 2013 11:06:42 +0200
> > >>>
> > >>> > Adding the new netdev features will make it go from 1 to 2:
> > >>>
> > >>> We already had more than 31 feature bits before Patrick's
> > >>> changes, and I'm pretty sure this was the case when we added
> > >>> that ethtool API.
> > >>
> > >> It wasn't, but this should be OK.  Userland is supposed to query the
> > >> number of features using ETHTOOL_GSSET_INFO and then work out the number
> > >> of words/blocks using FEATURE_BITS_TO_BLOCKS().
> > >
> > >
> > > Looking at
> > > http://cgit.freedesktop.org/NetworkManager/NetworkManager/tree/src/platform/nm-linux-platform.c#n1025
> > > there seems to be a couple of bugs in this area. This is certainly
> > > abusing the exported API, but it does mean that NM breaks if you ever
> > > move NETIF_F_VLAN_CHALLENGED (like the 802.1ad patch did):
> > >
> > > ----
> > > #define NETIF_F_VLAN_CHALLENGED (1 << 10)
> > >
> > > static gboolean
> > > link_supports_vlans (NMPlatform *platform, int ifindex)
> > > {
> > >         auto_nl_object struct rtnl_link *rtnllink = link_get (platform,
> > >         ifindex);
> > >         const char *name = nm_platform_link_get_name (ifindex);
> > >         struct {
> > >                 struct ethtool_gfeatures features;
> > >                 struct ethtool_get_features_block features_block;
> > >         } edata = { .features = { .cmd = ETHTOOL_GFEATURES, .size = 1 }
> > >         };
> > >
> > >         /* Only ARPHRD_ETHER links can possibly support VLANs. */
> > >         if (!rtnllink || rtnl_link_get_arptype (rtnllink) !=
> > >         ARPHRD_ETHER)
> > >                 return FALSE;
> > >
> > >         if (!name || !ethtool_get (name, &edata))
> > >                 return FALSE;
> > >
> > >         return !(edata.features.features[0].active &
> > >         NETIF_F_VLAN_CHALLENGED);
> > > }
> > > ----
> > >
> > >
> > > Not that I see how this particular bug matters unless you need VLAN
> > > support in NM.  But there could be similar issues around.  I guess
> > > avoiding unnecessary renumbering of the NETIF_F bits can save us some
> > > trouble.  Although you can certainly argue that those bits never were
> > > intended to be part of the API, and that using them like this is a user
> > > application bug.
> > 
> > This is certainly a bug in NM, and a fresh one: commit
> > b636ea86b1c0a28b77eda311c84d3b2417cad22e from 2013-04-10 14:40:58
> > (GMT). Userspace is expected to use ETHTOOL_GSTRINGS for
> > ETH_SS_FEATURES and find a corresponding bit position by feature name
> > ("vlan-challenged" in this case).
> > 
> > Cc: commit's author.
> 
> Recorded the bug with NetworkManager bugzilla blocking the upcoming release:
> 
> https://bugzilla.gnome.org/show_bug.cgi?id=699649
> 
> The code is experimental and is not used by NetworkManager even in the
> 'master' branch except by nm-platform's automated tests. Once we fix it, you
> don't need to worry about it.
> 
> Thanks!
> 
> Pavel

Fixed in NetworkManager master:

commit 7aefd5b5f4547c294092753b5cc355c95763134a
Author: Dan Winship <danw@gnome.org>
Date:   Mon May 6 12:10:01 2013 -0400
 
    platform: fix use of ethtool
   
    The bits in the result of ETHTOOL_GFEATURES are not in any defined
    order; you need to use ETHTOOL_GSTRINGS to get the names associated
    with each bit to find what each one does. Fix
    NMPlatformLinux:link_supports_vlans() to do this.
   
    https://bugzilla.gnome.org/show_bug.cgi?id=699649
 
diff --git a/src/platform/nm-linux-platform.c b/src/platform/nm-linux-platform.c
index 699c107..eeaeb2e 100644
--- a/src/platform/nm-linux-platform.c
+++ b/src/platform/nm-linux-platform.c
@@ -1024,6 +1024,40 @@ ethtool_get (const char *name, gpointer edata)
        return TRUE;
 }
 
+static int
+ethtool_get_stringset_index (const char *ifname, int stringset_id, const char *string)
+{
+       auto_g_free struct ethtool_sset_info *info;
+       auto_g_free struct ethtool_gstrings *strings;
+       guint32 len, i;
+
+       info = g_malloc0 (sizeof (*info) + sizeof (guint32));
+       info->cmd = ETHTOOL_GSSET_INFO;
+       info->reserved = 0;
+       info->sset_mask = 1ULL << stringset_id;
+
+       if (!ethtool_get (ifname, info))
+               return -1;
+       if (!info->sset_mask)
+               return -1;
+
+       len = info->data[0];
+
+       strings = g_malloc0 (sizeof (*strings) + len * ETH_GSTRING_LEN);
+       strings->cmd = ETHTOOL_GSTRINGS;
+       strings->string_set = stringset_id;
+       strings->len = len;
+       if (!ethtool_get (ifname, strings))
+               return -1;
+
+       for (i = 0; i < len; i++) {
+               if (!strcmp ((char *) &strings->data[i * ETH_GSTRING_LEN], string))
+                       return i;
+       }
+
+       return -1;
+}
+
 static gboolean
 link_supports_carrier_detect (NMPlatform *platform, int ifindex)
 {
@@ -1041,26 +1075,39 @@ link_supports_carrier_detect (NMPlatform *platform, int ifindex)
        return name && ethtool_get (name, &edata);
 }
 
-#define NETIF_F_VLAN_CHALLENGED (1 << 10)
-
 static gboolean
 link_supports_vlans (NMPlatform *platform, int ifindex)
 {
        auto_nl_object struct rtnl_link *rtnllink = link_get (platform, ifindex);
        const char *name = nm_platform_link_get_name (ifindex);
-       struct {
-               struct ethtool_gfeatures features;
-               struct ethtool_get_features_block features_block;
-       } edata = { .features = { .cmd = ETHTOOL_GFEATURES, .size = 1 } };
+       auto_g_free struct ethtool_gfeatures *features;
+       int index, block, bit, size;
 
        /* Only ARPHRD_ETHER links can possibly support VLANs. */
        if (!rtnllink || rtnl_link_get_arptype (rtnllink) != ARPHRD_ETHER)
                return FALSE;
 
-       if (!name || !ethtool_get (name, &edata))
+       if (!name)
+               return FALSE;
+
+       index = ethtool_get_stringset_index (name, ETH_SS_FEATURES, "vlan-challenged");
+       if (index == -1) {
+               debug ("vlan-challenged ethtool feature does not exist?");
+               return FALSE;
+       }
+
+       block = index /  32;
+       bit = index % 32;
+       size = block + 1;
+
+       features = g_malloc0 (sizeof (*features) + size * sizeof (struct ethtool_get_features_block));
+       features->cmd = ETHTOOL_GFEATURES;
+       features->size = size;
+
+       if (!ethtool_get (name, features))
                return FALSE;
 
-       return !(edata.features.features[0].active & NETIF_F_VLAN_CHALLENGED);
+       return !(features->features[block].active & (1 << bit));
 }
 
 static gboolean
