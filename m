Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaJOX7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaJOX7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:59:13 -0400
Date: Thu, 16 Oct 2014 07:58:36 +0800
From: Baoquan He <bhe@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, ak@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, whissi@whissi.de,
        kumagai-atsushi@mxc.nes.nec.co.jp, stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
Message-ID: <20141015235836.GB1642@dhcp-17-102.nay.redhat.com>
References: <20141011031452.GB11560@dhcp-16-116.nay.redhat.com>
 <543907B5.7060001@zytor.com>
 <20141013125257.GB6466@redhat.com>
 <20141013151955.GA9777@redhat.com>
 <543BF304.9090708@zytor.com>
 <20141013172242.GB9777@redhat.com>
 <20141014124932.GC5127@redhat.com>
 <20141015033701.GD16068@dhcp-16-116.nay.redhat.com>
 <695BEC26-402D-4B1C-9266-137F2BCFE5B9@zytor.com>
 <20141015235537.GA1642@dhcp-17-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015235537.GA1642@dhcp-17-102.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/14 at 07:55am, Baoquan He wrote:
> On 10/15/14 at 01:32pm, H. Peter Anvin wrote:
> > I don't see why we can't randomize anywhere in physical space.  We already handle the kernel above 4 GB and it wouldn't be hard to do the equivalent for the decompress/relocation code, using a #PF handler.  Not all CPUs support 1 GB pages.
> > 
> 
> Well, IIUC, in arch/x86/boot/compressed/head_64.S pgtable contains 6
> page frames and is used to build 4G identity mapping. Then this pgtable
> is loaded into cr3. Later jump into 64bit mode. decompress/relocation
> code should work in this region. Isn't it right?
> 
> Currently kernel surely can be put anywhere, even above 4G. This have
> been done very often in kexec/kdump. However in kexec/kdump the identity
> mapping is built for all physical memory after jumping to startup_64
                                           ~~~~~ should be before

> directly from purgatory, that's why kexec/kdump kernel can be put
> anywhere.
> 
> So for normal kernel, don't we need to extend the physical memory mappng
> to a larger region if we want to randomize anywhere in physical space?
> 
> Thanks
> Baoquan
> 
> 
> > On October 14, 2014 8:37:01 PM PDT, Baoquan He <bhe@redhat.com> wrote:
> > >On 10/14/14 at 08:49am, Vivek Goyal wrote:
> > >> On Mon, Oct 13, 2014 at 01:22:42PM -0400, Vivek Goyal wrote:
> > >> > On Mon, Oct 13, 2014 at 08:43:00AM -0700, H. Peter Anvin wrote:
> > >> > > On 10/13/2014 08:19 AM, Vivek Goyal wrote:
> > >> > > >>>
> > >> > > >>> This really shouldn't have happened this way on x86-64.  It
> > >has to happen
> > >> > > >>> this way on i386, but I worry that this may be a serious
> > >misdesign in kaslr
> > >> > > >>> on x86-64.  I'm also wondering if there is any other fallout
> > >of this?
> > >> > > >>
> > >> > > >> I agree. On x86_64, we should stick to previous design and
> > >this new
> > >> > > >> logic of performing relocations does not sound very clean and
> > >makes
> > >> > > >> things very confusing.
> > >> > > >>
> > >> > > >> I am wondering that why couldn't we simply adjust page tables
> > >in case of
> > >> > > >> kaslr on x86_64, instead of performing relocations.
> > >> > > > 
> > >> > > > Well, IIUC, if virtual addresses are shifted w.r.t what virtual
> > >address
> > >> > > > kernel was compiled for, then relocation will have to be done.
> > >> > > > 
> > >> > > > So question will be if physical address shift is enough for
> > >kaslr or
> > >> > > > virtual address shift is necessary.
> > >> > > > 
> > >> > > 
> > >> > > I would assume that without a virtual address shift kaslr is
> > >pretty darn
> > >> > > pointless.  Without the physical address shift the 1:1 map can be
> > >used,
> > >> > > and again, kaslr becomes pointless.  However, there is absolutely
> > >no
> > >> > > reason why they should be coupled.  They can, in fact, be
> > >independently
> > >> > > randomized.
> > >> > 
> > >> > Agreed. On x86_64, we should be able to randomize virtual address
> > >space
> > >> > and physical address space independently. And in that case whole of
> > >> > the physical memory should be available for a possible location for
> > >> > kernel. (As opposed to a small limit (I guess 1GB) now)
> > >
> > >It can be done to randomize virtual address space and physical address
> > >space independently. But limited by the 2G of kernel text mapping and
> > >module mapping virtual address space, virtual address can be randomized
> > >in (0x1000000, 1G) range. While physical address can be randomized in
> > >(0x1000000, 4G) according to the identity mapping of normal kernel.
> > >Then
> > >phys_base still stores an relative value, a different offset than
> > >before.
> > >
> > >This can be easily implement. One thing is still there's a limit for
> > >physical addr randomization, only below 4G. So I am wondering if we can
> > >extend the identify mapping to complete mapping of 48 bit, using 1G
> > >page
> > >frame. This can make physical addr be randomized to anywhere.
> > >
> > >So now there may be 3 options:
> > >
> > >1) Fix this bug in current kaslr. Since when randomize the new kernel
> > >location in choose_kernel_location(), cmdline options has been checked
> > >strictly, e.g if nokaslr is specified, it's safe to do the kernel
> > >location randomization. Then in handle_relocations(), we only need to
> > >check if the kernel location is changed, comparing with kernel loaded
> > >addr. If changed, kaslr is done, let's do the relocation handling. If
> > >not changed, no kaslr id done, just skip the relocation handling like
> > >before.
> > >
> > >2) randomize the virtual addr space and physical addr space
> > >independently. But physical addr space must be below 4G.
> > >
> > >3) extend the identity mapping to 48bit of addr space. Then we can
> > >randomized the virtual addr space in (0x1000000, 1G) and physical addr
> > >space in (0x1000000, real physical memory end).
> > >
> > >If option 3 is doable, it's the best. If not, I think bug fix should be
> > >better.
> > >
> > >> 
> > >> Hi Peter,
> > >> 
> > >> So what do we do about this issue in short term to make kexec work.
> > >Even
> > >> if we go for above solution, to make kexec work we will have to pass
> > >> "nokaslr" as we don't want kernel to move around in physical address
> > >space
> > >> as it might stomp over ELF headers we have stored.
> > >
> > >kexec doesn't need ELF headers. Kdump may need it. But in current
> > >kexec-tools implementation, kernel/initrd and other stuffs are placed
> > >from top to down, current implementation won't do kaslr since it only
> > >happened between kernel loaded addr and 1G. So we don't need to worry
> > >about the stomping.
> > >
> > >> 
> > >> If you don't like current patch, should we just disable relocations
> > >in
> > >> x86_64 if "nokaslr" command line is passed. That way kernel will not
> > >> be moved in physical as well as virtual address space.
> > >> 
> > >> Thanks
> > >> Vivek
> > 
> > -- 
> > Sent from my mobile phone.  Please pardon brevity and lack of formatting.
