Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3FCMxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:53:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab3FCMxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:53:30 -0400
Message-ID: <51AC91BD.2030002@redhat.com>
Date: Mon, 03 Jun 2013 14:53:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com> <51A7717D.6030203@redhat.com> <20130603102530.GH4725@redhat.com>
In-Reply-To: <20130603102530.GH4725@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2013 12:25, Gleb Natapov ha scritto:
> On Thu, May 30, 2013 at 05:34:21PM +0200, Paolo Bonzini wrote:
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
> This is 16 bit code that sets them up. So 32bit transition code does not
> reload them?

Yes.  It does this:

        movw    $1, %ax                         # protected mode (PE) bit
        lmsw    %ax                             # This is it!
        jmp     flush_instr

flush_instr:
        xorw    %bx, %bx                        # Flag to indicate a boot
        xorl    %esi, %esi                      # Pointer to real-mode code
        movw    %cs, %si
        subw    $DELTA_INITSEG, %si
        shll    $4, %esi                        # Convert to 32-bit pointer
        .byte 0x66, 0xea                        # prefix + jmpi-opcode
code32: .long   0x1000                          # will be set to 0x100000
                                                # for big kernels
        .word   __KERNEL_CS

which jumps to boot/compressed/head.S:

startup_32:
        cld
        cli
        movl    $(__KERNEL_DS), %eax
        movl    %eax, %ds
        movl    %eax, %es
        movl    %eax, %ss

and totally ignores fs/gs.  Much later there is this (in kernel/head.S):

        /*
         * We don't really need to load %fs or %gs, but load them anyway
         * to kill any stale realmode selectors.  This allows execution
         * under VT hardware.
         */
        movl %eax,%fs
        movl %eax,%gs
 
but the whole decompression is run under emulation.

Paolo

>> The DPL < RPL test fails.  Any ideas?  Should we introduce a new
>> intermediate value for emulate_invalid_guest_state (0=none, 1=some, 2=full)?
>>
>> Paolo
>>
>>> Cc: gnatapov@redhat.com
>>> Cc: kvm@vger.kernel.org
>>> Cc: <stable@vger.kernel.org> # 3.9
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/x86/kvm/emulate.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>>> index aa68106..028b34f 100644
>>> --- a/arch/x86/kvm/emulate.c
>>> +++ b/arch/x86/kvm/emulate.c
>>> @@ -1239,9 +1239,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>>>  	ctxt->modrm_seg = VCPU_SREG_DS;
>>>  
>>>  	if (ctxt->modrm_mod == 3) {
>>> +		int highbyte_regs = ctxt->rex_prefix == 0;
>>> +
>>>  		op->type = OP_REG;
>>>  		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
>>> -		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm, ctxt->d & ByteOp);
>>> +		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
>>> +					       highbyte_regs && (ctxt->d & ByteOp));
>>>  		if (ctxt->d & Sse) {
>>>  			op->type = OP_XMM;
>>>  			op->bytes = 16;
>>>
> 
> --
> 			Gleb.
> 

