Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3AVQXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:23:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3AVQXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:23:09 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
Date: Tue, 22 Jan 2013 17:23:03 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-24-desktop; KDE/4.6.0; x86_64; ; )
Cc: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <1358868049-19884-3-git-send-email-trenn@suse.de> <50FEB620.3020805@zytor.com>
In-Reply-To: <50FEB620.3020805@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221723.03863.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 04:54:08 PM H. Peter Anvin wrote:
> On 01/22/2013 09:20 AM, Thomas Renninger wrote:
> > From: Yinghai Lu <yinghai@kernel.org>
> > 
> > kdump voided the whole original e820 map and half way made
> > it up via memmap= options passed via kdump boot params again.
> > 
> > But this is conceptionally wrong. The whole original memory ranges
> > which are declared reserved, ACPI data/nvs or however are not usable
> > must stay the same and get honored by the kdump kernel.
> > 
> > Therefore memmap=resetusablemap gets introduced.
> > kdump passes this one and only the usable e820 ranges are removed.
> > kdump passes the usable ranges to use via memmap=x@y parameter(s).
> > The not usable e820 ranges are preserved.
> > 
> > This for example fixes mmconf (extended PCI config access) and
> > possibly other kernel parts which rely on remapped memory to be
> > in reserved or ACPI (data/nvs) declared e820 memory areas.
> > 
> > Tested-by: Thomas Renninger <trenn@suse.de>
> > Reviewed-by: Thomas Renninger <trenn@suse.de>
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> Tested-by: and Reviewed-by: are rather redundant with Signed-off-by:.
Yes, the Signed-off-by slipped in.

> Also, you should have a Signed-off-by: from the author (Yinghai).
From: and Signed-off-by: are also redundant?
 
> However, when thinking about it this really doesn't seem to be the right
> interface, either.
Why?

> Something like "memmap=reserveram" which turns all
> RAM areas into reserved areas, which can then be overridden by memmap=
> options would make more sense.
What for?
This would be wrong. If kexec tries to declare usable memory via memmap=
which is set to reserved by the BIOS, a WARN_ON() or even better BUG_ON()
can/should be issued. This is then not possible anymore.

Your suggestion would again make the e820 data useless. One would again 
not know whether an area which is reserved really is meant for BIOS/HW
communication. And for example broken mmconf platforms for which
the check "is mmconf area is in reserved space" returns false, would now
try to setup mmconf in kdump case. Do you want to introduce another
e820 type: KDUMP_RESERVED which formerly was usable? This would preserve
e820 info, but I cannot see for what this should be good for.

> Even more sense would be to pass the modified memmap to kexec...
Not sure what you mean with this. When kexec is called, you are in a 
kernel which does not have a modified memmap. How can a modified map
get passed to kexec?

Again: Please explain what is bad with this solution.
I cannot see a better and more robust way for kdump other than
reserving the original reserved memory areas as declared by the BIOS.

   Thomas
