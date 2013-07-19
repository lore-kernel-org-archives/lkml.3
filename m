Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab3GSMIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3GSMIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:08:13 -0400
Date: Fri, 19 Jul 2013 14:11:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
Message-ID: <20130719121102.GB1570@redhat.com>
References: <51E4501D.3010001@odi.ch>
 <20130716065626.GA1587@redhat.com>
 <51E4F790.6090308@odi.ch>
 <51E51712.4020609@broadcom.com>
 <51E58FA5.4000804@odi.ch>
 <20130717122944.GA25894@redhat.com>
 <51E6E1AB.5010300@odi.ch>
 <20130718105550.GA4628@redhat.com>
 <51E83AB7.6020002@odi.ch>
 <20130719120842.GA1570@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130719120842.GA1570@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 19, 2013 at 02:08:42PM +0200, Stanislaw Gruszka wrote:
> On Thu, Jul 18, 2013 at 08:57:59PM +0200, Ortwin Glück wrote:
> > On 07/18/2013 12:55 PM, Stanislaw Gruszka wrote:
> > >objdump -r -d --prefix-addresses net/mac80211/mac80211.ko > mac80211.txt
> > >objdump -r -d --prefix-addresses drivers/net/wireless/iwlwifi/dvm/iwldvm.ko > iwldvm.txt
> > 
> > Here you go. Please note, that the offsets have changed due to
> > .config changes. New trace attached. Transcript:
> > 
> > iwlagn_mac_remove_interface+0x5f/0x160
> > __ieee80211_suspend+0x4a1/0xb30
> > ieee80211_suspend+0x1a/0x20
> 
> Crash happen because we call iwlagn_mac_remove_interface with
> vif_priv->ctx NULL. I do not see any possibility of that other than
> doing ->remove_interface without previous ->add_interface, but I do
> not see how that possible. 
> 
> Does crash happen on any suspend or on second one ?  
> 
> I'm attaching patch, which should prevent crash (but not fix the issue,
> just workaround it), plese apply it. If it make suspend work, please then
> reload iwlwifi module with debug=0x3 option, suspend/resume machine and
> provide dmesg output after that.

This time really attaching forgotten patch.

Stanislaw

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwlwifi_check_ctx_null.patch"

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index cab23af..7f25fe1 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1536,6 +1536,9 @@ static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
+	if (WARN(ctx == NULL, "remove interface with NULL ctx\n"))
+		return;
+
 	mutex_lock(&priv->mutex);
 
 	if (WARN_ON(ctx->vif != vif)) {

--AhhlLboLdkugWU4S--
