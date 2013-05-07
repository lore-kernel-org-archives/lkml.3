Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3EGAup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:50:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:36246 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122Ab3EGAun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:50:43 -0400
Message-ID: <1367887826.4484.2.camel@pasglop>
Subject: Re: [PATCH 1/2] PCI: Split pci_assign_unassigned_resources to per
 root bus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 10:50:26 +1000
In-Reply-To: <1367882130-19452-1-git-send-email-yinghai@kernel.org>
References: <1367882130-19452-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 16:15 -0700, Yinghai Lu wrote:
> BenH reported that there is some assign unassigned resource problem
> in powerpc.
> 
> It turns out after
> | commit 0c5be0cb0edfe3b5c4b62eac68aa2aa15ec681af
> | Date:   Thu Feb 23 19:23:29 2012 -0800
> |
> |    PCI: Retry on IORESOURCE_IO type allocations
> 
> even the root bus does not have io port range, it will keep retrying
> to realloc with mmio.
> 
> Current retry logic is : try with must+optional at first, and if
> it fails will try must then try to extend must with optional.
> That will fail as mmio-non-pref and mmio-pref for bridge will
> be next to each other. So we have no chance to extend mmio-non-pref.

Shouldn't you do completely separate passes for IO and MMIO through the
whole lot instead since they are completely separate address spaces ?

IE. Even a legit setup with IOs, in case of failures on the IO side
(resource exhaustion, FW bugs, ...) we shouldn't retry the memory side
and vice-versa.

Note that I'm a bit worried by how invasive your proposed patch is. I
will let Gavin test it and if it works I'm happy but keep in mind that I
really need that fixed in 3.10 ... (especially since there are noises
around about a certain enterprise distro using that version...)

Cheers,
Ben.


