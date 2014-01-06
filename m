Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaAFOBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:01:25 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58836 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAFOBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:01:05 -0500
Date: Mon, 6 Jan 2014 15:01:03 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: BUG: build fail due to dependency issue (LIB80211_CRYPT_* failed to
 depend on LIB80211)
Message-ID: <20140106140103.GA24241@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just had the following non-satisfactory build result here
(read: caused sizeable waste of time):


  SORTEX  vmlinux
  SYSMAP  System.map
  Building modules, stage 2.
  MODPOST 210 modules
ERROR: "lib80211_unregister_crypto_ops" [net/wireless/lib80211_crypt_wep.ko] undefined!
ERROR: "lib80211_register_crypto_ops" [net/wireless/lib80211_crypt_wep.ko] undefined!
ERROR: "lib80211_unregister_crypto_ops" [net/wireless/lib80211_crypt_tkip.ko] undefined!
ERROR: "lib80211_register_crypto_ops" [net/wireless/lib80211_crypt_tkip.ko] undefined!
ERROR: "lib80211_unregister_crypto_ops" [net/wireless/lib80211_crypt_ccmp.ko] undefined!
ERROR: "lib80211_register_crypto_ops" [net/wireless/lib80211_crypt_ccmp.ko] undefined!
make[5]: *** [__modpost] Error 1
make[4]: *** [modules] Error 2



This is due to net/wireless/Kconfig:


config LIB80211
        tristate
        default n
        help
          This options enables a library of common routines used
          by IEEE802.11 wireless LAN drivers.

          Drivers should select this themselves if needed.

config LIB80211_CRYPT_WEP
        tristate

config LIB80211_CRYPT_CCMP
        tristate

config LIB80211_CRYPT_TKIP
        tristate

config LIB80211_DEBUG
        bool "lib80211 debugging messages"
        depends on LIB80211
        default n
        ---help---
          You can enable this if you want verbose debugging messages
          from lib80211.


A
    make menuconfig
showed these three crypt options rather very prominently,
yet with entry of LIB80211 proper nowhere to be seen,
thus it was very easy to fall into the trap of "enabling"
various crypto options, thereby "enabling" nice ultimate build failure.

And as you can see above as well, LIB80211_DEBUG decided to be
a law-abiding citizen, by caring to announce a proper dependency on LIB80211.


Happened on OpenWrt's 3.10.24, and verified Kconfig status to still be identical on linux trunk.

Thanks,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
