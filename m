Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab3CLVkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:40:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:43109 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab3CLVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:40:16 -0400
Date: Tue, 12 Mar 2013 22:40:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] irqchip: Add support for ARMv7-M's NVIC
In-Reply-To: <20130312204701.GS15375@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1303122150490.22263@ionos>
References: <1363103673-24720-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.02.1303121923280.22263@ionos> <20130312204701.GS15375@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1410459579-1363124414=:22263"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1410459579-1363124414=:22263
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 12 Mar 2013, Uwe Kleine-König wrote:

> Hello Thomas,
> 
> On Tue, Mar 12, 2013 at 08:57:34PM +0100, Thomas Gleixner wrote:
> > On Tue, 12 Mar 2013, Uwe Kleine-König wrote:
> > > +static struct nvic_chip_data nvic_data __read_mostly;
> > 
> > What the heck is this? You have a static struct which you set in
> > irqdata.chip_data?
> I copied that idea from the gic driver and didn't question it because I
> thought it's too early to allocate memory when it's needed. Or do you
> just wonder about the usage of this static variable?

Right, copying stuff from some other file is always a great excuse for
disabling the brain while coding.

Why the heck do you think it's safe to call irq_alloc_descs() from
that code then? Just because it did not explode in your face?

> > > +static inline void __iomem *nvic_dist_base(struct irq_data *d)
> > > +{
> > > +	struct nvic_chip_data *nvic_data = irq_data_get_irq_chip_data(d);
> > 
> > And then you do the dance of reading the pointer to that static struct
> > out of irq_data and dereferencing it?
> > 
> > What's the point of this? 
> The idea was to keep the functions generic anyhow.

Generic waste or what? If you dereference a static variable indirectly
via five indirections that makes the code obvious and the function
generic. I see ... NOT
  
> > > +	return nvic_data->dist_base;
> > > +}
> > > +
> > > +static void nvic_mask_irq(struct irq_data *d)
> > > +{
> > > +	u32 mask = 1 << (d->hwirq % 32);
> > > +
> > > +	writel_relaxed(mask, nvic_dist_base(d) + NVIC_ICER + d->irq / 32 * 4);
> > 
> > You're really missing the point of irq_data.chip_data 
> > 
> > If you set proper irq chip data per bank then this whole stuff is
> > reduced to:
> > 
> >    struct mydata *md = irq_data_get_irq_chip_data(d);
> >    u32 mask = 1 << (d->irq - md->irq_base);
> > 
> >    writel_relaxed(mask, md->iobase + NVIC_ICER);
> > 
> > Can you spot the difference and what that means in terms of
> > instruction cycles?
> Yeah I see. The cost is increased memory usage. You'd probably say that
> the amount needed here is too small to care about. Still many decisions
> like this sum up and make the 4 MiB of RAM I have a tight fit.

You did not answer my question completely.

You buy less memory usage for an increased instruction foot print
along with modulo/multiply/divide complexity in the interrupt hot
path.
  
> > > +static void __init nvic_init_bases(struct device_node *node,
> > > +		void __iomem *dist_base)
> > 
> > Please make this
> > 
> > static void __init nvic_init_bases(struct device_node *node,
> >                                    void __iomem *dist_base)
> > 
> > That's way easier to parse. Applies to all other multiline stuff as
> > well.
> My version is like vim does the layout for me. It's the first time
> someone opposes to it. The reason I prefer using a fixed indention is
> that I don't need to touch the latter lines when for example the
> function name or the function's type change.

I don't care about vim and your preferences. I care about the
readability and that's key for reviewing patch and reading code. Can
you spot the difference of:

static void __init nvic_init_bases(struct device_node *node,
	void __iomem *dist_base)
and

static void __init nvic_init_bases(struct device_node *node,
                                   void __iomem *dist_base)

Or

		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
				handle_fasteoi_irq);
and

		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
				         handle_fasteoi_irq);

The alignment of the arguments after the opening bracket makes it
entirely clear while your vim/lazyness style forces the reader to
decode it separately.
 
> Hmm, I can fix that if you insist.

You can Hmm as long as you want, except if you provide me an argument
why your magic vim setting is superiour.

> > > +	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
> > 
> >   irq_alloc_desc_from(16, irqs - 16, ...)
> > 
> > Also why are you allocating irqs-16 instead of the full number of
> > irqs?
> I already have a comment there in my tree.

Brilliant answer. I ask you a question and you tell me that you have a
comment in your tree ????

