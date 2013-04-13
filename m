Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3DMAsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:48:37 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47334 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3DMAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy4SvRc_4VwV9AD8Fpc5zKPPBdbzGYFej6LHBb1prK6=g@mail.gmail.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
	<20130412235352.GA16770@kroah.com>
	<CA+55aFy4SvRc_4VwV9AD8Fpc5zKPPBdbzGYFej6LHBb1prK6=g@mail.gmail.com>
Date: Fri, 12 Apr 2013 17:48:33 -0700
Message-ID: <CAOMFOmVrhQSnrLBB7WEOzRHrCUH1ofKCe8x+e7Aq_i_Kyvd+PA@mail.gmail.com>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran the test case for ~30 minutes and no crash. Before the patch it
took ~10 seconds for me to repro the crash.

The only harmless warning I see is


[ 1553.658421] ------------[ cut here ]------------
[ 1553.663211] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xbb/0xe0()
[ 1553.669571] Hardware name: MCP55
[ 1553.672834] sysfs: cannot create duplicate filename '/module/loop'
[ 1553.679035] Modules linked in: loop(+) sata_mv acpi_cpufreq mperf
freq_table processor msr cpuid genrtc bnx2x libcrc32c mdio ipv6 [last
unloaded: loop]
[ 1553.692983] Pid: 25935, comm: modprobe Tainted: G        W
3.9.0-dbg-DEV #1
[ 1553.700221] Call Trace:
[ 1553.702699]  [<ffffffff81087aaf>] warn_slowpath_common+0x7f/0xc0
[ 1553.708724]  [<ffffffff81087ba6>] warn_slowpath_fmt+0x46/0x50
[ 1553.714495]  [<ffffffff813167e0>] ? strlcat+0x60/0x80
[ 1553.719567]  [<ffffffff8121981b>] sysfs_add_one+0xbb/0xe0
[ 1553.724988]  [<ffffffff812199cf>] create_dir+0x7f/0xd0
[ 1553.730150]  [<ffffffff81219d59>] sysfs_create_dir+0x89/0xe0
[ 1553.735831]  [<ffffffff813104ad>] kobject_add_internal+0x9d/0x2a0
[ 1553.741945]  [<ffffffff81310ca3>] kobject_init_and_add+0x63/0x90
[ 1553.747973]  [<ffffffff81311194>] ? kset_find_obj+0x64/0x90
[ 1553.753571]  [<ffffffff810e65fa>] load_module+0xc2a/0x15b0
[ 1553.759077]  [<ffffffff8132ba70>] ? ddebug_proc_write+0x110/0x110
[ 1553.765191]  [<ffffffff8131b43e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1553.771652]  [<ffffffff810e7077>] sys_init_module+0xf7/0x140
[ 1553.777335]  [<ffffffff815e6515>] cstar_dispatch+0x7/0x1f
[ 1553.782753] ---[ end trace a5e2ab42bb81f1b3 ]---
[ 1553.787405] ------------[ cut here ]------------
[ 1553.792041] WARNING: at lib/kobject.c:196 kobject_add_internal+0x234/0x2a0()
[ 1553.799087] Hardware name: MCP55
[ 1553.802316] kobject_add_internal failed for loop with -EEXIST,
don't try to register things with the same name in the same directory.
[ 1553.814308] Modules linked in: loop(+) sata_mv acpi_cpufreq mperf
freq_table processor msr cpuid genrtc bnx2x libcrc32c mdio ipv6 [last
unloaded: loop]
[ 1553.828122] Pid: 25935, comm: modprobe Tainted: G        W
3.9.0-dbg-DEV #1
[ 1553.835342] Call Trace:
[ 1553.837799]  [<ffffffff81087aaf>] warn_slowpath_common+0x7f/0xc0
[ 1553.843801]  [<ffffffff81087ba6>] warn_slowpath_fmt+0x46/0x50
[ 1553.849548]  [<ffffffff81310644>] kobject_add_internal+0x234/0x2a0
[ 1553.855731]  [<ffffffff81310ca3>] kobject_init_and_add+0x63/0x90
[ 1553.861750]  [<ffffffff81311194>] ? kset_find_obj+0x64/0x90
[ 1553.867329]  [<ffffffff810e65fa>] load_module+0xc2a/0x15b0
[ 1553.872821]  [<ffffffff8132ba70>] ? ddebug_proc_write+0x110/0x110
[ 1553.878938]  [<ffffffff8131b43e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1553.885382]  [<ffffffff810e7077>] sys_init_module+0xf7/0x140
[ 1553.891037]  [<ffffffff815e6515>] cstar_dispatch+0x7/0x1f


That happens because kobject in kobject_put() path and its refcounter
== 0 but sysfs is not cleaned yet. kset_find_obj() returned NULL (as
per Linus patch). kobject_init_and_add() tries to add sysfs file with
existing name and fails.

On Fri, Apr 12, 2013 at 5:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 12, 2013 at 4:53 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> Linus, I think your patch will reduce the window the race could happen,
>> but it should still be there, although testing with it would be
>> interesting to see if the original problem can be triggered with it.
>
> Well, with my patch, there's no way you'll ever look up an object with
> a zero refcount, so you'll never release it twice. The atomic
> operations (atomic_inc_nonzero()) do guarantee that.
>
> The "kset->list_lock" means that the list traversal is safe too.
>
> So one particular race is definitely gone.
>
> Now, what people who call "kset_find_obj()" really expect when not
> locked against the last kobject_put(), I don't know. But at least it's
> conceptually safe now. They'll either get NULL (either because the
> object doesn't exist on the list, or because it does exist but is
> about to be removed), or they will get a valid object that has *not*
> started to be torn down yet.
>
>                  Linus
