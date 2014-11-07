Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaKGRhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:37:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34312 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaKGRhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:37:51 -0500
Date: Fri, 7 Nov 2014 18:37:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 3/8] x86, microcode, intel: clarify log messages
Message-ID: <20141107173746.GA5180@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-4-git-send-email-hmh@hmh.eng.br>
 <20141020135250.GD3524@pd.tnic>
 <20141021141332.GE22528@khazad-dum.debian.net>
 <20141029095453.GB17989@pd.tnic>
 <20141031200802.GC27028@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141031200802.GC27028@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 06:08:02PM -0200, Henrique de Moraes Holschuh wrote:
> In this case, it is useful churn IMHO: it is a building block that I used
> immediately and that I will also need later for further improvements, it is
> used to log that the early microcode driver failed due to an error
> (something we currently don't know at all),

So we're again trying to improve at the wrong side. What we actually
need to do is fix the early loader in those cases where it is still
b0rked. If any. I have currently two more fixes for 32-bit early
loading, one generic, one for AMD, but on 64-bit it is solid. At least I
don't know about any issues.

And then once all is in place, I'd like to make the loader as silent as
possible because it is supposed to just work.

If one still wants to debug stuff then we can have our small shell
script to gather the needed info on a system and people can run it on
theirs when reporting issues.

> This is a matter of personal taste, so I will just do it your way, and
> change the template to:
> 
> <driver>: Error|Warning: foo

Just look at dmesg output on any system.

> ... I don't know if anyone else is doing it that way, but it is quite
> cool in that it reduces the chances of some very horrible failure
> modes, so I will try to switch Debian and Ubuntu to it next year.

Whatever you do, just keep the users in mind. Adding the microcode to
the initrd should be trivial. Maybe it should be added by a script, or
some postinst whatever funkyness, whatever... just make sure *anyone*
can create it. Not a tutorial somewhere on the net but a single command
like

update-initramfs --add-microcode ...

or whatever, I don't care, as long as it is simple and
it always works. I don't want to be pointing people to
Documentation/x86/early-microcode.txt and ask "but but, have you done
this already".

> Yes, however isn't that code used only to save the microcode data used from
> the early initramfs (because otherwise it would be freed along with the rest
> of __initdata), and for nothing else?

What do you mean with "only"?

This code saves the microcode patch which we've used in the early
loader, into a memory buffer so that we can use it later, for example,
after resuming the box or for when cores are coming back online as a
result of a CPU hotplug operation.

This is not really important, though, I'm thinking, because we have
redundant functionality from the "late" microcode loader which updates
the microcode in its CPU hotplug callback.

For that to work, though, we need the correct microcode installed in
/lib/firmware.

So packagers should be doing two important things:

* add microcode to the initrd for early loading
* add microcode to /lib/firmware/ for late loading when needed

I think with this we're covered solid. Unless I'm missing a hole.

> When you're missing the rest of the data for whatever reason, e.g:
> incomplete firmware file.

But this is the same, right?

	(ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE

checks whether some of the extended signatures are incomplete. So we can
say:

	pr_err("error: Small exttable size/truncated extended signature in microcode data file.\n");

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
