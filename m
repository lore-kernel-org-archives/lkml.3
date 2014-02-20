Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaBTX1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:27:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46307 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbaBTX1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:27:41 -0500
Message-ID: <53068F5C.9000008@zytor.com>
Date: Thu, 20 Feb 2014 15:27:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: "m" constraints, jumps,  and alternatives
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The alternatives mechanism suffers from problems whenever there are
PC-relative items in the instruction stream.  We currently have a hack
in the alternatives mechanism where we detect the opcode of a call or
jmp instruction and adjust the offset, but that only works if the
replacement code consists solely of a call or jmp.

Well, when there are "m" contraints, we could end up with PC-relative
offsets if someone were to point the function in question at a global
variable on 64 bits.  This is much harder to decode at runtime; doing so
would require pretty much a full x86 decoder (which we do have one in
the kernel now, but it would be pretty slow I would think.)

I talked with H.J. about this, and one way to do this would be to do
post-linkage fixup of the alternatives section.  This does, however,
would seem to not work easily with kernel modules, as the kernel module
is left pre-link.  We could, of course, do equivalent fixup in the
kernel at module insertion time, since the module will include the
relocations.

Another option is to say "don't do that then", and weed out the current
uses of "m" and instead force the pointer in question explicitly into a
register.

What do you guys think?

	-hpa

