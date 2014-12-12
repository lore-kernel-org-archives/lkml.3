Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaLLWv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:51:27 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:58170 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaLLWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:51:26 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: CONFIG_CC_OPTIMIZE_FOR_SIZE breaking tridentfb
Date: Fri, 12 Dec 2014 23:51:06 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-fbdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412122351.06995.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have a weird problem with CONFIG_CC_OPTIMIZE_FOR_SIZE.

When it's enabled, tridentfb hangs with Blade3D card (ID 0x9880) in 
blade_image_blit(). The screen is blank with some artifacts and  machine does 
not respond to ping or keyboard. However, it can be rebooted by Alt+SysRq+B. 
It works fine with other cards (3DImage 9750 and CyberBlade XP) with no blit 
implementation. Commenting out contents of blade_image_blit() function makes 
the hang go away (nothing useful on the screen, of course).

Compiled kernel without CONFIG_CC_OPTIMIZE_FOR_SIZE: works
Then inserted #pragma GCC optimize ("Os") line into tridentfb.c: hangs (1)
Then added __attribute__((optimize("O2"))) to blade_image_blit(): works (2)

Compiled kernel with CONFIG_CC_OPTIMIZE_FOR_SIZE: hangs.
Then inserted #pragma GCC optimize ("O2") line into tridentfb.c: still hangs!
Then added __attribute__((optimize("O2"))) to blade_image_blit(): still hangs

$ gcc --version
gcc (Debian 4.7.2-5) 4.7.2

WTF is going on here?

objdumps from case (1) and (2):
this one hangs:
00000965 <blade_image_blit>:
     965:       55                      push   %ebp
     966:       57                      push   %edi
     967:       56                      push   %esi
     968:       89 d6                   mov    %edx,%esi
     96a:       53                      push   %ebx
     96b:       8b 38                   mov    (%eax),%edi
     96d:       8b 54 24 14             mov    0x14(%esp),%edx
     971:       8b 5c 24 18             mov    0x18(%esp),%ebx
     975:       8b 6c 24 1c             mov    0x1c(%esp),%ebp
     979:       8b 44 24 20             mov    0x20(%esp),%eax
     97d:       89 87 60 21 00 00       mov    %eax,0x2160(%edi)
     983:       8b 44 24 24             mov    0x24(%esp),%eax
     987:       89 87 64 21 00 00       mov    %eax,0x2164(%edi)
     98d:       b8 00 00 18 a0          mov    $0xa0180000,%eax
     992:       89 87 44 21 00 00       mov    %eax,0x2144(%edi)
     998:       89 d0                   mov    %edx,%eax
     99a:       c1 e0 10                shl    $0x10,%eax
     99d:       09 c8                   or     %ecx,%eax
     99f:       89 87 08 21 00 00       mov    %eax,0x2108(%edi)
     9a5:       8d 44 2a ff             lea    -0x1(%edx,%ebp,1),%eax
     9a9:       c1 e0 10                shl    $0x10,%eax
     9ac:       8d 54 19 ff             lea    -0x1(%ecx,%ebx,1),%edx
     9b0:       09 d0                   or     %edx,%eax
     9b2:       89 87 0c 21 00 00       mov    %eax,0x210c(%edi)
     9b8:       8d 43 1f                lea    0x1f(%ebx),%eax
     9bb:       8d 0c ad 00 00 00 00    lea    0x0(,%ebp,4),%ecx
     9c2:       c1 e8 05                shr    $0x5,%eax
     9c5:       8d 97 00 00 01 00       lea    0x10000(%edi),%edx
     9cb:       0f af c8                imul   %eax,%ecx
     9ce:       89 d7                   mov    %edx,%edi
     9d0:       f3 a4                   rep movsb %ds:(%esi),%es:(%edi)
     9d2:       5b                      pop    %ebx
     9d3:       5e                      pop    %esi
     9d4:       5f                      pop    %edi
     9d5:       5d                      pop    %ebp
     9d6:       c3                      ret

this one works:
00000965 <writemmr.isra.8>:
     965:       01 d0                   add    %edx,%eax
     967:       89 08                   mov    %ecx,(%eax)
     969:       c3                      ret
     96a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi

