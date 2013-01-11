Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3AKNoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:44:25 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54287 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3AKNoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:44:24 -0500
MIME-Version: 1.0
In-Reply-To: <50EFDE31.90709@csamuel.org>
References: <50EEA4C4.4080103@csamuel.org>
	<50EFDE31.90709@csamuel.org>
Date: Fri, 11 Jan 2013 08:44:23 -0500
Message-ID: <CA+5PVA5hCuTar1F=g5vgT2Cj1ZbF7w+HcWzhATUx7wFs_kuSWw@mail.gmail.com>
Subject: Re: MODSIGN: Modules fail signature verification with -ENOKEY
From: Josh Boyer <jwboyer@gmail.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 4:41 AM, Chris Samuel <chris@csamuel.org> wrote:
> /*
>  * Rusty requested I send this to LKML, please CC me in on responses as
>  * I am not subscribed to LKML for sanity reasons. :-)
>  */
>
> Hi Rusty, David, LKML,
>
> I suspect this is pilot error, or a deficiency in the Debian/Ubuntu
> make-kpkg scripts, but building various 3.8 kernels from before rc1
> through to just before rc3 I find I always get:
>
> Disabling lock debugging due to kernel taint
>
> which turns out to be the result of module_sig_check() failing to
> verify signatures because of -ENOKEY.

Check the installed modules.  A simple:

    hexdump -C <path to module> | tail -n 20

should be enough to tell you if the installed modules at least look like
they're signed.  You should see the expected "~Module signature appended~"
string.  You could also check the modules in the kernel build tree for
the same thing.

If you see the string in the kernel build tree copy, but not in the
installed copy, then something in your scripts stripped it off during the
install.  You'll likely need to use the modules_sign make target on the
installed module tree.

And lastly, if you see the modules are signed in both the build tree and
the installed location and you're using an initramfs it is possible that
the initramfs creation tool is stripping the signatures.  Dracut was
doing this until very recently.

> I'll forward a patch that adds a printk_once() when verification fails
> with -ENOKEY (as others seems to end in more obvious failures) and it
> emits the following:
>
> Module verification failed, required key not present, tainting kernel
> Disabling lock debugging due to kernel taint

That might indeed be worthwhile.

josh
