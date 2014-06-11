Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaFKPUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:20:41 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:40593 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbaFKPUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com>
 <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 08:20:17 -0700
Message-ID: <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com>
Subject: Re: vdso_install target broken post-3.15
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 8:16 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Wed, Jun 11, 2014 at 10:14 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> Hi,
>>
>> I'm guessing commit 6f121e548f83674ab4920a4e60afb58d4f61b829 is what
>> broke the vdso_install target:
>>
>> + make -s ARCH=x86_64
>> INSTALL_MOD_PATH=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.16.0-0.rc0.git1.1.fc21.x86_64
>> vdso_install KERNELRELEASE=3.16.0-0.rc0.git1.1.fc21.x86_64
>> make[1]: *** No rule to make target `arch/x86/vdso/vdso.so.dbg',
>> needed by `vdso.so'.  Stop.
>> make: *** [vdso_install] Error 2
>>
>> The crazy Fedora versioning there corresponds to
>> 3f17ea6dea8ba5668873afa54628a91aaa3fb1c0 in Linus' tree.  I'll poke at
>> this some, but if you have some quick ideas I'd be happy to try them.
>
> OK, I'm stumped.  Looking at that commit, it removes all target
> invocations for vdso.so.  Which means even a simple 'make' in the vdso
> directory fails with:
>
> [jwboyer@vader vdso]$ make
> make: *** No rule to make target `/vdso.so', needed by `/vdso.o'.  Stop.
> [jwboyer@vader vdso]$
>
> So how was this commit build tested?
>

There is no longer a vdso.so file at all, and I failed to test
vdso_install.  The kernel builds and works just fine, because nothing
expects the vdso.so file to exist.

vdso_install is neat, and I've often wanted the vdso to be installed
along with modules all the time so that gdb, etc can use the .dbg
files.  That being said, I clearly broke it pretty thoroughly.

Is vdso_install supposed to install a .so file or just a .so.dbg file?
 I'm having trouble parsing this:

quiet_cmd_vdso_install = INSTALL $@
      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
        @mkdir -p $(MODLIB)/vdso
        $(call cmd,vdso_install)

This seems like a rather complicated way of saying that the .so.dbg is
installed with the .dbg at the end removed.  We can do that.  Let me
see if I can disentangle the makefile enough.

If we need real stripped .so files, vdso2c knows how to generate them,
but the makefile doesn't invoke it like that.  I don't see why we'd
want to install them, though.

While I'm on this topic: would it be useful to also create symlinks
corresponding to the build ids?

--Andy
