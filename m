Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaEVADg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:03:36 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:45204 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaEVADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140521235143.GC21575@pd.tnic>
References: <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
	<CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
	<CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
	<20140521224816.GP25130@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
	<CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
	<CA+55aFwXTME_Ge53xKjyM35mVQ+gmvDPwTLa5kR5zAMnNTFSbQ@mail.gmail.com>
	<20140521235143.GC21575@pd.tnic>
Date: Thu, 22 May 2014 09:03:34 +0900
X-Google-Sender-Auth: 7vUXMRKzukv01Ip1J-zW7RoCsYE
Message-ID: <CA+55aFyD7wzt_Ev1yc3R+WnFNCBodGkEw5-qLsbhFMPQoFnEWw@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andy Lutomirski <luto@amacapital.net>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 8:51 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> Regardless, exceptions like MCE cannot be held pending and do pierce the
> NMI handler on both.

No, that's fine, if it's a thread-synchronous thing (ie a memory load
that causes errors). But for NMI handlers, that is irrelevant: if the
NMI code itself gets memory errors, the machine really is dead. Let's
face it, we're going to panic and reboot, there's no other real
alternative (other than the "just log it, pray, and continue in
unstable mode", which is actually a perfectly valid alternative in
many cases, since people don't necessarily care deeply and have
written their distributed algorithms to not rely on any particular
thread too  much, and will verify the end results anyway).

The problem is literally the non-synchronous things (like another CPU
having problems) where things like broadcast will actually turn a
non-thread-synchronous thing into problems for other CPU's. Then, a
user-mode memory access error (that we *can* recover from, perhaps by
killing the process and isolating the page) can turn into a
unrecoverable error on another CPU because it got interrupted at a
point where it really couldn't afford to be interrupted.

It appears Intel is fixing their braindamage.

                      Linus
