Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3CKTWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab3CKTWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:22:52 -0400
Date: Mon, 11 Mar 2013 15:22:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311192247.GG12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
 <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <87r4jllpfb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4jllpfb.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:14:16PM -0700, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > On 03/11/2013 11:50 AM, Yinghai Lu wrote:
> >>>
> >>> What is the purpose of reserving that kind of memory below 896 MB?  If
> >>> you have a 32-bit system, it will likely be useless since you are
> >>> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
> >>> a magic value in any way...?
> >> 
> >> We did not touch 32 bit system.
> >> 
> >> Do you mean that we should
> >> For 64bit, we should try under 4G, and then try MAXMEM
> >> instead of try under 896M, then 4G, and MAXMEM?
> >> 
> >> Try 896M at first, we will let user to avoid updating their kexec-tools.
> >> 
> >
> > Are you saying 896M is somehow hardcoded into kexec-tools?
> >
> > I actually disagree with trying low memory at all.  Push kdump as high
> > into the memory range as we can go, if there is a performance penalty it
> > is much better to take it in the kdump kernel.
> >
> > All the voodoo to try to keep people from updating kexec-tools is
> > disturbing; although breaking userspace is bad, updating kexec-tools is
> > probably easier than updating the kernel, and carrying the voodoo on
> > indefinitely has serious consequences.
> 
> I don't totally follow the reasoning, but there is one real motivating
> example that is not easy to fix and it has little to do with
> kexec-tools.  There is a practical issue that so far the easiest way
> to deal with iommus after a kexec on panic is to just not use them.
> The problem is what to do with existing DMAs transfers that were setup
> by the kernel that crashed and are using the iommu.
> 
> When you are loaded above 4G not using iommus can be a challenge.
> 
> There are practical consequences to all of this that started this
> discussion, and the practical consequences are primarily in kernel
> behavior.

iommu is a real concern. We have quite a few issues that with iommu
on kdump did not work. So practically we keep iommu off both in first
kernel and second kernel.

So always reserving memory at highest address will break all the cases
which work without iommu and rely on swiotlb. I think first we need
to make sure that kdump works reliably with iommu on, and then try
to move to always reserving memory at higest possible address.

Thanks
Vivek
