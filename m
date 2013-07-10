Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3GJGT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:19:58 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:1302 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3GJGT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:19:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,1033,1363132800"; 
   d="scan'208";a="580764956"
Date: Tue, 9 Jul 2013 23:19:34 -0700
From: Matt Wilson <msw@amazon.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, Jan Beulich <JBeulich@suse.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <x86@kernel.org>, Paul Bolle <pebolle@tiscali.nl>,
        <virtualization@lists.linux-foundation.org>, <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
Message-ID: <20130710061932.GB13671@u109add4315675089e695.ant.amazon.com>
References: <20130708192854.GF4927@phenom.dumpdata.com>
 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
 <51DB2134.9040909@zytor.com>
 <20130708205834.GA481@pd.tnic>
 <1373326534.1438.10.camel@x61.thuisdomein>
 <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
 <51DBDAB802000078000E37C1@nat28.tlf.novell.com>
 <20130709144840.GF24897@phenom.dumpdata.com>
 <20130709150554.GA27579@pd.tnic>
 <1382658288.20130710003458@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382658288.20130710003458@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 12:34:58AM +0200, Sander Eikelenboom wrote:
> 
> Tuesday, July 9, 2013, 5:05:54 PM, you wrote:
> 
> > On Tue, Jul 09, 2013 at 10:48:40AM -0400, Konrad Rzeszutek Wilk wrote:
> >> Then that should be discussed on grub2 to remove said check and modify
> >> the code so that it can properly work without regression.
> 
> > Actually, the kernel patch removing that symbol should be applied so
> > that grub2 breaks faster. One can't possibly rely on kernel internals
> > for anything, as it is insanely insane (yep, the tautology is on purpose
> > :-)).
>
> How insanely insane is it to be able to determine whether a certain
> compiled kernel binary supports a certain function ?
> 
> Grub does this in it's update script to prevent adding a xen +
> kernel combination that has no chance of booting when dom0 support
> has not been configured in the kernel.  That doesn't seem to be a
> unreasonable thought.
> 
> Grepping the accompanied config file in /boot for the xen dom0
> Kconfig parameter seems the best possible effort grub can do at the
> moment.

I think this can be improved, even with the situation today.

> Especially since the Kconfig parameter naming doesn't change that
> often.
> 
> If you know a better way for grub to determine if a certain function
> for a kernel binary is supported then please elaborate ..

Certainly. Parse the ELF notes that are present in a dom0-capable
Linux kernel binary itself.

$ readelf -n vmlinux

Notes at offset 0x0069be88 with length 0x0000017c:
  Owner		Data size	Description
  Xen		0x00000006	Unknown note type: (0x00000006)
  Xen		0x00000004	Unknown note type: (0x00000007)
  Xen		0x00000008	Unknown note type: (0x00000005)
  Xen		0x00000008	Unknown note type: (0x00000003)
  Xen		0x00000008	NT_VERSION (version)
  Xen		0x00000008	NT_ARCH (architecture)
  Xen		0x0000002a	Unknown note type: (0x0000000a)
  Xen		0x00000004	Unknown note type: (0x00000009)
  Xen		0x00000008	Unknown note type: (0x00000008)
  Xen		0x00000010	Unknown note type: (0x0000000d)
  Xen		0x00000004	Unknown note type: (0x0000000e)
  Xen		0x00000008	Unknown note type: (0x0000000c)
  Xen		0x00000008	Unknown note type: (0x00000004)
  GNU		0x00000014	NT_GNU_BUILD_ID (unique build ID bitstring)

See arch/x86/xen/xen-head.S.

There's a new note type (XEN_ELFNOTE_SUPPORTED_FEATURES) that we can
use to make dom0 support explicit.

http://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=xen/arch/x86/domain_build.c;hb=HEAD#l415

--msw
