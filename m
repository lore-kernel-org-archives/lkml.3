Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3L2W2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 17:28:09 -0500
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:44259 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752469Ab3L2W2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 17:28:07 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:2:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2194:2199:2393:2559:2562:2691:2828:2890:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4042:4117:4225:4321:4362:5007:7652:9010:10004:10848:11026:11232:11657:11658:11914:12043:12296:12438:12485:12517:12519:12555:12663:12731:12737:12740:13018:13019:13138:13161:13229:13231,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pet37_c3874e538c30
X-Filterd-Recvd-Size: 6774
Message-ID: <1388356082.26796.6.camel@joe-AO722>
Subject: Re: [PATCH net-next 19/20] net: plip: slight optimization of addr
 compare
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 29 Dec 2013 14:28:02 -0800
In-Reply-To: <alpine.DEB.2.02.1312292257250.2009@localhost6.localdomain6>
References: <52BD22ED.4030302@huawei.com>
	 <1388159283.12212.80.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1388163982.30298.12.camel@joe-AO722>
	 <alpine.DEB.2.02.1312272112110.2018@localhost6.localdomain6>
	 <1388177217.30298.24.camel@joe-AO722>
	 <alpine.DEB.2.02.1312292257250.2009@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-29 at 23:05 +0100, Julia Lawall wrote:
> After some work on getting more include files to be taken into account, I 
> get the following list of cases where both arguments have the form of a 
> field reference, the field has array type, and the field is not at the end 
> of the structure.  I guess these are all candidates for 
> ether_addr_equal_64bits (assuming that they correctly do satisfy these 
> properties)?

I believe yes.

> There seem to also be quite a number of comparisons that use memcmp rather 
> than ether_addr_equal.

Ding's patch series converts all the memcmp(e1, e1, \(ETH_ALEN\|6\))
via spatch to either ether_addr_equal or ether_addr_equal_unaligned.

I believe he's inspecting the sites to determine if the
conversion should use the _unaligned version.

> It seems that using ether_addr_equal would require 
> knowing about alignment.  In some cases, the structure field declaration 
> explicitly mentions alignment.  I'm not sure how to be sure that it holds 
> otherwise.  In particular, many of the relevant structures are declared as 
> __packed.  Perhaps that is also an issue for using 
> ether_addr_equal_64bits?

No, not really, the packing really doesn't matter, just
whether or not there are 2 more addressable bytes after
the u8 array[6].

Thanks for the list Julia.

> From linux-next of 20131224.
> 
> file drivers/scsi/fcoe/fcoe_ctlr.c on line 1524
> file drivers/scsi/fcoe/fcoe_ctlr.c on line 1528
> file drivers/scsi/fcoe/fcoe_ctlr.c on line 342
> file drivers/scsi/fcoe/fcoe_ctlr.c on line 1042
> file drivers/scsi/fcoe/fcoe_sysfs.c on line 660
> file drivers/scsi/fcoe/fcoe.c on line 1465
> file drivers/net/wireless/rtlwifi/ps.c on line 926
> file drivers/net/wireless/rtlwifi/ps.c on line 481
> file drivers/net/wireless/rtlwifi/base.c on line 1296
> file drivers/net/wireless/rtlwifi/base.c on line 1784
> file drivers/net/wireless/p54/txrx.c on line 311
> file drivers/net/wireless/rt2x00/rt2x00dev.c on line 568
> file drivers/net/wireless/rt2x00/rt2x00dev.c on line 571
> file drivers/net/wireless/ipw2x00/libipw_rx.c on line 1471
> file drivers/net/wireless/ath/carl9170/rx.c on line 605
> file drivers/net/wireless/ath/carl9170/rx.c on line 606
> file drivers/net/wireless/ath/carl9170/rx.c on line 539
> file drivers/net/wireless/ath/ath9k/htc_drv_txrx.c on line 1080
> file drivers/net/wireless/ath/ath9k/recv.c on line 985
> file drivers/net/wireless/ath/ath5k/base.c on line 1248
> file drivers/net/wireless/ath/ath5k/base.c on line 1312
> file drivers/net/wireless/iwlegacy/3945.c on line 472
> file drivers/net/wireless/iwlegacy/3945.c on line 469
> file drivers/net/wireless/iwlegacy/common.c on line 3749
> file drivers/net/wireless/iwlegacy/common.c on line 3750
> file drivers/net/wireless/iwlegacy/common.c on line 3751
> file drivers/net/wireless/mwl8k.c on line 1261
> file drivers/net/wireless/at76c50x-usb.c on line 1724
> file drivers/net/wireless/iwlwifi/dvm/rxon.c on line 878
> file drivers/net/wireless/iwlwifi/dvm/rxon.c on line 879
> file drivers/net/wireless/iwlwifi/dvm/rxon.c on line 880
> file drivers/net/wireless/iwlwifi/dvm/rx.c on line 783
> file drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c on line 334
> file drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c on line 580
> file drivers/net/vxlan.c on line 1371
> file drivers/staging/slicoss/slicoss.c on line 790
> file drivers/staging/vt6656/wpactl.c on line 230
> file drivers/staging/vt6656/dpc.c on line 357
> file drivers/staging/vt6656/dpc.c on line 369
> file net/bluetooth/bnep/core.c on line 407
> file net/bluetooth/bnep/core.c on line 410
> file net/wireless/scan.c on line 636
> file net/wireless/mlme.c on line 561
> file net/wireless/mlme.c on line 575
> file net/wireless/mlme.c on line 588
> file net/hsr/hsr_framereg.c on line 88
> file net/hsr/hsr_framereg.c on line 187
> file net/hsr/hsr_framereg.c on line 90
> file net/hsr/hsr_framereg.c on line 178
> file net/802/stp.c on line 49
> file net/mac80211/tx.c on line 1693
> file net/mac80211/mesh.c on line 1055
> file net/mac80211/mesh.c on line 1005
> file net/mac80211/scan.c on line 187
> file net/mac80211/scan.c on line 188
> file net/mac80211/mlme.c on line 2584
> file net/mac80211/mlme.c on line 4036
> file net/mac80211/mlme.c on line 3827
> file net/mac80211/mlme.c on line 2784
> file net/mac80211/mlme.c on line 2814
> file net/mac80211/mlme.c on line 2217
> file net/mac80211/mlme.c on line 2245
> file net/mac80211/mlme.c on line 2708
> file net/mac80211/mlme.c on line 2712
> file net/mac80211/mlme.c on line 2695
> file net/mac80211/iface.c on line 288
> file net/mac80211/rx.c on line 1910
> file net/mac80211/rx.c on line 1641
> file net/mac80211/rx.c on line 1642
> file net/mac80211/rx.c on line 3104
> file net/mac80211/rx.c on line 2341
> file net/mac80211/rx.c on line 2521
> file net/mac80211/rx.c on line 2340
> file net/mac80211/rx.c on line 2335
> file net/mac80211/rx.c on line 3093
> file net/mac80211/rx.c on line 3111
> file net/mac80211/rx.c on line 3127
> file net/mac80211/rx.c on line 3137
> file net/mac80211/rx.c on line 3147
> file net/mac80211/rx.c on line 3168
> file net/mac80211/rx.c on line 3103
> file net/mac80211/rx.c on line 2146
> file net/mac80211/sta_info.c on line 416
> file net/mac80211/status.c on line 595
> file net/mac80211/ibss.c on line 1126
> file net/mac80211/ibss.c on line 1018
> file net/mac80211/ibss.c on line 1437




