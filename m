Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3EBLwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:52:07 -0400
Received: from canardo.mork.no ([148.122.252.1]:34952 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab3EBLwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:52:05 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, <kaber@trash.net>,
        <torvalds@linux-foundation.org>, <hayeswang@realtek.com>,
        <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
Organization: m
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	<20130502083619.GA22010@macbook.localnet>
	<87d2t9bvj1.fsf@nemi.mork.no>
	<20130502.051727.949429506738234701.davem@davemloft.net>
	<1367490491.5106.137.camel@deadeye.wl.decadent.org.uk>
Date: Thu, 02 May 2013 13:51:42 +0200
In-Reply-To: <1367490491.5106.137.camel@deadeye.wl.decadent.org.uk> (Ben
	Hutchings's message of "Thu, 2 May 2013 11:28:11 +0100")
Message-ID: <87zjwda9bl.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> writes:
> On Thu, 2013-05-02 at 05:17 -0400, David Miller wrote:
>> From: Bjørn Mork <bjorn@mork.no>
>> Date: Thu, 02 May 2013 11:06:42 +0200
>> 
>> > Adding the new netdev features will make it go from 1 to 2:
>> 
>> We already had more than 31 feature bits before Patrick's
>> changes, and I'm pretty sure this was the case when we added
>> that ethtool API.
>
> It wasn't, but this should be OK.  Userland is supposed to query the
> number of features using ETHTOOL_GSSET_INFO and then work out the number
> of words/blocks using FEATURE_BITS_TO_BLOCKS().  


Looking at
http://cgit.freedesktop.org/NetworkManager/NetworkManager/tree/src/platform/nm-linux-platform.c#n1025
there seems to be a couple of bugs in this area. This is certainly
abusing the exported API, but it does mean that NM breaks if you ever
move NETIF_F_VLAN_CHALLENGED (like the 802.1ad patch did):

----
#define NETIF_F_VLAN_CHALLENGED (1 << 10)

static gboolean
link_supports_vlans (NMPlatform *platform, int ifindex)
{
	auto_nl_object struct rtnl_link *rtnllink = link_get (platform, ifindex);
	const char *name = nm_platform_link_get_name (ifindex);
	struct {
		struct ethtool_gfeatures features;
		struct ethtool_get_features_block features_block;
	} edata = { .features = { .cmd = ETHTOOL_GFEATURES, .size = 1 } };

	/* Only ARPHRD_ETHER links can possibly support VLANs. */
	if (!rtnllink || rtnl_link_get_arptype (rtnllink) != ARPHRD_ETHER)
		return FALSE;

	if (!name || !ethtool_get (name, &edata))
		return FALSE;

	return !(edata.features.features[0].active & NETIF_F_VLAN_CHALLENGED);
}
----


Not that I see how this particular bug matters unless you need VLAN
support in NM.  But there could be similar issues around.  I guess
avoiding unnecessary renumbering of the NETIF_F bits can save us some
trouble.  Although you can certainly argue that those bits never were
intended to be part of the API, and that using them like this is a user
application bug.



Bjørn
