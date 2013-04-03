Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3DCKSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482Ab3DCKSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:18:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <874nfo5em2.fsf@rustcorp.com.au>
References: <874nfo5em2.fsf@rustcorp.com.au> <1484037905.443048.1364884090669.JavaMail.root@redhat.com> <19926.1364924330@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer at kset_find_obj
Date: Wed, 03 Apr 2013 11:18:27 +0100
Message-ID: <10041.1364984307@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > I think this bit should be waved in front of Rusty.  It looks like it
> > might be a bug in error handling code.
> 
> It does look like it, but I can't see it.  The module code doesn't see
> an error (presumably sig_enforce is false), so we continue processing
> the module like normal.

I just realised there's a second similar oops in there, and I only summarised
the first one.  Not that I think the second one lends particularly much
illumination that I can see:

[   35.242163] BUG: unable to handle kernel paging request at ffffffffa03093f0 
[   35.242172] IP: [<ffffffff81303fb0>] kobject_get_path+0x20/0xf0 
...
[   35.242230] Call Trace: 
[   35.242233]  [<ffffffff81304ce6>] kobject_uevent_env+0x166/0x610 
[   35.242236]  [<ffffffff8130519b>] kobject_uevent+0xb/0x10 
[   35.242238]  [<ffffffff81303bca>] kobject_cleanup+0xca/0x1b0 
[   35.242241]  [<ffffffff81303a0b>] kobject_put+0x2b/0x60 
[   35.242247]  [<ffffffff810c8af4>] load_module+0x1384/0x1b00 
[   35.242252]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
[   35.242259]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
[   35.242262]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
[   35.242268]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 

This is followed by a bunch of soft lockup notices, so I guess one of the
oopsers was holding module_kset->list_lock.


Anyway, assuming the original oops happened in kset_find_obj() as called from
mod_sysfs_init(), it's possible that module_kset is corrupt.  The only thing
kset_find_obj() is using from the module is a NUL-terminated name - which is
typically in the file prior to a load of metadata, some of which will contain
zeroed bytes.

Btw, one thing I've noticed is that sysfs appears to be able to execute code
in the module by way of parameter alterations before the module is completely
set up.  I'm not sure this is an actual problem - but it might give an
interesting interaction with module initialisers as they might reasonably
expect that module parameters can't change whilst they're running.

> Is the module getting corrupted somehow?  I don't think the signing
> infrastructure is doing it...

I wonder if I should include all or part of the crytographic digest in the
signature descriptor block.  A single byte therefrom would give a 255 in 256
chance of picking up corruption - even if we can't actually verify the
signature.  There are three bytes of padding available.

The module signing stuff shouldn't be altering it.  Const pointers are used to
try and catch accidental alterations and the code mostly focuses on the bit
beyond the end of the normal module content.  The crypto layer does get to
play with it, but I doubt that is likely to corrupt it either.

David
