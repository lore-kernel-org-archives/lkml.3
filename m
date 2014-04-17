Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaDQRHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:07:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaDQRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:07:26 -0400
Date: Thu, 17 Apr 2014 14:04:26 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gleb@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] vmx: speed up wildcard MMIO EVENTFD
Message-ID: <20140417170426.GA9781@amt.cnet>
References: <1396291468-12120-1-git-send-email-mst@redhat.com>
 <1396291468-12120-2-git-send-email-mst@redhat.com>
 <20140417123354.GA16748@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417123354.GA16748@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 03:33:55PM +0300, Michael S. Tsirkin wrote:
> On Mon, Mar 31, 2014 at 09:50:44PM +0300, Michael S. Tsirkin wrote:
> > With KVM, MMIO is much slower than PIO, due to the need to
> > do page walk and emulation. But with EPT, it does not have to be: we
> > know the address from the VMCS so if the address is unique, we can look
> > up the eventfd directly, bypassing emulation.
> > 
> > Unfortunately, this only works if userspace does not need to match on
> > access length and data.  The implementation adds a separate FAST_MMIO
> > bus internally. This serves two purposes:
> >     - minimize overhead for old userspace that does not use eventfd with lengtth = 0
> >     - minimize disruption in other code (since we don't know the length,
> >       devices on the MMIO bus only get a valid address in write, this
> >       way we don't need to touch all devices to teach them to handle
> >       an invalid length)
> > 
> > At the moment, this optimization only has effect for EPT on x86.
> > 
> > It will be possible to speed up MMIO for NPT and MMU using the same
> > idea in the future.
> > 
> > With this patch applied, on VMX MMIO EVENTFD is essentially as fast as PIO.
> > I was unable to detect any measureable slowdown to non-eventfd MMIO.
> > 
> > Making MMIO faster is important for the upcoming virtio 1.0 which
> > includes an MMIO signalling capability.
> > 
> > The idea was suggested by Peter Anvin.  Lots of thanks to Gleb for
> > pre-review and suggestions.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Ping.
> Marcelo, any chance you could merge this for 3.16?

Applied, note: KVM_CAP_ number change.

FYI: "skip_emulated_instruction" breaks instructions which are composed of
other parts than just the 0-length eventfd register access, eg. rep mov.

