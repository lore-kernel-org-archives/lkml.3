Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaEVAGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:06:05 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57034 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEVAGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140521235143.GC21575@pd.tnic>
References: <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
 <20140521224816.GP25130@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
 <CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
 <CA+55aFwXTME_Ge53xKjyM35mVQ+gmvDPwTLa5kR5zAMnNTFSbQ@mail.gmail.com> <20140521235143.GC21575@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 17:05:41 -0700
Message-ID: <CALCETrW2krUjFq-zj2MNvg6sJg5NS3faSogLmHC6p0tKOTgH+g@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 4:51 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, May 22, 2014 at 08:30:33AM +0900, Linus Torvalds wrote:
>> If the OS then decides to take down the whole machine, the OS - not
>> the hardware - can choose to do something that will punch through
>> other CPU's NMI blocking (notably, init/reset), but the hardware doing
>> this on its own is just broken if true.
>
> Not that it is any consolation but MCE is not broadcast on AMD.
>
> Regardless, exceptions like MCE cannot be held pending and do pierce the
> NMI handler on both.
>
> Now, if the NMI handler experiences a non-broadcast MCE on the same CPU,
> while running, we're simply going to panic as we're in kernel space
> anyway.
>
> The only problem is if the NMI handler gets interrupted while running
> on a bystander CPU. And I think we could deal with this because the
> bystander would not see an MCE and will return safely. We just need
> to make sure that it returns back to the said NMI handler and not to
> userspace. Unless I'm missing something ...

Under my "always RET unless returning from IST to weird CS or to
specific known-invalid-stack regions" proposal this should work fine.
In the current code it'll also work fine *unless* it hits really early
in the NMI, in which case a second NMI can kill us.

--Andy
