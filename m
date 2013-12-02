Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3LBRaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:30:11 -0500
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:35154 "EHLO
	a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772Ab3LBRaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:30:09 -0500
X-Greylist: delayed 711 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 12:30:09 EST
Date: Mon, 2 Dec 2013 17:18:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Greg KH <greg@kroah.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: netfilter: active obj WARN when cleaning up
In-Reply-To: <20131202164039.GA19937@kroah.com>
Message-ID: <00000142b4514eb5-2e8f675d-0ecc-423b-9906-58c5f383089b-000000@email.amazonses.com>
References: <5294F27D.4000108@oracle.com> <20131126230709.GA10948@localhost> <alpine.DEB.2.02.1311271106090.30673@ionos.tec.linutronix.de> <20131127113939.GL16735@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1311271409280.30673@ionos.tec.linutronix.de>
 <20131127133231.GO16735@n2100.arm.linux.org.uk> <20131127134015.GA6011@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1311271443580.30673@ionos.tec.linutronix.de> <20131127233415.GB19270@kroah.com> <00000142b4282aaf-913f5e4c-314c-4351-9d24-615e66928157-000000@email.amazonses.com>
 <20131202164039.GA19937@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.02-54.240.9.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Greg KH wrote:

> On Mon, Dec 02, 2013 at 04:33:20PM +0000, Christoph Lameter wrote:
> > On Wed, 27 Nov 2013, Greg KH wrote:
> >
> > > Just make the kobject "dynamic" instead of embedded in struct kmem_cache
> > > and all will be fine.  I can't believe this code has been broken for
> > > this long.
> >
> > The slub code is was designed to use an embedded structure since we
> > only get the kobj  pointer passed to us from sysfs. If kobj is not
> > embedded then how can we get from the sysfs object to the kmem_cache
> > structure from the sysfs callbacks? Sysfs was designed to have embedded
> > objects as far as I can recall.
>
> Yes, it's designed to have embedded objects, so then use it that way and
> clean up the structure when the kobject goes away.  Don't use a
> different reference count for your structure than the one in the kobject
> and think that all will be fine.

We need our own reference count. So we just have to defer the
release of the kmem_cache struct until the ->release callback is
triggered. The put of the embedded kobject must be the last action on the
kmem_cache  structure which will then trigger release and that will
trigger the kmem_cache_free().



