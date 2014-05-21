Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaEUXHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:07:40 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46667 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaEUXHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:07:39 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
References: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic> <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
 <20140521224816.GP25130@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 16:07:18 -0700
Message-ID: <CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 4:05 PM, Luck, Tony <tony.luck@intel.com> wrote:
> On Wed, May 21, 2014 at 03:39:11PM -0700, Andy Lutomirski wrote:
>> But if we get a new MCE in here, it will be an MCE from kernel context
>> and it's fatal. So, yes, we'll clobber the stack, but we'll never
>> return (unless tolerant is set to something insane), so who cares?
>
> Remember that machine checks are broadcast.  So some other cpu
> can hit a recoverable machine check in user mode ... but that int#18
> goes everywhere.  Other cpus are innocent bystanders ... they will
> see MCG_STATUS.RIPV=1, MCG_STATUS.EIPV=0 and nothing important
> in any of their machine check banks.
>
> But if we are still finishing off processing the previous machine check,
> this will be a nested one - and BOOM, we are dead.

Oh.  Well, crap.

FWIW, this means that there really is a problem if one of these #MC
errors hits an innocent bystander who just happens to be handling an
NMI, at least if we delete the nested NMI code.  But I think my
simplified proposal gets this right.

>
> -Tony
>
> [If you peer closely at the latest edition of the SDM - you'll see the
> bits are defined for a non-broadcast model ... e.g. LMCE_S bit in
> MCG_STATUS .... but currently shipping silicon doesn't use that]



-- 
Andy Lutomirski
AMA Capital Management, LLC
