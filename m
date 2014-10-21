Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaJUONn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:13:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54911 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932618AbaJUONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:13:39 -0400
X-Sasl-enc: H8oIr3mfuKKesvOuZBnjfEARyEFCf/YvoeJ8N0gw5pjp 1413900818
Date: Tue, 21 Oct 2014 12:13:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 3/8] x86, microcode, intel: clarify log messages
Message-ID: <20141021141332.GE22528@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-4-git-send-email-hmh@hmh.eng.br>
 <20141020135250.GD3524@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020135250.GD3524@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Borislav Petkov wrote:
> On Mon, Sep 08, 2014 at 02:37:49PM -0300, Henrique de Moraes Holschuh wrote:
> > The Intel microcode update driver will skip the second hardware thread
> > on hyper-threaded cores during an update run, as the first hardware
> > thread will have updated the entire core.  This can confuse users,
> > because it will look like some CPUs were not updated in the system log.
> > Attempt to clarify the log messages to hint that we might be updating
> > more than one CPU (hardware thread) at a time.
> > 
> > Make sure all driver log messages conform to this template: "microcode:
> > CPU#: <message>".  The <message> might refer to the core, and not to the
> > hardware thread/CPU.
> > 
> > Reword error and debug messages for clarity or style.  Tag most error
> > messages as "error:", and warnings as "warning:".  Report conditions
> > which will stop a microcode update as errors, and conditions which will
> > not stop a microcode update as warnings.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

...

> > @@ -178,11 +178,11 @@ static int apply_microcode_intel(int cpu)
> >  	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
> >  
> >  	if (val[1] != mc_intel->hdr.rev) {
> > -		pr_err("CPU%d update to revision 0x%x failed\n",
> > +		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n",
> >  		       cpu_num, mc_intel->hdr.rev);
> >  		return -1;
> >  	}
> > -	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
> > +	pr_info("CPU%d: entire core updated to revision 0x%x, date %04x-%02x-%02x\n",
> 
> Those two above are not really needed IMO.

They are an attempt to make it more clear.  I've got bug reports about this
sort of issue before in Debian, people do wonder why some "cpus" are
updated, and others _apparently_ are not (because there are no messages for
them).

We have more reasons why an update fail.  Rejected by the processor is a
very specific one we want to single out (it basically means we are either
feeding crap to the processor _or_ violating one of the architectural
requirements).

> > @@ -214,7 +214,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
> >  
> >  		mc_size = get_totalsize(&mc_header);
> >  		if (!mc_size || mc_size > leftover) {
> > -			pr_err("error! Bad data in microcode data file\n");
> > +			pr_err("error: invalid microcode update data\n");
> 
> What's wrong with the original message?

This is a cosmetic fix, so that the messages follow the same pattern.

> > @@ -418,7 +421,7 @@ static void __ref show_saved_mc(void)
> >  		pr_debug("no microcode data saved.\n");
> >  		return;
> >  	}
> > -	pr_debug("Total microcode saved: %d\n", mc_saved_data.mc_saved_count);
> > +	pr_debug("total microcode entries saved: %d\n", mc_saved_data.mc_saved_count);
> 
> That should be "Total microcode patches saved" - "entries" doesn't say a whole
> lot.

We don't call them patches anywhere else in Intel's case.  But since you
prefer "patch", "patch" it is.

> >  	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
> >  	if (ret) {
> > -		pr_err("Cannot save microcode patch.\n");
> > +		pr_warn("warning: could not store microcode update data for later use.\n");
> 
> Capitalize: "Warning: could... "
> 
> otherwise that message clarification makes sense.

It is lowercase because we now prefix all pr_<level>() with "microcode: ",
so it will look like this:

"microcode: warning: foo"
"microcode: error: foo".

Should I capitalize this and all other messages of this sort?  It doesn't
look right to me to log "microcode: Error: foo" or "microcode: Warning:
foo".

> > @@ -579,7 +582,7 @@ print_ucode_info(struct ucode_cpu_info *uci, unsigned int date)
> >  {
> >  	int cpu = smp_processor_id();
> >  
> > -	pr_info("CPU%d microcode updated early to revision 0x%x, date = %04x-%02x-%02x\n",
> > +	pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
> 
> No, please no "entire core" mentions - that'll only confuse people.
> Simply think of logical cores as separate cores which share the
> microcode hw. No need for more confusion.

The status-quo confuses people, they wonder why some "cpus" were skipped,
and they file bugs about it or ask about it in the user forums.  I got a bug
report for a module-based AMD processor, and it took a few round-trips to
explain what was happening to the user...

If "entire core" is unclear, what wording would you suggest?

> > @@ -701,7 +704,7 @@ int __init save_microcode_in_initrd_intel(void)
> >  	microcode_pointer(mc_saved, mc_saved_in_initrd, initrd_start, count);
> >  	ret = save_microcode(&mc_saved_data, mc_saved, count);
> >  	if (ret)
> > -		pr_err("Cannot save microcode patches from initrd.\n");
> > +		pr_warn("warning: failed to save early microcode update data for future use\n");
> 
> This one actually loses info - the "initrd" part.

However, it isn't from the initrd: it comes from the early initramfs, which
is a different kind of beast.  We (distros) did have microcode data inside
the initrd/initramfs for the regular microcode driver, so the previous error
message could be misleading.

Would you perfer "warning: failed to save early initramfs microcode update
data for future use\n" ?

> > @@ -72,13 +72,13 @@ int microcode_sanity_check(void *mc, int print_err)
> >  		if ((ext_table_size < EXT_HEADER_SIZE)
> >  		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
> >  			if (print_err)
> > -				pr_err("error! Small exttable size in microcode data file\n");
> > +				pr_err("error: small exttable size in microcode data file\n");
> 
> That doesn't tell me a whole lot - maybe "... truncated exttable in microcode data file" ?

If it hit this codepath, it will not be due to "normal" truncation.  The
caller detects truncation earlier, checking the main header total_size
against the size of the data it got from userspace or the early initramfs.

The message really means: "exttable size incompatible with the size of a
valid table".

Would you prefer this alternate wording?

> >  		ext_header = mc + MC_HEADER_SIZE + data_size;
> >  		if (ext_table_size != exttable_size(ext_header)) {
> >  			if (print_err)
> > -				pr_err("error! Bad exttable size in microcode data file\n");
> > +				pr_err("error: bad exttable size in microcode data file\n");
> 
> Ditto.

I want to differentiate these two, they're caused by different issues, so
they should not be the same error message.

Would you prefer "exttable entry counter incompatible with exttable size",
which is what this message really means?

> > @@ -140,7 +140,7 @@ int microcode_sanity_check(void *mc, int print_err)
> >  			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
> >  		if (sum) {
> >  			if (print_err)
> > -				pr_err("aborting, bad checksum\n");
> > +				pr_err("error: bad extended signature checksum\n");
> 
> "Aborting ..." was better.

Well, every other error message in microcode_sanity_check() also means we
abort just the same.  It doesn't make sense to have "abort" just in this
one.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
