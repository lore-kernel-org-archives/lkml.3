Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbaJaUIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:08:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41932 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbaJaUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:08:15 -0400
X-Sasl-enc: kejueGKqebLEPTz2W2bqi3RM28Bd9m7MBf22njKPUMPR 1414786094
Date: Fri, 31 Oct 2014 18:08:02 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 3/8] x86, microcode, intel: clarify log messages
Message-ID: <20141031200802.GC27028@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-4-git-send-email-hmh@hmh.eng.br>
 <20141020135250.GD3524@pd.tnic>
 <20141021141332.GE22528@khazad-dum.debian.net>
 <20141029095453.GB17989@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029095453.GB17989@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Borislav Petkov wrote:
> On Tue, Oct 21, 2014 at 12:13:32PM -0200, Henrique de Moraes Holschuh wrote:
> > > > @@ -178,11 +178,11 @@ static int apply_microcode_intel(int cpu)
> > > >  	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
> > > >  
> > > >  	if (val[1] != mc_intel->hdr.rev) {
> > > > -		pr_err("CPU%d update to revision 0x%x failed\n",
> > > > +		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n",
> > > >  		       cpu_num, mc_intel->hdr.rev);
> > > >  		return -1;
> > > >  	}
> > > > -	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
> > > > +	pr_info("CPU%d: entire core updated to revision 0x%x, date %04x-%02x-%02x\n",
> > > 
> > > Those two above are not really needed IMO.
> > 
> > They are an attempt to make it more clear.  I've got bug reports about this
> > sort of issue before in Debian, people do wonder why some "cpus" are
> > updated, and others _apparently_ are not (because there are no messages for
> > them).
> 
> The fact that people open bugs doesn't always mean it is really a bug :-)

Indeed.

> And I'm pretty sure people will ask about "entire core" too. You simply
> can't explain to them that the microcode engine is shared between
> threads in a oneliner. :-)

Unfortunately, I believe you're correct.

