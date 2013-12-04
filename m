Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3LDJ2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:28:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44139 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3LDJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:28:42 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378857600"; 
   d="scan'208";a="78068766"
Message-ID: <1386149319.13256.83.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>
Date: Wed, 4 Dec 2013 09:28:39 +0000
In-Reply-To: <20131203201135.GA14243@phenom.dumpdata.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
	 <529DBA07.6090108@citrix.com>
	 <1386068884.13256.9.camel@kazak.uk.xensource.com>
	 <529DC7BA.7080506@citrix.com>
	 <1386078108.13256.30.camel@kazak.uk.xensource.com>
	 <529DF4A0.50103@citrix.com>
	 <1386083821.13256.42.camel@kazak.uk.xensource.com>
	 <20131203201135.GA14243@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 15:11 -0500, Konrad Rzeszutek Wilk wrote:
> > > If Konrad and Boris agree that breaking the kernel's ABI in this way is
> > > acceptable in this specific case, I'll defer to them.
> > 
> > My opinion as Xen on ARM hypervisor maintainer is that this is the right
> > thing to do in this case.
> 
> Heh. If somebody can guarantee me that (by testing the right variants and
> mentioning this in the git commit) that this does not break x86, then
> I am fine.
> 
> And by 'break x86' I mean that this combination works:
>  32-bit domU on 64-bit dom0
>  64-bit domU on 32-bit dom0
> 
> And perhaps also the obvious:
>  64-bit domU on 64-bit dom0
>  32-bit domU on 32-bit dom0

One way to test this is with gdb on a vmlinux for each arch with
CONFIG_DEBUG_INFO=y. For each MEMBER of each interesting STRUCT:
        (gdb) print &((struct STRUCT *)0)->MEMBER
(this is effectively an open coded offsetof)

This could probably even be semi automated by producing a script to feed
to gdb which run through all of the options and diffing the result.

If I could have the moon on a stick I would have a tool such as this
running against the canonical Xen headers, to catch breakage as it is
introduced upstream and a tool which could run against an arbitrary ELF
binary to validate it against the upstream results.
tools/include/xen-foreign/mkchecker.py goes some way towards that but
isn't really extensible to the extent we would need/want.

While I'm asking for unicorns a gcc __attribute__((warn_on_holes)) which
could be applied to a struct to enforce the need for explicit padding
would probably be incredibly useful for this of thing.

> Since the xen-blkback has its own version of the structs there is no
> need to change change newer and older version of it.

Someone should check that these are producing the right interface on ARM
though!

> As long as that works I am OK sticking it in.

Thanks.

> I think from the ARM perspective it is still in 'experimental' phase
> so anything goes to make it work under ARM.

Ian.


