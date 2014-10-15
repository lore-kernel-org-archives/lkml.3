Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaJOS1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:27:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJOS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:27:28 -0400
Date: Wed, 15 Oct 2014 11:27:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1 00/10] Remove weak function declarations
Message-Id: <20141015112727.49a453c3f6cef674fe1aecd3@linux-foundation.org>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 11:05:41 -0600 Bjorn Helgaas <bhelgaas@google.com> wrote:

> A common usage of "weak" is for a default implementation of a function.
> An architecture that needs something different can supply a non-weak
> ("strong") implementation, with the expectation that the linker will select
> the strong version and discard the weak default version.
> 
> We have a few function declarations in header files annotated as "weak".
> That causes every *every* definition to be marked "weak", which means there
> is no strong version at all.  In this case, the linker selects one of the
> weak versions based on link order.  I don't think this is what we want.
> 
> These patches remove almost all the weak annotations from header files
> (MIPS still uses it for get_c0_compare_int(), apparently relying on the
> fact that a weak symbol need not be defined at all).  In most cases, the
> default implementation was already marked weak at the definition.  When it
> wasn't, I added that.
> 
> It might be simplest if I ask Linus to pull these all as a group from my
> branch [1].  I'll look for acks from the following people.  If I don't see
> an ack, I'll drop the patch and you can take it yourself or ignore it as
> you wish.
> 
>   Eric:                    audit
>   Thomas, Ingo, or Peter:  x86
>   Ralf:                    MIPS
>   John or Thomas:          clocksource
>   Jason:                   kgdb
>   Ingo:                    uprobes
>   Andrew:                  vmcore, memory-hotplug

Acks, of course..

> I don't know whether these fix any actual bugs.  We *did* have a bug like
> this on MIPS a while ago (10629d711ed7 ("PCI: Remove __weak annotation from
> pcibios_get_phb_of_node decl")), so it's possible that they do fix
> something.

I'm rather astonished that we haven't hit problems with this before
now.

This is pretty rude behaviour from the linker, really - grabbing the
first __weak function and using that is very likely to be the wrong
thing to do.

Still, this is a bit of a hand grenade and we should think up some way
of detecting/preventing recurrences.

I guess a checkpatch rule which warns about __weak and
__attribute__((weak)) in a header file would help.  Is there anything
more robust we can do?  Coccinelle, sparse, etc?
