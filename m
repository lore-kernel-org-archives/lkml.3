Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3KSQWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:22:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3KSQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:22:07 -0500
Date: Tue, 19 Nov 2013 11:20:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Elena Ufimtseva <ufimtseva@gmail.com>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 2/2] xen: enable vnuma for PV guest
Message-ID: <20131119162039.GB6030@phenom.dumpdata.com>
References: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com>
 <1384811922-14642-3-git-send-email-ufimtseva@gmail.com>
 <528B5160.5010902@citrix.com>
 <20131119141620.GD5332@phenom.dumpdata.com>
 <528B774F.7090902@citrix.com>
 <20131119144630.GA5780@phenom.dumpdata.com>
 <528B7C29.3050103@citrix.com>
 <20131119151924.GC5790@phenom.dumpdata.com>
 <528B89DA.2080504@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528B89DA.2080504@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 03:55:06PM +0000, David Vrabel wrote:
> On 19/11/13 15:19, Konrad Rzeszutek Wilk wrote:
> > On Tue, Nov 19, 2013 at 02:56:41PM +0000, David Vrabel wrote:
> >> The relevant bits in dummy_numa_init are in the error path of
> >> xen_numa_init().
> > 
> > That seems the wrong place to do it. The top layer calls 
> > in each of the numa implementations and then falls back to
> > the dummy.
> 
> Think of it as not the dummy, but Xen setting the NUMA configuration up
> with only a single node.

Or with multiple nodes if numa=fake is used.

> 
> The useful bits in dummy_numa_init() are two calls to standard functions
> for use by *_numa_init() calls so it just seems easier all round to just
> call then directly than add a dependancy on dummy_numa_init().

My worry is more of the numa_init not being completly executed.

> 
> > Calling from within the implementation on something that is eventually
> > done on the upper level already is not right.
> 
> >From the point of view of the caller, it does the right thing.  NUMA is
> setup.
> 
> >> I do think this approach (using the provided API to setup the single
> >> (dummy) node), is preferable to calling dummy_numa_init().
> > 
> > Doesn't it do the same thing? And also what about if you the user
> > provides fakenuma?
> 
> I don't know what "fakenuma" is refering to.

numa=fake or see arch/x86/mm/numa_emulation.c

Which gets executed if you end up calling: numa_init(X) and 'X'
returns a zero or positive value.

Which it won't as the first thing it the Xen PV NUMA code does
is to see if the hypercall is supported. If not, it bails out - so we
never get to do the 'numa=fake' if a user wanted to.
