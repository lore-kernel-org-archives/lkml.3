Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3FCQlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab3FCQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:41:01 -0400
Date: Mon, 3 Jun 2013 19:40:57 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi.kivity@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
Message-ID: <20130603164057.GQ24773@redhat.com>
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
 <51A7717D.6030203@redhat.com>
 <51A77FA8.6010007@redhat.com>
 <CAEbWaiqg765n5jSz7+8_O-44j5NoTMhKVnN-ev7daSHBoR6Tiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEbWaiqg765n5jSz7+8_O-44j5NoTMhKVnN-ev7daSHBoR6Tiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 06:42:11PM +0300, Avi Kivity wrote:
> On Thu, May 30, 2013 at 7:34 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > Il 30/05/2013 17:34, Paolo Bonzini ha scritto:
> >> Il 30/05/2013 16:35, Paolo Bonzini ha scritto:
> >>> The x86-64 extended low-byte registers were fetched correctly from reg,
> >>> but not from mod/rm.
> >>>
> >>> This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
> >>> not enough.
> >>
> >> Well, it is enough but it takes 2 minutes to reach the point where
> >> hardware virtualization is used.  It is doing a lot of stuff in
> >> emulation mode because FS and GS have leftovers from the A20 test:
> >>
> >> FS =0000 0000000000000000 0000ffff 00009300 DPL=0 DS16 [-WA]
> >> GS =ffff 00000000000ffff0 0000ffff 00009300 DPL=0 DS16 [-WA]
> >>
> >> 0x00000000000113be:  in     $0x92,%al
> >> 0x00000000000113c0:  or     $0x2,%al
> >> 0x00000000000113c2:  out    %al,$0x92
> >> 0x00000000000113c4:  xor    %ax,%ax
> >> 0x00000000000113c6:  mov    %ax,%fs
> >> 0x00000000000113c8:  dec    %ax
> >> 0x00000000000113c9:  mov    %ax,%gs
> >> 0x00000000000113cb:  inc    %ax
> >> 0x00000000000113cc:  mov    %ax,%fs:0x200
> >> 0x00000000000113d0:  cmp    %gs:0x210,%ax
> >> 0x00000000000113d5:  je     0x113cb
> >>
> >> The DPL < RPL test fails.  Any ideas?  Should we introduce a new
> >> intermediate value for emulate_invalid_guest_state (0=none, 1=some, 2=full)?
> >
> > One idea could be to replace invalid descriptors with NULL ones.  Then
> > you can intercept this in the #GP handler and trigger emulation for that
> > instruction only.
> 
> Won't work, vmx won't let you enter in such a configuration.
> 
Why? It is possible to have NULL descriptor in 32bit mode with vmx. But
we do not usually intercept #GP while executing 32bit mode, so we will
have to track if there is artificial NULL selector and enables #GP
interception and then emulate on every #GP.

> Maybe you can detect the exact code sequence (%eip, some instructions,
> register state) and clear %fs and %gs.
My be we can set dpl to rpl unconditionally on a switch from 16 to 32
bit. The only problem I can see with it is that if a guest enters user
mode without explicitly reload the segment it will be accessible by a
user mode code, but I am not sure it is well defined what dpl of a 16
bit segment is after transition to 32 bit mode anyway, so it would be
crazy to do so.

--
			Gleb.
