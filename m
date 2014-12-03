Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLCPTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLCPTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:19:49 -0500
Date: Wed, 3 Dec 2014 23:19:28 +0800
From: WANG Chao <chaowang@redhat.com>
To: Joerg Roedel <jroedel@suse.de>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix kdump failures with crashkernel=high
Message-ID: <20141203151928.GC23163@dhcp-17-37.nay.redhat.com>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <20141203040123.GB23163@dhcp-17-37.nay.redhat.com>
 <20141203103506.GN3156@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203103506.GN3156@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/03/14 at 11:35am, Joerg Roedel wrote:
> Hi,
> 
> On Wed, Dec 03, 2014 at 12:01:23PM +0800, WANG Chao wrote:
> >From your experience It seems like swiotlb isn't working well with
> > crashkernel=X,high alone. What about using crashkernel=X,low with
> > crashkernel=X,high? Is there any reason you have to use
> > crashkernel=X,high alone?
> 
> Sure, when I specify an additional crashkernel=X,low then I can get
> things to work this way too. But my patch-set is about changing the
> default, since the failure was seen on common server systems with the
> defaults.

crashkernel=X doesn't work for you?

> 
> > crashkernel=X,high shouldn't automatically reserve 72M low at the first
> > place. Now it's going insane if you increase it to 256M by default.
> 
> How should a kernel without some low memory (which has only memory above
> 4G available) handle any 32bit DMA devices? There would be no way to
> allocate DMA-able memory for those devices.

I mean crashkernel=X,high shouldn't automatically reserve low.
crashkernel=X,high should always be used together with
crashkernel=X,low.

If one is not satisfied with the combination of two parameters,
crashkernel=X should be able to look for a suitable area below 4G. But
right now, crashkernel=X only deals under 896M.

I've sent a patch for this in the past:
[PATCH] x86, kdump: crashkernel=X try to reserve below 896M first, then try below 4G, then MAXMEM
- https://lkml.org/lkml/2013/10/14/183

X86 people don't like this idea so I didn't update the patch even
there's minor nit to clean up.

> 
> And as I said, if people prefer it I can change the patch-set so that
> the amount of low-memory allocated is subtracted from the amount of
> high-memory. This way the overall memory usage for kdump would stay the
> same while changing the defaults to work on more systems.

Say you do this, crashkernel=X,high would be reserve (X-n) high and (n)
low? IMHO I think it's better crashkernel=X,high means reserve X high
and high only.

Thanks
WANG Chao
