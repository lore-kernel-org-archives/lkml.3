Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845Ab3E3Pen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:34:43 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:42615 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3E3Pef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:34:35 -0400
Message-ID: <51A7717D.6030203@redhat.com>
Date: Thu, 30 May 2013 17:34:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, gnatapov@redhat.com
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/05/2013 16:35, Paolo Bonzini ha scritto:
> The x86-64 extended low-byte registers were fetched correctly from reg,
> but not from mod/rm.
> 
> This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
> not enough.

Well, it is enough but it takes 2 minutes to reach the point where
hardware virtualization is used.  It is doing a lot of stuff in
emulation mode because FS and GS have leftovers from the A20 test:

FS =0000 0000000000000000 0000ffff 00009300 DPL=0 DS16 [-WA]
GS =ffff 00000000000ffff0 0000ffff 00009300 DPL=0 DS16 [-WA]

0x00000000000113be:  in     $0x92,%al
0x00000000000113c0:  or     $0x2,%al
0x00000000000113c2:  out    %al,$0x92
0x00000000000113c4:  xor    %ax,%ax
0x00000000000113c6:  mov    %ax,%fs
0x00000000000113c8:  dec    %ax
0x00000000000113c9:  mov    %ax,%gs
0x00000000000113cb:  inc    %ax
0x00000000000113cc:  mov    %ax,%fs:0x200
0x00000000000113d0:  cmp    %gs:0x210,%ax
0x00000000000113d5:  je     0x113cb

The DPL < RPL test fails.  Any ideas?  Should we introduce a new
intermediate value for emulate_invalid_guest_state (0=none, 1=some, 2=full)?

Paolo

> Cc: gnatapov@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 3.9
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index aa68106..028b34f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1239,9 +1239,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  	ctxt->modrm_seg = VCPU_SREG_DS;
>  
>  	if (ctxt->modrm_mod == 3) {
> +		int highbyte_regs = ctxt->rex_prefix == 0;
> +
>  		op->type = OP_REG;
>  		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
> -		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm, ctxt->d & ByteOp);
> +		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
> +					       highbyte_regs && (ctxt->d & ByteOp));
>  		if (ctxt->d & Sse) {
>  			op->type = OP_XMM;
>  			op->bytes = 16;
> 

