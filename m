Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3GTOsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:48:03 -0400
Received: from science.horizon.com ([71.41.210.146]:15849 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754139Ab3GTOsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:48:01 -0400
Date: 20 Jul 2013 10:47:58 -0400
Message-ID: <20130720144758.13924.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: bp@alien8.de, linux@horizon.com
Subject: Re: [GIT PULL] x86 fixes for 3.11-rc2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20130720132548.GA13759@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:
> I don't think that matters because this is called only once on suspend.
> Unless the cleaner assembly translates into a palpable speedup, which I
> doubt.

I was thinking about code *size*, actually; I agree that speed is
too small to measure.

Clean code (21 bytes):
  4e:   b9 80 00 00 c0          mov    $0xc0000080,%ecx
  53:   0f 32                   rdmsr  
  55:   0f 30                   wrmsr  
  57:   31 f6                   xor    %esi,%esi
  59:   85 f6                   test   %esi,%esi
  5b:   89 43 14                mov    %eax,0x14(%ebx)
  5e:   89 53 18                mov    %edx,0x18(%ebx)
  61:   75 04                   jne    67 <acpi_suspend_lowlevel+0x67>

Ugly code (50 bytes):
  51:   b9 80 00 00 c0          mov    $0xc0000080,%ecx
  56:   0f 32                   rdmsr  
  58:   31 c9                   xor    %ecx,%ecx
  5a:   89 c6                   mov    %eax,%esi
  5c:   85 c9                   test   %ecx,%ecx
  5e:   89 45 ec                mov    %eax,-0x14(%ebp)
  61:   89 55 f0                mov    %edx,-0x10(%ebp)
  64:   89 73 14                mov    %esi,0x14(%ebx)
  67:   89 53 18                mov    %edx,0x18(%ebx)
  6a:   75 1b                   jne    87 <acpi_suspend_lowlevel+0x87>
  6c:   8b 75 ec                mov    -0x14(%ebp),%esi
  6f:   b9 80 00 00 c0          mov    $0xc0000080,%ecx
  74:   8b 7d f0                mov    -0x10(%ebp),%edi
  77:   89 f0                   mov    %esi,%eax
  79:   89 fa                   mov    %edi,%edx
  7b:   0f 30                   wrmsr  
  7d:   31 c0                   xor    %eax,%eax
  7f:   85 c0                   test   %eax,%eax
  81:   75 04                   jne    87 <acpi_suspend_lowlevel+0x87>

