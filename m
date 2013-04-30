Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab3D3Ooc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:44:32 -0400
Received: from smtp1.uu.se ([130.238.7.54]:36021 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760050Ab3D3Oo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:44:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.835
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20863.55352.431848.272078@pilspetsen.it.uu.se>
Date: Tue, 30 Apr 2013 16:42:00 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Warlich, Christof" <christof.warlich@siemens.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
In-Reply-To: <6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.43739.999287.287981@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warlich, Christof writes:
 > Mikael Pettersson <mikpe@it.uu.se> writes:
 > > Write to the fpstate ->mxcsr and ->swd fields in the sigaction handler's uc_mcontext.
 > 
 > To me, "sigaction handler's uc_mcontext" sounds like userspace, which really confuses me:
 > Even in most recent glibc-2.17, uc_mcontext is of type mcontext_t, which us defined as:
 > 
 > typedef struct {
 >   gregset_t gregs;
 >   fpregset_t fpregs;
 > } mcontext_t;
 > 
 > typedef struct fpregset {
 >     union {
 > 	struct fpchip_state {
 > 	    int state[27];
 > 	    int status;
 > 	} fpchip_state;
 > 	struct fp_emul_space {
 > 	    char fp_emul[246];
 > 	    char fp_epad[2];
 > 	} fp_emul_space;
 > 	int f_fpregs[62];
 >     } fp_reg_set;
 >     long int f_wregs[33];
 > } fpregset_t;
 > 
 > So there is no fpstate whatsoever.

You're looking at the wrong header: glibc-2.17/sysdeps/i386/sys/ucontext.h is legacy SVR4.
Instead look at glibc-2.17/sysdeps/unix/sysv/linux/x86/sys/ucontext.h.

(If the old one got installed on your system then something there is seriously wrong.)

The only quirk is that to access ->mxcsr on 32-bit you have to check if the high half of
->status contains FXSR_MAGIC and if so you need to cast that pointer to struct _fpstate*.
