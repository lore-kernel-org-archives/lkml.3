Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaKUJqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:46:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaKUJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:46:48 -0500
Date: Fri, 21 Nov 2014 17:46:27 +0800
From: Dave Young <dyoung@redhat.com>
To: Dave Jones <davej@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        WANG Chao <chaowang@redhat.com>, Baoquan He <bhe@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121094627.GA24536@dhcp-16-198.nay.redhat.com>
References: <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
 <20141119144105.GB108701@redhat.com>
 <20141119150333.GB2953@redhat.com>
 <20141119153852.GA16146@redhat.com>
 <20141119162806.GD2953@redhat.com>
 <20141120161055.GA8309@redhat.com>
 <20141120164809.GA22216@redhat.com>
 <20141120173821.GB9550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120173821.GB9550@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/14 at 12:38pm, Dave Jones wrote:
> On Thu, Nov 20, 2014 at 11:48:09AM -0500, Vivek Goyal wrote:
>  
>  > Can we try following and retry and see if some additional messages show
>  > up on console and help us narrow down the problem.
>  > 
>  > - Enable verbose boot messages. CONFIG_X86_VERBOSE_BOOTUP=y
>  > 
>  > - Enable early printk in second kernel. (earlyprintk=ttyS0,115200).
>  > 
>  >   You can either enable early printk in first kernel and reboot. That way
>  >   second kernel will automatically have it enabled. Or you can edit
>  >   "/etc/sysconfig/kdump" and append earlyprintk=<> to KDUMP_COMMANDLINE_APPEND. 
>  >   You will need to restart kdump service after this.
>  > 
>  > - Enable some debug output during runtime from kexec purgatory. For that one
>  >   needs to pass additional arguments to /sbin/kexec. You can edit
>  >   /etc/sysconfig/kdump file and modify "KEXEC_ARGS" to pass additional
>  >   arguments to /sbin/kexec during kernel load. I use following for my
>  >   serial console.
>  > 
>  >   KEXEC_ARGS="--console-serial --serial=0x3f8 --serial-baud=115200"
>  > 
>  >   You will need to restart kdump service.
> 
> The only serial port on this machine is usb serial, which doesn't have io ports.
> 
> From my reading of the kexec man page, it doesn't look like I can tell
> it to use ttyUSB0.

Enabling ttyUSB0 still need hacks in dracut/kdump module to pack the usb serial
ko to initramfs and load it early. We can work on it in Fedora because it may benefit
to some late problems.

> 
> And because it relies on usb being initialized, this probably isn't
> going to help too much with early boot.
> 
> earlyprintk=tty0 didn't show anything extra after the sysrq-c oops.
> likewise, =ttyUSB0

earlyprintk=vga instead of tty0?
earlyprintk=efi in case efi boot.

earlyprintk=dbgp sometimes also helps but it's a little hard to setup because we
need a usb debugger. My nokia n900 works well as a debugger. But to find a usable
usb debug port in native host might fail, so this is my last try for earlyprintk :(

> 
> I'm going to try bisecting the problem I'm debugging again, so I'm not
> going to dig into this much more today.
> 

Another case what I know about kdump kernel issue is nouveau sometimes does not work
So if this is the case you can try add "rd.driver.blacklist=nouveau" to field
KDUMP_COMMANDLINE_APPEND in /etc/sysconfig/kdump. Or just add "nomodeset" in 1st
kernel grub cmdline so that 2nd kernel will reuse it to avoid load drm modules and
also earlyprintk=vga probably could show something.

Thanks
Dave
