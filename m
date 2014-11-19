Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaKSQ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:28:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbaKSQ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:28:16 -0500
Date: Wed, 19 Nov 2014 11:28:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: WANG Chao <chaowang@redhat.com>, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119162806.GD2953@redhat.com>
References: <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
 <20141119144105.GB108701@redhat.com>
 <20141119150333.GB2953@redhat.com>
 <20141119153852.GA16146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119153852.GA16146@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:38:52AM -0500, Dave Jones wrote:
> On Wed, Nov 19, 2014 at 10:03:33AM -0500, Vivek Goyal wrote:
> 
>  > Not being able to capture the dump I can understand but having wedged
>  > the machine so that it does not reboot after dump failure sounds bad.
>  > So you could not get machine to boot even after a power cycle? Would
>  > you remember what was failing. I am curious to know what did kdump do
>  > to make machine unbootable.
> 
> Power cycling was fine, because then it booted into the non-kdump kernel.
> The issue was when I caused that kernel to panic, it would just sit there
> wedged, with no indication it even tried to switch to the kdump kernel.

I have seen the cases where we fail to boot in second kernel and often
failure can happen very early without any information on graphic console.
I have to always hook up a serial console to get an idea what went wrong
that early. It is not an idea situation but at the same time don't know
how to improve it.

I am wondering may be in some cases we panic in second kernel and sit
there. Probably we should append a kernel command line automatically
say "panic=1" so that it reboots itself if second kernel panics.

By any chance, have you enabled "CONFIG_RANDOMIZE_BASE"? If yes, please
disable that as currently kexec/kdump stuff does not work with it. And
it hangs very early in the boot process and I had to hook serial console
to get following message on console.

arch/x86/boot/compressed/misc.c
error("32-bit relocation outside of kernel!\n");

I noticed that error() halts in a while loop after error message. May be
there can be some way for it to try to reboot instead of halting in 
while loop.

> 
>  > > > Unless there's some magic step missing from the documentation at
>  > > > http://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes
>  > > > then I'm not optimistic it'll be useful.
>  > 
>  > I had a quick look at it and it basically looks fine. In fedora ideally
>  > it is just two steps process.
>  > 
>  > - Reserve memory using crashkernel. Say crashkernel=160M
>  > - systemctl start kdump
>  > - Crash the system or wait for it to crash.
>  > 
>  > So despite your bad experience in the past, I would encourage you to
>  > give it a try.
> 
> 'the past' here, is two weeks ago, on Fedora 21.
> 
> But, since then, I've reinstalled that box with Fedora 20 because I didn't
> trust gcc 4.9, and on f20 things are actually even worse.
> 
> Right now it doesn't even create the image correctly:
> 
> dracut: *** Stripping files done ***
> dracut: *** Store current command line parameters ***
> dracut: *** Creating image file ***
> dracut: *** Creating image file done ***
> kdumpctl: cat: write error: Broken pipe
> kdumpctl: kexec: failed to load kdump kernel
> kdumpctl: Starting kdump: [FAILED]

Hmmm..., can you please enable debugging in kdumpctl using "set -x" and
do "touch /etc/kdump.conf; kdumpctl restart" and give debug output to me.

> 
> It works if I run a Fedora kernel, but not with a self-built one.
> And there's zero information as to what I'm doing wrong.

I just tested F20 kdump on my box and it worked fine for me.

So for you second kernel hangs and there is no info on console? Is there
any possibility to hook up serial console, enable early printk and see
if soemthing shows up there.

Apart from this, if you run into kdump issues in fedora, please cc 
kexec fedora mailing list too so that we are aware of it.

https://lists.fedoraproject.org/mailman/listinfo/kexec

Thanks
Vivek
