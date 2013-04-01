Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3DAPKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:10:25 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:53381 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab3DAPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:10:23 -0400
Message-ID: <1364829008.3617.21.camel@thor.lan>
Subject: Re: n_tty_write() going into schedule but NOT coming out
From: Peter Hurley <peter@hurleysoftware.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>
Date: Mon, 01 Apr 2013 11:10:08 -0400
In-Reply-To: <5159925B.5050806@synopsys.com>
References: <5156DC21.20901@synopsys.com> <5159925B.5050806@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 19:27 +0530, Vineet Gupta wrote:
> Hi,
> 
> Any thoughts: I observe the same issue even with CONFIG_PREEMPT and
> CONFIG_PREEMPT_COUNT
> 
> -Vineet
> 
> On 03/30/2013 06:05 PM, Vineet Gupta wrote:
> > Hi,
> > 
> > I've been stress testing ARC Linux 3.8 (same happens for 3.9-rc3 as well). The
> > setup has 3 telnet sessions, each running find . -name "*" in a loop.
> > The platform is a FPGA @ 80 MHz, running a single core ARC700 so kernel .config
> > has !SMP and PREEMPT_NONE.
> > 
> > After ~10 mins of run, I see that one of the telnet session gets stuck (and later
> > the 2nd one as well), while system is still alive, 3rd telnet is running find merrily.
> > 
> > [ARCLinux]$ ps
> > ....
> >     7 root       0:00 inetd
> >    62 root       0:00 -/bin/sh
> >    64 root       1:34 telnetd -i -l /bin/sh
> >    65 root       0:00 /bin/sh
> >    75 root       1:47 telnetd -i -l /bin/sh
> >    76 root       0:00 /bin/sh
> >    79 root       0:53 telnetd -i -l /bin/sh
> >    80 root       0:00 /bin/sh
> >   281 root       0:00 find / -name *	<--- stuck
> >   358 root       0:03 find / -name *	<--- stuck
> >   377 root       0:00 find / -name *
> >   378 root       0:00 ps
> > 
> > Hung find task is sitting in the schedule() call in n_tty_write()
> > 
> > [ARCLinux]$ cat /proc/281/stack
> > [<8065945e>] n_tty_write+0x23a/0x424
> > [<80655cd4>] tty_write+0x1ac/0x2d4
> > [<805976ba>] vfs_write+0x92/0x110
> > [<80597816>] sys_write+0x4e/0x88
> > [<8050e780>] ret_from_system_call+0x0/0x4

Likely the writer is stuck because the receive buffer is full and the
reader is hung. What are the respective shells and telnetd doing?

Regards,
Peter Hurley

PS - include the controlling tty column in your ps output :)