> Hrrm, I still don't like that "entire core" thing, how about something
> like this:
> 
> 	pr_info("CPU%d: update to revision 0x%x, date %04x-%02x-%02x\n"
> 
> this doesn't say at least that we're updating a CPU to a revision sth
> sth but that we're doing the update on CPU%d. This should clearly
> state what happens without making any assumptions about what the core
> contains.

Will do.  I don't think this addresses what I was trying to do, however it
_is_ better, and if you accept my proposal for the change in logging, the
confusing issue will be taken care off anyway.

> > We have more reasons why an update fail.  Rejected by the processor is a
> > very specific one we want to single out (it basically means we are either
> > feeding crap to the processor _or_ violating one of the architectural
> > requirements).
> 
> That all doesn't matter - you only want to be able to pinpoint which
> error message you're looking at and as long as they differ, you're fine.
> Otherwise this is just an unnecessary churn.

In this case, it is useful churn IMHO: it is a building block that I used
immediately and that I will also need later for further improvements, it is
used to log that the early microcode driver failed due to an error
(something we currently don't know at all), and it can be used to log why
(since we can use it to have as many different error messages when
attempting to update the BSP microcode as we need).

> > It is lowercase because we now prefix all pr_<level>() with "microcode: ",
> > so it will look like this:
> > 
> > "microcode: warning: foo"
> > "microcode: error: foo".
> > 
> > Should I capitalize this and all other messages of this sort?  It doesn't
> > look right to me to log "microcode: Error: foo" or "microcode: Warning:
> > foo".
> 
> Why not? You have the piece of machinery which generates the message,
> i.e. "microcode" and then a sentence which starts with a capital letter.
> I think this is the accepted practice in the kernel.

This is a matter of personal taste, so I will just do it your way, and
change the template to:

<driver>: Error|Warning: foo

> I just don't like the quantification "entire core" because later, when
> CPU guys decide to split it more, we'll need to change it again.

Yes.

> > However, it isn't from the initrd: it comes from the early initramfs, which
> > is a different kind of beast.  We (distros) did have microcode data inside
> > the initrd/initramfs for the regular microcode driver, so the previous error
> > message could be misleading.
> 
> Wait a minute, we do supply the early microcode by adding it to the
> initrd: Documentation/x86/early-microcode.txt

As far as the kernel is concerned, there are two ways to do that: early
initramfs image (used by the early microcode drivers), or adding the regular
microcode.ko module and /lib/firmware/intel-ucode/* inside the regular
compressed initramfs, where it will be modprobed.

Both share "initramfs" (or initrd) in the name, but they are obviously two
completely different things.

As far as userspace is concerned there is at least one extra variant (which
doesn't matter as far as the kernel is concerned): Arch linux uses two
separate initramfs images, and tells the bootloader to load both.  The first
one has the early initramfs with the microcode data, the second one has the
regular compressed initramfs with the boot machinery.  I don't know if
anyone else is doing it that way, but it is quite cool in that it reduces
the chances of some very horrible failure modes, so I will try to switch
Debian and Ubuntu to it next year.

> > Would you perfer "warning: failed to save early initramfs microcode update
> > data for future use\n" ?
> 
> I guess we can say something method-agnostic without explicitly naming
> that method...

Yes, however isn't that code used only to save the microcode data used from
the early initramfs (because otherwise it would be freed along with the rest
of __initdata), and for nothing else?

> > > > @@ -72,13 +72,13 @@ int microcode_sanity_check(void *mc, int print_err)
> > > >  		if ((ext_table_size < EXT_HEADER_SIZE)
> > > >  		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
> > > >  			if (print_err)
> > > > -				pr_err("error! Small exttable size in microcode data file\n");
> > > > +				pr_err("error: small exttable size in microcode data file\n");
> > > 
> > > That doesn't tell me a whole lot - maybe "... truncated exttable in microcode data file" ?
> > 
> > If it hit this codepath, it will not be due to "normal" truncation.  The
> 
> What is a "normal" truncation?

When you're missing the rest of the data for whatever reason, e.g:
incomplete firmware file.

> > caller detects truncation earlier, checking the main header total_size
> > against the size of the data it got from userspace or the early initramfs.
> 
> You mean this:
> 
> 	if (data_size + MC_HEADER_SIZE > total_size)
> 
> ?
> 
> If so, this is not truncation check - it sanity-checks what's in the
> headers or the default sizes.

No, I mean this:

(early intel microcode driver caller code):
               mc_size = get_totalsize(mc_header);
               if (!mc_size || mc_size > leftover ||
                        microcode_sanity_check(ucode_ptr, 0) < 0)
		...

(regular intel microcode driver caller code):
                mc_size = get_totalsize(&mc_header);
                if (!mc_size || mc_size > leftover) {
                        pr_err("error! Bad data in microcode data file\n");
                        break;
                }

		...

                if (get_ucode_data(mc, ucode_ptr, mc_size) ||
                    microcode_sanity_check(mc, 1) < 0) {
                        break;
                }

Anything that was just partially downloaded (and not further corrupted) will
fail these tests before microcode_sanity_check() is even called,  Thus,
"caller detects truncation earlier".

> Btw, there's a typo in show_saved_mc()
> 
> pr_debug("mc_saved[%d]: sig=0x%x, pf=0x%x, rev=0x%x, toal size=0x%x, date = %04x-%02x-%02x\n",
> 						     ^^^^

Noted.  Might as well fix it, too :-)

> > The message really means: "exttable size incompatible with the size of a
> > valid table".
> 
> Let's call this:
> 
> 	"Error: extended signature table size mismatch!\n"
> 
> because this is what this check does.

Will do.

> > I want to differentiate these two, they're caused by different issues, so
> > they should not be the same error message.
> > 
> > Would you prefer "exttable entry counter incompatible with exttable size",
> > which is what this message really means?
> 
> Yep, that sounds better.

Ok, will do.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
