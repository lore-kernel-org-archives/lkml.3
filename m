Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3JJHnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:43:55 -0400
Received: from mailext.sit.fraunhofer.de ([141.12.72.89]:59596 "EHLO
	mailext.sit.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JJHny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:43:54 -0400
From: "Fuchs, Andreas" <andreas.fuchs@sit.fraunhofer.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
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
Thread-Index: AQHOvin6u4AZ44bxRkKQOytGbazfOpnkqreAgAXjQSmAAgD+AIABCB4j
Date: Thu, 10 Oct 2013 07:42:49 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724D2E99FB07@EXCH2010A.sit.fraunhofer.de>
References: <5240A2A3.4040102@tycho.nsa.gov>
 <20130923204232.GB16345@obsidianresearch.com>
 <5240BA0E.3000304@tycho.nsa.gov>
 <20130923222324.GA9533@obsidianresearch.com>
 <5241A199.1080505@tycho.nsa.gov>
 <20130930181005.GG28898@obsidianresearch.com>
 <5249E0CB.2070106@tycho.nsa.gov> <5249F6AF.7050608@linux.vnet.ibm.com>
 <20131004170803.GB6955@obsidianresearch.com>
 <9F48E1A823B03B4790B7E6E69430724D2E99F4E9@EXCH2010A.sit.fraunhofer.de>,<20131009173847.GC18899@obsidianresearch.com>
In-Reply-To: <20131009173847.GC18899@obsidianresearch.com>
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

Hi Jason,

the Unix-Domain-Socket or DBus has actually been on my agenda for quite
some time now, as soon as I find some time or MScCS student for it.
If you know any... ;-)

In any case, I like your idea to split trousers IPC to two distinct unix sockets
for localities. In this case, we could also split tcsd into two processes 
along with it for accessing the distinct char-devices and thereby make it 
more robust against bugs for "locality-escalation".

Also remember that many people have developed alternative stacks
that don't use trousers but operate directly on the char-device.
They would also benefit from char-device access control for localities.

Even with only a single trousers, I see no harm in two devices. For
backwards compatibility, the current /dev/tpm0 could be exported (with
highest level access control) along with tpm0l1, tpm0l2, ... and/or 
trousers could open both char-devices if it wanted to.


One more usecase for localities inside the kernel:

The kernel may want to use localityAtRelease OS in order to protect sealed
data (trusted keyrings) such that user-space could not even unseal
those if they got the blob and the auth-secret; user-space malware. 
Without cap_compromise_kernel not even root could gain access in those cases...
(I honestly don't know, if current trusted keyring incorporate localityAtRelease
already, so never mind if I am just proposing implemented features)

Cheers,
Andreas





________________________________________
Von: Jason Gunthorpe [jgunthorpe@obsidianresearch.com]
Gesendet: Mittwoch, 9. Oktober 2013 19:38

On Tue, Oct 08, 2013 at 09:15:55AM +0000, Fuchs, Andreas wrote:

> Rather than an ioctl, why not provide a different tpm-device per
> locality. This way, the access to the different localities can be
> restricted via standard user/group of the device.  i.e. /dev/tpm0l1,
> /dev/tpm0l2, ... or similar approaches...

The way the TPM architecture is setup you will need the middle ware to
do the switching between localities and managing cross locality
resources, so it doesn't make sense for the kernel to export a
locality specific char device.

You'd have to do the above by having trousers create unix domain
sockets for each of the privilege levels and using the usual security
mechanisms to protect access to those sockets.

Jason
