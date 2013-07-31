Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556Ab3GaQCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:02:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:31459 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab3GaQCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:02:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,788,1367996400"; 
   d="scan'208";a="339618818"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Shuah Khan <shuah.kh@samsung.com>
CC: Greg KH <gregkh@linuxfoundation.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konstantin Khlebnikov" <khlebnikov@openvz.org>
Subject: RE: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-Topic: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-Index: AQHOjRXXO1QsMPwzCEeJTRhZuUOzTZl+8h3A
Date: Wed, 31 Jul 2013 16:01:43 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE7A1F2@HASMSX106.ger.corp.intel.com>
References: <1375182711-10253-1-git-send-email-tomas.winkler@intel.com>
 <20130730142209.GA28956@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE783C8@HASMSX106.ger.corp.intel.com>
 <B8EFE96D1287C24090BAD9D858E15E6174EAFA@sisaex01sj>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE7868F@HASMSX106.ger.corp.intel.com>
 <B8EFE96D1287C24090BAD9D858E15E6174F3DA@sisaex01sj>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6174F3DA@sisaex01sj>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On 07/30/2013 01:30 PM, Winkler, Tomas wrote:
> >
> >>
> >   >>> Both H_IS and H_IE needs to be set to receive H_RDY interrupt
> >>>>>
> >>>>> 1. Assert H_IS to clear the interrupts during hw reset and use
> >>>>> mei_me_reg_write instead of mei_hcsr_set as the later strips down
> >>>>> the H_IS
> >>>>>
> >>>>> 2. fix interrupt disablement embarrassing typo
> >>>>>     hcsr |= ~H_IE -> hcsr &= ~H_IE; this will remove the unwanted
> >>>>> interrupt on power down
> >>>>>
> >>>>> 3. remove useless debug print outs
> >>>>>
> >>>>> Cc: Shuah Khan <shuah.kh@samsung.com>
> >>>>> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> >>>>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >>>>> ---
> >>>>>
> >>>>> V2: Fixed typo in Shuah email
> >>>>>
> >>>>> Hope this finally resolve the ME reset issue for all
> >>>>
> >>>> Can I get a "Tested-by:" from someone to ensure that it really does
> >>>> solve the problem?
> >>>
> >>> Yes,  please wait for ack/test results. It works for me but
> >>> unfortunately I
> >> cannot go over all  9 gens of  PCH and all their proliferations
> >> where ME resides.
> >>> I'm putting some effort to have better legacy HW testing coverage
> >>> but I'm
> >> not there yet.
> >>>
> >>
> >> Tomas,
> >>
> >> I have a test system that has shows the mei_me reset problem after
> >> boot- up. I tested this patch on top of 3.11-rc3 that has the
> >> previous 4 patches. I am seeing the issue still on this system:
> >>
> >> 00:03.0 Communication controller: Intel Corporation 82Q963/Q965 HECI
> >> Controller (rev 02)
> >>           Subsystem: Hewlett-Packard Company Device 2801
> >>           Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> >> ParErr- Stepping- SERR- FastB2B- DisINTx+
> >>           Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >> >TAbort-
> >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>           Latency: 0
> >>           Interrupt: pin A routed to IRQ 41
> >>           Region 0: Memory at f0521900 (64-bit, non-prefetchable) [size=16]
> >>           Capabilities: <access denied>
> >>           Kernel driver in use: mei_me
> >>
> >>
> >> I am attaching the dmesg. Please let me know if you need any more
> >> information from the system.
> >
> > I'm not sure this error though looks similar is coming from the same source,
> this is even after boot up, which  I haven't seen before.
> > Would it be possible you open more logs through dynamic debug on mei
> > and mei_me modules To preserve it over reboot I add it into
> > /etc/modprobe.d/mei.conf options mei dyndbg="+plf"
> > options mei_me dyndbg="+plf"
> >
> > Thanks
> > Tomas
> >
> 
> Tomas,
> 
> I tested the patch on the system I saw this problem during suspend/resume
> sequence. After 10 suspend-to-disk reboot mode and 10 suspend-to-disk
> platform mode tests, I couldn't reproduce the problem.
> So does this mean the problem went away. I don't know. With all your fixes I
> no longer can reproduce the problem during suspend/resume sequence. I
> used to see once every 3 or 4 suspend-to-resume attempts on this system.
> 
> The second machine I have I see the problem often during run-time and that
> has nothing to do with suspend/resume. I will get the dyndbg data you asked
> for from that system.
> 
> You have my Tested-by for the original suspend/resume problem I reported

Thanks very much for your effort!!!
I'm really curious for the second machine output.

Thanks
Tomas

