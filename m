Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3LBW5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:57:23 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:45146 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LBW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:57:22 -0500
MIME-Version: 1.0
X-Originating-IP: [173.161.199.49]
In-Reply-To: <CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com>
References: <CAFi4uRvcUPvKvaeO5gZnjhMCFS+08MhEixJw-iN0AWbeBfiHvQ@mail.gmail.com>
 <CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com>
From: Nick Pegg <nick@nickpegg.com>
Date: Mon, 2 Dec 2013 17:57:01 -0500
Message-ID: <CAFi4uRvm6Afag3_4LnEoHJ-WrtWPJLzTcqpia4mr_tCfUEpZeg@mail.gmail.com>
Subject: Re: NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Intel maintains newer drivers out-of-tree at
> http://sourceforge.net/projects/e1000/, and it's possible this is some
> bug that has already been fixed.  The current version there looks like
> e1000e-2.5.4, released 2013-09-05.
>
> Possible similar report: http://sourceforge.net/p/e1000/bugs/367/ (no
> real data there).

I've looked through the existing bug reports and version changelogs
and didn't see anything that seemed very relevant.

I was able to debug the e1000e object file and get the specific code
that's bugging out after the interface is unexpectedly reset:
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

The above code is from kernel version 3.9.2 and e1000e driver version
2.2.14-k. Should there be a check here to see if skb is NULL? I
checked the latest e1000e release (2.5.4) and there is no check there
either (near netdev.c:994).
