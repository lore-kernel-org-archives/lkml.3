Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbbANOaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:30:01 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58482 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbbANO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:29:58 -0500
Date: Wed, 14 Jan 2015 23:30:33 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_eh_report() unable to handle kernel NULL pointer dereference
Message-ID: <20150114143033.GA23906@swordfish>
References: <20150113142509.GA985@swordfish>
 <20150113152738.GC2976@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113152738.GC2976@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/13/15 10:27), Tejun Heo wrote:
> On Tue, Jan 13, 2015 at 11:25:09PM +0900, Sergey Senozhatsky wrote:
> > Hi,
> > 
> > linux-next 20150112
> > 
> > [  934.572323] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
> > [  934.572329] ata2: irq_stat 0x00400040, connection status changed
> > [  934.572332] ata2: SError: { HostInt PHYRdyChg 10B8B DevExch }
> > [  934.572341] BUG: unable to handle kernel NULL pointer dereference at 0000000000000460
> > [  934.572346] IP: [<ffffffff812c722c>] ata_eh_report+0x3ad/0x74d
> 
> Any chance you can run addr2line on it and map it to the source line?
>

Hello,

sorry for the delay, emails from my android gmail app are blocked as "outlook
spam".

here it is in reverse order, RIP is the last one.

~/_next$ addr2line -e vmlinux -i ffffffff812c97a3
   _next/drivers/ata/libata-eh.c:4020
~/_next$ addr2line -e vmlinux -i ffffffff812cfb7e
   _next/drivers/ata/libahci.c:1438
~/_next$ addr2line -e vmlinux -i ffffffff812cf943
   _next/drivers/ata/libahci.c:1470
~/_next$ addr2line -e vmlinux -i ffffffff812cfb7e
   _next/drivers/ata/libahci.c:1438
~/_next$ addr2line -e vmlinux -i ffffffff812d0bab
   _next/drivers/ata/libahci.c:1383
~/_next$ addr2line -e vmlinux -i ffffffff812c05c0
   _next/include/linux/libata.h:1085
   _next/drivers/ata/libata-core.c:3715
~/_next$ addr2line -e vmlinux -i ffffffff812c96e5
   _next/drivers/ata/libata-eh.c:3991
~/_next$ addr2line -e vmlinux -i ffffffff812c722c
   _next/drivers/ata/libata-eh.c:2485
   _next/drivers/ata/libata-eh.c:2583



just in case: RIP <ffffffff812c722c>

