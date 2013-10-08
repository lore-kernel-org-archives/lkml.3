Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3JHJjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:39:33 -0400
Received: from mailext.sit.fraunhofer.de ([141.12.72.89]:58702 "EHLO
	mailext.sit.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3JHJjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:39:31 -0400
X-Greylist: delayed 1361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 05:39:31 EDT
From: "Fuchs, Andreas" <andreas.fuchs@sit.fraunhofer.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Joel Schopp <jschopp@linux.vnet.ibm.com>
CC: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>, Sirrix AG <tpmdd@sirrix.com>
Subject: AW: [TrouSerS-tech] [tpmdd-devel] [PATCH 09/13] tpm: Pull
 everything related to sysfs into tpm-sysfs.c
Thread-Topic: [TrouSerS-tech] [tpmdd-devel] [PATCH 09/13] tpm: Pull
 everything related to sysfs into tpm-sysfs.c
Thread-Index: AQHOvin6u4AZ44bxRkKQOytGbazfOpnkqreAgAXjQSk=
Date: Tue, 8 Oct 2013 09:15:55 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724D2E99F4E9@EXCH2010A.sit.fraunhofer.de>
References: <52408E5D.4020904@tycho.nsa.gov>
	<20130923193633.GA9194@obsidianresearch.com>
	<5240A2A3.4040102@tycho.nsa.gov>
	<20130923204232.GB16345@obsidianresearch.com>
	<5240BA0E.3000304@tycho.nsa.gov>
	<20130923222324.GA9533@obsidianresearch.com>
	<5241A199.1080505@tycho.nsa.gov>
	<20130930181005.GG28898@obsidianresearch.com>
	<5249E0CB.2070106@tycho.nsa.gov>
	<5249F6AF.7050608@linux.vnet.ibm.com>,<20131004170803.GB6955@obsidianresearch.com>
In-Reply-To: <20131004170803.GB6955@obsidianresearch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.12.89.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some thoughts on those two questions:

1. Yes, userspace could be interested in setting TPM Localities specifically
for uses of PCR_Reset. For example a Browser could be interested in scheduling
Tabs in a PCR. For this it would reset the PCR and replay the old Extends when
switching a tab. Then the Tab could continue Extending on those pcrs.
Use cases may include any user-application that schedules children's tpm-access
via PCR_Reset...
The problem is, that whilst one process may be allowed to do so, another one may not.

2. This brings us to the problem of differentiating processes' access-rights
on the locality-feature and more specifically how to move this through the tcsd (as
another layer of abstraction). From a tpmdd perspective, if you provide localities,
you will not want to allow for everyone to just randomly set them. They actually
correspond to "capabilities" or access-rights on the TPM...

Random Proposal for discussion:
Rather than an ioctl, why not provide a different tpm-device per locality. This way, the
access to the different localities can be restricted via standard user/group of the device.
i.e. /dev/tpm0l1, /dev/tpm0l2, ... or similar approaches...

A privileged application may access /dev/tpm0l2 whilst another one only gets to l1...

Just some random thoughts, not well thought through though... ;-)

Cheers,
Andreas

________________________________________
Von: Jason Gunthorpe [jgunthorpe@obsidianresearch.com]
Gesendet: Freitag, 4. Oktober 2013 19:08
An: Joel Schopp
Cc: Leonidas Da Silva Barbosa; linux-kernel@vger.kernel.org; Rajiv Andrade; tpmdd-devel@lists.sourceforge.net; Richard Maciel Costa; trousers-tech@lists.sourceforge.net; Daniel De Graaf; Sirrix AG
Betreff: Re: [TrouSerS-tech] [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs into tpm-sysfs.c

On Mon, Sep 30, 2013 at 05:09:51PM -0500, Joel Schopp wrote:

> > So far, nobody I have talked to has offered any strong opinions on
> > what locality should be used or how it should be set. I think finding
> > a developer of trousers may be the most useful to talk about how the
> > ioctl portion of this would need to be set up - if someone is actually
> > needed.

> I am a TrouSerS developer and am ccing Richard, another TrouSerS
> developer, and ccing the trousers-tech list.  It would be good if you
> could elaborate on the question and context for those not following the
> entire thread, myself included.

Two questions:

Is userspace interested in using the TPM Locality feature, and if so
is there any thoughts on what the interface should be?

Is the kernel interested in using the TPM Locality feature? What for?

Jason

------------------------------------------------------------------------------
October Webinars: Code for Performance
Free Intel webinars can help you accelerate application performance.
Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most from
the latest Intel processors and coprocessors. See abstracts and register >
http://pubads.g.doubleclick.net/gampad/clk?id=60134791&iu=/4140/ostg.clktrk
_______________________________________________
TrouSerS-tech mailing list
TrouSerS-tech@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/trousers-tech
