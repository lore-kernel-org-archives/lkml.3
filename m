Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3CNT3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:29:05 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2768 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3CNT3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:29:03 -0400
Message-ID: <1363288671.12845.235.camel@misato.fc.hp.com>
Subject: Re: ACPI undocking on 3.8-rc5 no longer works with Lenovo T61
From: Toshi Kani <toshi.kani@hp.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com,
        rafael.j.wysocki@intel.com
Date: Thu, 14 Mar 2013 13:17:51 -0600
In-Reply-To: <20130309214025.GC7559@khazad-dum.debian.net>
References: <5107A899.9080109@redhat.com> <51390B2B.6070500@redhat.com>
	 <1362695426.12845.144.camel@misato.fc.hp.com>
	 <20130309214025.GC7559@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-09 at 18:40 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 07 Mar 2013, Toshi Kani wrote:
> > dock.0 on your Lenovo likely shows as "battery_bay", which I think you
> > cannot undock regardless of this patch.  Can you try to undock the one
> 
> You're supposed to be able to undock any thinkpad battery just fine, and it
> used to work on older firmware such as the one in the T61.  If this is
> broken, some other bugs may be at play.

Agreed.  Let's look at the error messages...

Dne 29.1.2013 11:46, Zdenek Kabelac napsal(a):
> Dmesg shows this:
>
> [ 2657.087414] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: undocking

The dock driver called _DCK, which was successful.  So, the dock driver
did its job.

> [ 2658.613494] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action
0x6 frozen

This message came from ata_eh_link_report(), which indicates that there
was an ATA link error detected.

> [ 2658.613508] ata4.00: ST_FIRST: !(DRQ|ERR|DF)
> [ 2658.613522] sr 3:0:0:0: CDB:
> [ 2658.613530] Get event status notification: 4a 01 00 00 10 00 00 00
08 00
> [ 2658.613583] ata4.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio
> 16392 in
>           res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM
violation)
> [ 2658.613670] ata4: soft resetting link
> [ 2658.766888] ata4.00: NODEV after polling detection

This indicates that the target device, which I think the battery bay,
was gone.

> [ 2658.766900] ata4.00: revalidation failed (errno=-2)
>

So, it looks to me that the battery bay was undocked, but an ATA link
error was detected.  This could be either a new FW causing the ATA link
error or the ATA stack detecting the link error which didn't before.

Thanks,
-Toshi

