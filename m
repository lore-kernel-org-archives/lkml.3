Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3FMWcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:32:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51287 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756489Ab3FMWcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:32:09 -0400
X-Sasl-enc: L/XARax3JMo2IdmsDPfg6rW55bpphhlfszCuOWCoA/cZ 1371162727
From: Simon Brown <smb@700c.org>
To: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Accessing more than 2GB of memory with a 32 bit kernel
Date: Thu, 13 Jun 2013 23:32:06 +0100
Message-ID: <3704356.7sSoN0NIpj@phaedrus>
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <51B8D59B.1040801@redhat.com>
References: <1371056055.24587.140661243104889.29DDEEB4@webmail.messagingengine.com> <51B8D59B.1040801@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 Jun 2013 16:10:03 Rik van Riel wrote:
> On 06/12/2013 12:54 PM, Simon Brown wrote:
> > Hello,
> > 
> > For the sake of an old prototype peripheral I'm using a non PAE 32 bit
> > x86 kernel and I'm having trouble accessing memory above 2 GB. The
> > system has 4GB installed and all is well with a PAE kernel.
> > 
> > I'm obviously expecting to lose some memory due to memory mapped devices
> > but I wasn't expecting to lose 2GB. Instead I'm suspecting a BIOS bug.
> > The system reports:
> > free -m
> > 
> >               total       used       free     shared    buffers
> >               cached
> > 
> > Mem:          2012        491       1521          0         40
> > 277
> > 
> > The mtrr table looked odd so I enabled sanitisation:
> > [    0.000000] original variable MTRRs
> > [    0.000000] reg 0, base: 2GB, range: 2GB, type UC
> > [    0.000000] reg 1, base: 0GB, range: 4GB, type WB
> > [    0.000000] reg 2, base: 4GB, range: 2GB, type WB
> > [    0.000000] total RAM covered: 4096M
> > [    0.000000] Found optimal setting for mtrr clean up
> > [    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 2
> > lose cover RAM: 0G
> > [    0.000000] New variable MTRRs
> > [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> > [    0.000000] reg 1, base: 4GB, range: 2GB, type WB
> > 
> > I don't understand the gap in the new table.
> 
> Check the e820 table. Chances are the BIOS is reserving 2GB to
> map various devices (especially video cards) below the 4GB limit.

The table looks like this:
  [    0.000000] BIOS-provided physical RAM map:
  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  [    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff80000 (usable)
  [    0.000000]  BIOS-e820: 000000007ff80000 - 000000007ff8e000 (ACPI data)
  [    0.000000]  BIOS-e820: 000000007ff8e000 - 000000007ffe0000 (ACPI NVS)
  [    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
  [    0.000000]  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)

So the BIOS has reserved the entire upper half. Can I do anything about that?

Simon

