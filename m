Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbbAUA0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:26:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:42251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbAUA0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:26:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,438,1418112000"; 
   d="scan'208";a="515136257"
From: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hayato Momma <h-momma@ce.jp.nec.com>
Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
	mode control
Thread-Topic: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast
 promiscuous	mode control
Thread-Index: AQHQNQsmhwpg0uFhykOk7liG8gdn8pzJslcQ
Date: Wed, 21 Jan 2015 00:26:17 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF222866469129B7F5@ORSMSX110.amr.corp.intel.com>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>
	<874mrlu18e.fsf@nemi.mork.no>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
In-Reply-To: <7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0L0QSmt016208



> -----Original Message-----
> From: Hiroshi Shimamoto [mailto:h-shimamoto@ct.jp.nec.com]
> Sent: Tuesday, January 20, 2015 3:40 PM
> To: BjÃ¸rn Mork
> Cc: e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; Choi, Sy
> Jong; linux-kernel@vger.kernel.org; Hayato Momma
> Subject: Re: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
> mode control
> 
> > Subject: Re: [PATCH 1/2] if_link: Add VF multicast promiscuous mode
> > control
> >
> > Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:
> >
> > > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > >
> > > Add netlink directives and ndo entry to control VF multicast promiscuous
> mode.
> > >
> > > Intel ixgbe and ixgbevf driver can handle only 30 multicast MAC
> > > addresses per VF. It means that we cannot assign over 30 IPv6
> > > addresses to a single VF interface on VM. We want thousands IPv6
> addresses in VM.
> > >
> > > There is capability of multicast promiscuous mode in Intel 82599 chip.
> > > It enables all multicast packets are delivered to the target VF.
> > >
> > > This patch prepares to control that VF multicast promiscuous
> functionality.
> >
> > Adding a new hook for this seems over-complicated to me.  And it still
> > doesn't solve the real problems that
> >  a) the user has to know about this limit, and
> >  b) manually configure the feature
> >
> > Most of us, lacking the ability to imagine such arbitrary hardware
> > limitations, will go through a few hours of frustrating debugging
> > before we figure this one out...
> >
> > Why can't the ixgbevf driver just automatically signal the ixgbe
> > driver to enable multicast promiscuous mode whenever the list grows
> > past the limit?
> 
> I had submitted a patch to change ixgbe and ixgbevf driver for this issue.
> https://lkml.org/lkml/2014/11/27/269
> 
> The previous patch introduces API between ixgbe and ixgbevf driver to
> enable multicast promiscuous mode, and ixgbevf enables it automatically if
> the number of addresses is over than 30.

I believe the issue is with allowing a VF to automatically enter Promiscuous Multicast without the PF's ok is concern over VM isolation.   Of course that isolation, when it comes to multicast, is rather limited anyway given that our multicast filter uses only 12-bit of the address for a match.  Still this (or doing it by default) would only open that up considerably more (all multicasts).  I assume for your application you're not concerned, but are there other use cases that would worry about such things?

Thanks,
-Don Skidmore <donald.c.skidmore@intel.com>

> 
> I got some comment and I would like to clarify the point, but there was no
> answer.
> That's the reason I submitted this patch.
> 
> Do you think a patch for the ixgbe/ixgbevf driver is preferred?
> 
> 
> thanks,
> Hiroshi
> 
> >
> > I'd also like to note that this comment in
> > drivers/net/ethernet/intel/ixgbevf/vf.c
> > indicates that the author had some ideas about how more than 30
> > addresses could/should be handled:
> >
> > static s32 ixgbevf_update_mc_addr_list_vf(struct ixgbe_hw *hw,
> > 					  struct net_device *netdev)
> > {
> > 	struct netdev_hw_addr *ha;
> > 	u32 msgbuf[IXGBE_VFMAILBOX_SIZE];
> > 	u16 *vector_list = (u16 *)&msgbuf[1];
> > 	u32 cnt, i;
> >
> > 	/* Each entry in the list uses 1 16 bit word.  We have 30
> > 	 * 16 bit words available in our HW msg buffer (minus 1 for the
> > 	 * msg type).  That's 30 hash values if we pack 'em right.  If
> > 	 * there are more than 30 MC addresses to add then punt the
> > 	 * extras for now and then add code to handle more than 30 later.
> > 	 * It would be unusual for a server to request that many multi-cast
> > 	 * addresses except for in large enterprise network environments.
> > 	 */
> >
> >
> >
> > The last 2 lines of that comment are of course totally bogus and
> > pointless and should be deleted in any case...  It's obvious that 30
> > multicast addresses is ridiculously low for lots of normal use cases.
> >
> >
> > BjÃ¸rn

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
