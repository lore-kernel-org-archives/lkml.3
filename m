Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3JJQuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:50:40 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37337 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3JJQuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:50:39 -0400
Date: Thu, 10 Oct 2013 10:50:24 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Fuchs, Andreas" <andreas.fuchs@sit.fraunhofer.de>
Cc: Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [TrouSerS-tech] [tpmdd-devel] [PATCH 09/13] tpm: Pull everything
 related to sysfs into tpm-sysfs.c
Message-ID: <20131010165024.GA19997@obsidianresearch.com>
References: <5240BA0E.3000304@tycho.nsa.gov>
 <20130923222324.GA9533@obsidianresearch.com>
 <5241A199.1080505@tycho.nsa.gov>
 <20130930181005.GG28898@obsidianresearch.com>
 <5249E0CB.2070106@tycho.nsa.gov>
 <5249F6AF.7050608@linux.vnet.ibm.com>
 <20131004170803.GB6955@obsidianresearch.com>
 <9F48E1A823B03B4790B7E6E69430724D2E99F4E9@EXCH2010A.sit.fraunhofer.de>
 <20131009173847.GC18899@obsidianresearch.com>
 <9F48E1A823B03B4790B7E6E69430724D2E99FB07@EXCH2010A.sit.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724D2E99FB07@EXCH2010A.sit.fraunhofer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:42:49AM +0000, Fuchs, Andreas wrote:

> In any case, I like your idea to split trousers IPC to two distinct
> unix sockets for localities. In this case, we could also split tcsd
> into two processes along with it for accessing the distinct
> char-devices and thereby make it more robust against bugs for
> "locality-escalation".

You still have to somehow manage cross locality state between the two
daemons..
 
> Also remember that many people have developed alternative stacks
> that don't use trousers but operate directly on the char-device.
> They would also benefit from char-device access control for localities.

I am one of those people, we actually don't use any middleware at
all. But to make that work I've had to carry the multi-open patch for
years :|

> Even with only a single trousers, I see no harm in two devices. For
> backwards compatibility, the current /dev/tpm0 could be exported (with
> highest level access control) along with tpm0l1, tpm0l2, ... and/or 
> trousers could open both char-devices if it wanted to.

Well, we could start with a 'no way out IOCTL'. So trousers can open
/dev/tpm twice and lock the two FDs to a specific locality then drop
privileges and fork priv-sep style sub processes.

The current kernel code is not ready for multiple char devices, it
will need a device class first..

> The kernel may want to use localityAtRelease OS in order to protect sealed
> data (trusted keyrings) such that user-space could not even unseal

It seems reasonable to have TPM data that will only live in the kernel
to be only releasable by the kernel..

Jason
