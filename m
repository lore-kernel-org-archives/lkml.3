Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3JCAKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:10:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55574 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab3JCAKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:10:54 -0400
Message-ID: <1380759074.20801.12.camel@buffalo>
Subject: Re: [tpmdd-devel] [PATCH 02/13] tpm atmel: Call request_region with
 the correct base
From: Ashley D Lai <adlai@linux.vnet.ibm.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Sirrix AG <tpmdd@sirrix.com>,
        Teddy Reed <teddy@prosauce.org>
Date: Wed, 02 Oct 2013 19:11:14 -0500
In-Reply-To: <201310020000.13490.PeterHuewe@gmx.de>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1379960083-8942-3-git-send-email-jgunthorpe@obsidianresearch.com>
	 <201310020000.13490.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100300-0320-0000-0000-00000137DEDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 00:00 +0200, Peter Hüwe wrote:
> Am Montag, 23. September 2013, 20:14:32 schrieb Jason Gunthorpe:
> 
> > Commit e0dd03caf20d040a0a86b6bd74028ec9bda545f5
> 
> > changed the code path here so that ateml_get_base_addr
> 
> > no longer directly altered the tpm_vendor_specific
> 
> > structure, and instead placed the base address on the stack.
> 
> > 
> 
> > The commit missed updating the request_region call, which
> 
> > would have resulted in request_region being called with 0
> 
> > as the base address.
> 
Good catch!!

> > 
> 
> > I don't know if request_region(0, ..) will fail, if so the
> 
> > driver has been broken since 2006 and we should remove it
> 
> > from the tree as it has no users.
> 
>  
> 
> The Atmel TPM depends on PPC64 || HAS_IOPORT
> 
>  
> 
> So request_region is defined as
> 
> #define request_region(start,n,name)
> __request_region(&ioport_resource, (start), (n), (name), 0)
> 
> http://lxr.free-electrons.com/source/include/linux/ioport.h?a=powerpc#L174
> 
>  
> 
> with the final check in 
> 
> __request_resource(struct resource *root, struct resource *new)
> 
> ...
> 
> 204 if (end < start)
> 
> 205 return root;
> 
> 206 if (start < root->start)
> 
> 207 return root;
> 
> 208 if (end > root->end)
> 
> 209 return root;
> 
>  
> 
>  
> 
> with root being ioport_resource, ioport_resource->start = 0 and
> new->start being 0
> 
> so at least the basic check should work.
> 
>  
> 
> Nevertheless it most probably does request and reserve the wrong
> region and if anything else has or wants to request the region it
> might cause a problem.
> 
Would be interesting to see what problem this may cause. Unfortunately I
don't have a machine to test this.

>  
> 
> Does anyone (Ashley? IBM Fellows? Ted?) have access to one of those
> ancient tpms and maybe a machine to use test them?
> 
See above. I will keep looking and will let you know if I can find one.

>  
> 
>  
> 
>  
> 
> I somewhat have the feeling that we should maybe begin to deprecate
> the vendor specific 1.1 tpms...
> 
I agree. If we have a machine to test and it fails then we know we don't
have a user for this.

>  
> 
>  
> 
>  
> 
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
>  
> 
> Staged here 
> https://github.com/PeterHuewe/linux-tpmdd for-james
> 
> 
>  
> 
> Peter
> 
>  
> 
> ------------------------------------------------------------------------------
> October Webinars: Code for Performance
> Free Intel webinars can help you accelerate application performance.
> Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most from 
> the latest Intel processors and coprocessors. See abstracts and register >
> http://pubads.g.doubleclick.net/gampad/clk?id=60134791&iu=/4140/ostg.clktrk
> _______________________________________________ tpmdd-devel mailing list tpmdd-devel@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/tpmdd-devel


