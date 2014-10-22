Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaJVXO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:14:58 -0400
Received: from p3plsmtp22-02-2.prod.phx3.secureserver.net ([68.178.252.56]:35783
	"EHLO p3plwbeout22-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbaJVXO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:14:57 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 19:14:57 EDT
X-SID: 6P9w1p0022XSfNk01
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: 57.68.76.66
User-Agent: Workspace Webmail 5.7.5
Message-Id: <20141022160955.802aba6dbaeed9f5026600c863362da9.2d1b0160c3.wbe@email22.secureserver.net>
From: <w.danford@electronics-software.com>
To: linux-kernel@vger.kernel.org
Subject: source file /drivers/base/platform.c
Date: Wed, 22 Oct 2014 16:09:55 -0700
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following originally sent to  gregkh@linuxfoundation.org
Automated reply suggested to send here and/or resend if I
desire this to specifically go to Greg.  I only wish to
point out a type of 'bug' in the file named.

---- Bug discovered, fix offered ----

in file platform.c

<code>

/**
 * platform_get_resource - get a resource for a device
 * @dev: platform device
 * @type: resource type
 * @num: resource index
 */
struct resource *platform_get_resource(struct platform_device *dev,
				       unsigned int type, unsigned int num)
{
	int i;

	for (i = 0; i < dev->num_resources; i++) {
		struct resource *r = &dev->resource[i];

//		if (type == resource_type(r) && num-- == 0)
		if (num-- == 0 && type == resource_type(r))
			return r;
	}
	return NULL;
}
EXPORT_SYMBOL_GPL(platform_get_resource);

</code>

I reversed the order of the two compares in line 73.
Reason is when the first compare fails then second condition is never
tested, but here that condition contains a post decrement assignment
operation.  Thus the post decrement is never done.  The result is num
can and in a particular case does get 'out of sync'.

The particular case I have is a porting to Atmel at91sam9261 platform.
The device/product I am porting to is based off Atmel's demo board
product at91sam9261ek.  A synopsis of the device/product differences is
it has a larger display, two added custom hardware devices on SPI bus,
one of the SOC USARTS is utilized (not utilized on demo board).  I am
updating and adding device driver sources.

Specific item is the resource struct for the display as follows.

<code>

static struct resource lcdc_resources[] = {
	/* Mem mapped LCD controller register set */
	[0] = {
		.start	= AT91SAM9261_LCDC_BASE,
		.end	= AT91SAM9261_LCDC_BASE + SZ_4K - 1,
		.flags	= IORESOURCE_MEM,
	},
	/* LCD controller IRQ */
	[1] = {
		.start	= NR_IRQS_LEGACY + AT91SAM9261_ID_LCDC,
		.end	= NR_IRQS_LEGACY + AT91SAM9261_ID_LCDC,
		.flags	= IORESOURCE_IRQ,
	},
	/* Mem mapped VRAM */
	[2] = {
		.start	= AT91SAM9261_SRAM_BASE,
		.end	= AT91SAM9261_SRAM_BASE + AT91SAM9261_SRAM_SIZE - 1,
		.flags	= IORESOURCE_MEM,
	},
};

</code>

Observe resource elements [0] and [2] are IORESOURCE_MEM types.
My test case within the customization of the lcd driver probe based on
atmel_lcdfb_core.c from Atmel is to print out the results of calls to
platform_get_resource from within the function
 
int __atmel_lcdfb_probe(struct platform_device *pdev,
			struct atmel_lcdfb_devdata *dev_data)

This is the test case print statement:

printk(KERN_INFO "r1: %08x %08x %08x %08x\n", (unsigned int)
platform_get_resource(pdev, IORESOURCE_MEM, 0),
														(unsigned int) platform_get_resource(pdev, IORESOURCE_MEM,
1),
														(unsigned int) platform_get_resource(pdev, IORESOURCE_MEM,
2),
														(unsigned int) platform_get_resource(pdev, IORESOURCE_MEM,
3));


>From what I understand to be the definition of the args to
platform_get_resource
I believe I should get valid results for index [0] and [2].  Yet the
results for
the original source are (MMU is activated, these are kernel virtual
addresses)

r1: c037cae0 c037cb18 00000000 00000000

then after this change I am submitting:

r1: c037cae0 00000000 c037cb18 00000000


As to correctness of the values, I also printed out the base address of
the resource struct in the highly customized function
at91_add_device_lcdc{}.

The base reported is c037cae0.  Then the resultant address mapping would
be:

struct lcdc_resources
[0]	c037cae0
			c037cae0
			c037cae4
			c037cae8 = NULL
			c037caec
			c037caf0 = NULL
			c037caf4 = NULL
			c037caf8 = NULL
[1]	c037cafc
			c037cafc
			c037cb00
			c037cb04 = NULL
			c037cb08
			c037cb0c = NULL
			c037cb10 = NULL
			c037cb14 = NULL
[2]	c037cb18
			c037cb18
			c037cb1c
			c037cb20 = NULL
			c037cb34
			c037cb38 = NULL
			c037cb3c = NULL
			c037cb30 = NULL

where the NULL are not assigned, so (hopefully) should default to NULL

An alternate conditional (also tested, works equally well) removes
assignment from within conditional:

		if (type == resource_type(r) && num == i)

Pick the solution you like best, this second condition could be
viewed as more straight forward, cleaner.

The compiler tool chain is pre built arm cross compiler from
CodeSourcery
(now owned by Mentor Graphics) running on Debian/Ubuntu 12.04 LTS
platform.
Sign on line:
Linux version 3.10.0+ (gcc version 4.8.3 20140320 (prerelease) (Sourcery
CodeBench Lite 2014.05-29) ) Wed Oct 22 09:53:49 CST 2014


---- End bug description and correction ----

The underlying cause of this bug is a classic compiler action which I
have
seen before.  Specifically a conditional of the form

if (a && b && c && ... )

typically gets compiled as exit conditional on first FALSE result.

So in this case the type mismatch being FALSE causes conditional exit
without
ever doing the second test.  But this second test contains within itself
an
assignment.  The assignment then is never performed.  Thus the index we
are
looking for is now incorrect.

In the object dump, or an asm output of, the compiled result you will
see
where on first compare fail a br instruction to end of conditional
block.
"Been there, done that, seen that."

My background (so you can feel confident I know what I am doing):
BSEE Purdue January 1970, over 40 years experience, hardware/circuit
design - ATE - last 15 years heavily embedded firmware development.
In the firmware development world I have seen this classic compiler
behavior.

I have read the MAINTAINERS doc, particularly about patch submission.
(That is where I got this e-mail from.)
I have never submitted any specific code line change, so I am simply
trying to precisely document what and why here.  Note also I have only
one specific target (code under development) to test on and have not
passed this on otherwise.  I just confirmed the bug's existence today
22 Oct 2014.

----------------------------------------
Update: After further testing I noticed other devices which had been
properly discovered/registerd perviously no longer showed up as
recognized
after the above edit included.

Reverting back to the original source condition restored the discovery
of
these devices.

So, I must condlude this behavior, do not do assignment when type
mismatch, is desired.

As a result I now suggest a more specific definition is desirable.
The definition of the 'num' is the offset index for the specific
resource 'type' to be searched for ignoring all others not of this
'type'. ... still convoluted.  By example, first resource of 'type'
is num=0, second resource of 'type' is num=1 even though say they
may be [1] and [3] in the complete resource array of resource structs.

Note my example has type IORESOURCE_MEM as members [0] and [2] in the
arrya.  So to look for [2] it is the second, num = 1, of type
IORESOURCE_MEM.

In conclusion this is a documentation issue!

