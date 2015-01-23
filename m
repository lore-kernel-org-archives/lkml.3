Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbbAWAd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:33:29 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:62156 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbbAWAd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:33:26 -0500
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: David Laight <David.Laight@ACULAB.COM>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hayato Momma <h-momma@ce.jp.nec.com>
Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
 mode control
Thread-Topic: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast
 promiscuous mode control
Thread-Index: AQHQNnojft9AdafUtk2TcpSSX3pUk5zMEn2AgADAtGA=
Date: Fri, 23 Jan 2015 00:32:00 +0000
Message-ID: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0B6B1@BPXM14GP.gisp.nec.co.jp>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>
	<874mrlu18e.fsf@nemi.mork.no>
	<7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
	<F6FB0E698C9B3143BDF729DF222866469129B7F5@ORSMSX110.amr.corp.intel.com>
	<7F861DC0615E0C47A872E6F3C5FCDDBD05E07F09@BPXM14GP.gisp.nec.co.jp>
	<F6FB0E698C9B3143BDF729DF222866469129B844@ORSMSX110.amr.corp.intel.com>
	<7F861DC0615E0C47A872E6F3C5FCDDBD05E08FF6@BPXM14GP.gisp.nec.co.jp>
	<063D6719AE5E284EB5DD2968C1650D6D1CAD01D6@AcuExch.aculab.com>
	<7F861DC0615E0C47A872E6F3C5FCDDBD05E090FE@BPXM14GP.gisp.nec.co.jp>
	<F6FB0E698C9B3143BDF729DF222866469129BC03@ORSMSX110.amr.corp.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D1CAD0C8A@AcuExch.aculab.com>
	<F6FB0E698C9B3143BDF729DF222866469129BFFD@ORSMSX110.amr.corp.intel.com>
 <87bnlqpq6v.fsf@nemi.mork.no>
 <F6FB0E698C9B3143BDF729DF222866469129C09C@ORSMSX110.amr.corp.intel.com>
In-Reply-To: <F6FB0E698C9B3143BDF729DF222866469129C09C@ORSMSX110.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.205.5.123]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0N0XYlg030507

> Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous mode control
> >
> > "Skidmore, Donald C" <donald.c.skidmore@intel.com> writes:
> >
> > > My hang up is more related to: without the nob to enable it (off by
> > > default) we are letting one VF dictate policy for all the other VFs
> > > and the PF.  If one VF needs to be in promiscuous multicast so is
> > > everyone else.  Their stacks now needs to deal with all the extra
> > > multicast packets.  As you point out this might not be a direct
> > > concern for isolation in that the VM could have 'chosen' to join any
> > > Multicast group and seen this traffic.  My concern over isolation is
> > > one VF has chosen that all the other VM now have to see this multicast
> > > traffic.
> >
> > Apologies if this question is stupid, but I just have to ask about stuff I don't
> > understand...
> >
> > Looking at the proposed implementation, the promiscous multicast flag
> > seems to be a per-VF flag:
> >
> > +int ixgbe_ndo_set_vf_mc_promisc(struct net_device *netdev, int vf, bool
> > +setting) {
> > +	struct ixgbe_adapter *adapter = netdev_priv(netdev);
> > +	struct ixgbe_hw *hw = &adapter->hw;
> > +	u32 vmolr;
> > +
> > +	if (vf >= adapter->num_vfs)
> > +		return -EINVAL;
> > +
> > +	adapter->vfinfo[vf].mc_promisc_enabled = setting;
> > +
> > +	vmolr = IXGBE_READ_REG(hw, IXGBE_VMOLR(vf));
> > +	if (setting) {
> > +		e_info(drv, "VF %u: enabling multicast promiscuous\n", vf);
> > +		vmolr |= IXGBE_VMOLR_MPE;
> > +	} else {
> > +		e_info(drv, "VF %u: disabling multicast promiscuous\n", vf);
> > +		vmolr &= ~IXGBE_VMOLR_MPE;
> > +	}
> > +
> > +	IXGBE_WRITE_REG(hw, IXGBE_VMOLR(vf), vmolr);
> > +
> > +	return 0;
> > +}
> > +
> >
> > I haven't read the data sheet, but I took a quick look at the excellent high
> > level driver docs:
> > http://www.intel.com/content/dam/doc/design-guide/82599-sr-iov-driver-
> > companion-guide.pdf
> >
> > It mentions "Multicast Promiscuous Enable" in its "Thoughts for
> > Customization" section:
> >
> >  7.1 Multicast Promiscuous Enable
> >
> >  The controller has provisions to allow each VF to be put into Multicast
> > Promiscuous mode.  The Intel reference driver does not configure this
> > option .
> >
> >  The capability can be enabled/disabled by manipulating the MPE field  (bit
> > 28) of the PF VF L2 Control Register (PFVML2FLT â€“ 0x0F000)
> >
> > and showing a section from the data sheet describing the "PF VM L2 Control
> > Register - PFVML2FLT[n]  (0x0F000 + 4 * n, n=0...63; RW)"
> >
> > To me it looks like enabling Promiscuos Multicast for a VF won't affect any
> > other VF at all.  Is this really not the case?
> >
> >
> >
> > BjÃ¸rn
> 
> Clearly not a dumb question at all and I'm glad you mentioned that. :)  I was going off the assumption, been awhile since
> I read the patch, that the patch was using FCTRL.MPE or MANC.MCST_PASS_L2 which would turn multicast promiscuous on for
> everyone.  Since the patch is using PFVML2FLT.MPE this lessens my concern over effect on the entire system.

I believe the patches for this VF multicast promiscuous mode is per VF.

> 
> That said I still would prefer having a way to override this behavior on the PF, although I admit my argument is weaker.
> I'm still concerned about a VF changing the behavior of the PF without any way to prevent it.  This might be one part
> philosophical (PF sets policy not the VF) but this still could have a noticeable effect on the overall system.  If any
> other VFs (or the PF) are receiving MC packets these will have to be replicated which will be a performance hit.  When
> we use the MC hash this is limited vs. when anyone is in MC promiscuous every MC packet used by another pool would be
> replicated.  I could imagine in some environments (i.e. public clouds) where you don't trust what is running in your VM
> you might what to block this from happening.

I understand your request and I'm thinking to submit the patches
  1) Add new mbox API between ixgbe/ixgbevf to turn MC promiscuous on,
     and enables it when ixgbevf needs over 30 MC addresses.
  2) Add a policy knob to prevent enabling it from the PF.

Does it seem okay?

BTW, I'm bit worried about to use ndo interface for 2) because adding a
new hook makes core code complicated.
Is it really reasonable to do it with ndo?
I haven't find any other suitable method to do it, right now. And using
ndo VF hook looks standard way to control VF functionality.
Then, I think it's the best way to implement this policy in ndo hook.

> 
> In some ways it is almost the mirror image of the issue you brought up:
> 
> Adding a new hook for this seems over-complicated to me.  And it still
> doesn't solve the real problems that
>  a) the user has to know about this limit, and
>  b) manually configure the feature
> 
> My reverse argument might be that if this happens automatically.  It might take the VM provider a long time to realize
> performance has taken a hit because some VM asked to join 31 multicast groups and entered MC promiscuous.  Then only to
> find that they have no way to block such behavior.
> 
> Maybe I wouldn't as concerned if the patch author could provide some performance results to show this won't have as a
> negative effect as I'm afraid it might?

Hm, what kind of test case would you like to have?
The user A who has 30 MC addresses vs the user B who has 31 MC addresses, which
means that MC promiscuous mode, and coming MC packets the user doesn't expect?

thanks,
Hiroshi
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