00000970 <blade_image_blit>:
     970:       83 ec 1c                sub    $0x1c,%esp
     973:       89 5c 24 0c             mov    %ebx,0xc(%esp)
     977:       89 c3                   mov    %eax,%ebx
     979:       8b 44 24 28             mov    0x28(%esp),%eax
     97d:       89 74 24 10             mov    %esi,0x10(%esp)
     981:       89 ce                   mov    %ecx,%esi
     983:       8b 4c 24 2c             mov    0x2c(%esp),%ecx
     987:       89 54 24 04             mov    %edx,0x4(%esp)
     98b:       ba 60 21 00 00          mov    $0x2160,%edx
     990:       89 7c 24 14             mov    %edi,0x14(%esp)
     994:       8b 7c 24 20             mov    0x20(%esp),%edi
     998:       89 04 24                mov    %eax,(%esp)
     99b:       8b 44 24 30             mov    0x30(%esp),%eax
     99f:       89 6c 24 18             mov    %ebp,0x18(%esp)
     9a3:       8b 6c 24 24             mov    0x24(%esp),%ebp
     9a7:       89 44 24 08             mov    %eax,0x8(%esp)
     9ab:       8b 03                   mov    (%ebx),%eax
     9ad:       e8 b3 ff ff ff          call   965 <writemmr.isra.8>
     9b2:       8b 4c 24 08             mov    0x8(%esp),%ecx
     9b6:       ba 64 21 00 00          mov    $0x2164,%edx
     9bb:       8b 03                   mov    (%ebx),%eax
     9bd:       e8 a3 ff ff ff          call   965 <writemmr.isra.8>
     9c2:       8b 03                   mov    (%ebx),%eax
     9c4:       b9 00 00 18 a0          mov    $0xa0180000,%ecx
     9c9:       ba 44 21 00 00          mov    $0x2144,%edx
     9ce:       e8 92 ff ff ff          call   965 <writemmr.isra.8>
     9d3:       8b 03                   mov    (%ebx),%eax
     9d5:       89 f9                   mov    %edi,%ecx
     9d7:       c1 e1 10                shl    $0x10,%ecx
     9da:       ba 08 21 00 00          mov    $0x2108,%edx
     9df:       09 f1                   or     %esi,%ecx
     9e1:       e8 7f ff ff ff          call   965 <writemmr.isra.8>
     9e6:       8b 04 24                mov    (%esp),%eax
     9e9:       ba 0c 21 00 00          mov    $0x210c,%edx
     9ee:       8d 4c 07 ff             lea    -0x1(%edi,%eax,1),%ecx
     9f2:       c1 e1 10                shl    $0x10,%ecx
     9f5:       8d 44 2e ff             lea    -0x1(%esi,%ebp,1),%eax
     9f9:       09 c1                   or     %eax,%ecx
     9fb:       8b 03                   mov    (%ebx),%eax
     9fd:       e8 63 ff ff ff          call   965 <writemmr.isra.8>
     a02:       8b 0c 24                mov    (%esp),%ecx
     a05:       8d 55 1f                lea    0x1f(%ebp),%edx
     a08:       8b 03                   mov    (%ebx),%eax
     a0a:       c1 ea 05                shr    $0x5,%edx
     a0d:       8b 5c 24 0c             mov    0xc(%esp),%ebx
     a11:       8b 74 24 10             mov    0x10(%esp),%esi
     a15:       c1 e1 02                shl    $0x2,%ecx
     a18:       8b 7c 24 14             mov    0x14(%esp),%edi
     a1c:       0f af ca                imul   %edx,%ecx
     a1f:       8b 6c 24 18             mov    0x18(%esp),%ebp
     a23:       05 00 00 01 00          add    $0x10000,%eax
     a28:       8b 54 24 04             mov    0x4(%esp),%edx
     a2c:       83 c4 1c                add    $0x1c,%esp
     a2f:       e9 fc ff ff ff          jmp    a30 <blade_image_blit+0xc0>
                        a30: R_386_PC32 memcpy


-- 
Ondrej Zary
