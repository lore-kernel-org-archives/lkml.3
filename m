Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaJIIb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:31:29 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:56971 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaJIIbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:31:21 -0400
Message-ID: <1412843479.1828.22.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 4/4] nl80211: Join and Leave handling for OCB mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 09 Oct 2014 10:31:19 +0200
In-Reply-To: <1410445822-6559-5-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140911_163052_322975_2F1DAFAB)
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163052_322975_2F1DAFAB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:30 +0200, Rostislav Lisovy wrote:
> Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>

same comment about commit log here - also this patch should either go
first in the series, or just be squashed with the cfg80211 patch,
there's no real need to distinguish between the two. I guess it can't be
first, so best just squash it.

I think you can also squash patches 1 and 2, since 2 is so small.

> ---
>  include/uapi/linux/nl80211.h |  8 ++++++++
>  net/wireless/nl80211.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index cdf9ba4..4b39455 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -544,6 +544,11 @@
>   * @NL80211_CMD_LEAVE_MESH: Leave the mesh network -- no special arguments, the
>   *	network is determined by the network interface.
>   *
> + * @NL80211_CMD_JOIN_OCB: Join the OCB network. The center frequency and
> + *	bandwidth of a channel must be given.
> + * @NL80211_CMD_LEAVE_OCB: Leave the OCB network -- no special arguments, the
> + *	network is determined by the network interface.
> + *
>   * @NL80211_CMD_UNPROT_DEAUTHENTICATE: Unprotected deauthentication frame
>   *	notification. This event is used to indicate that an unprotected
>   *	deauthentication frame was dropped when MFP is in use.
> @@ -833,6 +838,9 @@ enum nl80211_commands {
>  	NL80211_CMD_JOIN_MESH,
>  	NL80211_CMD_LEAVE_MESH,
>  
> +	NL80211_CMD_JOIN_OCB,
> +	NL80211_CMD_LEAVE_OCB,
> +
>  	NL80211_CMD_UNPROT_DEAUTHENTICATE,
>  	NL80211_CMD_UNPROT_DISASSOCIATE,

No no, you really really really can't add anything in the middle of this
enum. The's a comments at the top of it explaining why :)

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index cf178d2..bfbb54d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1876,6 +1876,7 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
>  	 * operation to set the monitor channel if possible.
>  	 */
>  	return !wdev ||
> +		wdev->iftype == NL80211_IFTYPE_OCB ||
>  		wdev->iftype == NL80211_IFTYPE_AP ||
>  		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
>  		wdev->iftype == NL80211_IFTYPE_MONITOR ||

I don't think this is right - join() handles the channel setting.

> @@ -2307,6 +2308,8 @@ static int nl80211_send_chandef(struct sk_buff *msg,
>  			chandef->chan->center_freq))
>  		return -ENOBUFS;
>  	switch (chandef->width) {
> +	case NL80211_CHAN_WIDTH_5:
> +	case NL80211_CHAN_WIDTH_10:

This is also wrong, just like the cfg80211.h change in the other patch,
since the NL80211_ATTR_WIPHY_CHANNEL_TYPE cannot encode 5/10 MHz.

You need to remove both changes.

> +static int nl80211_join_ocb(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct ocb_setup setup;
> +	int err;
> +
> +	/* start with default */
> +	memset(&setup, 0x0, sizeof(setup));

struct ocb_setup setup = {};

Would be an easier way to generate the same code. IMHO no comment is
needed.

johannes

