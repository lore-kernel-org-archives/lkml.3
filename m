Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaCGS4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:56:39 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59594 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaCGS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:56:38 -0500
MIME-Version: 1.0
In-Reply-To: <1394176888.1018.3.camel@wall-e.seibold.net>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Mar 2014 10:56:17 -0800
Message-ID: <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: Stefani Seibold <stefani@seibold.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 11:21 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Hi Fengguang,
>
> i have build a kernel with the config, but my kvm is unable to start it.
> I will try to find a way to test your kernek config.
>
> One thing is the crash point:
>
> The function sysenter_setup was modified by Andy, maybe he has an idea
> what fails.

*sigh*

My host kernel is currently fscked up and won't run KVM.  Also, I want
to confirm that I'm reproducing exactly what you're seeing, and I
think it depends on the toolchain.  Can you (Fenguang) do:

$ ls -l arch/x86/vdso/vdso32*.so
-rwxrwxr-x. 1 luto luto 4096 Mar  7 10:19 arch/x86/vdso/vdso32-int80.so
-rwxrwxr-x. 1 luto luto 4116 Mar  7 10:19 arch/x86/vdso/vdso32-sysenter.so

(Of course, triggering this depends on which image gets selected.)

Note that we have a .so file that exceeds 4k, i.e. one page.  Then
read the relevant code and wonder what everyone was smoking when they
wrote it.  There are so many buffer overflows, screwed up
initializations, unnecessary and incorrect copies, etc, that I don't
even want to speculate on what the first failure will be when the
image is bigger than a page.

It's easy enough to fix, but someone should figure out what the impact
will be on the compat vdso case.

I wonder how hard it would be to change the compat vdso do be a dummy
image a la the x86_64 fake vsyscall page so that old code can keep
working (maybe with a performance hit) and new code can use a sane
image.

--Andy
