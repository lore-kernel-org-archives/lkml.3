Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaG1Uom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:44:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49220 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaG1Uoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:44:39 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140728203955.GA4611@thinpad.lan.raisama.net>
References: <1406574278-23946-1-git-send-email-ehabkost@redhat.com> <53D6A1F2.5070404@zytor.com> <20140728203955.GA4611@thinpad.lan.raisama.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86, paravirt: BUG_ON on {rd,wr}msr exceptions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jul 2014 13:43:36 -0700
To: Eduardo Habkost <ehabkost@redhat.com>
CC: virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5961f265-e3d0-4122-87b8-10151e1ee4d6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As much as I hate adding new pvops, it might be the better answer, especially since those are the real native ops.


On July 28, 2014 1:39:55 PM PDT, Eduardo Habkost <ehabkost@redhat.com> wrote:
>On Mon, Jul 28, 2014 at 12:18:10PM -0700, H. Peter Anvin wrote:
>> On 07/28/2014 12:04 PM, Eduardo Habkost wrote:
>> > When CONFIG_PARAVIRT is enabled, the kernel is ignoring exceptions
>on
>> > the {rd,wr}msr instructions. This makes serious issues (either on
>the
>> > guest kernel, or on the host) be silently ignored, and is different
>from
>> > the native MSR code (which does not ignore the exceptions).
>> > 
>> > As paravirt.h already includes linux/bug.h, I don't see what was
>the
>> > original issue preventing BUG_ON from being used.
>> > 
>> > Change rdmsr(), wrmsr(), and rdmsrl() to BUG_ON() on errors.
>> 
>> How much does this bloat the kernel?
>
>It seems to add 8 bytes to each {wr,rd}msr() call (4 extra
>instructions:
>test, jmp, ud2, jmp).
>
>allyesconfig, paravirt enabled, before:
>
>  text    data     bss     dec     hex filename
>108368312       23500872        55705600        187574784       b2e2a00
>vmlinux
>
>allyesconfig, paravirt enabled, after:
>
>   text    data     bss     dec     hex filename
>108384438       23500904        55717888        187603230       b2e991e
>vmlinux
>
>allyesconfig vmlinux is 28446 bytes larger.
>
>An alternative is to add read_msr_unsafe() & write_msr_unsafe() fields
>to pv_cpu_ops, pointing to native_read_msr() & native_write_msr().

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
