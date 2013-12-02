Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3LBXfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:35:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:8315 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab3LBXfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:35:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,813,1378882800"; 
   d="scan'208";a="445630242"
From: "Fujinaka, Todd" <todd.fujinaka@intel.com>
To: Nick Pegg <nick@nickpegg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: [E1000-devel] NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0
	timed out
Thread-Topic: [E1000-devel] NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0
	timed out
Thread-Index: AQHO77HPl9Q7B0xzyECmuqwXzbS+o5pBjmeQ
Date: Mon, 2 Dec 2013 23:34:28 +0000
Message-ID: <9B4A1B1917080E46B64F07F2989DADD6528F0CCC@ORSMSX102.amr.corp.intel.com>
References: <CAFi4uRvcUPvKvaeO5gZnjhMCFS+08MhEixJw-iN0AWbeBfiHvQ@mail.gmail.com>
	<CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com>
 <CAFi4uRvm6Afag3_4LnEoHJ-WrtWPJLzTcqpia4mr_tCfUEpZeg@mail.gmail.com>
In-Reply-To: <CAFi4uRvm6Afag3_4LnEoHJ-WrtWPJLzTcqpia4mr_tCfUEpZeg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having difficulty following this issue, most likely because of our email system. Can you file a new bug on sourceforge?

Thanks.

Todd Fujinaka
Software Application Engineer
Networking Division (ND)
Intel Corporation
todd.fujinaka@intel.com
(503) 712-4565


-----Original Message-----
From: Nick Pegg [mailto:nick@nickpegg.com] 
Sent: Monday, December 02, 2013 2:57 PM
To: linux-kernel@vger.kernel.org; e1000-devel@lists.sourceforge.net
Subject: Re: [E1000-devel] NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out

> Intel maintains newer drivers out-of-tree at 
> http://sourceforge.net/projects/e1000/, and it's possible this is some 
> bug that has already been fixed.  The current version there looks like 
> e1000e-2.5.4, released 2013-09-05.
>
> Possible similar report: http://sourceforge.net/p/e1000/bugs/367/ (no 
> real data there).

I've looked through the existing bug reports and version changelogs and didn't see anything that seemed very relevant.

I was able to debug the e1000e object file and get the specific code that's bugging out after the interface is unexpectedly reset:
--------
(gdb) l *e1000_clean_rx_irq+0x101
0x19d81 is in e1000_clean_rx_irq
(drivers/net/ethernet/intel/e1000e/netdev.c:933).
928                     rmb();  /* read descriptor and rx_buffer_info
after status DD */
929
930                     skb = buffer_info->skb;
931                     buffer_info->skb = NULL;
932
933                     prefetch(skb->data - NET_IP_ALIGN);
934
935                     i++;
936                     if (i == rx_ring->count)
937                             i = 0;
--------

The above code is from kernel version 3.9.2 and e1000e driver version 2.2.14-k. Should there be a check here to see if skb is NULL? I checked the latest e1000e release (2.5.4) and there is no check there either (near netdev.c:994).

------------------------------------------------------------------------------
Rapidly troubleshoot problems before they affect your business. Most IT organizations don't have a clear picture of how application performance affects their revenue. With AppDynamics, you get 100% visibility into your Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
http://pubads.g.doubleclick.net/gampad/clk?id=84349351&iu=/4140/ostg.clktrk
_______________________________________________
E1000-devel mailing list
E1000-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/e1000-devel
To learn more about Intel&#174; Ethernet, visit http://communities.intel.com/community/wired
