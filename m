Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131Ab3GaJYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:24:50 -0400
Received: from mta2.perrit.net ([194.213.15.114]:38451 "EHLO mta2.perrit.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab3GaJYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:24:49 -0400
Message-ID: <1375262687.2540.26.camel@jazz.koekkoek>
Subject: Re: Link state change detection problem on Moschip MCS7832 again
From: Jeroen Koekkoek <jeroen@koekkoek.nl>
To: linux-kernel@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>
Date: Wed, 31 Jul 2013 11:24:47 +0200
In-Reply-To: <1375261905.2540.23.camel@jazz.koekkoek>
References: <50EFE644.3000904@linuxtv.org>
	 <1375261905.2540.23.camel@jazz.koekkoek>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 11:11 +0200, Jeroen Koekkoek wrote:
> On Fri, 2013-01-11 at 11:15 +0100, Michael Hunold wrote:
> > Hi,
> > 
> > I have a no-name Moschip MCS7832-based adapter shows a strange behaviour 
> > in my system after a system upgrade. "lsusb -vv" for that device is 
> > attached to the end of the mail.
> > 
> > I am using the adapter for embedded systems development, where it serves 
> > kernels via TFTP and root filesystems via NFS.
> > 
> > I have recently upgrade my system to Kubuntu 12.10 which uses a 3.5.0-21 
> > kernel. Before that upgrade the device was working fine with Xubuntu 10.10.
> > 
> > I have used the network-manager applet that comes with Kubuntu to assign 
> > a static IP address to that interface.
> > 
> > The symptom is that when the remote system's bootloader (u-boot in my 
> > case) starts to fetch the kernel via TFTP, it usually starts fine (a 
> > couple of "#" are shown to indicate progress), then timeouts are 
> > happening ("T" is shown), then progress continues, then more timeouts 
> > and so on.
> > 
> > I can see the following messages getting repeated in /var/log/syslog:
> > 
> > [...]
> > Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
> > now OFF (device state 100, deferring action for 4 seconds)
> > Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
> > now ON (device state 100)
> > [...]
> > 
> > I found the following bug report and this got me going:
> > https://bugzilla.kernel.org/show_bug.cgi?id=28532
> > 
> > Here is what I investigated so far.
> > 
> > 1. I noticed that the patch dabdaf0caa3af520dbc1df87b2fb4e77224037bd 
> > from Ondrej Zary is missing in the kernel Kubuntu is serving, so I 
> > downloaded the most-recent mcs7830.c from kernel.org and recompiled the 
> > module. The problem stays the same, there is no improvement.
> > 
> > 2. I undid both commits dabdaf0caa3af520dbc1df87b2fb4e77224037bd and 
> > b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113 which added the "mcs7830: 
> > Implement link state detection" in the first place. Without that 
> > "feature" my adapter is now working reliably again.
> > 
> > 3. Commit dabdaf0caa3af520dbc1df87b2fb4e77224037bd had the following 
> > comment:
> > 
> > "The device had an undocumented "feature": it can provide a sequence of
> > spurious link-down status data even if the link is up all the time.
> > A sequence of 10 was seen so update the link state only after the device
> > reports the same link state 20 times."
> > 
> > I tried to increase the number from 20 gradually, but it did not help to 
> > fix the problem. In my desparation I tried 100 as well, but this only 
> > postponed the
> > 
> > 4. In my desparation, I went back to the most recent driver and added 
> > the following code to mcs7830_status() in order to track after how many 
> > calls to that function the link state changes.
> > 
> > [...]
> > {
> > 	static int xxx_counter = 0;
> > 	static int xxx_link = -1;
> > 	if (link != xxx_link) {
> > 		printk("counter %4d -> link %d\n", xxx_counter, link);
> > 		xxx_link = link;
> > 		xxx_counter = 0;
> > 	} else {
> > 		xxx_counter++;
> > 	}
> > }
> > [...]
> > 
> > This resulted in the following output:
> > 
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.025109] counter  105 -> link 0
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.101840] counter   76 -> link 1
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.207724] counter  105 -> link 0
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.285582] counter   77 -> link 1
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.392416] counter  106 -> link 0
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.468149] counter   75 -> link 1
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.574036] counter  105 -> link 0
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.651893] counter   77 -> link 1
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.757719] counter  105 -> link 0
> > Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
> > now OFF (device state 100, deferring action for 4 seconds)
> > Jan 11 11:01:04 elmc-teemhu kernel: [11627.834546] counter   76 -> link 1
> > Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
> > now ON (device state 100)
> > Jan 11 11:01:05 elmc-teemhu kernel: [11627.939259] counter  104 -> link 0
> > Jan 11 11:01:05 elmc-teemhu kernel: [11628.018204] counter   78 -> link 1
> > 
> > So it seems the link state is constantly toggling and the network 
> > manager eventually picks that up and does some reconfiguratation to the 
> > network interface which disturbs both TFTP and NFS.
> > 
> > As I already said above, when I undo both commits then everything is 
> > working fine again. Network manager is not complaining any more and TFTP 
> > and NFS is working fine.
> > 
> > Any idea what is wrong with that adapter? Is it unable to report link 
> > state changes correctly at all?
> > 
> > How to make the current driver work correctly without reverting the two 
> > commit completly?
> > 
> > Best regards
> > Michael.
> 
> Hi,
> 
> I'm experiencing the same problem. After reverting the commits below, my
> problems disappeared.
> 
> commit b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113
> 	mcs7830: Implement link state detection
> 
> commit b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113
> 	mcs7830: Implement link state detection
> 
> I'm running Fedora 19 (Linux laptop.lan 3.10.3-300.fc19.x86_64 #1 SMP
> Fri Jul 26 00:00:58 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux).
> 
> Best regards,
> Jeroen Koekkoek
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Oops, forgot to mention that I'm using a MCS7830 based adapter, not a
MCS7832 based one.

Best,
Jeroen


