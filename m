Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab3DISW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:22:29 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:65507 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3DISW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1304091122490.21884@ionos>
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com>
	<alpine.LFD.2.02.1304091122490.21884@ionos>
Date: Tue, 9 Apr 2013 11:22:27 -0700
X-Google-Sender-Auth: n8apRxYu9ceGaQYttR3SBh8z7RY
Message-ID: <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
From: Kees Cook <keescook@chromium.org>
To: "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 2:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 8 Apr 2013, H. Peter Anvin wrote:
>
>> On 04/08/2013 03:43 PM, Kees Cook wrote:
>> > This makes the IDT unconditionally read-only. This primarily removes
>> > the IDT from being a target for arbitrary memory write attacks. It has
>> > an added benefit of also not leaking (via the "sidt" instruction) the
>> > kernel base offset, if it has been relocated.
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > Cc: Eric Northup <digitaleric@google.com>
>>
>> Also, tglx: does this interfere with your per-cpu IDT efforts?
>
> I don't think so. And it's on the backburner at the moment.

What would be a good way to do something similar for the GDT? sgdt
leaks GDT location as well, and even though it's percpu, it should be
trivial to figure out a kernel base address, IIUC.

$ ./sgdt
ffff88001fc04000
# cat /sys/kernel/debug/kernel_page_tables
...
---[ Low Kernel Mapping ]---
...
0xffff880001e00000-0xffff88001fe00000         480M     RW         PSE GLB NX pmd

With the IDT patch, things look good for sidt:

$ ./sidt
ffffffffff579000
# cat /sys/kernel/debug/kernel_page_tables
...
---[ End Modules ]---
0xffffffffff579000-0xffffffffff57a000           4K     ro             GLB NX pte

Can we create a RO fixed per-cpu area?

-Kees

--
Kees Cook
Chrome OS Security
