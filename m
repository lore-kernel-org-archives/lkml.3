Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaJUOKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:10:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40279 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442AbaJUOKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:10:23 -0400
X-Sasl-enc: oEDJCDMgh8I1PduenbCND/u5/1PJRqmmmgLK/Vcyn6W5 1413900622
Date: Tue, 21 Oct 2014 12:10:15 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: add error logging to early
 update driver
Message-ID: <20141021141015.GD22528@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
 <20141020150801.GE3524@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020150801.GE3524@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Borislav Petkov wrote:
> On Mon, Sep 08, 2014 at 02:37:50PM -0300, Henrique de Moraes Holschuh wrote:
> > Enhance the logging in the Intel early microcode update driver to
> > be able to report errors.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > ---
> >  arch/x86/kernel/cpu/microcode/intel_early.c |   94 +++++++++++++++------------
> >  1 file changed, 54 insertions(+), 40 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> > index f73fc0a..8ad50d6 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> > @@ -31,6 +31,12 @@
> >  #include <asm/tlbflush.h>
> >  #include <asm/setup.h>
> >  
> > +enum {
> > +	INTEL_EARLYMCU_NONE = 0, /* did nothing */
> > +	INTEL_EARLYMCU_UPDATEOK, /* microcode updated */
> > +	INTEL_EARLYMCU_REJECTED, /* cpu rejected it */
> > +};
> > +
> >  static unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
> >  static struct mc_saved_data {
> >  	unsigned int mc_saved_count;
> > @@ -576,37 +582,50 @@ scan_microcode(unsigned long start, unsigned long end,
> >  
> >  /*
> >   * Print ucode update info.
> > + * for status == INTEL_EARLYMCU_UPDATEOK, data should be the mcu date
> > + * for status == INTEL_EARLYMCU_REJECTED, data should be mcu revision
> >   */
> > -static void
> > -print_ucode_info(struct ucode_cpu_info *uci, unsigned int date)
> > +static void print_ucode_info(const unsigned int status,
> > +			      const struct ucode_cpu_info *uci,
> > +			      const unsigned int data)
> >  {
> >  	int cpu = smp_processor_id();
> > -
> > -	pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
> > -		cpu,
> > -		uci->cpu_sig.rev,
> > -		date & 0xffff,
> > -		date >> 24,
> > -		(date >> 16) & 0xff);
> > +	struct ucode_cpu_info ucil;
> > +
> > +	switch (status) {
> > +	case INTEL_EARLYMCU_NONE:
> > +		break;
> > +	case INTEL_EARLYMCU_UPDATEOK:
> > +		if (!uci) {
> > +			collect_cpu_info_early(&ucil);
> > +			uci = &ucil;
> > +		}
> > +		pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
> > +			cpu,
> > +			uci->cpu_sig.rev,
> > +			data & 0xffff,
> > +			data >> 24,
> > +			(data >> 16) & 0xff);
> > +		break;
> > +	case INTEL_EARLYMCU_REJECTED:
> > +		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n", cpu, data);
> > +		break;
> > +	}
> >  }
> >  
> >  #ifdef CONFIG_X86_32
> >  
> > -static int delay_ucode_info;
> > -static int current_mc_date;
> > +static unsigned int delay_ucode_info;
> > +static unsigned int delay_ucode_info_data;
> 
> First of all, this really is date and not data and prefixing it with
> "delay" really doesn't make it cleaner.

For INTEL_EARLYMCU_UPDATEOK, it is the date.

For INTEL_EARLYMCU_REJECTED, it is the revision of the microcode that was
    rejected (as opposed to the revision of the microcode currently in the
    processor), because that's far more important to know than the date.

However, if you prefer, I could have _date, _oldrev, and _newrev, and
enhance the error messages a bit (updated from rev X to rev Y, date Z), etc.

> Then, this whole scheme can be simplified a bit by dropping
> delay_ucode_info and using current_mc_date to test whether to print the
> message or not. After printing, you set it back to 0.

In the INTEL_EARLYMCU_REJECTED case, the data we need to print might be
zero, and it has 32 bits.

Besides, this way one can trivially add new messages when required.  And we
will need to do that eventually.

In fact, I have a patch somewhere that needs to add a new failure message:
we have several failure cases which we want to differentiate, at the very
least "processor didn't like it" and "it looks corrupt, so we didn't even
try to install it".

If you want, I will add it when I resubmit this stack, instead of waiting
for the next one.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
