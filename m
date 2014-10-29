Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaJ2JzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:55:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbaJ2Jy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:54:58 -0400
Date: Wed, 29 Oct 2014 10:54:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 3/8] x86, microcode, intel: clarify log messages
Message-ID: <20141029095453.GB17989@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-4-git-send-email-hmh@hmh.eng.br>
 <20141020135250.GD3524@pd.tnic>
 <20141021141332.GE22528@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141021141332.GE22528@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:13:32PM -0200, Henrique de Moraes Holschuh wrote:
> > > @@ -178,11 +178,11 @@ static int apply_microcode_intel(int cpu)
> > >  	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
> > >  
> > >  	if (val[1] != mc_intel->hdr.rev) {
> > > -		pr_err("CPU%d update to revision 0x%x failed\n",
> > > +		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n",
> > >  		       cpu_num, mc_intel->hdr.rev);
> > >  		return -1;
> > >  	}
> > > -	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
> > > +	pr_info("CPU%d: entire core updated to revision 0x%x, date %04x-%02x-%02x\n",
> > 
> > Those two above are not really needed IMO.
> 
> They are an attempt to make it more clear.  I've got bug reports about this
> sort of issue before in Debian, people do wonder why some "cpus" are
> updated, and others _apparently_ are not (because there are no messages for
> them).

The fact that people open bugs doesn't always mean it is really a bug :-)

And there's a very simple answer to that:

$ grep microcode /proc/cpuinfo | uniq

should give only a single line.

And I'm pretty sure people will ask about "entire core" too. You simply
can't explain to them that the microcode engine is shared between
threads in a oneliner. :-)

Hrrm, I still don't like that "entire core" thing, how about something
like this:

	pr_info("CPU%d: update to revision 0x%x, date %04x-%02x-%02x\n"

this doesn't say at least that we're updating a CPU to a revision sth
sth but that we're doing the update on CPU%d. This should clearly
state what happens without making any assumptions about what the core
contains.

> We have more reasons why an update fail.  Rejected by the processor is a
> very specific one we want to single out (it basically means we are either
> feeding crap to the processor _or_ violating one of the architectural
> requirements).

That all doesn't matter - you only want to be able to pinpoint which
error message you're looking at and as long as they differ, you're fine.
Otherwise this is just an unnecessary churn.

> It is lowercase because we now prefix all pr_<level>() with "microcode: ",
> so it will look like this:
> 
> "microcode: warning: foo"
> "microcode: error: foo".
> 
> Should I capitalize this and all other messages of this sort?  It doesn't
> look right to me to log "microcode: Error: foo" or "microcode: Warning:
> foo".

Why not? You have the piece of machinery which generates the message,
i.e. "microcode" and then a sentence which starts with a capital letter.
I think this is the accepted practice in the kernel.

> The status-quo confuses people, they wonder why some "cpus" were skipped,
> and they file bugs about it or ask about it in the user forums.  I got a bug
> report for a module-based AMD processor, and it took a few round-trips to
> explain what was happening to the user...
> 
> If "entire core" is unclear, what wording would you suggest?

See above.

I just don't like the quantification "entire core" because later, when
CPU guys decide to split it more, we'll need to change it again.

> However, it isn't from the initrd: it comes from the early initramfs, which
> is a different kind of beast.  We (distros) did have microcode data inside
> the initrd/initramfs for the regular microcode driver, so the previous error
> message could be misleading.

Wait a minute, we do supply the early microcode by adding it to the
initrd: Documentation/x86/early-microcode.txt

Also, what you do on Debian doesn't necessarily mean all distros do it,
does it?

> Would you perfer "warning: failed to save early initramfs microcode update
> data for future use\n" ?

I guess we can say something method-agnostic without explicitly naming
that method...


> > > @@ -72,13 +72,13 @@ int microcode_sanity_check(void *mc, int print_err)
> > >  		if ((ext_table_size < EXT_HEADER_SIZE)
> > >  		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
> > >  			if (print_err)
> > > -				pr_err("error! Small exttable size in microcode data file\n");
> > > +				pr_err("error: small exttable size in microcode data file\n");
> > 
> > That doesn't tell me a whole lot - maybe "... truncated exttable in microcode data file" ?
> 
> If it hit this codepath, it will not be due to "normal" truncation.  The

What is a "normal" truncation?

> caller detects truncation earlier, checking the main header total_size
> against the size of the data it got from userspace or the early initramfs.

You mean this:

	if (data_size + MC_HEADER_SIZE > total_size)

?

If so, this is not truncation check - it sanity-checks what's in the
headers or the default sizes.


Btw, there's a typo in show_saved_mc()

pr_debug("mc_saved[%d]: sig=0x%x, pf=0x%x, rev=0x%x, toal size=0x%x, date = %04x-%02x-%02x\n",
						     ^^^^
> The message really means: "exttable size incompatible with the size of a
> valid table".

Let's call this:

	"Error: extended signature table size mismatch!\n"

because this is what this check does.

> I want to differentiate these two, they're caused by different issues, so
> they should not be the same error message.
> 
> Would you prefer "exttable entry counter incompatible with exttable size",
> which is what this message really means?

Yep, that sounds better.

> Well, every other error message in microcode_sanity_check() also means we
> abort just the same.  It doesn't make sense to have "abort" just in this
> one.

Ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
