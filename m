Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab3DBMQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:16:48 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15286 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757255Ab3DBMQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:16:47 -0400
From: <oskar.andero@sonymobile.com>
Date: Tue, 2 Apr 2013 14:16:43 +0200
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Collett, Toby" <Toby.Collett@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] kprobe: initialize kprobe_blacklist when it is used
 firstly
Message-ID: <20130402121643.GA21724@caracas.corpusers.net>
References: <1364799356-15768-1-git-send-email-iamjoonsoo.kim@lge.com>
 <515AB7C6.2030807@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <515AB7C6.2030807@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:49 Tue 02 Apr     , Masami Hiramatsu wrote:
> Hi,
> 
> (2013/04/01 15:55), Joonsoo Kim wrote:
> > Currently, initializing kprobe_blacklist is done during boot process.
> > It takes 230 ms on our android platform and this is significant amount
> > for our use case. We can disable CONFIG_KPROBES for production kernel,
> > but it is hassle. This kprobe functionality is not commonly used,
> > so we don't need to pay this cost at all times. With this rationale,
> > change code to initialize kprobe_blacklist when it is used firstly.
> 
> I saw similar patch from Oskar and Toby, and I decided to wait
> until his blacklist separating work. I'd like to ask Oskar
> how the patch is going first.
> 

I am currently preparing a series of 4 patches including the move of
blacklist initialization (same as Joonsoo's patch) and separation of
architecture specific blackpoints.
The patches are dependent, so I appreciate if you wait a bit.

You can expect the series at latest tomorrow.

-Oskar

> > 
> > Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> > I fotgot to add lkml.
> > Sorry for noise.
> > 
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index e35be53..5e90092 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -101,6 +101,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
> >  	{"mcount",},	/* mcount can be called from everywhere */
> >  	{NULL}    /* Terminator */
> >  };
> > +static bool kprobe_blacklist_initialized;
> >  
> >  #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
> >  /*
> > @@ -1324,6 +1325,49 @@ out:
> >  	return ret;
> >  }
> >  
> > +static void __kprobes init_kprobe_blacklist(void)
> > +{
> > +	unsigned long offset = 0, size = 0;
> > +	char *modname, namebuf[128];
> > +	const char *symbol_name;
> > +	void *addr;
> > +	struct kprobe_blackpoint *kb;
> > +
> > +	mutex_lock(&kprobe_mutex);
> > +	if (kprobe_blacklist_initialized)
> > +		goto out;
> > +
> > +	/*
> > +	 * Lookup and populate the kprobe_blacklist.
> > +	 *
> > +	 * Unlike the kretprobe blacklist, we'll need to determine
> > +	 * the range of addresses that belong to the said functions,
> > +	 * since a kprobe need not necessarily be at the beginning
> > +	 * of a function.
> > +	 */
> > +	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
> > +		kprobe_lookup_name(kb->name, addr);
> > +		if (!addr)
> > +			continue;
> > +
> > +		kb->start_addr = (unsigned long)addr;
> > +		symbol_name = kallsyms_lookup(kb->start_addr,
> > +				&size, &offset, &modname, namebuf);
> > +		if (!symbol_name)
> > +			kb->range = 0;
> > +		else
> > +			kb->range = size;
> > +	}
> > +
> > +	/* This guarantee that who see initilized will
> > +	 * get a updated data of kprobe_blacklist */
> > +	smp_wmb();
> > +	kprobe_blacklist_initialized = true;
> > +
> > +out:
> > +	mutex_unlock(&kprobe_mutex);
> > +}
> > +
> >  static int __kprobes in_kprobes_functions(unsigned long addr)
> >  {
> >  	struct kprobe_blackpoint *kb;
> > @@ -1331,6 +1375,7 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
> >  	if (addr >= (unsigned long)__kprobes_text_start &&
> >  	    addr < (unsigned long)__kprobes_text_end)
> >  		return -EINVAL;
> > +
> >  	/*
> >  	 * If there exists a kprobe_blacklist, verify and
> >  	 * fail any probe registration in the prohibited area
> > @@ -1476,6 +1521,9 @@ int __kprobes register_kprobe(struct kprobe *p)
> >  	struct module *probed_mod;
> >  	kprobe_opcode_t *addr;
> >  
> > +	if (unlikely(!kprobe_blacklist_initialized))
> > +		init_kprobe_blacklist();
> > +
> >  	/* Adjust probe address from symbol */
> >  	addr = kprobe_addr(p);
> >  	if (IS_ERR(addr))
> > @@ -2065,11 +2113,6 @@ static struct notifier_block kprobe_module_nb = {
> >  static int __init init_kprobes(void)
> >  {
> >  	int i, err = 0;
> > -	unsigned long offset = 0, size = 0;
> > -	char *modname, namebuf[128];
> > -	const char *symbol_name;
> > -	void *addr;
> > -	struct kprobe_blackpoint *kb;
> >  
> >  	/* FIXME allocate the probe table, currently defined statically */
> >  	/* initialize all list heads */
> > @@ -2079,28 +2122,6 @@ static int __init init_kprobes(void)
> >  		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
> >  	}
> >  
> > -	/*
> > -	 * Lookup and populate the kprobe_blacklist.
> > -	 *
> > -	 * Unlike the kretprobe blacklist, we'll need to determine
> > -	 * the range of addresses that belong to the said functions,
> > -	 * since a kprobe need not necessarily be at the beginning
> > -	 * of a function.
> > -	 */
> > -	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
> > -		kprobe_lookup_name(kb->name, addr);
> > -		if (!addr)
> > -			continue;
> > -
> > -		kb->start_addr = (unsigned long)addr;
> > -		symbol_name = kallsyms_lookup(kb->start_addr,
> > -				&size, &offset, &modname, namebuf);
> > -		if (!symbol_name)
> > -			kb->range = 0;
> > -		else
> > -			kb->range = size;
> > -	}
> > -
> >  	if (kretprobe_blacklist_size) {
> >  		/* lookup the function address from its name */
> >  		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
> 