Stop that nonsense, I don't care about your magic tree, but I care
about answers to a review question.
 
> > > +	if (IS_ERR_VALUE(irq_base)) {
> > 
> > See Russells reply
> > 
> > > +		WARN(1, "Cannot allocate irq_descs\n");
> > 
> > What's the point of that warn? The call path is always the same. So
> > you are spamming dmesg with a pointless backtrace. And on top of that
> > you do:
> There is one warning per call to nvic_init_bases. So I don't expect more
> than one message in dmesg.

You're missing the point again. It does not matter whether you expect
one or more. The point is, the call chain is known already. So why is
dumping a stack trace usefull? It's entirely sufficient to have a
pr_warn() or whatever, simply because this is the important
information which might scroll out of the observers window with a
stack trace which is completely useless. A stack trace is only
helpfull when the code in question can be called from a gazillion of
call sites. If the call chain is clear, it's pointless.
 
> > 
> > > +		irq_base = 16;
> > 
> > So you cannot allocate irq_descs and then you set base to 16 and pray
> > that everything works?
> If something goes wrong here the machine is probably silent about it. So
> continuing after a prayer might (or might not?) be an option.

What are you smoking? Either the machine can work with the
preallocated 16 irqs and allow you to retrieve additional debugging
info or it does not. It's that easy.
 
> > > +	}
> > > +	nvic_data.domain = irq_domain_add_legacy(node, irqs - 16, irq_base, 0,
> > > +			&irq_domain_simple_ops, NULL);
> > > +	if (WARN_ON(!nvic_data.domain))
> > > +		return;
> > 
> > See above. Also you are leaking irqdescs though it's questionable
> > whether the machine can continue at all. And of course the init call
> > itself will return sucess.

-ENOANSWER

> > > +	/*
> > > +	 * Set priority on all interrupts.
> > > +	 */
> > > +	for (i = 0; i < irqs; i += 4)
> > > +		writel_relaxed(0, dist_base + NVIC_IPRI + i);
> > > +
> > > +	/*
> > > +	 * Disable all interrupts
> > > +	 */
> > > +	for (i = 0; i < irqs; i += 32)
> > > +		writel_relaxed(~0, dist_base + NVIC_ICER + i * 4 / 32);
> > > +
> > > +	/*
> > > +	 * Setup the Linux IRQ subsystem.
> > > +	 */
> > > +	for (i = 0; i < irqs; i++) {
> > > +		irq_set_chip_and_handler(irq_base + i, &nvic_chip,
> > > +				handle_fasteoi_irq);
> > 
> > Above you do:
> > 	irq_base = irq_alloc_descs(-1, 16, irqs - 16, numa_node_id());
> > 
> > So you allocate irqs-16 interrupt descriptors and then you initialize
> > 16 more than you allocated.
> right.
> 
> > Brilliant stuff that.

-ENOANSWER
 
> > > +		irq_set_chip_data(irq_base + i, &nvic_data);
> > > +		set_irq_flags(irq_base + i, IRQF_VALID | IRQF_PROBE);
> > > +	}
> > > +}
> > > +
> > > +static int __init nvic_of_init(struct device_node *node,
> > > +		struct device_node *parent)
> > > +{
> > > +	void __iomem *dist_base;
> > > +
> > > +	if (WARN_ON(!node))
> > 
> > Sigh.
> > 
> > Though the real question is: can this actually happen?
> It didn't happen for me.

Great argument for writing silly code.

> What do you suggest? dropping WARN_ON?

Did you actually try to understand any of my review questions?

> > > +		return -ENODEV;
> > > +
> > > +	dist_base = of_iomap(node, 0);
> > > +	WARN(!dist_base, "unable to map nvic dist registers\n");
> > 
> > Brilliant. You can't map stuff and then you continue just for fun or
> > what?
> What do you suggest? returning -ESOMETHING?

-EMORON perhaps?

Come on, do I need to make any further suggestions? See above, either
the machine can survive the failure or it cannot.
 
> > > +	nvic_init_bases(node, dist_base);
> > 
> > Great. You have failure pathes in nvic_init_bases() and then you
> > return unconditionally success:

-ENOANSWER

> Most of your critics also apply to irq-gic.c.

That's completely irrelevant.

> I will follow up with a patch for that when you are happy with my
> work for the nvic.

Do you really think that copying crappy code, making that copied code
worse and on top of that nerve racking the reviewer makes you the
person of choice to fixup the initial crap ?

Thanks,

	tglx
--8323328-1410459579-1363124414=:22263--
