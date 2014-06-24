Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaFXThG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:37:06 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:60903 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750985AbaFXThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:37:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2553:2559:2562:2691:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:4605:5007:6119:6120:7652:7875:7903:7974:9121:10004:10400:10450:10455:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12679:12740:13161:13229:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none
X-HE-Tag: books89_5a705c07f2051
X-Filterd-Recvd-Size: 4116
Message-ID: <1403638620.29061.35.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 24 Jun 2014 12:37:00 -0700
In-Reply-To: <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477762.18747.14.camel@joe-AO725>
	 <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	 <1403505219.18747.37.camel@joe-AO725> <87egyeqt03.fsf@rasmusvillemoes.dk>
	 <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 21:13 +0200, Mathias Krause wrote:
> On 24 June 2014 16:31, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
[]
> > gcc already seems to contain infrastructure for this kind of thing, so
> > maybe it doesn't even require a plugin, but simply a little coordination
> > with the gcc folks. This snippet from gcc internals seems relevant:
> >
> > -- Target Hook: section * TARGET_ASM_FUNCTION_RODATA_SECTION (tree
> >           DECL)
> >      Return the readonly data section associated with 'DECL_SECTION_NAME
> >      (DECL)'.  The default version of this function selects
> >      '.gnu.linkonce.r.name' if the function's section is
> >      '.gnu.linkonce.t.name', '.rodata.name' if function is in
> >      '.text.name', and the normal readonly-data section otherwise.
> >
> 
> I don't think it's that easy. You cannot simply put all strings into
> the .init.rodata section when code currently gets emitted to
> .init.text. The reason is because strings used in __init code might be
> referenced later on, too. For example, the name passed to
> class_create() won't be copied. If that one would go into the
> .init.rodata section automatically, we would have dangling pointers
> after the .init.* memory got freed. Therefore a compiler driven
> approach would need to be implemented as a compiler extension, a gcc
> plugin to handle such cases -- know when a string can safely be put
> into the .init.rodata section and when not. But that decision is not
> as easy as Joe might think it would be. How would the plugin know
> which strings to put into the .init.rodata section? Would it only
> handle the ones passed to printk()?

Yes.

> I still strongly believe it's better to do this manually.

Maybe.

It'd work with any version of the compiler that way too.

It's a pretty simple transform.

I believe this will show most all of the __init
uses of printks:

$ grep-2.5.4 -rP --include=*.[ch] -n '\b__init\b[^\n][^\}]+\n}' * | \
  grep -P '^[\w\/\.]+:\d+:|\bprintk\b|\bpr_[a-z]+' | \
  grep -P -B1 '\bprintk\b|\bpr_[a-z]+'

This shows a little more than a 1000 __init printks
treewide that could be converted.

For example:
arch/ia64/include/asm/cyclone.h:6:extern void __init cyclone_setup(void);
        printk(KERN_ERR "Cyclone Counter: System not configured"
--
arch/ia64/kernel/acpi.c:66:static unsigned long __init acpi_find_rsdp(void)
                printk(KERN_WARNING PREFIX
--
arch/ia64/kernel/acpi.c:366:static int __init acpi_parse_madt(struct acpi_table
        printk(KERN_INFO PREFIX "Local APIC address %p\n", ipi_base_addr);

etc...

There are maybe 200 or so __exit ones.


