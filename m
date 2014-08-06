Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaHFLpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:45:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbaHFLpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:45:53 -0400
Message-ID: <53E2156E.9060700@suse.cz>
Date: Wed, 06 Aug 2014 13:45:50 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: escape single backslashes in macro make-cmd
References: <20140726163551.19857.17737.stgit@zurg>
In-Reply-To: <20140726163551.19857.17737.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-26 18:35, Konstantin Khlebnikov wrote:
> This already has been fixed in commit c353acba28fb3fa1fd05fd
> ("kbuild: make: fix if_changed when command contains backslashes")
> but escaping still isn't perfect and triggers false-positive rebuilds.
> 
> For x86 problem happens every time, because rules in arch/x86/realmode/rm/
> and arch/x86/boot/ contains commands like sed -n -e 's/foo\(.*\)/\1/p'.
> Backslash in \1 isn't escaped and turns into ascii symbol with code 1.
> Macro if_changed detects command change and rebuilds target again and again.
> 
> Backslash escaping conflicts with other passes because it's used for escaping
> other symbols. To avoid that current macro handles only double backslashes.
> Obviously this doesn't work for \1 like above.
> 
> This patch reorders passes. It doubles all backslashes before escaping # and '
> 
> Visible effect in rebuilding x86/defconfig without changes, before patch:
> 
> blind@zurg:~/src/linux$ make V=2
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh - due to target missing
>   CHK     include/generated/compile.h
>   PASYMS  arch/x86/realmode/rm/pasyms.h - due to command line change

With which make and shell version are you seeing this? While the patch
looks correct, I can't reproduce the error here:

$ make V=2
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh - due to target missing
  CHK     include/generated/compile.h
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 12 modules - due to target is PHONY
$ cat arch/x86/realmode/rm/.pasyms.h.cmd
cmd_arch/x86/realmode/rm/pasyms.h := nm arch/x86/realmode/rm/header.o
arch/x86/realmode/rm/trampoline_64.o arch/x86/realmode/rm/stack.o
arch/x86/realmode/rm/reboot.o arch/x86/realmode/rm/wakeup_asm.o
arch/x86/realmode/rm/wakemain.o arch/x86/realmode/rm/video-mode.o
arch/x86/realmode/rm/copy.o arch/x86/realmode/rm/bioscall.o
arch/x86/realmode/rm/regs.o arch/x86/realmode/rm/video-vga.o
arch/x86/realmode/rm/video-vesa.o arch/x86/realmode/rm/video-bios.o |
sed -n -r -e 's/^([0-9a-fA-F]+) [ABCDGRSTVW] (.+)$$/pa_\2 = \2;/p' |
sort | uniq > arch/x86/realmode/rm/pasyms.h

This is with both 3.16 and my kbuild branch, which is based on 3.16-rc1.
Also, in the description, you say that backslash escaping conflicts with
escaping # and ', but this has nothing to do with the \2 backreference
in the sed command.

Michal