ffffffff812c6e7f <ata_eh_report>:
ffffffff812c6e7f:       55                      push   %rbp
ffffffff812c6e80:       48 89 fe                mov    %rdi,%rsi
ffffffff812c6e83:       ba 01 00 00 00          mov    $0x1,%edx
ffffffff812c6e88:       48 89 e5                mov    %rsp,%rbp
ffffffff812c6e8b:       41 57                   push   %r15
ffffffff812c6e8d:       41 56                   push   %r14
ffffffff812c6e8f:       41 55                   push   %r13
ffffffff812c6e91:       41 54                   push   %r12
ffffffff812c6e93:       53                      push   %rbx
ffffffff812c6e94:       48 81 ec a8 00 00 00    sub    $0xa8,%rsp
ffffffff812c6e9b:       48 89 bd 68 ff ff ff    mov    %rdi,-0x98(%rbp)
ffffffff812c6ea2:       31 ff                   xor    %edi,%edi
ffffffff812c6ea4:       e8 7e 46 ff ff          callq  ffffffff812bb527 <ata_link_next>
ffffffff812c6ea9:       48 85 c0                test   %rax,%rax
ffffffff812c6eac:       49 89 c4                mov    %rax,%r12
ffffffff812c6eaf:       0f 84 08 07 00 00       je     ffffffff812c75bd <ata_eh_report+0x73e>
ffffffff812c6eb5:       41 f6 84 24 b4 04 00    testb  $0x8,0x4b4(%r12)
ffffffff812c6ebc:       00 08 
ffffffff812c6ebe:       49 8b 1c 24             mov    (%r12),%rbx
ffffffff812c6ec2:       c7 85 70 ff ff ff 00    movl   $0x0,-0x90(%rbp)
ffffffff812c6ec9:       00 00 00 
ffffffff812c6ecc:       66 c7 85 74 ff ff ff    movw   $0x0,-0x8c(%rbp)
ffffffff812c6ed3:       00 00 
ffffffff812c6ed5:       0f 85 ce 06 00 00       jne    ffffffff812c75a9 <ata_eh_report+0x72a>
ffffffff812c6edb:       41 80 bc 24 bc 04 00    cmpb   $0x0,0x4bc(%r12)
ffffffff812c6ee2:       00 00 
ffffffff812c6ee4:       b8 00 00 00 00          mov    $0x0,%eax
ffffffff812c6ee9:       4d 8d ac 24 bc 04 00    lea    0x4bc(%r12),%r13
ffffffff812c6ef0:       00 
ffffffff812c6ef1:       4c 8d bb d0 01 00 00    lea    0x1d0(%rbx),%r15
ffffffff812c6ef8:       4c 0f 44 e8             cmove  %rax,%r13
ffffffff812c6efc:       45 31 f6                xor    %r14d,%r14d
ffffffff812c6eff:       48 8d 83 d0 1e 00 00    lea    0x1ed0(%rbx),%rax
ffffffff812c6f06:       48 89 85 60 ff ff ff    mov    %rax,-0xa0(%rbp)
ffffffff812c6f0d:       49 f7 07 00 00 01 00    testq  $0x10000,(%r15)
ffffffff812c6f14:       74 2d                   je     ffffffff812c6f43 <ata_eh_report+0xc4>
ffffffff812c6f16:       49 8b 7f b8             mov    -0x48(%r15),%rdi
ffffffff812c6f1a:       e8 65 5c ff ff          callq  ffffffff812bcb84 <ata_dev_phys_link>
ffffffff812c6f1f:       4c 39 e0                cmp    %r12,%rax
ffffffff812c6f22:       75 1f                   jne    ffffffff812c6f43 <ata_eh_report+0xc4>
ffffffff812c6f24:       49 8b 07                mov    (%r15),%rax
ffffffff812c6f27:       a8 40                   test   $0x40,%al
ffffffff812c6f29:       74 07                   je     ffffffff812c6f32 <ata_eh_report+0xb3>
ffffffff812c6f2b:       41 83 7f 5c 01          cmpl   $0x1,0x5c(%r15)
ffffffff812c6f30:       74 11                   je     ffffffff812c6f43 <ata_eh_report+0xc4>
ffffffff812c6f32:       a9 00 00 02 00          test   $0x20000,%eax
ffffffff812c6f37:       74 07                   je     ffffffff812c6f40 <ata_eh_report+0xc1>
ffffffff812c6f39:       41 83 7f 5c 00          cmpl   $0x0,0x5c(%r15)
ffffffff812c6f3e:       74 03                   je     ffffffff812c6f43 <ata_eh_report+0xc4>
ffffffff812c6f40:       41 ff c6                inc    %r14d
ffffffff812c6f43:       49 81 c7 e8 00 00 00    add    $0xe8,%r15
ffffffff812c6f4a:       4c 3b bd 60 ff ff ff    cmp    -0xa0(%rbp),%r15
ffffffff812c6f51:       75 ba                   jne    ffffffff812c6f0d <ata_eh_report+0x8e>
ffffffff812c6f53:       45 85 f6                test   %r14d,%r14d
ffffffff812c6f56:       75 0f                   jne    ffffffff812c6f67 <ata_eh_report+0xe8>
ffffffff812c6f58:       41 83 bc 24 a4 04 00    cmpl   $0x0,0x4a4(%r12)
ffffffff812c6f5f:       00 00 
ffffffff812c6f61:       0f 84 42 06 00 00       je     ffffffff812c75a9 <ata_eh_report+0x72a>
ffffffff812c6f67:       f6 43 20 04             testb  $0x4,0x20(%rbx)
ffffffff812c6f6b:       48 c7 c0 d4 a6 5a 81    mov    $0xffffffff815aa6d4,%rax
ffffffff812c6f72:       49 c7 c6 6d 0e 58 81    mov    $0xffffffff81580e6d,%r14
ffffffff812c6f79:       8b 8b 68 3b 00 00       mov    0x3b68(%rbx),%ecx
ffffffff812c6f7f:       4c 0f 45 f0             cmovne %rax,%r14
ffffffff812c6f83:       83 f9 04                cmp    $0x4,%ecx
ffffffff812c6f86:       7f 1a                   jg     ffffffff812c6fa2 <ata_eh_report+0x123>
ffffffff812c6f88:       48 c7 c2 24 28 5b 81    mov    $0xffffffff815b2824,%rdx
ffffffff812c6f8f:       be 06 00 00 00          mov    $0x6,%esi
ffffffff812c6f94:       31 c0                   xor    %eax,%eax
ffffffff812c6f96:       48 8d bd 70 ff ff ff    lea    -0x90(%rbp),%rdi
ffffffff812c6f9d:       e8 6d dd f3 ff          callq  ffffffff81204d0f <snprintf>
ffffffff812c6fa2:       49 8b bc 24 98 04 00    mov    0x498(%r12),%rdi
ffffffff812c6fa9:       00 
ffffffff812c6faa:       45 8b 8c 24 a0 04 00    mov    0x4a0(%r12),%r9d
ffffffff812c6fb1:       00 
ffffffff812c6fb2:       45 8b 84 24 04 04 00    mov    0x404(%r12),%r8d
ffffffff812c6fb9:       00 
ffffffff812c6fba:       41 8b 8c 24 a4 04 00    mov    0x4a4(%r12),%ecx
ffffffff812c6fc1:       00 
ffffffff812c6fc2:       48 85 ff                test   %rdi,%rdi
ffffffff812c6fc5:       41 8b 84 24 a8 04 00    mov    0x4a8(%r12),%eax
ffffffff812c6fcc:       00 
ffffffff812c6fcd:       74 4d                   je     ffffffff812c701c <ata_eh_report+0x19d>
ffffffff812c6fcf:       48 8d b5 70 ff ff ff    lea    -0x90(%rbp),%rsi
ffffffff812c6fd6:       48 c7 c2 29 28 5b 81    mov    $0xffffffff815b2829,%rdx
ffffffff812c6fdd:       41 52                   push   %r10
ffffffff812c6fdf:       56                      push   %rsi
ffffffff812c6fe0:       48 c7 c6 cb da 56 81    mov    $0xffffffff8156dacb,%rsi
ffffffff812c6fe7:       41 56                   push   %r14
ffffffff812c6fe9:       50                      push   %rax
ffffffff812c6fea:       31 c0                   xor    %eax,%eax
ffffffff812c6fec:       e8 4f 55 ff ff          callq  ffffffff812bc540 <ata_dev_printk>
ffffffff812c6ff1:       48 83 c4 20             add    $0x20,%rsp
ffffffff812c6ff5:       4d 85 ed                test   %r13,%r13
ffffffff812c6ff8:       74 6a                   je     ffffffff812c7064 <ata_eh_report+0x1e5>
ffffffff812c6ffa:       49 8b bc 24 98 04 00    mov    0x498(%r12),%rdi
ffffffff812c7001:       00 
ffffffff812c7002:       4c 89 e9                mov    %r13,%rcx
ffffffff812c7005:       48 c7 c2 63 fc 56 81    mov    $0xffffffff8156fc63,%rdx
ffffffff812c700c:       31 c0                   xor    %eax,%eax
ffffffff812c700e:       48 c7 c6 cb da 56 81    mov    $0xffffffff8156dacb,%rsi
ffffffff812c7015:       e8 26 55 ff ff          callq  ffffffff812bc540 <ata_dev_printk>
ffffffff812c701a:       eb 48                   jmp    ffffffff812c7064 <ata_eh_report+0x1e5>
ffffffff812c701c:       56                      push   %rsi
ffffffff812c701d:       48 8d b5 70 ff ff ff    lea    -0x90(%rbp),%rsi
ffffffff812c7024:       48 c7 c2 29 28 5b 81    mov    $0xffffffff815b2829,%rdx
ffffffff812c702b:       4c 89 e7                mov    %r12,%rdi
ffffffff812c702e:       56                      push   %rsi
ffffffff812c702f:       48 c7 c6 cb da 56 81    mov    $0xffffffff8156dacb,%rsi
ffffffff812c7036:       41 56                   push   %r14
ffffffff812c7038:       50                      push   %rax
ffffffff812c7039:       31 c0                   xor    %eax,%eax
ffffffff812c703b:       e8 6b 53 ff ff          callq  ffffffff812bc3ab <ata_link_printk>
ffffffff812c7040:       48 83 c4 20             add    $0x20,%rsp
ffffffff812c7044:       4d 85 ed                test   %r13,%r13
ffffffff812c7047:       74 1b                   je     ffffffff812c7064 <ata_eh_report+0x1e5>
ffffffff812c7049:       4c 89 e9                mov    %r13,%rcx
ffffffff812c704c:       48 c7 c2 63 fc 56 81    mov    $0xffffffff8156fc63,%rdx
ffffffff812c7053:       48 c7 c6 cb da 56 81    mov    $0xffffffff8156dacb,%rsi
ffffffff812c705a:       4c 89 e7                mov    %r12,%rdi
ffffffff812c705d:       31 c0                   xor    %eax,%eax
ffffffff812c705f:       e8 47 53 ff ff          callq  ffffffff812bc3ab <ata_link_printk>
ffffffff812c7064:       41 8b 84 24 a0 04 00    mov    0x4a0(%r12),%eax
ffffffff812c706b:       00 
ffffffff812c706c:       85 c0                   test   %eax,%eax
ffffffff812c706e:       0f 84 80 01 00 00       je     ffffffff812c71f4 <ata_eh_report+0x375>
ffffffff812c7074:       48 c7 c1 6d 0e 58 81    mov    $0xffffffff81580e6d,%rcx
ffffffff812c707b:       a9 00 00 00 04          test   $0x4000000,%eax
ffffffff812c7080:       49 c7 c7 e4 26 5b 81    mov    $0xffffffff815b26e4,%r15
ffffffff812c7087:       4c 0f 44 f9             cmove  %rcx,%r15
ffffffff812c708b:       48 c7 c2 ed 26 5b 81    mov    $0xffffffff815b26ed,%rdx
ffffffff812c7092:       a9 00 00 00 02          test   $0x2000000,%eax
ffffffff812c7097:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c709b:       a9 00 00 00 01          test   $0x1000000,%eax
ffffffff812c70a0:       49 c7 c6 1c 27 5b 81    mov    $0xffffffff815b271c,%r14
ffffffff812c70a7:       49 c7 c5 23 27 5b 81    mov    $0xffffffff815b2723,%r13
ffffffff812c70ae:       41 57                   push   %r15
ffffffff812c70b0:       48 89 95 38 ff ff ff    mov    %rdx,-0xc8(%rbp)
ffffffff812c70b7:       48 c7 c2 f7 26 5b 81    mov    $0xffffffff815b26f7,%rdx
ffffffff812c70be:       49 c7 c3 2d 27 5b 81    mov    $0xffffffff815b272d,%r11
ffffffff812c70c5:       49 c7 c2 35 27 5b 81    mov    $0xffffffff815b2735,%r10
ffffffff812c70cc:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c70d0:       a9 00 00 80 00          test   $0x800000,%eax
ffffffff812c70d5:       48 c7 c7 40 27 5b 81    mov    $0xffffffff815b2740,%rdi
ffffffff812c70dc:       48 c7 c6 49 27 5b 81    mov    $0xffffffff815b2749,%rsi
ffffffff812c70e3:       49 c7 c1 59 27 5b 81    mov    $0xffffffff815b2759,%r9
ffffffff812c70ea:       48 89 95 40 ff ff ff    mov    %rdx,-0xc0(%rbp)
ffffffff812c70f1:       48 c7 c2 02 27 5b 81    mov    $0xffffffff815b2702,%rdx
ffffffff812c70f8:       49 c7 c0 66 27 5b 81    mov    $0xffffffff815b2766,%r8
ffffffff812c70ff:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c7103:       a9 00 00 40 00          test   $0x400000,%eax
ffffffff812c7108:       ff b5 38 ff ff ff       pushq  -0xc8(%rbp)
ffffffff812c710e:       ff b5 40 ff ff ff       pushq  -0xc0(%rbp)
ffffffff812c7114:       48 89 95 48 ff ff ff    mov    %rdx,-0xb8(%rbp)
ffffffff812c711b:       48 c7 c2 0b 27 5b 81    mov    $0xffffffff815b270b,%rdx
ffffffff812c7122:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c7126:       a9 00 00 20 00          test   $0x200000,%eax
ffffffff812c712b:       ff b5 48 ff ff ff       pushq  -0xb8(%rbp)
ffffffff812c7131:       48 89 95 50 ff ff ff    mov    %rdx,-0xb0(%rbp)
ffffffff812c7138:       48 c7 c2 93 24 5b 81    mov    $0xffffffff815b2493,%rdx
ffffffff812c713f:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c7143:       a9 00 00 10 00          test   $0x100000,%eax
ffffffff812c7148:       ff b5 50 ff ff ff       pushq  -0xb0(%rbp)
ffffffff812c714e:       48 89 95 58 ff ff ff    mov    %rdx,-0xa8(%rbp)
ffffffff812c7155:       48 c7 c2 14 27 5b 81    mov    $0xffffffff815b2714,%rdx
ffffffff812c715c:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c7160:       a9 00 00 08 00          test   $0x80000,%eax
ffffffff812c7165:       4c 0f 44 f1             cmove  %rcx,%r14
ffffffff812c7169:       a9 00 00 04 00          test   $0x40000,%eax
ffffffff812c716e:       4c 0f 44 e9             cmove  %rcx,%r13
ffffffff812c7172:       a9 00 00 02 00          test   $0x20000,%eax
ffffffff812c7177:       48 89 95 60 ff ff ff    mov    %rdx,-0xa0(%rbp)
ffffffff812c717e:       4c 0f 44 d9             cmove  %rcx,%r11
ffffffff812c7182:       a9 00 00 01 00          test   $0x10000,%eax
ffffffff812c7187:       4c 0f 44 d1             cmove  %rcx,%r10
ffffffff812c718b:       f6 c4 08                test   $0x8,%ah
ffffffff812c718e:       48 0f 44 f9             cmove  %rcx,%rdi
ffffffff812c7192:       f6 c4 04                test   $0x4,%ah
ffffffff812c7195:       48 0f 44 f1             cmove  %rcx,%rsi
ffffffff812c7199:       48 c7 c2 50 27 5b 81    mov    $0xffffffff815b2750,%rdx
ffffffff812c71a0:       ff b5 58 ff ff ff       pushq  -0xa8(%rbp)
ffffffff812c71a6:       f6 c4 02                test   $0x2,%ah
ffffffff812c71a9:       48 0f 44 d1             cmove  %rcx,%rdx
ffffffff812c71ad:       f6 c4 01                test   $0x1,%ah
ffffffff812c71b0:       4c 0f 44 c9             cmove  %rcx,%r9
ffffffff812c71b4:       a8 02                   test   $0x2,%al
ffffffff812c71b6:       4c 0f 44 c1             cmove  %rcx,%r8
ffffffff812c71ba:       a8 01                   test   $0x1,%al
ffffffff812c71bc:       ff b5 60 ff ff ff       pushq  -0xa0(%rbp)
ffffffff812c71c2:       48 c7 c0 71 27 5b 81    mov    $0xffffffff815b2771,%rax
ffffffff812c71c9:       41 56                   push   %r14
ffffffff812c71cb:       48 0f 45 c8             cmovne %rax,%rcx
ffffffff812c71cf:       31 c0                   xor    %eax,%eax
ffffffff812c71d1:       41 55                   push   %r13
ffffffff812c71d3:       41 53                   push   %r11
ffffffff812c71d5:       41 52                   push   %r10
ffffffff812c71d7:       57                      push   %rdi
ffffffff812c71d8:       4c 89 e7                mov    %r12,%rdi
ffffffff812c71db:       56                      push   %rsi
ffffffff812c71dc:       48 c7 c6 cb da 56 81    mov    $0xffffffff8156dacb,%rsi
ffffffff812c71e3:       52                      push   %rdx
ffffffff812c71e4:       48 c7 c2 63 28 5b 81    mov    $0xffffffff815b2863,%rdx
ffffffff812c71eb:       e8 bb 51 ff ff          callq  ffffffff812bc3ab <ata_link_printk>
ffffffff812c71f0:       48 83 c4 70             add    $0x70,%rsp
ffffffff812c71f4:       4c 8d 7d 8a             lea    -0x76(%rbp),%r15
ffffffff812c71f8:       41 be 20 00 00 00       mov    $0x20,%r14d
ffffffff812c71fe:       31 c0                   xor    %eax,%eax
ffffffff812c7200:       b9 03 00 00 00          mov    $0x3,%ecx
ffffffff812c7205:       48 8b 93 88 01 00 00    mov    0x188(%rbx),%rdx
ffffffff812c720c:       48 c7 85 76 ff ff ff    movq   $0x0,-0x8a(%rbp)
ffffffff812c7213:       00 00 00 00 
ffffffff812c7217:       48 8d bd 7e ff ff ff    lea    -0x82(%rbp),%rdi
ffffffff812c721e:       48 c7 45 8a 00 00 00    movq   $0x0,-0x76(%rbp)
ffffffff812c7225:       00 
ffffffff812c7226:       f3 ab                   rep stos %eax,%es:(%rdi)
ffffffff812c7228:       48 8d 7d 92             lea    -0x6e(%rbp),%rdi
ffffffff812c71d3:       41 53                   push   %r11
ffffffff812c71d5:       41 52                   push   %r10
ffffffff812c71d7:       57                      push   %rdi
ffffffff812c71d8:       4c 89 e7                mov    %r12,%rdi
ffffffff812c71db:       56                      push   %rsi
ffffffff812c71dc:       48 c7 c6 cb da 56 81    mov    $0xffffffff8156dacb,%rsi
ffffffff812c71e3:       52                      push   %rdx
ffffffff812c71e4:       48 c7 c2 63 28 5b 81    mov    $0xffffffff815b2863,%rdx
ffffffff812c71eb:       e8 bb 51 ff ff          callq  ffffffff812bc3ab <ata_link_printk>
ffffffff812c71f0:       48 83 c4 70             add    $0x70,%rsp
ffffffff812c71f4:       4c 8d 7d 8a             lea    -0x76(%rbp),%r15
ffffffff812c71f8:       41 be 20 00 00 00       mov    $0x20,%r14d
ffffffff812c71fe:       31 c0                   xor    %eax,%eax
ffffffff812c7200:       b9 03 00 00 00          mov    $0x3,%ecx
ffffffff812c7205:       48 8b 93 88 01 00 00    mov    0x188(%rbx),%rdx
ffffffff812c720c:       48 c7 85 76 ff ff ff    movq   $0x0,-0x8a(%rbp)
ffffffff812c7213:       00 00 00 00 
ffffffff812c7217:       48 8d bd 7e ff ff ff    lea    -0x82(%rbp),%rdi
ffffffff812c721e:       48 c7 45 8a 00 00 00    movq   $0x0,-0x76(%rbp)
ffffffff812c7225:       00 
ffffffff812c7226:       f3 ab                   rep stos %eax,%es:(%rdi)
ffffffff812c7228:       48 8d 7d 92             lea    -0x6e(%rbp),%rdi
ffffffff812c722c:       44 8b aa 60 04 00 00    mov    0x460(%rdx),%r13d
ffffffff812c7233:       b1 3e                   mov    $0x3e,%cl
ffffffff812c7235:       f3 aa                   rep stos %al,%es:(%rdi)
ffffffff812c7237:       f6 83 d2 01 00 00 01    testb  $0x1,0x1d2(%rbx)
ffffffff812c723e:       0f 84 55 03 00 00       je     ffffffff812c7599 <ata_eh_report+0x71a>
ffffffff812c7244:       48 89 d7                mov    %rdx,%rdi
ffffffff812c7247:       e8 38 59 ff ff          callq  ffffffff812bcb84 <ata_dev_phys_link>
ffffffff812c724c:       4c 39 e0                cmp    %r12,%rax
ffffffff812c724f:       0f 85 44 03 00 00       jne    ffffffff812c7599 <ata_eh_report+0x71a>
ffffffff812c7255:       83 bb 2c 02 00 00 00    cmpl   $0x0,0x22c(%rbx)
ffffffff812c725c:       0f 84 37 03 00 00       je     ffffffff812c7599 <ata_eh_report+0x71a>
ffffffff812c7262:       48 63 83 e4 01 00 00    movslq 0x1e4(%rbx),%rax
ffffffff812c7269:       83 f8 03                cmp    $0x3,%eax
ffffffff812c726c:       74 38                   je     ffffffff812c72a6 <ata_eh_report+0x427>
ffffffff812c726e:       0f b6 93 a8 01 00 00    movzbl 0x1a8(%rbx),%edx


	-ss
