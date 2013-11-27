Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab3K0XEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:04:46 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:32778 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3K0XEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:04:42 -0500
MIME-Version: 1.0
In-Reply-To: <cb0c1623-0e58-4418-b22e-cdcadbf31dea@email.android.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
	<5294F10C.8060901@amacapital.net>
	<CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
	<52964EC7.9000504@zytor.com>
	<52966C0A.7070201@zytor.com>
	<20131127222104.GA748@pd.tnic>
	<b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com>
	<20131127222944.GB748@pd.tnic>
	<cb0c1623-0e58-4418-b22e-cdcadbf31dea@email.android.com>
Date: Wed, 27 Nov 2013 15:04:41 -0800
X-Google-Sender-Auth: jlmjkne1T9M79H_jsqMvOxiJ8iI
Message-ID: <CA+55aFzTppZ+uhZ+mfHYmmJ9+aboEMUQ9PUfW63BTA-z+1nWqQ@mail.gmail.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 2:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> No, we're not... sysexit/sysret doesn't count.

So sysexit/sysret doesn't count as a serializing instruction, no. But
it doesn't need to, because *self*-modifying code doesn't need a
serializing instruction, only a branch. It's only *cross*-modifying
code that needs a serializing instruction.

So the IPI is sufficient for the cross-modifying case, and the sysret
is sufficient for the self-modifying case. And we also don't need to
worry about "what happens if we schedule to another CPU, and
self-modifying becomes cross-modifying", because the scheduling will
then do the serializing instruction.

So IPI for other CPU's (limited to the mm-mask) and just a system call
for local CPU should be perfectly fine.

          Linus
