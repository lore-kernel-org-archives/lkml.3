Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaAQRCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:02:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58437 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaAQRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:02:08 -0500
Date: Fri, 17 Jan 2014 10:02:04 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.11][v3.12][v3.13][Regression] EISA: Initialize device before
 its resources
Message-ID: <20140117170204.GA13939@google.com>
References: <52D81C92.9050800@canonical.com>
 <CAErSpo64e52Vv8bJ54cPcpnZ=OHMaxt2-D6dA4HCrrLnKo1n7g@mail.gmail.com>
 <52D82169.2000107@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52D82169.2000107@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 01:14:01PM -0500, Joseph Salisbury wrote:
> On 01/16/2014 01:12 PM, Bjorn Helgaas wrote:
> > On Thu, Jan 16, 2014 at 10:53 AM, Joseph Salisbury
> > <joseph.salisbury@canonical.com> wrote:
> >> Hi Bjorn,
> >>
> >> A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
> >> was found the following commit introduced this bug:
> > Sorry about that, and thanks for the report.  Did you mean to include
> > URL for the bug?
> Yes, sorry about that:
> http://pad.lv/1251816

Hi Joseph,

Can you attach the 3.8.0-32-generic config (the one matching the successful
boot at https://launchpadlibrarian.net/156685076/BootDmesg.txt) to the bug?

The only way I can match up the output:

  EISA: Probing bus 0 at eisa.0
  Cannot allocate resource for EISA slot 1
  Cannot allocate resource for EISA slot 2
  Cannot allocate resource for EISA slot 4
  Cannot allocate resource for EISA slot 5
  EISA: Detected 0 cards.

with the code is if we have root->force_probe set, and the only way I see for
that to happen is if we're in the virtual_eisa_root_init() path and
CONFIG_EISA_VLB_PRIMING=y:

  #if defined(CONFIG_ALPHA_JENSEN) || defined(CONFIG_EISA_VLB_PRIMING)
  #define EISA_FORCE_PROBE_DEFAULT 1
  #else
  #define EISA_FORCE_PROBE_DEFAULT 0
  #endif

  static int force_probe = EISA_FORCE_PROBE_DEFAULT;

  virtual_eisa_root_init
    eisa_bus_root.force_probe = force_probe
    eisa_root_register(&eisa_bus_root)
      eisa_probe(root)
	printk("EISA: Probing bus %d at %s")
	if (eisa_request_resources)         
	  printk("EISA: Cannot allocate resource for mainboard")    # we don't see this
	if (eisa_init_device)               
	  eisa_release_resources
	  kfree
	  if (!root->force_probe)           
	    return -ENODEV
	    goto force_probe
	printk("EISA: Mainboard %s detected")       # we don't see this

	force_probe:
	for (i = 1; ...; i++)
	  if (eisa_request_resources(i))
	    printk("Cannot allocate resource for EISA slot %d", i)
	printk("EISA: Detected %d cards")

Bjorn
