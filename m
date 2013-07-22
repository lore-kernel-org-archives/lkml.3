Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab3GVLTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:19:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab3GVLTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:19:42 -0400
Date: Mon, 22 Jul 2013 13:22:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
Message-ID: <20130722112236.GA7364@redhat.com>
References: <20130716065626.GA1587@redhat.com>
 <51E4F790.6090308@odi.ch>
 <51E51712.4020609@broadcom.com>
 <51E58FA5.4000804@odi.ch>
 <20130717122944.GA25894@redhat.com>
 <51E6E1AB.5010300@odi.ch>
 <20130718105550.GA4628@redhat.com>
 <51E83AB7.6020002@odi.ch>
 <20130719120842.GA1570@redhat.com>
 <51E9899E.3080307@odi.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51E9899E.3080307@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 19, 2013 at 08:46:54PM +0200, Ortwin Glück wrote:
> On 07/19/2013 02:08 PM, Stanislaw Gruszka wrote:
> >I'm attaching patch, which should prevent crash (but not fix the issue,
> >just workaround it), plese apply it. If it make suspend work, please then
> >reload iwlwifi module with debug=0x3 option, suspend/resume machine and
> >provide dmesg output after that.
> 
> 
> Here the requested dmesg. Please note that two different WARN_ONs
> trigger here directly after each other.
> 
> To me it looks like iwlagn_mac_remove_interface() is called twice,
> but I am not familiar with the code.

We remove interface that we do not add in the driver. I think I found
reason of that - I removed below code in bad commit:

        list_for_each_entry(sdata, &local->interfaces, list) {
[snip]
-               switch (sdata->vif.type) {
-               case NL80211_IFTYPE_AP_VLAN:
-               case NL80211_IFTYPE_MONITOR:
-                       /* skip these */
-                       continue;

Attached patch should correct that. Please test if it fixes the
crash.

Thanks
Stanislaw


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mac80211_fix_suspend_crash.patch"

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 7fc5d0d..3401262 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -99,10 +99,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	}
 	mutex_unlock(&local->sta_mtx);
 
-	/* remove all interfaces */
+	/* remove all interfaces that were created in the driver */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
+		if (!ieee80211_sdata_running(sdata) ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
+
 		drv_remove_interface(local, sdata);
 	}
 

--9jxsPFA5p3P2qPhR--
