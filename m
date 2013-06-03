Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab3FCPmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:42:17 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:64565 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <51A77FA8.6010007@redhat.com>
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
	<51A7717D.6030203@redhat.com>
	<51A77FA8.6010007@redhat.com>
Date: Mon, 3 Jun 2013 18:42:11 +0300
Message-ID: <CAEbWaiqg765n5jSz7+8_O-44j5NoTMhKVnN-ev7daSHBoR6Tiw@mail.gmail.com>
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
From: Avi Kivity <avi.kivity@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 7:34 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 30/05/2013 17:34, Paolo Bonzini ha scritto:
>> Il 30/05/2013 16:35, Paolo Bonzini ha scritto:
>>> The x86-64 extended low-byte registers were fetched correctly from reg,
>>> but not from mod/rm.
>>>
>>> This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
>>> not enough.
>>
>> Well, it is enough but it takes 2 minutes to reach the point where
>> hardware virtualization is used.  It is doing a lot of stuff in
>> emulation mode because FS and GS have leftovers from the A20 test:
>>
>> FS =0000 0000000000000000 0000ffff 00009300 DPL=0 DS16 [-WA]
>> GS =ffff 00000000000ffff0 0000ffff 00009300 DPL=0 DS16 [-WA]
>>
>> 0x00000000000113be:  in     $0x92,%al
>> 0x00000000000113c0:  or     $0x2,%al
>> 0x00000000000113c2:  out    %al,$0x92
>> 0x00000000000113c4:  xor    %ax,%ax
>> 0x00000000000113c6:  mov    %ax,%fs
>> 0x00000000000113c8:  dec    %ax
>> 0x00000000000113c9:  mov    %ax,%gs
>> 0x00000000000113cb:  inc    %ax
>> 0x00000000000113cc:  mov    %ax,%fs:0x200
>> 0x00000000000113d0:  cmp    %gs:0x210,%ax
>> 0x00000000000113d5:  je     0x113cb
>>
>> The DPL < RPL test fails.  Any ideas?  Should we introduce a new
>> intermediate value for emulate_invalid_guest_state (0=none, 1=some, 2=full)?
>
> One idea could be to replace invalid descriptors with NULL ones.  Then
> you can intercept this in the #GP handler and trigger emulation for that
> instruction only.

Won't work, vmx won't let you enter in such a configuration.

Maybe you can detect the exact code sequence (%eip, some instructions,
register state) and clear %fs and %gs.
